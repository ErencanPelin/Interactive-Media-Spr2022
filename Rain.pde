public class rain 
{
  float x, y, s;
  
  rain(float x, float y, float s) 
  {
    this.x = x;
    this.y = y;
    this.s = s; //speed
  }
  
  void update() 
  {
    y = y + s; // falling speed
    if (y > height) 
    { //when rain hits the bottom of the screen it is sent back to top
      y = 0;
    }
  }
  
  void raindrop() 
  {
    fill(#068BD6); //blue color of rain
    noStroke();
    circle(x, y, random(10)); //raindrop creation
    noStroke();
  }
}
