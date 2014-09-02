/**
 * 2 Cameras Example
 * by Gerardo Bort. 
 *
 * <gerardobort@gmail.com>
 */

import processing.video.*;

Capture[] cams;
int totalCameras;
int cameraWidth, cameraHeight;
Capture video;
int[] buffer1;
int[] buffer2;
int[] buffer3;
int numPixels;

void setup() {
    size(640*2, 480);

    String[] cameras = Capture.list();
    cameraWidth = 640;
    cameraHeight = 480;
  
    if (cameras.length == 0) {
        println("There are no cameras available for capture.");
        exit();
    } else {
        //println("Available cameras:");
        //for (int i = 0; i < cameras.length; i++) {
        //    println(cameras[i]);
        //}
    
        totalCameras = 2;
        cams = new Capture[totalCameras];
        cams[0] = new Capture(this, cameraWidth, cameraHeight, "/dev/video0", 24);
        cams[1] = new Capture(this, cameraWidth, cameraHeight, "/dev/video1", 24);
        cams[0].start();     
        cams[1].start();     

        numPixels = cameraWidth*cameraHeight;
        buffer1 = new int[numPixels*totalCameras];
        buffer2 = new int[numPixels*totalCameras];
        buffer3 = new int[numPixels*totalCameras];
        loadPixels();
    }      
}

void draw() {
    int videoX, videoY, screenX, screenY, screenIndex;
    for (int c = 0; c < totalCameras; c++) {
        video = cams[c];
        if (video.available() == true) {
            video.read();
            video.loadPixels();
        }
        for (int i = 0; i < numPixels; i++) {
            videoX = i % cameraWidth;
            if (c == 0) {
                videoX = cameraWidth - videoX;
            }
            videoY = abs(i / cameraWidth);
            screenX = videoX + (width/2)*c;
            screenY = videoY;
            screenIndex = screenY*width + screenX;
            color currColor = video.pixels[i];
            color prevColor = buffer1[screenIndex];
            buffer1[screenIndex] = currColor;

            int currR = (currColor >> 16) & 0xFF;
            int currG = (currColor >> 8) & 0xFF;
            int currB = currColor & 0xFF;
            int prevR = (prevColor >> 16) & 0xFF;
            int prevG = (prevColor >> 8) & 0xFF;
            int prevB = prevColor & 0xFF;
            int diffR = abs(currR - prevR);
            int diffG = abs(currG - prevG);
            int diffB = abs(currB - prevB);
            if (screenIndex < width*height) {
                pixels[screenIndex] = color(diffR, diffG, diffB);
            }
        }
    }
    updatePixels();
}

