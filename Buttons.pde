
public class Buttons{
  
  //Variables
  private boolean A, minus, plus;
  
  //Constructor
  public Buttons(){
    A = false;
    minus = false;
    plus = false;
  }
  
  //Constructor
  public Buttons(boolean A_, boolean minus_, boolean plus_){
    A = A_;
    minus = minus_;
    plus = plus_;
  }
  
  public boolean isA() {
   return A;
  }
  
  public void setA(boolean A_) {
    A = A_;
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