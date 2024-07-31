////////////////////////////////////////////////////////
// date: 21 AUG 2013
// split an hyperstack into separate folders.
// z-project (Average method)
// numbered sequentially
////////////////////////////////////////////////////////

dir1 = getDirectory("Choose Source Directory ");
list = getFileList(dir1);

open(dir1+list[0]);
run("Hyperstack to Stack");

m1 = getString("prompt", "marker")
dapiDir = dir1+"dapi"+File.separator;
markerDir = dir1+m1+File.separator;
fosDir = dir1+"fos"+File.separator;
wfaDir = dir1+"wfa"+File.separator;

File.makeDirectory(dapiDir);
File.makeDirectory(markerDir);
File.makeDirectory(fosDir); 
File.makeDirectory(wfaDir); 

function splitImages(seq,whichDir,sectionNumber){
	selectWindow(list[0]);
	run("Make Substack...", "  slices="+seq+"");
	run("Z Project...", "start=1 stop=3 projection=[Average Intensity]");
	selectWindow("AVG_Substack ("+seq+")");
	saveAs("tiff", whichDir+sectionNumber);
	close();
	selectWindow("Substack ("+seq+")");
	close();
}

// combine the images in one Stack
function stackify(DirToStack,fileName){
	
	listToStack = getFileList(DirToStack);

	for (i=0; i<listToStack.length; i++) {
		setBatchMode(true);
	    	showProgress(i+1, listToStack.length);
	    	open(DirToStack+listToStack[i]);
	    	setBatchMode(false);
	}
	run("Images to Stack");
	saveAs("tiff", dir1+fileName);
	close();
}

// slice 1
name=m1+"1";
splitImages("1,5,9",dapiDir,"dapi_1");
splitImages("2,6,10",markerDir,name);
splitImages("3,7,11",fosDir,"fos_1");
splitImages("4,8,12",wfaDir,"wfa_1");

// slice #2
name=m1+"2";
splitImages("13,17,21",dapiDir,"dapi_2");
splitImages("14,18,22",markerDir,name);
splitImages("15,19,23",fosDir,"fos_2");
splitImages("16,20,24",wfaDir,"wfa_2");

// slice #3
name=m1+"3";
splitImages("25,29,33",dapiDir,"dapi_3");
splitImages("26,30,34",markerDir,name);
splitImages("27,31,35",fosDir,"fos_3");
splitImages("28,32,36",wfaDir,"wfa_3");

// slice #4
name=m1+"4";
splitImages("37,41,45",dapiDir,"dapi_4");
splitImages("38,42,46",markerDir,name);
splitImages("39,43,47",fosDir,"fos_4");
splitImages("40,44,48",wfaDir,"wfa_4");

// slice 5
name=m1+"5";
splitImages("19,53,57",dapiDir,"dapi_5");
splitImages("50,54,58",markerDir,name);
splitImages("51,55,59",fosDir,"fos_5");
splitImages("52,56,60",wfaDir,"wfa_5");

// slice #6
name=m1+"6";
splitImages("61,65,69",dapiDir,"dapi_6");
splitImages("62,66,70",markerDir,name);
splitImages("63,67,71",fosDir,"fos_6");
splitImages("64,68,72",wfaDir,"wfa_6");

// slice #7
name=m1+"7";
splitImages("73,77,81",dapiDir,"dapi_7");
splitImages("74,78,82",markerDir,name);
splitImages("75,79,83",fosDir,"fos_7");
splitImages("76,80,84",wfaDir,"wfa_7");

// slice #8
name=m1+"8";
splitImages("85,89,93",dapiDir,"dapi_8");
splitImages("86,90,94",markerDir,name);
splitImages("87,91,95",fosDir,"fos_8");
splitImages("88,92,96",wfaDir,"wfa_8");

// use this for tracing ROIs
stackify(dapiDir,"dapi");


