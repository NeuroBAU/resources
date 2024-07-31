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


original = getTitle();

// Z-project
getDimensions(width, height, channels, slices, frames);
run("Z Project...", "start=1 stop="+slices+" projection=[Max Intensity]");

// close original image
selectWindow(original);
close();

// split Z-stack channels
selectWindow("MAX_"+original);
run("Split Channels");

// close DAPI channel
selectWindow("C1-MAX_"+original);
close();

run("Merge Channels...", "c1=C2-MAX_"+original+" c4=C3-MAX_"+original+" create");
run("Channels Tool...");
