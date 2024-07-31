
function zoomFactor(factor) {
	for (i = 0; i < factor; i++) {
		run("Out [-]");
	}
}


function getSdSample(sample_size, start_frame){

	fname = getImageID();
	
	setBatchMode(true);
	for (i = 0; i < sample_size; i++) {
		selectImage(fname);
		setSlice(start_frame + i);
		run("Duplicate...", "title="+i);
	}
	
	run("Images to Stack");
	run("Z Project...", "projection=[Standard Deviation]");
//	run("Z Project...", "projection=[Average Intensity]");
	run("Set Measurements...", "integrated redirect=None decimal=3");
	run("Measure");
	selectWindow("STD_Stack");
	close();
	selectWindow("Stack");
	close();
	setBatchMode(false);
//	zoomFactor(2);
//	selectWindow("STD_Stack");
//	rename(start_frame + "_STD");
//	close();
};


getSdSample(30, 830);

//for (i = 1; i < 10; i++) {
//	getSdSample(30, i * 50);
//	setResult("Frame", i, i * 5);
//}
//



