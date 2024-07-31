
// empty ROI manager
if (roiManager("count")>0){
	roiManager("Deselect");
	roiManager("Delete");
}

// generate mask for detecting ROIs
run("Duplicate...", " ");
run("8-bit");
setAutoThreshold("Default");
//run("Threshold...");
setThreshold(0, 240);
run("Convert to Mask");
run("Fill Holes");
setOption("BlackBackground", true);
//run("Dilate");
run("Analyze Particles...", "size=1100-Infinity show=Outlines clear add");
close();
close();
roiManager("Show All");
roiManager("Show All without labels");
// number of detected ROIs
temp_counter = roiManager("count");


function measureColor(xIN,yIN,row,xPxNumber,yPxNumber){
	v = getPixel(xIN,yIN);
        red = (v>>16)&0xff;  // extract red byte (bits 23-17)
        green = (v>>8)&0xff; // extract green byte (bits 15-8)
        blue = v&0xff;       // extract blue byte (bits 7-0)
        setResult("Red", row, red);
        setResult("Green", row, green);
        setResult("Blue", row, blue);
        setResult("pixel.row", row, xPxNumber);
        setResult("pixel.column", row, yPxNumber);
        updateResults;
}


trackRow=0;
// loop over ROIs and do stuff ...
for (i=0; i<temp_counter; i++) {
	roiManager("Select", i);
	run("To Bounding Box");
	getSelectionCoordinates(x, y);

	xPixels = 48;
	yPixels = 48;
	xLength = (x[1]-x[0])/xPixels;
	yLength = (y[2]-y[0])/yPixels;
	
	xNew=floor(xLength + x[0]);
	yNew=floor(yLength + y[0]);

	startx = x[0]-xLength;
	for (px=0; px<xPixels; px++){
		startx+=xLength;
		starty = y[0]-yLength;
		for(py=0; py<yPixels; py++){
			starty+=yLength;
			makeRectangle(startx, starty, xLength, yLength);
			run("Average Color", " ");
			measureColor(startx, starty,trackRow,py,px);
			trackRow++;
		}
	}
}
roiManager("Show None");
run("Select None");


