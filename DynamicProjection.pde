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
 - Funcionalidad de matar monstruitos.
 - Reaparecen en otro sitio aleatoriamente.
 */

// Include statements for the library
import oscP5.*;
import netP5.*;

// Declare variables
OscP5 oscP5;
OscMessage theOscMessage;
NetAddress myRemoteLocation;
IRCoordinates IRC = new IRCoordinates();
Accelerometer ACC = new Accelerometer();
Buttons BUTT = new Buttons();
PImage[] mnstr1 = new PImage[6];
PImage[] mnstr2 = new PImage[6];
PImage bgImg, trg, plImg;
PVector POV, MOUSE, RND_POS_1, RND_POS_2;
//Adaptation
float angle = 0.5, speed = 0.1;
int cam_z = 800, scalar = 50, imgsIndex = 0;

// Declare constants
public static final int IMG_WIDTH = 100;
public static final int IMG_HEIGHT = 100;
public static final int FR = 20;
public static final int PORT = 9000;
public static final int OSCL = 50;
public static final float PHASE = 100;
public static final int ZOOM = 10;
public static final int NUM_FRAMES = 6;
public static final boolean ISWIIMOTE = true;

// Sets the initial conditions
public void setup() {
  // Sets processing window to full screen.
  // Processing 3D (P3D).
  fullScreen(P3D, 1);
  // Frames to be displayed every second
  frameRate(FR); 
  // Sets the background to black.
  background(0); 
  // Disables filling geometry.
  noFill();
  // The oscP5 client will be on this computer, port 9000.
  oscP5 = new OscP5(this, PORT);
  loadImages();
  RND_POS_1 = generateRandomPos();
  RND_POS_2 = generateRandomPos();
}

public void draw() {
  // Sets the background to black with every new call to 
  // draw() otherwise the previous image would still 
  // be displayed.
  background(0); 
  // Disables drawing the stroke (outline). 
  noStroke();
  // Sets the default ambient and directional light.
  lights();
  // Sets the position of the camera through setting the eye 
  // position, the center of the scene, and which axis is facing 
  // upward.
  cameraControl(ISWIIMOTE);

  PVector [] ANM_POS = generateAnmPos();
  printBgImage();
  printAnimations(ANM_POS);
  printPlImage();
  printTarget(trg, ISWIIMOTE);
  isZooming();
  isShooting(ANM_POS, ISWIIMOTE);
}

/*
Incoming osc message are forwarded to the oscEvent method.
 oscEvent() runs in the background, so whenever a message arrives,
 it is input to this method as the "theOscMessage" argument
 */
public void oscEvent(OscMessage theOscMessage) {
  readIRC(theOscMessage);
  readBUTT(theOscMessage);
  readACC(theOscMessage);
}

private void readIRC(OscMessage theOscMessage) {
  // Raw IR (x, y, size / 4 tracked dots). These are the values as 
  // given by the built-in infrared camera. The Wiimote can track 
  // up to 4 dots. Their x, y coordinates are reported as well as 
  // the sizes of the dots.
  // x and y are in a range of 0 to 1. Given that we want a Cartesian
  // place, we substract 0.5 in order to center de image and have a
  // range of -0.5 to 0.5.
  if ( theOscMessage.addrPattern().indexOf("/wii/1/ir/xys/1") != -1 ) {
    IRC.setIR1(new PVector(theOscMessage.get(0).floatValue()-0.5, 
      theOscMessage.get(1).floatValue()-0.5));
  }
  if ( theOscMessage.addrPattern().indexOf("/wii/1/ir/xys/2") != -1 ) {
    IRC.setIR2(new PVector(theOscMessage.get(0).floatValue()-0.5, 
      theOscMessage.get(1).floatValue()-0.5));
  }

  // IR: These values represent the x and y coordinates of an 
  // imaginary point to which the Wiimote is directed.
  if ( theOscMessage.addrPattern().indexOf("/wii/1/ir/0") != -1) {
    IRC.getIRAux().x = (theOscMessage.get(0).floatValue()-0.5);
  }
  if ( theOscMessage.addrPattern().indexOf("/wii/1/ir/1") != -1) {
    // Y axis grows upwards so we invert it.
    IRC.getIRAux().y = ((theOscMessage.get(0).floatValue()-0.5) * -1);
  }
}

