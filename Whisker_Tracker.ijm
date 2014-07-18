run("Colors...", "foreground=black background=white selection=red")
run("Overlay Options...", "stroke=red width=1 fill=none");
n = 100;
setTool("angle");
waitForUser("The second click is for the basepoint. The first and third clicks \n define the range where the minimum point is looked for.");
getSelectionCoordinates(xCoordinates, yCoordinates);
points = "";
xdelta = xCoordinates[0] - xCoordinates[1];
ydelta = yCoordinates[0] - yCoordinates[1];
r = sqrt(xdelta * xdelta + ydelta * ydelta);
x0 = xCoordinates[1];
y0 = yCoordinates[1];
run("Add Selection...")
theta1 = atan2(yCoordinates[1] - yCoordinates[0], xCoordinates[0] - xCoordinates[1]);
theta2 = atan2(yCoordinates[1] - yCoordinates[2], xCoordinates[2] - xCoordinates[1]);

if (abs(theta1 - theta2) > PI){
	if (theta1 < theta2){
		theta1 = theta1 + 2 * PI;
	} else {
		theta2 = theta2 + 2 * PI;	
	}
}

for (i=0; i<n; i++) {
	if (points == "") {
		points = toString(x0 + r * cos(theta1 + (theta2-theta1) / n * i)) +","+ toString(y0 - r * sin(theta1 + (theta2-theta1) / n * i));
	} else {
		points = points + "," + toString(x0 + r * cos(theta1 + (theta2-theta1) / n * i)) +","+ toString(y0 - r * sin(theta1 + (theta2-theta1) / n * i));
	}
}

//run("Subtract Background...", "rolling=600 light stack");

Dialog.create("range for z projection");
Dialog.addNumber("first", 1, 0, 5, "th frame");
Dialog.addNumber("last", 1, 0, 5, "th frame");
Dialog.show();
startNum = Dialog.getNumber();
endNum = Dialog.getNumber();

stackName = getTitle();
run("Z Project...", "start=" + startNum + " stop=" + endNum +  " projection=Median");
medianImage = getTitle();
imageCalculator("difference create stack", stackName, medianImage);
run("Invert", "stack");

run("Line Width...", "line=5");
sliceNum = nSlices;

for (i=1; i<sliceNum+1; i++) {
	Stack.setSlice(i);
	eval("makeLine(" + points+")");
	profile = getProfile();
	if (i == 1) {
		pointNum = profile.length;
		outProfile = newArray(sliceNum * pointNum);
	}
	for (j=0; j<pointNum; j++) {
		outProfile[(i-1) * pointNum + j] = profile[j];
	}
	mi = Array.findMinima(profile, 1);
	mi = mi[0];
	ma = theta1 + (theta2 - theta1) * mi/profile.length;
	drawLine(x0, y0, x0 + r*cos(ma), y0 - r * sin(ma));
	Overlay.addSelection;
}

newImage("time vs angle","8-bit", sliceNum, pointNum, 1);
selectWindow("time vs angle");

for (i=0; i<sliceNum; i++) {
	for (j=0; j<pointNum; j++){
		setPixel(i, j, outProfile[i*pointNum + j]);
	}
}

run("Enhance Contrast", "saturated=0.35");
iterate = 1;

while(iterate == 1) {
	minArray = newArray(sliceNum);
	minAngleString = "";
	for (i=0; i<sliceNum; i++) {
		minIndex = 0;
		minPixelVal = 255;
		makeLine(i, 0, i, pointNum);
		column = getProfile();
		columnIndex = Array.findMinima(column, 1);
		minIndex = columnIndex[0];
		minArray[i] = minIndex;
		minAngle = (theta1 + (theta2 - theta1) * minIndex/pointNum) * 180 / PI;
		minAngleString = minAngleString + " "+ toString(minAngle);
		makePoint(i,minIndex);
		run("Add Selection...");
	}
	setTool("rectangle");
	run("Colors...", "foreground=white background=white selection=red");
	waitForUser("Inspect manually: \n Get rid of incorrectly tracked positions. \n Make rectangles with the mouse > right click > clear.");
	Dialog.create("Manual Inspection");
	Dialog.addChoice("Is this OK?", newArray("Find minima again!", "ok!"));
	Dialog.show();
	if (Dialog.getChoice == "ok!") {
		iterate = 0;
	} else {
		run("Remove Overlay");
	}
}

imageDir = getDirectory("image"); // need to specify the folder?
f = File.open(""); // display file open dialog
print(f, "angleArray = [" + minAngleString + "];");
print(f, "r = " + r + ";");
print(f, "basePoint = [" + toString(x0) + " " + toString(y0) + "];");
print(f, "x1 = " + xCoordinates[0] + "; y1 = " + yCoordinates[0] + ";");
exit;