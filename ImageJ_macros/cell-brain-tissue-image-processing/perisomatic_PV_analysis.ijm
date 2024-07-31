//////////////////////////// Global function for clearing up the ROI manager/////////////////
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

// open dapi
path = File.openDialog("open DAPI");
open(path);

// open zif
path = File.openDialog("open ZIF");
open(path);

// create directory to save files
saveDir = File.directory+"data"+File.separator;
File.makeDirectory(saveDir);

// stack images
run("Images to Stack");

// zoom 200%
run("Set... ", "zoom=200");

// make sure the settings are right
setTool("freehand");
roiManager("Show All");
roiManager("Associate", "false");
run("Set Measurements...", "area mean min centroid perimeter feret's integrated area_fraction display redirect=None decimal=3");

// TRACE ZIF+
setSlice(2);
waitForUser("trace ZIF+");
nZIFp = roiManager("count");

// Set color of ZIF+ cells
m = newArray(nZIFp);

for (i=0; i<nZIFp; i++){
	m[i]=i;
}
roiManager("Select", m);
roiManager("Set Color", "#117c9a");
roiManager("Set Line Width", 0);
roiManager("Set Fill Color", "#117c9a");
roiManager("Deselect");


// TRACE ZIF-
setSlice(1);
waitForUser("trace ZIF negative");

totalZIF = roiManager("count");
nZIFn = totalZIF-nZIFp;

// get height of the image 
imageHeight = getHeight();

// measure X & Y position of each ROI and measure intensity on ZIF channel
setSlice(2);
roiManager("Measure");
for (i=0; i<nResults; i++){
	setResult("image_height",i,imageHeight);
	tmpY = getResult("Y",i);
	setResult("dv_position",i,(tmpY*100)/imageHeight);
}
for (i=0; i<nZIFp; i++){
	setResult("cell-type",i,"P");
}
for (i=nZIFp; i<totalZIF; i++){
	setResult("cell-type",i,"N");
}

// Save results (INTENSITY)
selectWindow("Results");
saveAs("Text",saveDir+File.nameWithoutExtension+"_intensity_ZIF.txt");
run("Close");

// close DAPI and ZIF
close();

// open PV
path = File.openDialog("open PV");
open(path);

// zoom 200%
run("Set... ", "zoom=200");

// convert to binary
run("Threshold...");
waitForUser("SET THRESHOLD!");

setOption("BlackBackground", false);
run("Convert to Mask");

// close threshold window
selectWindow("Threshold");
run("Close");

nROIs = roiManager("count");

run("Set Measurements...", "area centroid perimeter area_fraction display redirect=None decimal=3");

for (i=0; i<nROIs; i++){
	roiManager("Select", i);
	run("Make Band...", "band=3");
	run("Analyze Particles...", "  summarize");
}

// Save results (Perisomatic PV density)
close();
selectWindow("Summary");
saveAs("Text",saveDir+File.nameWithoutExtension+"_perisomatic_PV.txt");
run("Close");

selectWindow("Results");
run("Close");


