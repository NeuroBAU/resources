////////////////////////////////////////////////////////////////////////////
// Author: Leonardo Restivo
// Hospital for Sick Children
// Neurosciences and Mental Health department, Paul Frankland lab
// Toronto - ON
// CANADA
// www.sciple.org
// @ScipleNeuro
////////////////////////////////////////////////////////////////////////////
// WHAT IS IT?
// 	z-project subslices of a stack and merge them into a multi-channel image
// 	used for visualizing z-depth of different dendritic and axonal branches
////////////////////////////////////////////////////////////////////////////
// USAGE:
//	open a z-stack image
//	open this macro
//	change fileName and fileExtension
//	Run the macro
////////////////////////////////////////////////////////////////////////////
// TO DO: 
// 	[1] Open Dialog for selecting file
// 	[2] dynamic z-stack range and number of channels
////////////////////////////////////////////////////////////////////////////

// filename of the open window
fname = "fileName"

// e.g. ".tif" or ".lsm"
ext = "fileExtension"

// first 10 slices of the stack will be z-projected using Max-intensity
selectWindow(fname+"."+ext);
run("Z Project...", "start=1 stop=10 projection=[Max Intensity]");

// slices from 11-20
selectWindow(fname+"."+ext);
run("Z Project...", "start=11 stop=20 projection=[Max Intensity]");

// ...
selectWindow(fname+"."+ext);
run("Z Project...", "start=21 stop=30 projection=[Max Intensity]");

// ...
selectWindow(fname+"."+ext);
run("Z Project...", "start=31 stop=40 projection=[Max Intensity]");

// ...
selectWindow(fname+"."+ext);
run("Z Project...", "start=41 stop=50 projection=[Max Intensity]");

// merge the z-projected images using different channel colors
run("Merge Channels...", "c2=[MAX_"+fname+"."+ext+"] c3=[MAX_"+fname+"-1."+ext+"] c6=[MAX_"+fname+"-2."+ext+"] c7=[MAX_"+fname+"-3."+ext+"] c5=[MAX_"+fname+"-4."+ext+"]create ignore");

