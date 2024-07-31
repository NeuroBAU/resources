
function zoomFactor(factor) {
	for (i = 0; i < factor; i++) {
		run("Out [-]");
	}
}


//------------------------
n_of_slices = 2962;
//------------------------

fname = getImageID();
step = nSlices / n_of_slices;
print('Samples taken every ~'+ step+' frames');
zoomFactor(6);

setBatchMode(true);
for (i = 1; i < n_of_slices; i++) {
	selectImage(fname);
	setSlice(i * step);
	run("Duplicate...", "title="+i);
	run("8-bit");
}
run("Images to Stack");
selectWindow("Stack");
run("Z Project...", "projection=[Average Intensity]");
imageCalculator("Subtract create stack", "Stack","AVG_Stack");
//run("Gaussian Blur...", "sigma=5 stack");
//run("Maximum...", "radius=16 stack");
//setAutoThreshold("Otsu dark");
//setOption("BlackBackground", true);
//run("Convert to Mask", "method=Otsu background=Dark calculate black");
//run("Dilate", "stack");
//run("Dilate", "stack");
//run("Dilate", "stack");
//run("Dilate", "stack");
//run("Dilate", "stack");
//run("Dilate", "stack");
//run("Dilate", "stack");




setBatchMode(false);
//run("Convolve...", "text1=[0 0 0 0 -1\n-1 0 1 1 -1\n0 1 1 1 -1] normalize stack");




//run("Gaussian Blur...", "sigma=40");
//
//imageCalculator("Subtract create stack", "Stack","AVG_Stack");
//selectWindow("AVG_Stack");
//close();
//
//selectWindow("Result of Stack");