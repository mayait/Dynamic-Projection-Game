/**

 DynamicProjectionGame
 Julian Maya, Maria Santos & Guillermo Marin
 julian.maya@gmail.com, msantosbaranco@gmail.com, guillermo.marin.g@gmail.com 

 A novel interactive approach with virtual content in a physical world using small projectors and sensors. 
 Advanced Interface Design Project: Dynamic Projection
 Exploring physical space using small projectors, Processing, wiimote and OSC
 
 Requirements:
 - Processing 3.2.2 	https://processing.org/				
 - OScP5 				https://doi.org/10.5281/zenodo.16308		An Open Sound Control (OSC) implementation for Java and Processing
 - OSculator 3.0		https://osculator.net/						OSX Wiimote - OSC mesage Broker

 */

/**
 Comentarios:
   - Código adaptado. 
   - Rotación de la wii box fixed.
   - Modificado el tamaño de imagen para evitar que se exapanda.
 */
 
// Include statements for the library
import oscP5.*;
import netP5.*;

// Declare variables
OscP5 oscP5;
OscMessage theOscMessage;
NetAddress myRemoteLocation;
IRCoordinates IRC;
Accelerometer ACC;
Buttons BUTT;
int camZ = 800;

// Declare constants
public static final int IMG_WIDTH = 1600;
public static final int IMG_HEIGHT = 1200;
public static final int FR = 20;
public static final int PORT = 9000;

// Sets the initial conditions
public void setup(){
  // Sets processing window to 800 x 600 and render in 
  // Processing 3D (P3D).
  size(800 , 600, P3D); 
  // Frames to be displayed every second
  frameRate(FR); 
  // Sets the background to black.
  background(0); 
  // Disables filling geometry.
  noFill();
  // The oscP5 client will be on this computer, port 9000.
  oscP5 = new OscP5(this, PORT);
  IRC = new IRCoordinates();
  ACC = new Accelerometer();
  BUTT = new Buttons();
}

public void draw(){
  // Specifies an amount to displace objects within the 
  // display window. The x parameter specifies left/right 
  // translation, the y parameter specifies up/down translation.
  // translate(width/2, height/2); 
  // Sets the background to black with every new call to 
  // draw() otherwise the previous image would still 
  // be displayed.
  background(0); 
  // Loads an image into a variable of type PImage.
  PImage img = loadImage("images/textura3.jpg");
  // Disables drawing the stroke (outline). 
  noStroke();
  // Sets the default ambient and directional light.
  lights();
  // Zoom depending of buttons + and -.
  zoom();
  // Sets the position of the camera through setting the eye 
  // position, the center of the scene, and which axis is facing 
  // upward.
  camera(0.0, 0.0, camZ,
         IRC.getIRAux().x * width, IRC.getIRAux().y * height, 0.0,
         0.0, 1.0, 0.0);

  texturiseImage(img);
  drawAllPoints();
  drawWiimote();
}

/*
Incoming osc message are forwarded to the oscEvent method.
oscEvent() runs in the background, so whenever a message arrives,
it is input to this method as the "theOscMessage" argument
*/
public void oscEvent(OscMessage theOscMessage){
  readIRC(theOscMessage);
  readBUTT(theOscMessage);
  readACC(theOscMessage);
}

private void readIRC(OscMessage theOscMessage){
  // Raw IR (x, y, size / 4 tracked dots). These are the values as 
  // given by the built-in infrared camera. The Wiimote can track 
  // up to 4 dots. Their x, y coordinates are reported as well as 
  // the sizes of the dots.
  // x and y are in a range of 0 to 1. Given that we want a Cartesian
  // place, we substract 0.5 in order to center de image and have a
  // range of -0.5 to 0.5.
  if( theOscMessage.addrPattern().indexOf("/wii/1/ir/xys/1") != -1 ){
     IRC.setIR1(new PVector(theOscMessage.get(0).floatValue()-0.5, 
       theOscMessage.get(1).floatValue()-0.5));
   }
  if( theOscMessage.addrPattern().indexOf("/wii/1/ir/xys/2") != -1 ){
     IRC.setIR2(new PVector(theOscMessage.get(0).floatValue()-0.5, 
       theOscMessage.get(1).floatValue()-0.5));
  }
  
  // IR: These values represent the x and y coordinates of an 
  // imaginary point to which the Wiimote is directed.
  if( theOscMessage.addrPattern().indexOf("/wii/1/ir/0") != -1){
    IRC.getIRAux().x = (theOscMessage.get(0).floatValue()-0.5);
  }
  if( theOscMessage.addrPattern().indexOf("/wii/1/ir/1") != -1){
    // Y axis grows upwards so we invert it.
    IRC.getIRAux().y = ((theOscMessage.get(0).floatValue()-0.5) * -1);
  }
}

