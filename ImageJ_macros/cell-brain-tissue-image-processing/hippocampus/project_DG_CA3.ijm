//////////////////////////// Global function for clearing up the ROI manager/////////////////
function cleanupROI(){
	temp_counter = roiManager("count");
	if (temp_counter>0){
		roiManager("Delete");
	}
}

var minRange = 0;
var maxRange = 175;

macro "projectDG [d]"{
	cleanupROI();
	path = File.openDialog("open file");
	open(path);
	original = getTitle();
	getDimensions(width, height, channels, slices, frames);
	run("Z Project...", "start=1 stop="+slices+" projection=[Max Intensity]");
	selectWindow(original);
	close();
	run("Smooth", "stack");
	run("Brightness/Contrast...");
	Stack.setChannel(1);
	setMinAndMax(minRange, maxRange);
	Stack.setChannel(2);
	setMinAndMax(minRange, maxRange);
	Stack.setChannel(3);
	setMinAndMax(minRange, maxRange);
	run("Channels Tool...");
}