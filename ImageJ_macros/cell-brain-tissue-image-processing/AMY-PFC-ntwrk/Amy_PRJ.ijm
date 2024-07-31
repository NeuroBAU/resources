///////////////////////////////////////////////////////////////////////////////////////////
//MADE BY: 	Leonardo Restivo | Franklandlab
//DATE:	Feb/2013
//DESCRIPTION:
//	Process images for amygdala project (z- project, split channels, particle analysis define ROIs)
/////////////////////////////////////////////////////////////////////////////////////////////



//////////////////////////// Global function for clearing up the ROI manager/////////////////
function cleanupROI(){
	temp_counter = roiManager("count");
	if (temp_counter>0){
		for (i=0; i<temp_counter; i++) {
			roiManager("Select", 0);
			roiManager("Delete");
		}
	}
}

///////////////////////////////Global function for opening file/////////////////////////////////////
function openFile(){
	path = File.openDialog("open file");
	open(path);
	return(path);
}

////////////////////////////////////////// BATCH SLICING & STACKING ///////////////////////////////////////////////////////
macro "batch slicing [b]"{

	// choose origianl directory W/ all images (INDIVIDUAL SETS)
	dir1 = getDirectory("Choose Source Directory ");
	list = getFileList(dir1);

	// get marker name
	m1 = getString("prompt", "marker")

	// make dir for images
	wholeAmyDir = dir1+"whole"+File.separator;

	//--------activate to save into different folders-------
	dapiDir = dir1+"dapi"+File.separator;
	markerDir = dir1+m1+File.separator;
	fosDir = dir1+"fos"+File.separator;
	wfaDir = dir1+"wfa"+File.separator;
	//------------------------------------------------------
	
	File.makeDirectory(wholeAmyDir);
	
	
	//--------activate to save into different folders-------
	File.makeDirectory(dapiDir);
	File.makeDirectory(markerDir);
	File.makeDirectory(fosDir); 
	File.makeDirectory(wfaDir); 
	//------------------------------------------------------

	//  z- project and split channels
	for (i=0; i<list.length; i++) {
		setBatchMode(true);
	    	showProgress(i+1, list.length);
	    	open(dir1+list[i]);
	    	getDimensions(width, height, channels, slices, frames);

	    	// z-projection range is hardcoded!!!!!!!!!!!! 
	    	stack_parameters = "start=0 stop=3 projection=[Max Intensity]";
		run("Z Project...", stack_parameters);

		//split the 4 channels
		run("Split Channels");

		//--------activate to save into different folders-------
		saveAs("tiff", wfaDir+"wfa"+list[i]);
		close();
		saveAs("tiff", fosDir+"fos"+list[i]);
		close();
		saveAs("tiff", markerDir+m1+list[i]);
		close();
		saveAs("tiff", dapiDir+"dapi"+list[i]);
		//------------------------------------------------------

		// --------- Activate to save all files in the same folder ------
		//saveAs("tiff", wholeAmyDir+"wfa"+list[i]);
		//close();
		//saveAs("tiff", wholeAmyDir+"fos"+list[i]);
		//close();
		//saveAs("tiff", wholeAmyDir+m1+list[i]);
		//close();
		saveAs("tiff", wholeAmyDir+"dapi"+list[i]);
		//saveAs("tiff", dapiDir+"dapi"+list[i]);
		//----------------------------------------------------------------
		
		close();
		close();
		setBatchMode(false);
	}
	
	// combine the images in one hyperstack
	function stackify(DirToStack,fileName){
		
		listToStack = getFileList(DirToStack);
	
		for (i=0; i<listToStack.length; i++) {
			setBatchMode(true);
		    	showProgress(i+1, listToStack.length);
		    	open(DirToStack+listToStack[i]);
		    	setBatchMode(false);
		}
		run("Images to Stack");
		saveAs("tiff", dir1+fileName);
		close();
	}

	// combine the images in one hyperstack (whole amygdala)
	//stackify(dapiDir,"dapi"); // use this for tracing ROIs
	//stackify(markerDir,m1);
	//stackify(fosDir,"fos");
	//stackify(wfaDir,"wfa");
}




// Better use CellProfiler pipelines (more accurate!!!)
////////////////////////////////////////// PARTICLE-ANALYSIS ///////////////////////////////////////////////////////
//           OPTIMIZED FOR DAPI DETECTION (20x objective, 1024x1024, 4 slices stack, 3um step)			 //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////