//Reading Data from Buttons: A, Minus, Plus.
private void readBUTT(OscMessage theOscMessage){
  if( theOscMessage.addrPattern().indexOf("/wii/1/button/A") != -1){
     BUTT.setA(true);
  }
  
  if( theOscMessage.addrPattern().indexOf("/wii/1/button/Minus") != -1){
     BUTT.setMinus(true);
  }
  
  if( theOscMessage.addrPattern().indexOf("/wii/1/button/Plus") != -1){
     BUTT.setPlus(true);
  }
}

private void readACC(OscMessage theOscMessage){
  // Pitch, Raw, Yaw. These values represent the 
  // orientation of the remote. These values are derived from 
  // the x, y, and z accelerations.
  if( theOscMessage.addrPattern().indexOf("/wii/1/accel/pry") != -1 ){
     ACC.setPitch(theOscMessage.get(0).floatValue());
     ACC.setRoll(theOscMessage.get(1).floatValue());
     ACC.setYaw(theOscMessage.get(2).floatValue());
  }
  // Raw Accelerations (x, y, z). These are the acceleration 
  // values as measured by the accelerometer chip of the Wiimote.
  if( theOscMessage.addrPattern().indexOf("/wii/1/accel/xyz") != -1 ){
     ACC.setX(theOscMessage.get(0).floatValue());
     ACC.setY(theOscMessage.get(1).floatValue());
     ACC.setZ(theOscMessage.get(2).floatValue());
  }
}

private void texturiseImage(PImage img){
  // beginShape() begins recording vertices for a shape.
  beginShape();
  // Sets a texture to be applied to vertex points.
  texture(img);
  vertex(-width, -height, 0, 0, 0);
  vertex(width, -height, 0, IMG_WIDTH, 0);
  vertex(width, height, 0, IMG_WIDTH, IMG_HEIGHT);
  vertex(-width, height, 0, 0, IMG_HEIGHT);
  // endShape() stops recording vertices for a shape.
  endShape();
}

private void zoom(){
  // Less zoom means the distance is larger.
  if(BUTT.isMinus()){
    camZ = camZ+10;
    BUTT.setMinus(false);
  }  
  // More zoom means the distance is shorter.
  if(BUTT.isPlus()){
    camZ = camZ-10;
    BUTT.setPlus(false);
  }
}

private void drawPoint (String s, float x, float y, int i){
  // Sets the width of the stroke. All widths are set in units of 
  // pixels.
  strokeWeight(10);
  // Draws a point, a coordinate in space at the dimension of one 
  // pixel. 
  point(x * width, y * height);
  textSize(32);
  text(s+" \t x:"+x+"\t y:"+y, 200, i*50-200);
}

private void drawAllPoints(){
  // Sets the color used to draw lines and borders around shapes. 
  stroke(240, 240, 240); // Grey
  drawPoint("ir", IRC.getIRAux().x, IRC.getIRAux().y, 1);
  stroke(256, 0, 0); // Red
  drawPoint("ir1", IRC.getIR1().x, IRC.getIR1().y, 2);
  stroke(0, 256, 0); // Green
  drawPoint("ir2", IRC.getIR2().x, IRC.getIR2().y, 3);
}

private void drawWiimote(){
  stroke(0, 0, 256); // Blue
  strokeWeight(2); 
  //translate(IRC.getIRAux().x*800, IRC.getIRAux().y*600, 0);
  // Backward translation of 400 px so that it is in a different 
  // plane than the img.
  translate(0, 0, 400);
  // The box is given the orientation of the remote in Pitch, Raw, Yaw
  // Pitch -> x, Roll -> y, Yaw -> z.
  rotateX(-1 * (ACC.getPitch() - 0.5));
  rotateY(ACC.getRoll() - 0.5);
  rotateZ(ACC.getYaw() - 0.5);
  // A box is an extruded rectangle. box(w, h, d): 
  // w = dimension of the box in the x-dimension
  // h = dimension of the box in the y-dimension
  // d = dimension of the box in the z-dimension
  box(50, 25, 100);    
}