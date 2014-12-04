path = File.openDialog("open the log file.");
str = File.openAsString(path);
lines = split(str, ";");
angles = split(lines[0], "[]");
angles = Array.slice(angles, 1, 2);
angles = split(angles[0]);
anglesDouble = newArray(lengthOf(angles));

for (i=0; i<lengthOf(angles); i++) {
	anglesDouble[i] = parseFloat(angles[i]);
}

r = split(lines[1], "=;");
r = parseFloat(r[1]);

basePoint = split(lines[2], "[]");
basePoint = split(basePoint[1]);
basePointX = parseFloat(basePoint[0]);
basePointY = parseFloat(basePoint[1]);

makeOval(basePointX-r, basePointY-r, 2*r, 2*r);
Overlay.addSelection;

showMessage("left click to update the angle. right click to end the process.");

rightButton = 4;
leftButton = 16;
iterate = true;
while (iterate == true){
	sn = getSliceNumber();
	drawLine(basePointX, basePointY, basePointX + r * cos(anglesDouble[sn-1] * PI / 180), basePointY - r * sin(anglesDouble[sn-1] * PI / 180));
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
	if (flags&rightButton != 0){
		iterate = false;
	}
}

f = File.open(""); // display file open dialog
fName = File.name;
fFolder = File.directory;
fPath = fFolder + File.separator + fName;
File.close(f);

File.append("angleArray = [", fPath);

for (i=0; i<lengthOf(anglesDouble); i++) {
	File.append(" " + anglesDouble[i], fPath);
}

File.append("];", fPath);
File.append("\r", fPath);
File.append("r = " + r + ";", fPath);
File.append("basePoint = [" + toString(basePointX) + " " + toString(basePointY) + "];", fPath);