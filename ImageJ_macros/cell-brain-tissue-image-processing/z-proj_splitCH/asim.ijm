//////////////////////////// Global function for clearing up the ROI manager/////////////////
function cleanupROI(){
	temp_counter = roiManager("count");
	if (temp_counter>0){
		roiManager("Delete");
	}
}

macro "asim [a]"{
	cleanupROI();
	path = File.openDialog("open file");
	open(path);
	original = getTitle();
	// set polygon tool for tracing ROIs
	setTool("polygon");
	getDimensions(width, height, channels, slices, frames);
	run("Z Project...", "start=5 stop=8 projection=[Max Intensity]");
	waitForUser("[1] Select ROI\n \n[2]then press OK");
	run("Crop");
	setBackgroundColor(0, 0, 0);
	run("Clear Outside");
	run("Split Channels");
	saveAs("tiff",File.directory+original+"_DAPI");
	close();
	saveAs("tiff", File.directory+original+"_CRTC");
	close();
	close();
}