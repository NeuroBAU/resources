
/*
 * Author: 			Leonardo Restivo
 * Affiliation: 	Neuro-BAU, Department fo Fundamental Neuroscience, University of Lausanne
 * Date: 			29.AUG.2019
 * TO DO: 			Add the clean-up roi at the beginning
 */

function findOnset(array_in, critical_value, step) {
	/*
	 * `critical_value` is 2 * standard deviations above the average value
	 * `step` is the length of the "jump ahead" to find the next Inter Led  Interval
	 * and start to look for value above the average
	 * return array with onset points (by default the number is set to 3),
	 * this can be extended to accept more onsetpoints
	 * Example:
	 *			findOnset(x, 195, 20);
	 */
	onset_points = newArray(3);
	counter = 0;
	for (i = 0; i < array_in.length; i++) {
//		print(i);
		if (array_in[i] > critical_value) {
			print("index: ", i, '\t',"value: ", array_in[i]);
			onset_points[counter] = i + 1; // +1 to compensate for index mismatch between array, ROI and frmae indexing
			counter += 1;
			i += step;
		}
	};
	return onset_points;
}

if (roiManager("count") > 0){
	roiManager("Deselect");
	roiManager("Delete");
}

// get movie title
movie_title = getImageID();

// set the tool to draw the ROI
setTool("oval");

// only collect data on the mean gray value
run("Set Measurements...", "mean redirect=None decimal=3");

// ask user to trace the ROI
waitForUser("Select the ROI");
roiManager("Add");

// go to the beginning of the stack (movie) and zoom out to speedup the analysis
setSlice(1);
for (i = 0; i < 9; i++) {
	run("Out [-]");
}

// Go through each slice (frame) and measure intensity inside the ROI
setBatchMode(true);
for (r = 0; r < nSlices; r++) {
	run("Measure");
	run("Next Slice [>]");
	setResult("frame", r, r);
}
setBatchMode(false);

// Plot the results
R = nResults();
xValues = newArray(R);
yValues = newArray(R);

for(i = 0; i < R; i++){
	yValues[i] = getResult("Mean", i);
	xValues[i] = getResult("frame", i);
}

// get statistics
Array.getStatistics(yValues, min, max, mean, stdDev);
onset_threshold = mean + stdDev*2;
jump_ahead = 300;
print('Mean:'+ '\t' + mean);
print('Std.Dev:' + '\t' + stdDev);
print('Critical value:' + onset_threshold);

// find onset points
points = findOnset(yValues, onset_threshold, jump_ahead);

// plot LED intensity value
Plot.create("Title", "frame", "Mean");
Plot.setColor("red");
Plot.add("line",xValues, yValues);
Plot.setLimits(0, R, 0, 255);
Plot.setColor("black");
for (i = 0; i < points.length; i++) {
	Plot.drawLine(points[i],0, points[i], 255);
}
Plot.show()

// set plot location to top left
setLocation(0, 0);
getLocationAndSize(x, y, width, height); 

// extract frames with LED onset
window_x_position = 0;
for (i = 0; i < points.length; i++) {
	selectImage(movie_title);
	run("Select None");
	setSlice(points[i]);
	run("Duplicate...", "title=" + points[i]);
	run("Set... ", "zoom=50");
	setLocation(window_x_position, height + 30);
	window_x_position += 400;
}


