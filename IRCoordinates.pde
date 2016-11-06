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



public class IRCoordinates{
  
  //Variables
  private PVector IR1, IR2, IRAux;
  
  //Constructor
  public IRCoordinates(){
    //IR = new PVector(x, y, z);
    IR1 = new PVector(0, 0, 0);
    IR2 = new PVector(0, 0, 0);
    IRAux = new PVector(0, 0, 0);
  }
  
  //Constructor
  public IRCoordinates(PVector IR1_, PVector IR2_, PVector IRAux_){
    IR1 = IR1_;
    IR2 = IR2_;
    IRAux = IRAux_;
  }
  
  public PVector getIR1() {
    return IR1;
  }

  public void setIR1(PVector IR1_) {
    IR1 = IR1_;
  }
  
  public PVector getIR2() {
    return IR2;
  }

  public void setIR2(PVector IR2_) {
    IR2 = IR2_;
  }

  public PVector getIRAux() {
    return IRAux;
  }

  public void setIRAux(PVector IRAux_) {
    //IRAux = IRAux_; //Auxiliar original de Maria.
    //En este experimento incluyo un valor de Z.
    float x = IRAux_.x;
    float y = IRAux_.y;
    float z = 0;
    IRAux.set (x,y,z);
    
  }
}