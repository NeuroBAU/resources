
///////////////// GENERATE BACKGROUND

setBatchMode(true)
for (i = 0; i < 30; i++) {
	selectWindow("/Users/lex 1/switchdrive/Neuro-BAU/Research-projects/Bagni/Valentina/NLT/NLT_pilot_1.mp4");
	setSlice(i * i/5 * i/5 + 1);
	run("Duplicate...", "title="+i);
	run("8-bit");
}

run("Images to Stack", "name=Stack title=[] use");
run("Z Project...", "projection=[Average Intensity]");
run("Gaussian Blur...", "sigma=20");
setBatchMode(false)

for (i = 0; i < 5; i++) {
	run("Out [-]");
}
rename("bkg");

///////////////// LOOP OVER FRAMES
setBatchMode(true)
for (frame = 1; frame < 500; frame++) {
	selectWindow("/Users/lex 1/switchdrive/Neuro-BAU/Research-projects/Bagni/Valentina/NLT/NLT_pilot_1.mp4");
	setSlice(frame);
	run("Duplicate...", "title=tmp");
	run("8-bit");
	imageCalculator("Subtract create", "bkg","tmp");
	selectWindow("Result of bkg");
	run("8-bit");
	
	//setAutoThreshold("Default dark");
	//run("Threshold...");
	setThreshold(50, 255);
//	setOption("BlackBackground", true);
	run("Convert to Mask");
	
	for (i = 0; i < 7; i++) {
		run("Erode");
	}
	for (i = 0; i < 5; i++) {
		run("Dilate");
	}
	selectWindow("Result of bkg");
	run("Analyze Particles...", "size=3000-Infinity show=Nothing add");
//	selectWindow("Result of bkg");
	close();
	
	selectWindow("tmp");
	close();
}
setBatchMode(false)
