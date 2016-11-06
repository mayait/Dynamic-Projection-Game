
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
    IRAux = IRAux_;
  }
}