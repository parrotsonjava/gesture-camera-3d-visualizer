# gesture-camera-3d-visualizer


## Getting started

This demo only works with Google Chrome. Don't try it using Firefox or other browsers.

To start this demo, start a web server. Then navigate to:
http://localhost:${PORT}/${PATH_TO_VISUALIZER}/index.html

You should now see a grid. Alternatively, close all Chrome processes (also the background processes).
Then restart Chrome using the command line option "--allow-file-access-from-files".

Then you can navigate to:
file://${PATH_TO_VISUALIZER}/index.html

There are currently five different supported visualizers:

Leap Motion:
http://localhost:${PORT}/${PATH_TO_VISUALIZER}/index.html?filter=Leap

Intel RealSense (face) - Windows only:
http://localhost:${PORT}/${PATH_TO_VISUALIZER}/index.html?filter=IntelRealSense-Face

Intel RealSense (hands) - Windows only:
http://localhost:${PORT}/${PATH_TO_VISUALIZER}/index.html?filter=IntelRealSense-Hands

Intel PerC (hands) - Using the PilotDataDeterminer application:
http://localhost:${PORT}/${PATH_TO_VISUALIZER}/index.html?filter=IntelPerceptual

Kinect 2 (skeleton) - Using the PilotDataDeterminer application:
http://localhost:${PORT}/${PATH_TO_VISUALIZER}/index.html?filter=Kinect2

## Online demo:

Have a look at the demo at the following URLs.

Intel RealSense hands visualizer:
http://parrotsonjava.github.io/gesture-camera-3d-visualizer/index.html?filter=IntelRealSense-Hands

Intel RealSense face visualizer:
http://parrotsonjava.github.io/gesture-camera-3d-visualizer/index.html?filter=IntelRealSense-Face
