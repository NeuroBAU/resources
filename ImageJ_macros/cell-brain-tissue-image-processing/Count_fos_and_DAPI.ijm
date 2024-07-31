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
setTool("polygon");
original = getTitle();
getDimensions(width, height, channels, slices, frames);
run("Z Project...", "start=1 stop="+slices+" projection=[Max Intensity]");
run("Split Channels");
close(original);
close("C3-MAX_"+original);
selectWindow("C1-MAX_"+original);
waitForUser('select area');
roiManager("Add");
run("Smooth");
run("Smooth");
run("Smooth");

run("Find Maxima...", "noise=10 output=List");
print (original+'\t'+'DAPI'+'\t'+nResults);

//----------------------------
selectWindow("C2-MAX_"+original);

roiManager("Select", 0);
run("Smooth");
run("Smooth");
run("Smooth");

run("Find Maxima...", "noise=10 output=List");
print (original+'\t'+'FOS'+'\t'+nResults);
close("C1-MAX_"+original);
close("C2-MAX_"+original);
close("Results");
