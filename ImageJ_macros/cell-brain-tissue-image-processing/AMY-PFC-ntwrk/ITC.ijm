
// generate non-destructive layer
run("Duplicate...", "title=temp");

// scale down the resolution (lump the high-density structures)
run("Bin...", "x=10 y=10 bin=Average");
run("Size...", "width=2048 height=2048 constrain interpolation=None");
run("Gaussian Blur...", "sigma=10");
run("Find Maxima...", "noise=50 output=[Maxima Within Tolerance]");

//generate selection from macro structures
run("Create Selection");
run("Add to Manager");
roiManager("Select", 0);

//grow the boundaries of the regions by 8um 
run("Enlarge...", "enlarge=8");
run("Add to Manager");
roiManager("Select", 0);
roiManager("Delete");

// select the original image
selectWindow("temp");
roiManager("Select", 0);

//close analyzed windows
selectWindow("temp Maxima");
run("Close");
selectWindow("temp");
run("Close");

// backup original
run("Duplicate...", "title=temp");

//----------------------- generate LOW density
selectWindow("temp");
run("Duplicate...", "title=temp_LOW");
roiManager("Select", 0);
setBackgroundColor(0, 0, 0);
run("Clear", "slice");
roiManager("Deselect");

//----------------------- generate HIGH density
selectWindow("temp");
run("Duplicate...", "title=temp_HIGH");
roiManager("Select", 0);
run("Make Inverse");
setBackgroundColor(0, 0, 0);
run("Clear", "slice");
roiManager("Deselect");

selectWindow("temp");
run("Close");


//particle analysis on high-density structures
//run("Median...", "radius=2");
//run("Find Maxima...", "noise=3 output=[Segmented Particles] exclude light");
//run("Distance Map");
//run("Find Maxima...", "noise=3 output=[Maxima Within Tolerance] exclude light");
//run("Watershed");
//roiManager("Show All");
//run("Analyze Particles...", "size=1-500 circularity=0.40-1.00 show=Nothing exclude clear add");