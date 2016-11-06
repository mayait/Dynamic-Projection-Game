
public class Accelerometer{
  
  //Variables
  private float pitch, roll, yaw, x, y, z;
  
  //Constructor
  public Accelerometer(){
    pitch = 0;
    roll = 0;
    yaw = 0;
    x = 0;
    y = 0;
    z = 0;
  }
  
  //Constructor
  public Accelerometer(float pitch_, float roll_, float yaw_, float x_, float y_, float z_){
    pitch = pitch_;
    roll = roll_;
    yaw = yaw_;
    x = x_;
    y = y_;
    z = z_;
  }
  
  public float getPitch() {
   return pitch;
  }
  
  public void setPitch(float pitch_) {
    pitch = pitch_;
  }
  
  public float getRoll() {
   return roll;
  }
  
  public void setRoll(float roll_) {
    roll = roll_;
  }

  public float getYaw() {
   return yaw; 
  }
  
  public void setYaw(float yaw_) {
    yaw = yaw_;
  }
  
  public float getX() {
   return x; 
  }
  
  public void setX(float x_) {
    x = x_;
  }
  
  public float getY() {
   return y; 
  }
  
  public void setY(float y_) {
    y = y_;
  }
  
  public float getZ() {
   return z; 
  }
  
  public void setZ(float z_) {
    z = z_;
  }
}