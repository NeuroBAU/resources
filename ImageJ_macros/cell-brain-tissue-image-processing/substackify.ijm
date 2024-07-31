macro "substackify [d]"{
	// open file
	path = File.openDialog("open file");
	open(path);
	
	// get original title
	original = getTitle();
	
	// make substack
	for (seq=1; seq<3; seq++) {
		selectWindow(original);
		run("Make Substack...", "channels=1-3 slices=1-4 frames="+seq+"");
		// save substack
		saveAs("tiff",path+original+"_"+seq);
		close();
	}
}