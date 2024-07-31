
// choose directory 1
dir1 = getDirectory("Choose Source Directory ");
list1 = getFileList(dir1);

// choose directory 2
dir2 = getDirectory("Choose Source Directory ");
list2 = getFileList(dir2);

fileName = getString("Choose file name to create directory", "myFile");
outDir = File.directory+fileName+"_processed"+File.separator;
print(outDir);
File.makeDirectory(outDir);

// !!! assumes equal number of images in the two  directories
for (i=0; i<list1.length; i++) {
	// open the files
	setBatchMode(true);
	open(dir1+list1[i]);
	open(dir2+list2[i]);

	// do your stuff here
	//...
	
	selectWindow(list1[i]);
	close();
	selectWindow(list2[i]);
	close();

	// save as
	selectWindow();
	tempFileName = File.nameWithoutExtension
	newFile = outDir+tempFileName+"_processed";
	saveAs(".tif",newFile);
	close();
	setBatchMode(false);
}

