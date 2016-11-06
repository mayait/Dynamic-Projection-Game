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



public class Buttons{
  
  //Variables
  private boolean A, B, minus, plus;
  
  //Constructor
  public Buttons(){
    A = false;
    B = false;
    minus = false;
    plus = false;
  }
  
  //Constructor
  public Buttons(boolean A_, boolean B_, boolean minus_, boolean plus_){
    A = A_;
    B = B_;
    minus = minus_;
    plus = plus_;
  }
  
  public boolean isA() {
   return A;
  }
  
  public void setA(boolean A_) {
    A = A_;
  }
  
  public boolean isB() {
   return B;
  }
  
  public void setB(boolean B_) {
    B = B_;
  }
  
  public boolean isMinus() {
   return minus;
  }
  
  public void setMinus(boolean minus_) {
    minus = minus_;
  }

  public boolean isPlus() {
   return plus; 
  }
  
  public void setPlus(boolean plus_) {
    plus = plus_;
  }
}