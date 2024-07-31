// open original file
open("/Users/volocity5/Documents/Restivo/cellProfiler/trial_Huron/set3/fos.tif");
run("8-bit");
setThreshold(1, 255);
setOption("BlackBackground", true);
run("Convert to Mask");
run("Analyze Particles...", "size=0.05-Infinity circularity=0.00-1.00 show=Nothing exclude clear add");
// close window
close();

// open original file
open("/Users/volocity5/Documents/Restivo/cellProfiler/trial_Huron/set3/dapi.tif");

roiManager("Select", 0);
run("Crop");
getDimensions(width, height, channels, slices, frames);
makeRectangle(width/2, 0, width/2, height/2);
run("Crop");
// save cropped file