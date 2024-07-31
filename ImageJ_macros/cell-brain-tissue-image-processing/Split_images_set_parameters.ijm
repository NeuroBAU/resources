
// clean up old ROIs (if present)
if (roiManager("count")>0){
	roiManager("Delete");
}

Stack.setDisplayMode("composite");

// duplicate image and create a working image for splitting channels
run("Duplicate...", "title=working-image duplicate");
run("Split Channels");
selectWindow("C1-working-image");
rename("dapi");
selectWindow("C2-working-image");
rename("gfp");
selectWindow("C3-working-image");
rename("fos");

// point tool settings
run("Point Tool...", "type=Circle color=Orange size=[Extra Large] add label");
setTool("point");

// set the measurements
run("Set Measurements...", "area mean centroid bounding shape feret's skewness display redirect=None decimal=3");

// open brightness & contrast
run("Brightness/Contrast...");
