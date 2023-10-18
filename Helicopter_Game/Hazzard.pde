class Hazzard
{
  PImage image;
  boolean active;
  int size;
  float xPos, yPos;
  float speed;
  
  public Hazzard()
  {
    active = true;
    size = (int)random(35,45);
    xPos = width+size/2;
    yPos = random(height);
    speed = 3;
    image = loadImage( (int)random(10) + ".png" );
    image.resize(0,size);
  }
  
  //Returns true if hazzard is off the screen
  boolean move()
  {
    xPos -= speed;
    if( xPos < -size )
      return true;
    return false;
  }
  
  void drawHazzard()
  {
    fill(0,200,200);
    image(image,xPos,yPos);
  }
  
  void reset()
  {
    active = true;
    xPos = width+size/2;
    yPos = random(height);
    speed = random(2,4);
  }
}
