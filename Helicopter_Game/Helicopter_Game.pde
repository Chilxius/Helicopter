//Bennett Ritchie
//Helicopter Game v1

//Player data
float xPos = 100, yPos;
float ySpeed;
int size = 50;
boolean accelerationOn = false;
PImage playerImage;
int hurtFrames = 0;
int health = 5;
//boolean flicker = false;
float angle;

//Star data
int starCount = 100;
float starPos[][] = new float[2][starCount];

//Badguy data
ArrayList<Hazzard> baddies = new ArrayList<Hazzard>();
int nextBadguyCounter = 10000;

void setup()
{
  size(900,400);
  imageMode(CENTER);
  
  //Player data setup
  yPos = height/2;
  playerImage = loadImage("player.png");
  playerImage.resize(0,size);
  
  //Set stars' positions
  for(int i = 0; i < starCount; i++)
  {
    starPos[0][i] = random(width);
    starPos[1][i] = random(height);
  }
  
  //Create first baddie
  baddies.add( new Hazzard() );
}

void draw()
{
  background(0);
  noStroke();
  
  //Draw Stars
  fill(255,255,170);
  for( int i = 0; i < starCount; i++ )
  {
    ellipse( starPos[0][i], starPos[1][i], 2, 2 ); //Draw
    starPos[0][i]-=.1; //Move
    if(starPos[0][i]<0) //If offscreen...
    {
      starPos[0][i]+=width; //Reset
      starPos[1][i]=random(height);
    }
  }
    
  //Draw player
  fill(255,0,0);
  translate(xPos,yPos);
  rotate(angle);
  if( hurtFrames % 5 == 0 )
    image(playerImage,0,0);
  rotate(-angle);
  translate(-xPos,-yPos);
  
  //Move player
  yPos-=ySpeed;
  if(yPos>height-size/2)
  {
    yPos = height-size/2;
    ySpeed = -ySpeed; //Bounce
  }
  if(yPos<size/2)
  {
    yPos = size/2;
    ySpeed = -ySpeed; //Bounce
  }
  
  //Invulnurablity Frames
  if( hurtFrames > 0 )
    hurtFrames--;
  if( angle > 0 )
    angle -= (2*PI)/50;
  
  //Acceleration
  if(accelerationOn)
    ySpeed += .3;
  
  //Gravity
  ySpeed-=0.1;
  
  
  //Handle all the bad guys
  for(int i = 0; i < baddies.size(); i++)
  {
    if( baddies.get(i).move() ) //Move and check to see if it went offscreen
      baddies.get(i).reset();
      
    baddies.get(i).drawHazzard(); //Draw the hazzard
  
    //Were you hit? (and vulnurable)
    if( hurtFrames == 0 && wasHit( xPos, yPos, size, baddies.get(i) ) ) //Check if it hit the player
    {
      hurtFrames = 100;
      angle = 4*PI;
      health--;
    }
  }
  //Check to see if it's time for a new bad guy
  if( nextBadguyCounter < millis() )
  {
    nextBadguyCounter = millis() + 10000; //Reset counter
    baddies.add( new Hazzard() ); //Add bad
  }
  
  drawHUD();
  
  if( health <= 0 )
  {
    fill(255);
    textSize(100);
    textAlign(CENTER);
    text("GAME OVER",width/2,height/2);
    noLoop();
  }
}

//Check for collisions
boolean wasHit( float playerX, float playerY, float playerSize, Hazzard h )
{
  if( dist( playerX, playerY, h.xPos, h.yPos) <= (playerSize+h.size)/2 )
    return true;
  else
    return false;
}

//Draws the HUD
void drawHUD()
{
  //lives
  for( int i = 0; i < health; i++ )
  {
    fill(200,0,50);
    ellipse(20+i*30,20,20,20);
  }
  
  //health bar
  fill(50,255*(health/5.0),0); noStroke();
  rect(width - 220, 20, 200*(health/5.0), 20);
  noFill(); stroke(170); strokeWeight(3);
  rect(width - 220, 20, 200, 20);
}

//Keypressed re-routes to mousePressed
void keyPressed()
{
  if( key == ' ' )mousePressed();
}
void keyReleased()
{
  if( key == ' ' )mouseReleased();
}

//Acceleration turns on and off as mouse/key is pressed
void mousePressed()
{
  accelerationOn = true;
}
void mouseReleased()
{
  accelerationOn = false;
}
