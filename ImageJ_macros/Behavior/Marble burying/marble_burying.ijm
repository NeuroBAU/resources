//++++++++++++++++++++++++++++++++++++++++++++++++++++++++
// Neuro-BAU | DNF | UNIL
// Leonardo Restivo - 2019-05-29
// Macro for cleaning images of the Marble Burying assay
//
// +-+-+-+-+-+-+-+- UPDATE: 21-JAN-2020 +-+-+-+-+-+-+-+-+-
//Procedure (how to run)
// run the macro:
//		- select the movie.
//		- click and drag the Circle ROI
//		- while dragging the roi press `T` (i.e. add to ROI manager)
//		  on all marbles of the BEFORE image and then press `deselect` and `measure`
//		- save results to spreadsheet
//		- Close `BEFORE` image, activate `AFTER` image
//		- go over the ROI manager list and place the ROIs on the dark spots
//		- press `deselect` and `measure` on the ROI manager window
//		- save results to spreadsheet
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++

// open movie
run("Movie (FFMPEG)...", "choose=[] use_virtual_stack first_frame=0 last_frame=-1");

movie = getImageID();
print(movie);

// generate first frame
run("Duplicate...", "title=before");
run("8-bit");
run("Gaussian Blur...", "sigma=4");
run("Median...", "radius=10");
run("Minimum...", "radius=2");
before = getImageID();

selectImage(movie);
last_frame =  nSlices();

// generate second frame
setSlice(last_frame);
run("Duplicate...", "title=after");
run("8-bit");
run("Gaussian Blur...", "sigma=4");
run("Median...", "radius=10");
run("Minimum...", "radius=2");

// close original movie
selectImage(movie);
close();

// setup measurements
run("Set Measurements...", "area mean min integrated redirect=None decimal=3");
setTool("oval");
selectImage(before);
makeOval(100, 175, 20, 20);
