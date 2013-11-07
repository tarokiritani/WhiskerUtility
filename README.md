Whisker_Tracker
===============
Whisker_Tracker.ijm is an ImageJ/FIJI macro for tracking of a single whisker. It
uses the existing functionality of ImageJ to simplify the analysis.

Downloading
===========
https://github.com/tarokiritani/jWhisktracker

Click "ZIP" button, and download the macro.

Installation
============
First, make sure that your ImageJ/FIJI version is up to date (Help > update ImageJ).
It also requires some plugins which may not be included in old ImageJ versions. If
you do not have either FIJI or ImageJ, you are recommended to get FIJI.
To install the macro, put Whisker_Tracker.ijm in the plugins folder or a subfolder
of ImageJ/FIJI. You can run this macro by pressing a single key by creating a
shortcut using Plugins>Shortcuts>Create Shortcut.

Images
======
The program expects a grayscale, white-background (high pixel value) image stack.
The image quality is crucial for correct tracking. I use the Optronis 600x2 camera, Navitar 50mm lens
(f/1.4), and an 2x expansion lens (EX2C, Edmund Optics). The whisker is illuminated
using an infrared LED (M850L2-C1, Thorlabs).

![Alt text](https://raw.github.com/tarokiritani/jWhisktracker/master/withExpander.jpg "Whisker Image")

Algorithm
=========
The macro first determines an arc and a basepoint on the image based on the user input. It then looks
for the darkest point on the arc, and calculates the angle from the basepoint. It
also subtract the background before searching for the whisker.

How to Use
==========
1. Open a stack of whisker image.
2. Run the macro.
3. You are prompted to click three points. The first and last determine the range
where the whisker are searched for. The second point is the base point. After determining
the points, you can still click and drag the points to change the positions.
4. Click "OK".
5. The program preprocess the data, and find the angle of the tracked whisker.
6. If the result looks good, save the data in a text file. The text can be directly
copied and pasted in Matlab.
7. If this software is useful to you, we'd appreciate it if you acknowledged it with
the URL (https://github.com/tarokiritani/jWhisktracker).