//Reading Data from Buttons: A, Minus, Plus.
private void readBUTT(OscMessage theOscMessage) {
  if ( theOscMessage.addrPattern().indexOf("/wii/1/button/A") != -1) {
    BUTT.setA(true);
  }

  if ( theOscMessage.addrPattern().indexOf("/wii/1/button/B") != -1) {
    BUTT.setB(true);
  }

  if ( theOscMessage.addrPattern().indexOf("/wii/1/button/Minus") != -1) {
    BUTT.setMinus(true);
  }

  if ( theOscMessage.addrPattern().indexOf("/wii/1/button/Plus") != -1) {
    BUTT.setPlus(true);
  }
}

private void readACC(OscMessage theOscMessage) {
  // Pitch, Raw, Yaw. These values represent the 
  // orientation of the remote. These values are derived from 
  // the x, y, and z accelerations.
  if ( theOscMessage.addrPattern().indexOf("/wii/1/accel/pry") != -1 ) {
    ACC.setPitch(theOscMessage.get(0).floatValue());
    ACC.setRoll(theOscMessage.get(1).floatValue());
    ACC.setYaw(theOscMessage.get(2).floatValue());
  }
  // Raw Accelerations (x, y, z). These are the acceleration 
  // values as measured by the accelerometer chip of the Wiimote.
  if ( theOscMessage.addrPattern().indexOf("/wii/1/accel/xyz") != -1 ) {
    ACC.setX(theOscMessage.get(0).floatValue());
    ACC.setY(theOscMessage.get(1).floatValue());
    ACC.setZ(theOscMessage.get(2).floatValue());
  }
}
/**
 Loads and resises the animation images into the variable imgs.
 */
private void loadImages() {
  bgImg = loadImage("images/space_BG.gif");
  plImg = loadImage("images/space_objects.gif");
  trg = loadImage("images/target.png");
  mnstr1 [0] = loadImage("images/invader/invader_1_0001.gif");
  mnstr1 [1] = loadImage("images/invader/invader_1_0002.gif");
  mnstr1 [2] = loadImage("images/invader/invader_1_0003.gif");
  mnstr1 [3] = loadImage("images/invader/invader_1_0004.gif");
  mnstr1 [4] = loadImage("images/invader/invader_1_0005.gif");
  mnstr1 [5] = loadImage("images/invader/invader_1_0006.gif");

  mnstr2 [0] = loadImage("images/invader/invader_2_0001.gif");
  mnstr2 [1] = loadImage("images/invader/invader_2_0002.gif");
  mnstr2 [2] = loadImage("images/invader/invader_2_0003.gif");
  mnstr2 [3] = loadImage("images/invader/invader_2_0004.gif");
  mnstr2 [4] = loadImage("images/invader/invader_2_0005.gif");
  mnstr2 [5] = loadImage("images/invader/invader_2_0006.gif");

  for (int i = 0; i < NUM_FRAMES; i++) {
    mnstr1[i].resize(IMG_WIDTH, IMG_HEIGHT);
    mnstr2[i].resize(IMG_WIDTH, IMG_HEIGHT);
  }
}

/**
 Generates oscilation motion values.
 */
private PVector generateMotion(float x, float y) {
  angle += speed;
  return new PVector(x + sin(angle) * scalar, y + cos(angle) * scalar);
}

/**
 Renders background image.
 */
private void printBgImage() {
  bgImg.resize(width*2, height*2);
  image(bgImg, -width, -height);
}

/**
 Renders planets image.
 */
private void printPlImage() {
  plImg.resize(width*2, height*2);
  image(plImg, -width, -height);
}

private PVector [] generateAnmPos() {
  PVector [] ANM_POS = new PVector[2];
  ANM_POS [0] = generateMotion(RND_POS_1.x, RND_POS_1.y);
  ANM_POS [1] = generateMotion(RND_POS_2.x, RND_POS_2.y);
  return ANM_POS;
}

private void printAnimations(PVector [] ANM_POS) {
  printAnimation(ANM_POS[0].x, ANM_POS[0].y, mnstr1);
  printAnimation(ANM_POS[1].x, ANM_POS[1].y, mnstr2);
}

/**
 Renders the animation in motion depending of X and Y.
 */
private void printAnimation(float x, float y, PImage[] imgs) {
  imgsIndex = (imgsIndex + 1) % imgs.length;
  image(imgs[imgsIndex], x-imgs[0].width/2, y-imgs[0].height/2);
}

/**
 Renders target image.
 */
