//////////////////////////////////////////////////
// October 5th, 2013							//
// Leonardo Restivo, Paul Frankland lab			//
// Neurosciences and Mental Health department	//
// Hospital for Sick Children, Toronto - ON		//
// CANADA										//
//////////////////////////////////////////////////

macro "Sample tiles [j]"{
	// takes an image and randomly samples (with replacement) small tiles

	// window size
	w=150;			// <----------------- User input !!!
	h=150;
	
	start=0;
	samplesize=5;

	// open original image
	path = File.openDialog("open file");
	open(path);

	// find image width and height
	getDimensions(width, height, channels, slices, frames);
	
	// save results in this directory (i.e. where the files are stored)
	dir = File.directory
	saveDir = dir+"Manual"+File.separator;
	File.makeDirectory(saveDir);

	// file name
	fname = File.nameWithoutExtension
	
	// sample whole image and save the individual tiles
	for (i=start; i<=samplesize; i++){
		x = random*width;
		y = random*height;
		print ('original X: '+x);
		if (x+w > width){
			x=width-w;
			print ('adjusted X: '+x+' *');
		};
		print ('original Y: '+y);
		if (y+h > height){
			y=height-h;
			print ('adjusted Y: '+y+' *');
		};
		
		makeRectangle(x, y, w, h);
		run("Copy");
		newImage("Untitled", "RGB black", w, h, 1);
		run("Paste");
		fnameSeq= saveDir+fname+"_"+i+".tif";
		saveAs("Tiff", fnameSeq);
		close();
	}
}

////////////////////////////////////////////////////////////////////////////////////////

macro "rapid counter [b]"{

	// Dead simple manual cell counter for saving the x,y coordinates of counted cells
	
	// open original image
	path = File.openDialog("open file");
	open(path);

	// make sure nothing is selected, and you're ready to go!
	run("Select None");

	// get filename
	fname = File.nameWithoutExtension;

	// set bare minimum measurements (centroid:x,y)
	run("Set Measurements...", "  centroid display redirect=None decimal=3");
	
	// use multipoint tool to count cells
	setTool("multipoint");
	
	// wait for user
	waitForUser("Count cells NOW!");

	// generate coordinates file
	run("Measure");

	// save file in the same directory where the images are stored (new directory)
	dir = File.directory
	saveDir = dir+"Manual_counts"+File.separator;
	File.makeDirectory(saveDir);
	saveAs("Results", saveDir+fname+"_Manual.txt");
	close();

	// empty result window
	run("Clear Results");
}



