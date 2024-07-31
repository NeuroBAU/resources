

// setup
run("Set Measurements...", "area centroid bounding fit shape limit redirect=None decimal=3");
id = getImageID;

setBatchMode(true);
id = getImageID;
  for (i=1; i<= 10500; i++) {
    showProgress(i, 10);
	// in loop
	setSlice(i); //8810 6164
	run("Duplicate...", "title=temp");
	run("8-bit");
	makeRectangle(284, 208, 594, 588);
	run("Crop");
	run("Gaussian Blur...", "sigma=30");
	setAutoThreshold("Default");
	//run("Threshold...");
	setThreshold(0, 121);
	setOption("BlackBackground", true);
	run("Convert to Mask");
	run("Analyze Particles...", "include");
	close();
  }
setBatchMode(false);
saveAs("Results", "/Users/lex/Documents/Sci/Neuro-BAU/code/ImageJ_macros/cylinder/Results.txt");
run("Clear Results");