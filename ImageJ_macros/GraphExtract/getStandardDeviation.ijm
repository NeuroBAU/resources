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
Dialog.addNumber("Y-axis: MIN value", 0)
Dialog.addNumber("Y-axis: MAX value", 1800)
Dialog.addNumber("Number of subjects: ", 12)
Dialog.show()
nSeries   = Dialog.getNumber();
YMin   = Dialog.getNumber();
YMax   = Dialog.getNumber();
nSubjects   = Dialog.getNumber();

run("Set Measurements...", "invert redirect=None decimal=1");

function getDataPointOnYAxis(y1,y2){
	if(y1<y2){
		return(y1)
	}else{
		return(y2)
	}
}



// Y axis
setTool("line");
waitForUser("trace Y axis");
getLine(x1, y1, x2, y2, lineWidth);

YMax_m = getHeight()-y2;
YMin_m = getHeight()-y1;

// set add parameters for pointer
run("Point Tool...", "type=Crosshair color=Orange size=Medium add label");

// loop over series to get coordinates
for (i=0;i<nSeries;i++){
	print("----------- SERIES NUMBER "+i+1+" --------------");
	waitForUser("trace y error bars of point number "+i+1);
	getLine(errx1, erry1, errx2, erry2, lineWidth);
	errBar = abs(abs(erry1-erry2)*(YMax-YMin)/(YMax_m - YMin_m) + YMin);
	print ("Y Standard Error\t" + errBar);	
	print ("Y Standard Deviation\t" + errBar*sqrt(nSubjects));
	print("y value\t" + abs(getDataPointOnYAxis(erry1,erry2)*(YMax-YMin)/(YMax_m - YMin_m) + YMin));
}
