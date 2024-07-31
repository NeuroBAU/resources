fname = getImageID();

selectImage(fname);
	setBatchMode(true);
for (i = 1; i < nSlices; i++) {
//	print(nSlices);
	print(i);
	selectWindow("Result of Stack");
	x = getResult("X", i);
	y = getResult("Y", i);
	setSlice(i);
	makeRectangle(x - 128, y - 128, 228, 228);
	run("Duplicate...", "title=g");
	selectWindow("Result of Stack");
}
run("Images to Stack");
setBatchMode(false);



//makeRectangle(423-128, 345-128, 228, 228);