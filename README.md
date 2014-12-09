Whisker_Tracker
===============
Whisker_Tracker.ijm is an ImageJ/FIJI macro for tracking a single whisker. It
uses the existing functionality of ImageJ to simplify the analysis.

Whisker_Inspector
=================
Whisker_Inspector.ijm checks the result of the output file from Whisker_Tracker.ijm.
It is possible to check and correct the whisker position of each frame.

Downloading
===========
https://github.com/tarokiritani/jWhisktracker

Click "ZIP" button, and download the macro.

Installation
============
First, make sure that your ImageJ/FIJI version is up to date (Help > update ImageJ).
These macros also require some plugins which may not be included in old ImageJ versions. If
you do not have either FIJI or ImageJ, you are recommended to get FIJI.
To install the macros, put them in the plugins folder or a subfolder.

Images
======
The program expects a grayscale, white-background (high pixel value) image stack.
The image quality is crucial for correct tracking. I use the Optronis 600x2 camera, Navitar 50mm lens
(f/1.4), and an 2x expansion lens (EX2C, Edmund Optics). The whisker is illuminated
using an infrared LED (M850L2-C1, Thorlabs).

![Alt text](https://raw.github.com/tarokiritani/jWhisktracker/master/withExpander.jpg "Whisker Image")

<!---
Algorithm
=========
Whisker_Tracker.ijm first determines an arc and a basepoint on the image based on the user input. It then looks
for the darkest point on the arc, and calculates the angle from the basepoint. It
also subtract the background before searching for the whisker.
-->

How to Use
==========
1. Open a virtual stack of your whisker movie. 
2. Run Whisker_Tracker.ijm.
3. You are prompted to click three points. The first and last determine the range
where the whisker are searched for. The second point is the base point. After determining
the points, you can still click and drag the points to change the positions.
4. Click "OK".
5. Make a background image. This can be done by getting the median projection between two frames or by loading a file.
6. The background image is subtracted, and the program looks for the darkest point on the arc. Do not click image windows of ImageJ while the macro is running.
7. A new image named "time vs angle" pops up. In this image, each column corresponds to a profile on the arc of a frame. The darkest points in each column are connected.
8. Remove any incorrectly tracked points by a. making an roi, and b. hit edit > clear. It is convenient to make a shortcut for 'clear' in Plugins > Shortcuts > Create shortcut.
9. Repeat this until the whisker is correctly tracked.
10. Save the data in a text file. The text can be directly
 copied and pasted in Matlab.
11. Click your movie stack and run Whisker_Inspector.ijm. Open the output file you generated when prompted.
12. Check whisker position in each frame. Correct whisker position with a left click. Right click the image when you are done.
13. If this software is useful to you, I would appreciate it if you acknowledged it with
the URL (https://github.com/tarokiritani/jWhisktracker).