private void printTarget(PImage trg, boolean iswiimote) {
  trg.resize(50, 50);
  if (iswiimote) {
    image(trg, POV.x - trg.width/2, POV.y - trg.height/2);
  } else {
    image(trg, MOUSE.x - trg.width/2, MOUSE.y - trg.height/2);
  }
}

/**
 Allows to control navigation with the Wiimote or mouse:
 - True: wiimote
 - False: mouse
 */
private void cameraControl(boolean isWiimote) {
  PVector aux = setAuxVector(isWiimote);
  camera(aux.x, aux.y, cam_z, 
    aux.x, aux.y, 0.0, 
    0.0, 1.0, 0.0);
}

/**
  Normalises the cursor position and returns it depending on whether it is
  the Mouse or the Wiimote.
 */
private PVector setAuxVector(boolean isWiimote) {
  if (isWiimote) {
    normalisePOV();
    return new PVector(POV.x, POV.y);
  } else {
    normaliseMousePos();
    return new PVector(MOUSE.x, MOUSE.y);
  }
}
/**
 Normalises the POV position to fit the size of the screen.
 */
private void normalisePOV() {
  POV = new PVector(IRC.getIRAux().x * (width * 2), 
    IRC.getIRAux().y * (height * 2));
}

/**
 Normalises the mouse position to fit the size of the screen.
 */
private void normaliseMousePos() {
  MOUSE = new PVector((mouseX - width/2) * 2, (mouseY - height/2) * 2);
}

/**
 Zooms in and out depending of buttons + and -.
 - Less zoom means the distance is larger.
 - More zoom means the distance is shorter.
 */
private void isZooming() {
  if (BUTT.isMinus()) {
    cam_z = cam_z+ZOOM;
    BUTT.setMinus(false);
  }  
  if (BUTT.isPlus()) {
    cam_z = cam_z-ZOOM;
    BUTT.setPlus(false);
  }
}

/**
 Draws points given coordinates X and Y.
 - Sets the width of the stroke. All widths are set in units of pixels.
 - Draws a point, a coordinate in space at the dimension of one pixel. 
 */
private void drawPoint (String s, float x, float y, int i) {
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
private void drawAllPoints() {
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
private void drawWiimote() {
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

/**
 Generates random coordinates to randomise positioning of animation.
 */
private PVector generateRandomPos() {
  return new PVector(random(-posPhase(width), posPhase(width)), 
    random(-posPhase(height), posPhase(height)));
}

/**
 Reduces the range of the original screen size to avoid overflow of 
 animation when randomising is.
 */
private float posPhase(float var) {
  return var - PHASE;
}

/**
 Given the animation image position and the cursor type, calls method 
 isShooting(x, y, imgs, i, isWiimote);
 */
private void isShooting(PVector [] ANM_POS, boolean isWiimote) {
  isShooting(ANM_POS[0].x, ANM_POS[0].y, mnstr1, 1, isWiimote);
  stroke(256, 256, 256); // White
  point(ANM_POS[0].x+50, ANM_POS[0].y+50);
  isShooting(ANM_POS[1].x, ANM_POS[1].y, mnstr2, 2, isWiimote);
}

/**
 If the shooting button is pressed, calls methos containsPOV(aux, x y, imgs)
 and if true, generates a new animation image position.
 */
private void isShooting(float x, float y, PImage[] imgs, int i, boolean isWiimote) {
  if (BUTT.isA() || mousePressed) {
    stroke(256, 256, 256); // White
    strokeWeight(20);
    PVector aux = setAuxVector(isWiimote);
    point(aux.x, aux.y);
    if (containsPOV(aux, x, y, imgs)) {
      if (i == 1) {
        RND_POS_1 = generateRandomPos();
      } else {
        RND_POS_2 = generateRandomPos();
      }
    }
    BUTT.setA(false);
  }
}

/**
 Checks if the coursour position is within the range of the animation image.
 */
private boolean containsPOV(PVector aux, float x, float y, PImage[] imgs) {
  boolean isContained = false;
  if ((aux.x >= x-imgs[0].width/2 && aux.x <= x+imgs[0].width/2) && 
    (aux.y >= y-imgs[0].height/2 && aux.y <= y+imgs[0].height/2)) {
    stroke(256, 0, 0); // Green
    strokeWeight(20);
    point(aux.x, aux.y);
    isContained = true;
  }
  return isContained;
}