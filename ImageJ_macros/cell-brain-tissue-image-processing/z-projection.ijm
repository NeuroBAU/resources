//////////////////////////// Global function for clearing up the ROI manager/////////////////
function cleanupROI(){
	temp_counter = roiManager("count");
	if (temp_counter>0){
		roiManager("Delete");
	}
}



macro "projectDG [d]"{
	// cleanupROI();
	path = File.openDialog("open file");
	open(path);
	original = getTitle();
	getDimensions(width, height, channels, slices, frames);
	run("Z Project...", "start=1 stop="+slices+" projection=[Max Intensity]");
	selectWindow(original);
	close();
	run("Channels Tool...");
}