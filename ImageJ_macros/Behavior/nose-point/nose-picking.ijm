setTool("point");

waitForUser( "pick nose :)" );
getSelectionCoordinates(xCoordinates, yCoordinates);
x = xCoordinates[0] - 8;
y = yCoordinates[0] - 8;

window_name = getTitle();
fname = "background"
counter = 0;

setBatchMode(true);
for (i = 0; i < 6; i++) {
	for (j = 0; j < 6; j++) {
	makeRectangle(x + i, y + j, 16, 16);
	roiManager("Add");
	run("Duplicate...", "title=" + window_name);
	selectWindow(window_name);
	saveAs("PNG", "/Users/lex\ 1/switchdrive/Neuro-BAU/code/nose-tracking-cnn/train/" + window_name + "_" + fname + "_" + counter +".png");
	selectWindow(window_name + "_" + fname + "_" + counter +".png");
	close();
	counter++;
	}
}
setBatchMode(false);