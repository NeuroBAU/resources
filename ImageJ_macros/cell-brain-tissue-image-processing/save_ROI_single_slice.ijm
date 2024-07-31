
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

// open file
path = File.openDialog("open AMYGDALA file");
open(path);

// z-project
run("Z Project...", "projection=[Average Intensity]");

// close the original file
var fname = File.name;
selectWindow(File.name);
close();

// make sure that ImageJ is collecting the proper data
run("Set Measurements...","area centroid stack display decimal=3");

// array of labels [used to define the regions name]
var selectMe = newArray("LA","BLA","Ce","ITC");

// selection labels
function foo(labelSet){
	Dialog.create("Label ROI");
	Dialog.addChoice("Label", labelSet)
	Dialog.show();
	lbl = Dialog.getChoice();
	return lbl;
};

roiDir = File.directory+"ROI"+File.separator;
File.makeDirectory(roiDir);

saveDir = File.directory;
saveTitle = File.nameWithoutExtension;

// set polygon tool for tracing ROIs
setTool("polygon");

// HARDCODED: assumes that there are exactly 4 ROIs in the image
selected_labels = newArray(4);

// HARDCODED: same thing here: ony 4 ROIs
// Select ROIs and save the coordinates to file
for (i = 0; i <4; i++){
	waitForUser("Select Roi");
	roiManager("Add");
	roiManager("Select", i);
	tempLabel = foo(selectMe);
	selected_labels[i] = tempLabel;
	// roiManager("Show All")
	print(selected_labels[i]);
	run ("Labels...","color=white font=10 show use draw bold");
	roiManager("Select", i);
	roiManager("Rename", selected_labels[i]);
	sliceNumber = getSliceNumber();
	// save coordinates in a subdirectory named ROI
	saveAs("XY Coordinates", roiDir+saveTitle+"_"+selected_labels[i]+".txt");		
}

// split channels into 3 different images
run("Split Channels");

// Assumes that there are  three markers (or channels) and their names are hardcoded here)
// The order of the elements in the array reflects the channel order in the image
var marker = newArray("DAPI","ZIF","PV");

// crop the image to the ROIs sizes and save in separate files
for (i = 1; i <=3; i++){
	setBatchMode(true);
	for (j = 0; j <4; j++){
		
		selectWindow("C"+i+"-AVG_"+fname);
		roiManager("select",j);
		// duplicate
		run ("Duplicate..."," ");
		run("Make Inverse");
	    setBackgroundColor(0, 0, 0);
	    run("Clear", "slice");
		// save copy
		saveAs("Tiff", roiDir + fname + "_" + marker[i-1] + "_" + selected_labels[j] + ".tif");
		close();
	}
	selectWindow("C"+i+"-AVG_"+fname);
	close();
	setBatchMode(false);
}