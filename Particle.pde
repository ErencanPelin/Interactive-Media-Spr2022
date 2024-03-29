public class Particle
{
  PVector pos;
  float xVel, yVel;
  color _color;
  public float lifetime;
  float size;
  
  public Particle(float xPos, float yPos, float xVel, float yVel, color _color, float lifetime)
  {
    size = random(10, 20);
    this.lifetime = lifetime;
    pos = new PVector(xPos, yPos);
    this.xVel = xVel;
    this.yVel = yVel;
    this._color = _color;
  }
  
  public void Update()
  {
    lifetime--;
    pos.x += xVel;
    pos.y += yVel;
    DrawParticle();
  }
  
  private void DrawParticle()
  {
    fill(_color);
    circle(pos.x, pos.y, size);
  }
}
