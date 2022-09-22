public class Particle
{
  float xPos, yPos, xVel, yVel;
  color _color;
  float lifetime;
  
  public Particle(float xPos, float yPos, float xVel, float yVel, color _color)
  {
    lifetime = random(250, 250);
    this.xPos = xPos;
    this.yPos = yPos;
    this.xVel = xVel;
    this.yVel = yVel;
    this._color = _color;
  }
  
  public void Update()
  {
    lifetime--;
    xPos += xVel;
    yPos += yVel;
    DrawParticle();
  }
  
  private void DrawParticle()
  {
    fill(_color);
    circle(xPos, yPos + random(-2,2), 10);
  }
}
