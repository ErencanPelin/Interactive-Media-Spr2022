import java.util.List;

public float timeStr = 0.0f; //time string
float time = 0; //current time within the application
float[] peopleData = new float[10]; //people data - connect to EIF data
//float[] tempData = new float[100]; //weather or other data - connect ot EIF data
int dataPoint = 0; //the variable used to scroll through the data
List<Particle> particles = new ArrayList(); //stores all active particles to be rendered in the scene
List<Particle> garbageStack = new ArrayList(); //dead particles are added to this list and then destroyed in the next frame - garbage collection
List<Particle> inBuilding = new ArrayList(); //the particles currently in the building

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
   // tempData[i] = random(0, 10);
  }
}

void draw()
{
  //refresh screen
  clear();
  drawSkybox();
  
  //increment time
  time += 0.4; //where 0.5 = timeSpeed
  if (time >= 60) 
  {   
    time = 0;
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

    int num = inBuilding.size() - round(peopleData[dataPoint]); //the number of particles we're supposed to have in the building
    if (num > 0) //we need to remove some particles
    {
      for (int i = num; i > 0; i--)
        inBuilding.remove(0);
    }
    else if (num < 0) //we need to add some particles
    {
      for (int i = 0; i < abs(num); i++)
        spawnBuildingParticle();
    }
  }
  
  //update all particles
  for(Particle p : particles)
  {
    if (p == null) continue;
    p.Update();
    if (p.lifetime <= 0) garbageStack.add(p);
  }
  drawBuilding();
  for(Particle p : inBuilding)
  {
    if (p == null) continue;
    p.Update();
  }
  
  //garbage collect
  RemoveDeadParticles();
//  drawHourTime(); //<>//
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
  rectMode(LEFT);
  fill(#666687);
  float h = height / 2;
  rect(width * 0.3, height * 0.3, width * 0.7, height * 0.55);
}

void spawnBuildingParticle() //draws 'p' number circles within the building
{
  //the area boids will spawn in and move around in
  //width * 0.3, height * 0.3, width * 0.7, height * 0.55 - rect size for the building
  PVector bounds1 = new PVector(width * 0.3 + 20, height * 0.3 + 20); //bottom left corner of the building
  PVector bounds2 = new PVector(width * 0.7 - 20, height * 0.55 - 20); //top right corner of the building
  
  PVector pos = new PVector(random(bounds1.x, bounds2.x), random(bounds1.y, bounds2.y)); //calculate a random position between bounds
  Particle newParticle = new Particle(pos.x, pos.y, 0, 0, #4499ff);
  inBuilding.add(newParticle);
}

void RemoveDeadParticles() //removes dead particles at the end of their lifetime
{
  for(Particle p : garbageStack) particles.remove(p);
  garbageStack.clear();
}
