///////////////////////////////////////////////////////////////////////////////////////////
//MADE BY: 	Leonardo Restivo | Franklandlab
//DATE:	Feb/2013
//DESCRIPTION:
//	general macros for cell counting and region definition (ROI)
//	Made for Asim
/////////////////////////////////////////////////////////////////////////////////////////////


//////////////////////////// Global function for clearing up the ROI manager/////////////////
function cleanupROI(){
	counter = roiManager("count");
	for (i = 0; i <counter; i++){
		roiManager("Select", 0);
		roiManager("Delete");
	}
}

/////////////////////////////////////MACRO///////////////////////////////////////////////
// THis macro is tuned for counting DAPInuclei and one additional marker (i.e. 2 channels)
// DAPI is always on the first channel
// DAPIis counted using local maxima
// the second marker is counted using a basic thresholding method
/////////////////////////////////////////////////////////////////////////////////////////

macro "count DAPI and Marker [x]"{

	// clean up the ROI manager (make sure that nothing is left-behind from previous analysis)
	cleanupROI();
	
	// define measurements to be done on the stack
	run("Set Measurements...", "area mean centroid feret's integrated stack display redirect=None decimal=3");
	
	// open original stack
	path = File.openDialog("open file")
	open(path)
	saveTitle = getTitle();
	print("file: ",saveTitle);
	
	// find image data
	getDimensions(width, height, channels, slices, frames);
	
	var projectionType = newArray("Max Intensity","Average Intensity");
	
	//---------------------- Generate Dialog ----------------------
	Dialog.create("Inital parameters");
	Dialog.addMessage("........ Z-Projection\n");
	Dialog.addNumber("Start:",1);
	Dialog.addNumber("Stop:", slices);
	Dialog.addChoice("Projection type",projectionType);
	Dialog.addMessage("........ Choose Smoothing\n");
	Dialog.addNumber("Sigma smoothing:", 2);
	Dialog.addNumber("Noise tolerance:", 20);
	Dialog.addMessage("Particle Size values (um)\n");
	Dialog.addNumber("Particle Size [Min]:", 5);
	Dialog.addNumber("Particle Size [Max]:", 250);
	Dialog.addNumber("Particle Circularity [Min]:", 0.4);
	Dialog.addNumber("Particle Circularity [Max]:", 1);
	Dialog.addCheckbox("Adjust Brightness/Contrast", false);
	Dialog.show();
	//---------------------- get Dialog input ------------------------
	start		= Dialog.getNumber();
	stop		= Dialog.getNumber();
	projection 	= Dialog.getChoice();
	sigmaSmoothing	= Dialog.getNumber();
	tolerance	= Dialog.getNumber();
	pSizeMin 	= Dialog.getNumber();
	pSizeMax 	= Dialog.getNumber();
	pCircMin 	= Dialog.getNumber();
	pCircMax 	= Dialog.getNumber();
	brightnessContrast = Dialog.getCheckbox();
	
	if (brightnessContrast){
		run("Brightness/Contrast...");
		waitForUser("Click APPLY and then OK when you're done");
	}
	
	// z-projection (all slides)
	stack_parameters = "start="+start+" stop="+stop+" projection=["+projection+"]";
	run("Z Project...", stack_parameters);

	setTool("polygon");
	waitForUser("Trace region and click OK");
	run("Crop");
	run("Make Inverse");
	run("Clear","stack");

	// split channels
	run("Split Channels");

	selectWindow(saveTitle);
	close();

	// ASSUMING THAT DAPI IS ALWAYS THE FIRST CHANNEL!!!!!!!!
	for (i=1; i<=channels ; i++){
		// convert to grays
		run("Grays");
		
		// Invert the lookup table (Black on White)
		run("Invert LUT");

		//work on a backup
		run("Duplicate...","title=temp");
		
		// gaussian blur on the image
		run("Gaussian Blur...","sigma="+sigmaSmoothing+" scaled stack");
		
		// processing of DAPI: local MAXIMA
		if (i==2){
		    run("Find Maxima...", "noise="+ tolerance +" output=[Maxima Within Tolerance] light");
		}
		// processing CRTC: basic thresholding
		else{
		    //run("Auto Local Threshold", "method=Bernsen radius=15 parameter_1=0 parameter_2=0 white");
		    run("Threshold...");
		    waitForUser("Adjust Threshold, click APPLY, then click OK when you're done");
		}

		// split nuclei
		run("Watershed");

		// DAPI counting: user-defined particle size and circularity
		if (i==2){
			run ("Analyze Particles...", "size="+pSizeMin+"-"+pSizeMax+" circularity="+pCircMin+"-"+pCircMax+" show=Ellipses exclude clear add stack");
			counter = roiManager("count");
			print ("Total DAPI cells:", counter);
		}
		// CRTC counting: MIN particle size is hard-coded(!!!) MAX size, circularity are user-defined
		else{
			run ("Analyze Particles...", "size=30-"+pSizeMax+" circularity="+pCircMin+"-"+pCircMax+" show=Ellipses exclude clear add stack");
			counter = roiManager("count");
			print ("Total CRTC cells:", counter);
		}
		close();
		close();
		

		roiManager("Set Fill Color","green");
		run ("Labels...", "color=white font=1");
		roiManager("Show All");
		waitForUser("results OK?");
		answer = getBoolean("save results?");
		if (answer){
			roiManager("Measure");
			if (i==2){
				saveTitle="DAPI";
			}
			else{
				saveTitle="CRTC";
			}
			saveAs("Results", File.directory+File.nameWithoutExtension+"_"+saveTitle+".txt");	
		}		
		close();
	}

	// empty roi manager
	cleanupROI();

	// close all remaining images
	close();	
}