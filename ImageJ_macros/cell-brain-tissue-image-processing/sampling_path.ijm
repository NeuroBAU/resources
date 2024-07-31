// TO DO: 
// Set number of non-repeating samples
// Exclude samples outside of image boundaries

setTool("freeline");
waitForUser("trace sampling path");
roiManager("Add");
roiManager("Select", 0);
run("Interpolate", "interval=10 smooth adjust");
roiManager("Add");
roiManager("Select", 0);
roiManager("Delete");
roiManager("Select", 0);
roiManager("Rename", "sampling-path");
getSelectionCoordinates(x, y);
random_index = floor(random()*x.length);
ROI_height = 300;
box_width = 100;

upperY = y[random_index]-ROI_height/2;
makeRectangle(x[random_index],upperY, box_width, ROI_height)
run("Duplicate...", "title=random-sample duplicate");

setLocation(screenHeight/1.43, 100);
run("In [+]");
run("In [+]");
run("Scale to Fit");
setTool("point");
run("Point Tool...", "type=Crosshair color=Orange size=Medium add label");