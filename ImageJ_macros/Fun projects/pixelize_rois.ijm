
// How to use
// select at least one ROI and add it to the ROI manager
// run the macro to pixelize the selecteed region(s)

//--------------------------------------------------------
// How many ROIs to pixelize?
//--------------------------------------------------------
temp_counter = roiManager("count");
roiManager("Show All without labels");

//--------------------------------------------------------
// extract RGB from pixelscolor and save it to results
//--------------------------------------------------------
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

//--------------------------------------------------------
// how many pixels per ROI? ask the users with a Dialog
//--------------------------------------------------------
Dialog.create("Define pixel grid");
Dialog.addNumber("Label", 2, 0, 4, "Columns");
Dialog.addNumber("Label", 2, 0, 4, "Rows");
Dialog.show();

xPixels = Dialog.getNumber(); 
yPixels = Dialog.getNumber(); 



//--------------------------------------------------------
// get ROIs and pixelize them. works also on irregularly-shaped ROIs
//--------------------------------------------------------
trackRow=0;
for (i=0; i<temp_counter; i++) {
	roiManager("Select", i);
	run("To Bounding Box");
	getSelectionCoordinates(x, y);

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
			roiManager("Select", i);
			if (selectionContains(startx,starty)>0){
				makeRectangle(startx, starty, xLength, yLength);
				run("Average Color", " ");
				measureColor(startx, starty,trackRow,py,px);
			trackRow++;		
			}

		}
	}
}

//--------------------------------------------------------
// clean up ROIs
//--------------------------------------------------------
roiManager("Show None");
run("Select None");

if (roiManager("count")>0){
	roiManager("Deselect");
	roiManager("Delete");	
}
