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

Dialog.create("range for z projection");
Dialog.addNumber("first", 1, 0, 5, "th frame");
Dialog.addNumber("last", 1, 0, 5, "th frame");
Dialog.show();
startNum = Dialog.getNumber();
endNum = Dialog.getNumber();

stackName = getTitle();
run("Z Project...", "start=" + startNum + " stop=" + endNum +  " projection=Median");
medianImage = getTitle();
run("Line Width...", "line=5");
eval("makeLine(" + points+")");
profileMedian = getProfile();
pointNum = profileMedian.length;
selectWindow(stackName);
sliceNum = nSlices;
outProfile = newArray(sliceNum * pointNum);
for (i=1; i<sliceNum+1; i++) {
	Stack.setSlice(i);
	eval("makeLine(" + points+")");
	profile = getProfile();
	for (j=0; j<pointNum; j++) {
		outProfile[(i-1) * pointNum + j] = abs(profile[j]-profileMedian[j]);
	}
}

newImage("time vs angle","8-bit", sliceNum, pointNum, 1);
selectWindow("time vs angle");
for (i=0; i<sliceNum; i++) {
	for (j=0; j<pointNum; j++){
		setPixel(i, j, outProfile[i*pointNum + j]);
	}
}

run("Invert");
run("Enhance Contrast", "saturated=0.35");
run("Line Width...", "line=1");
iterate = 1;
while(iterate == 1) {
	minArray = newArray(sliceNum);
	columns = newArray(sliceNum);
	for (i=0; i<sliceNum; i++) {
		columns[i] = i;
		makeLine(i, 0, i, pointNum-1);
		columnProfile = getProfile();
		columnMin = Array.findMinima(columnProfile, 1);
		minArray[i] = columnMin[0];
	}
	makeSelection("polyline", columns, minArray);
	roiManager("add");
	roiManager("Show All");
	roiManager("Set Color", "red");
	roiManager("Set Line Width", 2);
	setTool("rectangle");
	run("Colors...", "foreground=white background=white selection=red");
	waitForUser("Inspect manually: \n Get rid of incorrectly tracked positions. \n Make rectangles with the mouse > right click > clear.");
	Dialog.create("Manual Inspection");
	Dialog.addChoice("Is this OK?", newArray("Find minima again!", "ok!"));
	Dialog.show();
	if (Dialog.getChoice == "ok!") {
		iterate = 0;
	} else {
		roiManager("reset");
	}
}

imageDir = getDirectory("image"); // need to specify the folder?
f = File.open(""); // display file open dialog
fName = File.name;
fFolder = File.directory;
fPath = fFolder + File.separator + fName;
File.close(f);

File.append("angleArray = [", fPath);

for (i=0; i<sliceNum; i++) {
	minAngle = (theta1 + (theta2 - theta1) * minArray[i]/pointNum) * 180 / PI;
	minAngle = toString(minAngle);
	File.append(" " + minAngle, fPath);
}

File.append("];", fPath);
File.append("\r", fPath);
File.append("r = " + r + ";", fPath);
File.append("basePoint = [" + toString(x0) + " " + toString(y0) + "];", fPath);
File.append("x1 = " + xCoordinates[0] + "; y1 = " + yCoordinates[0] + ";", fPath);