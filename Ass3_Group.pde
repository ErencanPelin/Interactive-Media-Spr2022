import java.util.List;
import controlP5.*;
ControlP5 cp5;
String s = "00.00";


float[] peopleData = new float[10];
float[] tempData = new float[100];
List<Particle> particles = new ArrayList(); //100 = max particles
List<Particle> garbageStack = new ArrayList();

void setup()
{
  noStroke();
  //init screen
  size(1500, 1500);
  
  cp5 = new ControlP5(this);
  cp5.addSlider("HourSlider")
     .setPosition(500, 1225)
     .setRange(00.00, 23.59)
     .setSize(800, 30)
     .setValueLabel("Hour")
     ;
     
   cp5.addSlider("DaySlider")
     .setPosition(500, 1325)
     .setRange(1, 7)
     .setSize(800, 30)
     .setValueLabel("Day")
     ;
     
   cp5.addToggle("RealPauseToggle")
   .setPosition(175, 1300)
   .setState(true)
   .setLabel("REAL TIME                                                   PAUSE")
   .setMode(ControlP5.SWITCH)
   .setSize(250, 100)
   ;

  
  //init data
  for (int i = 0; i < peopleData.length; i++) //this should be replaced with the data from the API
  {
    peopleData[i] = random(0, 20);
    tempData[i] = random(0, 10);
  }
}


int dataPoint = 0; //the variable used to scroll through the data
float time = 0;
void draw()
{
  //refresh screen
  clear();
  drawSkybox();
  
  
  //increment time
  time+=0.5;
  if (time % 60 == 0) 
  {
    time = 0; //loop
    dataPoint++;
    if (dataPoint >= peopleData.length) dataPoint = 0; //loop
    
    //create human particles: (ENTER)
    for (int i = 0; i < peopleData[dataPoint]; i++)
      particles.add(new Particle(random(-20, 0), 300 + random(-5, 25), random(2, 3), random(0, 0), #00ff00));
    //create human particles: (EXIT)
    for (int i = 0; i < peopleData[dataPoint]; i++)
      particles.add(new Particle((width / 2) + 150 + random(-20, 0), 300 + random(-5, 25), random(2, 3), random(0, 0), #ff0000));
  }

  //create rain particles:
  
  
  //refresh all particles
  for(Particle p : particles)
  {
    if (p == null) continue;
    p.Update();
    if (p.lifetime <= 0) garbageStack.add(p);
  }
  
  //garbage collect
  RemoveDeadParticles();
  
  //draw b11 on top
  drawBuilding();
  
  drawHourTime();
}

void drawHourTime() {
  textSize(50);
  text(s, 250, 1240);
}

void drawSkybox() //draws the sun & sky
{
  rectMode(CENTER);
  fill(#5566ff);
  rect(width * 0.5f, height * 0.5f, width, height);
  fill(#449944);
  rect(width * 0.5f, height * 0.75f, width, height * 0.5f);
}

void drawBuilding() //draws b11
{
  rectMode(CENTER);
  fill(#666687);
  rect(width / 2, (height / 2) - 90, 300, 250);
}

void RemoveDeadParticles()
{
  for(Particle p : garbageStack) particles.remove(p);
  garbageStack.clear();
}
