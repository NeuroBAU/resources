Dialog.create("Define pixel grid");
Dialog.addNumber("start", 2, 0, 4, "Columns");
Dialog.addNumber("end", 2, 0, 4, "Rows");
Dialog.show();

var start = Dialog.getNumber(); 
var end = Dialog.getNumber(); 



roiManager("add");
// loop over ROIs and do stuff ...
for (i=start; i<end; i++) {
	setSlice(i);
	roiManager("add");
	roiManager("Select", 0);
	setForegroundColor(0, 0, 0);
	run("Draw", "slice");
}


//waitForUser('set threshold');