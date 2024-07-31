//////////////////////////// Global function for clearing up the ROI manager/////////////////
function cleanupROI(){
	temp_counter = roiManager("count");
	if (temp_counter>0){
		roiManager("Delete");
	}
}


function findHighLow(){
	
	//REQUIRES DAPI CHANNEL SELECTION !!!!!!
	
	// generate non-destructive layer
	run("Duplicate...", "title=temp");
	run("Subtract Background...", "rolling=40");
	
	// scale down the resolution (lump the high-density structures)
	// ------------------- TOIMPROVEDETECTIONOFHIGHDENSITY!!!!!!!!!-----------------
	run("Bin...", "x=10 y=10 bin=Average");
	run("Size...", "width=2048 height=2048 constrain interpolation=None");
	run("Gaussian Blur...", "sigma=10");
	run("Enhance Contrast...", "saturated=1 normalize");
	run("Auto Threshold", "method=Yen ignore_black white");
	run ("Analyze Particles...", "size=2000-infinity circularity=0.00-1.00 show=Masks exclude clear");
	
	//generate selection from macro structures
	run("Create Selection");
	run("Add to Manager");
	roiManager("Select", 0);
	
	//grow the boundaries of the regions by 8um 
	run("Enlarge...", "enlarge=8");
	run("Add to Manager");
	roiManager("Select", 0);
	roiManager("Delete");
	
	// select the original image
	selectWindow("temp");
	roiManager("Select", 0);
	
	//close analyzed windows
	selectWindow("Mask of temp");
	run("Close");
	selectWindow("temp");
	run("Close");
	roiManager("Deselect");

	// Returns the high density regions boundaries
}

function splitHighLow(){
	// backup original
	run("Duplicate...", "title=temp");
	
	//----------------------- generate LOW density
	selectWindow("temp");
	run("Duplicate...", "title=temp_LOW");
	roiManager("Select", 0);
	setBackgroundColor(0, 0, 0);
	run("Clear", "slice");
	roiManager("Deselect");
	
	//----------------------- generate HIGH density
	selectWindow("temp");
	run("Duplicate...", "title=temp_HIGH");
	roiManager("Select", 0);
	run("Make Inverse");
	setBackgroundColor(0, 0, 0);
	run("Clear", "slice");
	roiManager("Deselect");
	
	selectWindow("temp");
	run("Close");
}



////////////////////////////////////////// BATCH SLICING & STACKING ///////////////////////////////////////////////////////
macro "batch slicing [b]"{

	// choose origianl directory W/ all images (INDIVIDUAL SETS)
	dir1 = getDirectory("Choose Source Directory ");
	list = getFileList(dir1);

	// get marker name
	m1 = getString("prompt", "marker")

	// make dir for images
	highDir = dir1+"high"+File.separator;
	lowDir = dir1+"low"+File.separator;
	
	File.makeDirectory(highDir);
	File.makeDirectory(lowDir);

	//  z- project and split channels
	for (i=0; i<list.length; i++) {
		setBatchMode(true);
	    	showProgress(i+1, list.length);
	    	open(dir1+list[i]);
	    	getDimensions(width, height, channels, slices, frames);

	    	// z-projection range is hardcoded!!!!!!!!!!!! 
	    	stack_parameters = "start=3 stop=6 projection=[Average Intensity]";
		run("Z Project...", stack_parameters);

		//split the 4 channels
		run("Split Channels");

		// <------ insert HERE the function for splitting images in HIGH/LOW ->
		selectWindow("C1-AVG_"+list[i]);
		findHighLow();
		

		// ---------------- WFA
		splitHighLow();
		selectWindow("temp_HIGH");
		saveAs("tiff", highDir+"WFA"+list[i]);
		close(); //close tempHIGH

		selectWindow("temp_LOW");
		saveAs("tiff", lowDir+"WFA"+list[i]);
		close(); //close tempLOW
		close(); //close original

		// ---------------- FOS
		splitHighLow();
		selectWindow("temp_HIGH");
		saveAs("tiff", highDir+"fos"+list[i]);
		close(); //close tempHIGH

		selectWindow("temp_LOW");
		saveAs("tiff", lowDir+"fos"+list[i]);
		close(); //close tempLOW
		close(); //close original

		// ---------------- MARKER
		splitHighLow();
		selectWindow("temp_HIGH");
		saveAs("tiff", highDir+m1+list[i]);
		close(); //close tempHIGH

		selectWindow("temp_LOW");
		saveAs("tiff", lowDir+m1+list[i]);
		close(); //close tempLOW
		close(); //close original

		// ---------------- DAPI
		splitHighLow();
		selectWindow("temp_HIGH");
		saveAs("tiff", highDir+"DAPI"+list[i]);
		close(); //close tempHIGH

		selectWindow("temp_LOW");
		saveAs("tiff", lowDir+"DAPI"+list[i]);
		close(); //close tempLOW
		close(); //close original
		
		close();
		cleanupROI();
		
		setBatchMode(false);
	}
	print("MACRO EXECUTION COMPLETED");
	
}
