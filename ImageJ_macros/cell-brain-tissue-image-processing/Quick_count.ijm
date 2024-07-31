
macro "projectDG [d]"{
	// cleanupROI();
	path = File.openDialog("open file");
	open(path);
	original = getTitle();
	getDimensions(width, height, channels, slices, frames);
	run("Z Project...", "start=1 stop="+slices+" projection=[Max Intensity]");
	selectWindow(original);
	close();
	setAutoThreshold("Default dark");
	run("Threshold...");
	setThreshold(48, 255);
	setOption("BlackBackground", false);
	run("Convert to Mask");
	run("Close");
	run("Watershed");
	run("Analyze Particles...", "size=50-150 display clear");
}