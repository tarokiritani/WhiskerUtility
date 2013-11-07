path = File.openDialog("open the log file.");
str = File.openAsString(path);
lines = split(str, "\n");
angles = split(lines[0], "[]");
angles = Array.slice(angles, 1, 2);
angles = split(angles[0]);
anglesDouble = newArray(lengthOf(angles));

for (i=0; i<lengthOf(angles); i++) {
	anglesDouble[i] = parseFloat(angles[i]);
}

print(anglesDouble[0]);
print(anglesDouble[99]);

r = split(lines[1], "=;");
print(r[1]);
r = parseFloat(r[1]);
print(r);

basePoint = split(lines[2], "[]");
basePoint = split(basePoint[1]);
basePointX = parseFloat(basePoint[0]);
basePointY = parseFloat(basePoint[1]);

//moviePath = File.openDialog("open the movie file.");

makeOval(basePointX-r, basePointY-r, 2*r, 2*r);
Overlay.addSelection;

for (i = 0; i<nSlices; i++) {
	Stack.setSlice(i + 1);
	drawLine(basePointX, basePointY, basePointX + r * cos(anglesDouble[i] * PI / 180), basePointY - r * sin(anglesDouble[i] * PI / 180));
}

showMessage("right click to update the angle. <Alt> to end the process.");

alt = 8;
leftButton = 16;
iterate = true;
while (iterate == true){
	getCursorLoc(x, y, z, flags);
	if (flags&leftButton != 0){
		tangential = atan2(basePointY - y, x - basePointX);
		if (tangential < 0){
			tangential = tangential + 2 * PI;
		}
		anglesDouble[z] = tangential * 180 / PI;
		iterate = true;
		drawLine(basePointX, basePointY, basePointX + r * cos(anglesDouble[z] * PI / 180), basePointY - r * sin(anglesDouble[z] * PI / 180));
	}
	if (flags&alt != 0){
		iterate = false;
	}
	wait(10);
}

anglesString = "";
for (i = 0; i<lengthOf(anglesDouble); i++) {
	anglesString = anglesString + " " + anglesDouble[i];
}

f = File.open(""); // display file open dialog
print(f, "angleArray = [" + anglesString + "];");
exit;