macro "particleMe [p]"{
	
	// clean up the ROi manager (make sure that nothing is left over from previous analysis)
	cleanupROI();
	
	// define measurements to be done on the stack
	run("Set Measurements...", "area mean centroid feret's integrated stack display redirect=None decimal=3");

        // pretty labels and masks
	roiManager("Set Fill Color","green");
	run ("Labels...", "color=white font=1");
	roiManager("Show All");

	// open original stack
	path = File.openDialog("open file");
	open(path);

	// get title of the original stack. May be used to save the processed file
	saveTitle = getTitle();
	  
	  ///////////////////////// Generate Dialog /////////////////////////
	  // [1] Sigma smoothing value
	  // [2] Noise tolerance
	  Dialog.create("Inital parameters");
	  // The following values are perfect for my staining (Leo)
	  Dialog.addMessage("Choose Smoothing and Noise tolerance for local maxima\n");
	  Dialog.addNumber("Sigma smoothing:", 3); 
	  Dialog.addNumber("Noise tolerance:", 50);
	  Dialog.addMessage("Particle Size values (um)\n");
	  Dialog.addNumber("Particle Size [Min]:", 15);
	  Dialog.addNumber("Particle Size [Max]:", 300);
	  Dialog.addCheckbox("Adjust Brightness/Contrast", false);
	  Dialog.show();
	  sigmaSmoothing= Dialog.getNumber();
	  tolerance 	= Dialog.getNumber();
	  pSizeMin 	= Dialog.getNumber();
	  pSizeMax	= Dialog.getNumber();
	  brightnessContrast = Dialog.getCheckbox();
	  /////////////////////////  END dialog /////////////////////////

	// pop-up brigthness controller
	if (brightnessContrast){
		run("Brightness/Contrast...");
		waitForUser("Click APPLY and then OK when you're done");
	}

	// convert to grays
	run("Grays");

	// Invert the lookup table (Black on White)
	run("Invert LUT");

	// image pre-processing

	run("Subtract Background...", "rolling=24 light sliding");
	run("Maximum...", "radius=1");
 	run("Median...", "radius=6 stack");
	run("Convolve...", "text1=[-1 -1 -1 -1 -1\n-1 -1 -1 -1 -1\n-1 -1 24 -1 -1\n-1 -1 -1 -1 -1\n-1 -1 -1 -1 -1\n] stack");
	run("Find Edges","stack");
	run("Median...", "radius=4 stack");
	
	/////////////////// find maxima in every slice of the stack ///////////////////
	// courtesy of imageJ website!
	setBatchMode(true);
	input = getImageID();
	n = nSlices();

	for (i=1; i<=n; i++) {
		showProgress(i, n);
		selectImage(input);
	 	setSlice(i);
	 	run("Find Maxima...", "noise="+ tolerance +" output=[Maxima Within Tolerance] light");
	 	if (i==1)
	        	output = getImageID();
	    	else  {
		 	run("Select All");
		        run("Copy");
		        close();
		        selectImage(output);
		        run("Add Slice");
		        run("Paste");
	    	}
	  }
	  run("Select None");
	  setBatchMode(false);
	/////////////////////////// END batch local maxima /////////////////////////////

	// Processing on binary image
 	run("Close-", "stack");
	run("Dilate", "stack");
	run("Close-", "stack");
	run("Watershed", "stack");

	// Clear results before doing particle analysis
	run("Clear Results");

	// Analyze particles detected with Local Maxima
	run ("Analyze Particles...", "size="+pSizeMin+"-"+pSizeMax+" circularity=0.40-1.00 show=Nothing exclude clear add stack");
	roiManager("Set Fill Color","green");
	run ("Labels...", "color=white font=1");
	roiManager("Show All");

	// save ROIs
	roiManager("Save", File.directory+File.nameWithoutExtension+".zip");

	open(path);
	
	// close all windows
	run("Close");
	run("Close");
	run("Close");
	
	//#--------------- dev zone
	open(path);
	roiManager("Show All");
	//#--------------- END zone
	
	// empty roy manager
	//cleanupROI();

	// save the Results (text file) to the original directory
//	saveAs("Results", File.directory+File.nameWithoutExtension+"_"+saveTitle+".txt");
	
}


//////////////////////////////////// DEFINE-ROIs /////////////////////////////////////////////////

macro "Regions [r]" {

	// clean left-over ROIs
	cleanupROI();
	
	// set measurements
	run("Set Measurements...","area centroid stack display decimal=3");

	// array of labels
	var selectMe = newArray("LA","BLA","Ce","ITC");

	// selction labels
	function foo(labelSet){
		Dialog.create("Label ROI");
		Dialog.addChoice("Label", labelSet)
		Dialog.show();
		lbl = Dialog.getChoice();
		return lbl;
	};
	
	// Open original file
	path = File.openDialog("open AMYGDALA file");
	open(path);

	roiDir = File.directory+"ROI"+File.separator;
	File.makeDirectory(roiDir);
	
	saveTitle = File.nameWithoutExtension;
	saveDir = File.directory;

	// set polygon tool for tracing ROIs
	setTool("polygon");

	// Set the ROIs
	var regionCounter=0;
	for (s = 0; s <nSlices; s++){
		setSlice(s+1);
		nROI = getNumber("Select the number of ROIs", 0);
		selected_labels = newArray(nROI);
		for (i = 0; i <nROI; i++){
			waitForUser("Select Roi");
			roiManager("Add");
			roiManager("Select", regionCounter);
			tempLabel = foo(selectMe);
			selected_labels[i] = tempLabel;
			// roiManager("Show All")
			print(selected_labels[i]);
			run ("Labels...","color=white font=10 show use draw bold");
			roiManager("Select", regionCounter);
			sliceNumber = getSliceNumber();
			saveAs("XY Coordinates", roiDir+saveTitle+"_"+selected_labels[i]+"_"+sliceNumber+".txt");
			regionCounter++;			
		}
	}

	// Save Roi file
	roiManager("Save", saveDir+saveTitle+"_roi.zip");


	// Extract & Save measures from roi manager
	roiManager ("Measure");
	saveAs("Results", saveDir+saveTitle+"_RESULTS.txt");

	// clean up roi manager
	cleanupROI();
	close();
}





