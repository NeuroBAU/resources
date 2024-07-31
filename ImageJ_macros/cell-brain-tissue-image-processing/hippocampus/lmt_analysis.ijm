
//////Global function for clearing up the ROI manager//////
function cleanupROI(){
	temp_counter = roiManager("count");
	if (temp_counter>0){
		for (i=0; i<temp_counter; i++) {
			roiManager("Select", 0);
			roiManager("Delete");
		}
	}
}
cleanupROI();

// Set measurements for filopodia and LMTs
run("Set Measurements...","area centroid perimeter length display decimal=3");

// Open original file
path = File.openDialog("open LMT file");
open(path);

// File and directory info
saveTitle = File.nameWithoutExtension;
saveDir = File.directory+"data"+File.separator;
File.makeDirectory(saveDir);

// Z-project
getDimensions(width, height, channels, slices, frames);
run("Z Project...", "start=1 stop="+slices+" projection=[Max Intensity]");
selectWindow(File.name);
close();

// Find filopodia (click)
run("Point Tool...", "type=Dot color=Yellow size=Small add");
setTool("point");
waitForUser("click on FILOPODIA head");
filopodiaNumber = roiManager("count");

if (filopodiaNumber>0){
	// Trace filopodia
	setTool("freeline"); //setTool("polyline");
	for (s = 0; s <filopodiaNumber; s++){
	 waitForUser("Trace filopodia #"+s+1);
	 roiManager("Add");
	 setOption("Show All",true);
	}
	
	// Save filopodia length and close result window
	// set labels for each filopodia
	for (s = 0; s <filopodiaNumber; s++){
		setResult("Label",s,saveTitle);
		setResult("file_path",s,File.directory);
	}
	roiManager("Measure");
	saveAs("Results", saveDir+saveTitle+"_filopodia_length.txt");
	selectWindow("Results");
	run("Close");

}
// if no filopodia are found then save empty result file
else{
	setResult("Label",0,saveTitle);
	setResult("Area",0,0);
	setResult("X",0,0);
	setResult("Y",0,0);
	setResult("Perim.",0,0);
	setResult("Length",0,0);
	saveAs("Results", saveDir+saveTitle+"_filopodia_length.txt");
}

// Trace LMT area
setTool("freehand");
waitForUser("Trace LMT");
run("Measure");
setResult("filopodia",0,filopodiaNumber);
setResult("Label",0,saveTitle);
setResult("file_path",0,File.directory);
saveAs("Results", saveDir+saveTitle+"_LMT.txt");
selectWindow("Results");
run("Close");

// Close image file
close();

