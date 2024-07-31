

function findArea(){
	
	// image title
	original_image = getTitle()
	selectWindow(original_image);
	setLocation(screenWidth/20,screenHeight/10);

	// define a mask
	run("8-bit");
	run("Grays");
	run("Duplicate...", "title=blurred-mask channels=1");
	selectWindow("blurred-mask");
	setLocation(screenWidth/4,screenHeight/10);
	run("Gaussian Blur...", "sigma=10 scaled slice");
	run("Threshold...");
	waitForUser('set threshold');
	
	// make sure the proper window is selected
	selectWindow("blurred-mask");
	
	// generate mask
	setAutoThreshold("Default dark");
	setOption("BlackBackground", true);
	run("Convert to Mask", "method=Default background=Dark");
	run("Analyze Particles...", "size=1000-Infinity pixel clear add");
	
	// close mask
	selectWindow("blurred-mask");
	run("Close");
	
	// select original image and apply mask
	selectWindow(original_image);
	roiManager("Show All");
	roiManager("UseNames", "true");
	roiManager("Select", 0);
	roiManager("Rename", "ROI-area");
	run("Measure");

}

findArea();

