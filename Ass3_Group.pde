import java.util.List;

public float timeStr = 0.0f; //time string
float time = 0; //current time within the application
float[] peopleData = new float[10]; //people data - connect to EIF data
float[] tempData = new float[100]; //weather or other data - connect ot EIF data
int dataPoint = 0; //the variable used to scroll through the data
List<Particle> particles = new ArrayList(); //stores all active particles to be rendered in the scene
List<Particle> garbageStack = new ArrayList(); //dead particles are added to this list and then destroyed in the next frame - garbage collection

void setup()
{
  noStroke();
  //init screen
  //CHANGE
  size(1500, 900);
  
  //init GUI
  GUI.Init(this);
  
  //init data
  for (int i = 0; i < peopleData.length; i++) //this should be replaced with the data from the API
  {
    peopleData[i] = random(0, 20);
    tempData[i] = random(0, 10);
  }
}

void draw()
{
  //refresh screen
  clear();
  drawSkybox();
  
  //increment time
  time += 0.5; //where 0.5 = timeSpeed
  if (time >= 60) 
  {
    time = 0; //loop time to start next hour
    
    timeStr++; //loop the hour
    if (timeStr >= 24) timeStr = 0; //loop time to start next day
    
    dataPoint++; //increment the datapoint for the hour
    if (dataPoint >= peopleData.length) dataPoint = 0; //loop
    
    //create human particles: (ENTER)
    for (int i = 0; i < peopleData[dataPoint]; i++)
      particles.add(new Particle(random(-40, 0), (height * 0.5f) + random(-5, 25), random(5, 6), random(0, 0), #00ff00));
    //create human particles: (EXIT)
    for (int i = 0; i < peopleData[dataPoint]; i++)
      particles.add(new Particle((width / 2) + 150 + random(-40, 0), (height * 0.5f) + random(-5, 25), random(5, 6), random(0, 0), #ff0000));

    //create rain particles:
  
  }
  
  //refresh all particles
  for(Particle p : particles)
  {
    if (p == null) continue;
    p.Update();
    if (p.lifetime <= 0) garbageStack.add(p);
  }
  
  //garbage collect
  RemoveDeadParticles();
  
  //draw building 11 on top
  drawBuilding();
  drawHourTime();
}

void drawHourTime() //draws current time on the screen
{
  fill(#ffffff);
  float textSize = 40;
  textSize(textSize);
  text(timeStr, width - textSize * 3.5f, textSize);
}

void drawSkybox() //draws the sun & sky
{
  rectMode(CENTER);
  fill(#5566ff);
  rect(width * 0.5f, height * 0.5f, width, height);
  fill(#449944);
  rect(width * 0.5f, height * 0.75f, width, height * 0.5f);
}

void drawBuilding() //draws building 11
{
  rectMode(CENTER);
  fill(#666687);
  float h = height / 2;
  rect(width / 2, h - (h / 5), width / 2, h * 0.7f);
}

void fillBuilding(int p) //draws 'p' number circles within the building
{
  for (int i = 0; i < p; i++)
  {
    
  }
}

void RemoveDeadParticles() //removes dead particles at the end of their lifetime
{
  for(Particle p : garbageStack) particles.remove(p);
  garbageStack.clear();
}
