
// setup
setTool("oval");
makeOval(266, 234, 435, 435);
roiManager("Add");
fname = getImageID();

setBatchMode(true);
for (i = 1; i < 2960; i++) {
	selectImage(fname);
	setSlice(i);
	run("Duplicate...", "title=a");
	image_a = getImageID();
	run("8-bit");
	run("Median...", "radius=3");
	run("Enhance Contrast", "saturated=0.35");
	run("Apply LUT");
	selectImage(fname);
	setSlice(i+1);
	run("Duplicate...", "title=b");
	image_b = getImageID();
	run("8-bit");
	run("Median...", "radius=3");
	run("Enhance Contrast", "saturated=0.35");
	run("Apply LUT");
	imageCalculator("Subtract create", "b","a");
	result = getImageID();
	selectImage(result);
	rename(i);
	selectImage(image_a);
	close();
	selectImage(image_b);
	close();
}
run("Images to Stack");
setBatchMode(false);

