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
   - Animación integrada
   - Target integrado
   - Background integrado
   - Campo de exploración ampliado
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
int camZ, frame;
PImage bgImg, trg;
PImage[] imgs;
PVector POV;
float theta;

// Declare constants
public static final int IMG_WIDTH = 50;
public static final int IMG_HEIGHT = 50;
public static final int FR = 20;
public static final int PORT = 9000;
public static final int OSCL = 50;
public static final int OSCL_X =50;
public static final int OSCL_Y = 55;

// Sets the initial conditions
public void setup(){
  // Sets processing window to full screen.
  // Processing 3D (P3D).
  fullScreen(P3D,1);
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
  imgs = new PImage[4];
  camZ = 800;
  frame = 0;
  theta = 0;
  bgImg = loadImage("images/haunted_house3.jpg");
  trg = loadImage("images/target.png");
}

public void draw(){
  // Sets the background to black with every new call to 
  // draw() otherwise the previous image would still 
  // be displayed.
  background(0); 
  // Loads the animation images into the variable img.
  loadImages();
  // Disables drawing the stroke (outline). 
  noStroke();
  // Sets the default ambient and directional light.
  lights();
  // Zoom depending of buttons + and -.
  zoom();
  // Sets the position of the camera through setting the eye 
  // position, the center of the scene, and which axis is facing 
  // upward.
  normalisePOV();
  camera(POV.x, POV.y, camZ,
         POV.x, POV.y, 0.0,
         0.0, 1.0, 0.0);
  
  PVector XY = generateOscilation();
  texturiseBgImage(bgImg);
  texturiseImages(imgs, XY);
  texturiseTarget(trg);
  //drawAllPoints();
  //drawWiimote();
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

private void loadImages(){
  imgs [0] = loadImage("cubic_0003.gif");
  imgs [1] = loadImage("cubic_0004.gif");
  imgs [2] = loadImage("cubic_0005.gif");
  imgs [3] = loadImage("cubic_0006.gif");
  
  for (int i = 0; i < 4; i++){
   imgs[i].resize(IMG_WIDTH, IMG_HEIGHT);
  }
}

/**
  Loads image sequences and generates oscilation values.
 */
private PVector generateOscilation(){
  frame = (frame+1) % 4;
  theta += 0.1;
  return new PVector((sin(theta)) * OSCL, (cos(theta)) * OSCL);  
}

/**
  Renders target image.
 */
private void texturiseTarget(PImage trg){
  trg.resize(50, 50);
  image(trg, POV.x - trg.width/2, POV.y - trg.height/2);
}

/**
  Renders background image.
 */
private void texturiseBgImage(PImage bgImg){
  beginShape();
  texture(bgImg);
  vertex(-width, -height, 0, 0, 0);
  vertex(width, -height, 0, bgImg.width, 0);
  vertex(width, height, 0, bgImg.width, bgImg.height);
  vertex(-width, height, 0, 0, bgImg.height);
  endShape();
}

/**
  Renders animation.
 */
private void texturiseImages(PImage[] img, PVector XY){
  // beginShape() begins recording vertices for a shape.
  beginShape();
  // Sets a texture to be applied to vertex points.
  texture(imgs[frame]);
  vertex(-OSCL_X+XY.x, OSCL_Y-XY.y, 0, 0, IMG_HEIGHT);
  vertex(OSCL_X+XY.x, OSCL_Y-XY.y, 0, IMG_WIDTH, IMG_HEIGHT);
  vertex(OSCL_X+XY.x, -OSCL_Y-XY.y, 0, IMG_WIDTH, 0);
  vertex(-OSCL_X+XY.x, -OSCL_Y-XY.y, 0, 0, 0);
  // endShape() stops recording vertices for a shape.
  endShape();
}

/**
  Normalises the POV position to fit the size of the screen.
 */
private void normalisePOV(){
  POV = new PVector(IRC.getIRAux().x * (width * 2), 
                    IRC.getIRAux().y * (height * 2));
}

/**
  Zooms in and out depending of buttons + and -.
    - Less zoom means the distance is larger.
    - More zoom means the distance is shorter.
 */
private void zoom(){
  if(BUTT.isMinus()){
    camZ = camZ+10;
    BUTT.setMinus(false);
  }  
  if(BUTT.isPlus()){
    camZ = camZ-10;
    BUTT.setPlus(false);
  }
}

/**
  Draws points given coordinates X and Y.
    - Sets the width of the stroke. All widths are set in units of pixels.
    - Draws a point, a coordinate in space at the dimension of one pixel. 
 */
private void drawPoint (String s, float x, float y, int i){
  strokeWeight(10);
  point(x * (width * 2), y * (height * 2));
  //textSize(32);
  //text(s+" \t x:"+x+"\t y:"+y, 200, i*50-200);
}

/**
  Displays POV, IR_1 and IR_2 positions.
    - Sets the color used to draw lines and borders around shapes. 
    - Calls drawPoint() method.
 */
private void drawAllPoints(){
  stroke(240, 240, 240); // Grey
  drawPoint("ir", IRC.getIRAux().x, IRC.getIRAux().y, 1);
  stroke(256, 0, 0); // Red
  drawPoint("ir1", IRC.getIR1().x, IRC.getIR1().y, 2);
  stroke(0, 256, 0); // Green
  drawPoint("ir2", IRC.getIR2().x, IRC.getIR2().y, 3);
}

/**
  Displays wiimote position and rotation.
    - Sets backward translation of 400 px so that it is in a different 
      plane than the img.
    - 
 */
private void drawWiimote(){
  stroke(0, 0, 256); // Blue
  strokeWeight(2); 
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