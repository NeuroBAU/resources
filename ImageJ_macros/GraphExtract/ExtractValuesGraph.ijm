//////////////////////////// Global function for clearing up the ROI manager/////////////////
function cleanupROI(){
	counter = roiManager("count");
	for (i = 0; i <counter; i++){
		roiManager("Select", 0);
		roiManager("Delete");
	}
}
/////////////////////////////////////////////////////////////////////////////////////////////
// generate multiple dialogs depending on number of series

// dialog_1 asks for number of series
// dialog_2 loops through series to get the name 


// TO DO: invert coordinates!

cleanupROI();

Dialog.create("Graph Parameters");
Dialog.addNumber("Number of series", 1)
Dialog.addNumber("X-axis: MIN value", 0)
Dialog.addNumber("X-axis: MAX value", 7)
Dialog.addNumber("Y-axis: MIN value", 0)
Dialog.addNumber("Y-axis: MAX value", 1800)
Dialog.addCheckbox("y-error-bars", false)
Dialog.show()
nSeries   = Dialog.getNumber();
XMin   = Dialog.getNumber();
XMax   = Dialog.getNumber();
YMin   = Dialog.getNumber();
YMax   = Dialog.getNumber();
ErrBars = Dialog.getCheckbox();
//print (nSeries,XMin,XMax,YMin,YMax);

run("Set Measurements...", "redirect=None decimal=1");

// X axis
setTool("line");
waitForUser("trace X axis");
getLine(x1, y1, x2, y2, lineWidth);

// origin
XMin_m = x1;

// max value on Xaxis
XMax_m = x2;


// Y axis
setTool("line");
waitForUser("trace Y axis");
getLine(x1, y1, x2, y2, lineWidth);

//YMax_m = getHeight()-y2;
//YMin_m = getHeight()-y1;

YMax_m = y2;
YMin_m = y1;


// set add parameters for pointer: the points will be added as ROIs
run("Point Tool...", "type=Crosshair color=Orange size=Medium add label");

// loop over series to get coordinates
for (i=0;i<nSeries;i++){
	print("----------- SERIES NUMBER "+i+1+" --------------");
	setTool("point");
	waitForUser("select data point from the series number "+i+1+"\n click OK when done");
	
	// loop over individual points
	for( j=0;j<roiManager("count");j++){
		roiManager("select", j);

		// get actual point
		getSelectionCoordinates(xCoordinates, yCoordinates);
		Xseries = (xCoordinates[0]-XMin_m)*(XMax-XMin)/(XMax_m-XMin_m) + XMin;
		Yseries = (yCoordinates[0]-YMin_m)*(YMax-YMin)/(YMax_m - YMin_m) + YMin;
		if (ErrBars){
			setTool("line");
			waitForUser("trace y error bars of point number "+j+1);
			getLine(errx1, erry1, errx2, erry2, lineWidth);
			errBar = abs(abs(erry1-erry2)*(YMax-YMin)/(YMax_m - YMin_m) + YMin);
			print ( Xseries+'\t'+ Yseries+'\t'+errBar);	
		}
		else{
			print ( Xseries+'\t'+ Yseries);		
		}
	}
	cleanupROI();
}

cleanupROI();



