import beads.*;
import processing.sound.*;
import java.util.List;
import java.util.Date;
import java.text.SimpleDateFormat;
import java.util.*;

String[] dayName = { 
  "Sunday", "Monday", "Tuesday", "Wednesday", 
  "Thursday", "Friday", "Saturday"
};
public float timeStr = 0.0f; //time string
float time = 0; //current time within the application
float[] peopleData = new float[10]; //people data - connect to EIF data
//float[] tempData = new float[100]; //weather or other data - connect ot EIF data
int dataPoint = 0; //the variable used to scroll through the data
List<Particle> particles = new ArrayList(); //stores all active particles to be rendered in the scene
List<Particle> garbageStack = new ArrayList(); //dead particles are added to this list and then destroyed in the next frame - garbage collection
List<Particle> inBuilding = new ArrayList(); //the particles currently in the building
float [][] peopleDataIN = new float [6][23]; // lists data in Days (x achsis) and times (y achsis)
float [][] peopleDataOUT = new float [6][23]; // lists data in Days (x achsis) and times(y achsis)
float currentDataIn; // data where sliders are
float currentDataOut; // data where sliders are
float currentDataRAIN; // data where sliders are
List<DataStore> datastoreIN = new ArrayList();
List<DataStore> datastoreOUT = new ArrayList();
List<DataStore> datastoreRAIN = new ArrayList();

PShape building; // creats a variable for the obj file

Table peopleIN;
Table peopleOUT;
Table rainTable;
int index;

// slider data
int sliderDay;
int sliderHour;

//RAIN
rain[] r;
int n = 150; //number of rain droplets
boolean rainStatusDRIZZLE;
boolean rainStatusFULL;//toggle rain on or off
//float rainAmount;

//AudioContext ac;
SoundFile drizzle;
SoundFile rain;
int drizzleOnce;
int rainOnce;

void setup()
{
  noStroke();
  //init screen
  //CHANGE
  lights();
  size(1500, 900, P3D);
  building = loadShape("UTS_B11_Final.obj"); // assigns the OBJ file to the Pshape variable
  building.translate(-1300,-670,-400);
  building.rotate(PI, 0, 0, 1);
  
  //init GUI
  GUI.Init(this);
  
  //init data
  peopleIN = loadTable("https://eif-research.feit.uts.edu.au/api/csv/?rFromDate=2022-02-21T00%3A00&rToDate=2022-02-27T23%3A59%3A59&rFamily=people_sh&rSensor=CB11.PC02.14.Broadway&rSubSensor=CB11.02.Broadway.East+In", "csv");
  //Inward People Sensor Data for Broadway East Door from 21st FEB 12:00:00AM - 27th FEB 11:59:59PM
  peopleOUT = loadTable("https://eif-research.feit.uts.edu.au/api/csv/?rFromDate=2022-02-21T00%3A00&rToDate=2022-02-27T23%3A59%3A59&rFamily=people_sh&rSensor=CB11.PC02.14.Broadway&rSubSensor=CB11.02.Broadway.East+Out", "csv");
  //Outward People Sensor Data for Broadway East Door from 21st FEB 12:00:00AM - 27th FEB 11:59:59PM
  rainTable = loadTable("https://eif-research.feit.uts.edu.au/api/csv/?rFromDate=2022-02-21T00%3A00&rToDate=2022-02-27T23%3A59%3A59&rFamily=weather&rSensor=RG", "csv");
  //Rain Gauge Data for Building 11 from 21st FEB 12:00:00AM - 27th FEB 11:59:59PM
  
  savePeopleDataINinDataStore();
  savePeopleDataOUTinDataStore();
  saveRainDatainDataStore();


//StringToDate
  
  //display data in console - DEBUGGING
  //for(int i = 0; i <rainTable.getRowCount(); i++)
  //{
  //  for (int x = 0; x < rainTable.getColumnCount(); x++)
  //  {
  //    System.out.println(rainTable.getString(i, x));
  //  }
  //}
  
  //RAIN
  r = new rain[n];
  for(int i = 0; i < r.length; i++) 
    r[i] = new rain(random(width), random(200), random(5, 25));
  
  //for (int i = 0; i < peopleData.length; i++) //this should be replaced with the data from the API
    //peopleData[i] = random(0, 20);
    

    //ac = new AudioContext();
    drizzle = new SoundFile(this, "DrizzleAudioFile.mp3");
    drizzle.amp(0.03); //Audio Volume Adjuster
    rain = new SoundFile(this, "RainAudioFile.mp3");
    rain.amp(0.5); //Audio Volume Adjuster

    
}

int trackIn;
int trackOut;
int trackFill;
int toFill;
DataStore curDataIn;
DataStore curDataOut;
DataStore curDataRAIN;
color skyColor = #000000;
void draw()
{
  lights();
  curDataIn = null;
  curDataOut = null;
  curDataRAIN = null;
  // match data with slider and save in a current variable
  for(DataStore d : datastoreIN)
  {
    //println(sliderDay + " " + sliderHour);
    if(d.weekDay == sliderDay && d.hour == sliderHour)
    {
      currentDataIn = d.value;
      curDataIn = d;
    
    }
  }
  for(DataStore d : datastoreOUT)
  {
    //println(sliderDay + " " + sliderHour);
    if(d.weekDay == sliderDay && d.hour == sliderHour)
    {
      currentDataOut = d.value;
      curDataOut = d;
      //System.out.println(curDataOut);
    }
  }
  for(DataStore d : datastoreRAIN)
  {
    //println(sliderDay + " " + sliderHour);
    if(d.weekDay == sliderDay && d.hour == sliderHour)
    {
      currentDataRAIN = d.value;
      //System.out.println(currentDataRAIN);
      curDataRAIN = d;
      //System.out.println(curDataRAIN);
    }
  }
  if (curDataIn == null) currentDataIn = 0;
  if (curDataOut == null) currentDataOut = 0;
  if (curDataRAIN == null) currentDataRAIN = 0;
  toFill = round(currentDataIn - currentDataOut);
  //refresh screen
  clear();
  
  float r = (1f - abs(12f - sliderHour) / 23f) * 103f;
  float g = (1f - abs(12f - sliderHour) / 23f) * 160f;
  float b = (1f - abs(12f - sliderHour) / 23f) * 227f;
  skyColor = color(r, g, b);
  background(skyColor);
  shape(building);

  rain();
 
  //increment time
  time += 1; //where 0.5 = timeSpeed
  if (time >= 2) 
  {   
    time = 0;
    timeStr++; //loop the hour
    if (timeStr >= 24) timeStr = 0; //loop time to start next day
    
    dataPoint++; //increment the datapoint for the hour
    if (dataPoint >= peopleData.length) dataPoint = 0; //loop
   
   if (trackIn < currentDataIn)
   {
      particles.add(new Particle(random(-90, 0), (height * 0.55f) + random(-5, 25), random(5, 6), random(0, 0),#90FFC3, 75));
      trackIn++;
   }   
   
   if (trackOut < currentDataOut)
   {
      particles.add(new Particle((width / 2) + 290, (height * 0.6f) + random(-5, 25), random(5, 6), random(0, 0), #FF5517, 100));
      trackOut++;
   } 
   
   if (trackFill < toFill) //add people
   {
     spawnBuildingParticle();
     trackFill++;
   }
   if (trackFill > toFill)
   {
     if (inBuilding.size() > 1)
     {
       inBuilding.remove(0);
       trackFill--;
     }
   }
  }
  
  //update all particles
  for(Particle p : particles)
  {
    if (p == null) continue;
    p.Update();
    if (p.lifetime <= 0) garbageStack.add(p);
  }


  for(Particle p : inBuilding)
  {
    if (p == null) continue;
    p.Update();
  }
  //garbage collect
  RemoveDeadParticles();
  
 /* if (index < peopleIN.getRowCount())
  {
    int p = peopleIN.getInt(index, 1);
    String s = Integer.toString(p);
    textSize(30);
    text("People in: " + s, 200, 100);
    index++;
    //DISPLAYS DATA ON SCREEN  FOR PEOPLE ENTERING
  }
  
  if (index < peopleOUT.getRowCount()) 
  {
    int o = peopleOUT.getInt(index, 1);
    String s = Integer.toString(o);
    textSize(30);
    text("People out: " + s, 200, 200);
    index++;
    //DISPLAYS DATA ON SCREEN FOR PEOPLE LEAVING
  }*/
}

//public void sound() {
//  //String audioFileName = "RainAudioFile.mp3";
//  //SamplePlayer player = new SamplePlayer(ac, SampleManager.sample(audioFileName));
//  //Gain g = new Gain(ac, 1, 1);
//  //g.addInput(player);
//  //ac.out.addInput(g);
//  //ac.start();
//}

void drawHourTime() //draws current time on the screen
{
  fill(#ffffff);
  float textSize = 40;
  textSize(textSize);
  text(timeStr, width - textSize * 3.5f, textSize);
}

void spawnBuildingParticle() //draws 'p' number circles within the building
{
  //the area boids will spawn in and move around in
  //width * 0.3, height * 0.3, width * 0.7, height * 0.55 - rect size for the building
  PVector bounds1 = new PVector(width * 0.3, height * 0.3 + 20); //bottom left corner of the building
  PVector bounds2 = new PVector(width * 0.7 - 40, height * 0.5 + 70); //top right corner of the building
  
  PVector pos = new PVector(random(bounds1.x, bounds2.x), random(bounds1.y, bounds2.y)); //calculate a random position between bounds
  Particle newParticle = new Particle(pos.x, pos.y, 0, 0, #FFFFFF, 50);
  inBuilding.add(newParticle);
}
void RemoveDeadParticles() //removes dead particles at the end of their lifetime
{
  for(Particle p : garbageStack) particles.remove(p);
  garbageStack.clear();
}

SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
void savePeopleDataINinDataStore()
{
  int t = 0;
  int lastHr = 3;
  for(int i = 0; i < peopleIN.getRowCount(); i++)
  {
    int newHour = Integer.parseInt(peopleIN.getString(i, 0).split(" ")[1].split(":")[0]);
    int val = peopleIN.getInt(i, 1);
    t += val;
    if (newHour != lastHr)
    {
      lastHr = newHour;
      
      try
      {
       // println(peopleIN.getString(i, 0).split(" ")[0]);
        Date date = dateFormat.parse(peopleIN.getString(i, 0).split(" ")[0]); 
      //  println(date);
        String weekDayName = dayName[date.getDay()];
        datastoreIN.add(new DataStore(date,weekDayName,date.getDay(),lastHr,t));
      } catch(Exception e) {}
      t = 0;
    }
  }
}

void savePeopleDataOUTinDataStore()
{
  int t = 0;
  int lastHr = 3;//Integer.parseInt(peopleIN.getString(0, 0).split(" ")[1].split(":")[0]);
  for(int i = 0; i < peopleOUT.getRowCount(); i++)
  {
    int newHour = Integer.parseInt(peopleOUT.getString(i, 0).split(" ")[1].split(":")[0]);
    int val = peopleOUT.getInt(i, 1);
    t += val;
    if (newHour != lastHr)
    {
      lastHr = newHour;
      
      try
      {
        Date date = dateFormat.parse(peopleOUT.getString(i, 0).split(" ")[0]); 
        String weekDayName = dayName[date.getDay()];
        datastoreOUT.add(new DataStore(date,weekDayName,date.getDay(),lastHr,t));
      } catch(Exception e) {}
      t = 0;
    }
  }
}

void saveRainDatainDataStore()
{
  Float t = 0.0;
  int lastHr = 3;
  for(int i = 0; i < rainTable.getRowCount(); i++)
  {
    int newHour = Integer.parseInt(rainTable.getString(i, 0).split(" ")[1].split(":")[0]);
    Float val = rainTable.getFloat(i, 1);
    //System.out.println(val);
    t += val;
    if (newHour != lastHr)
    {
      lastHr = newHour;
      
      try
      {
        //System.out.println(rainTable.getString(i, 0).split(" ")[0]);
        Date date = dateFormat.parse(rainTable.getString(i, 0).split(" ")[0]); 
        //System.out.println(date);
        String weekDayName = dayName[date.getDay()];
        datastoreRAIN.add(new DataStore(date,weekDayName,date.getDay(),lastHr,t));
      } catch(Exception e) {}
      t = 0.0;
    }
  }
}

 public void rain() { 
  if (currentDataRAIN > 0.0 && currentDataRAIN < 0.5) {
    rainStatusDRIZZLE = true;
  }
  
  if (currentDataRAIN > 0.5) {
    rainStatusFULL = true;
  }
  
  //rainStatus = true; //turns rain on if set to true
  if (rainStatusDRIZZLE == true) 
  {
    textSize(30);
    fill(255);
    text("! Rainfall @ Current Selected Time: " + curDataRAIN.value + "ml", 30, 40);
    for(int i = 0; i < r.length; i++) 
    {
      r[i].raindrop();
      r[i].update();
    }
    //sound();
    drizzleOnce++;
    if (drizzleOnce == 1){
    drizzle.play();
    }
  }
  else {
    drizzle.stop();
    drizzleOnce = 0;
  }
  
  if (rainStatusFULL == true) 
  {
    textSize(30);
    fill(255);
    text("! Rainfall @ Current Selected Time: " + curDataRAIN.value + "ml", 30, 40);
    for(int i = 0; i < r.length; i++) 
    {
      r[i].raindrop();
      r[i].update();
      r[i].update();
      r[i].update();
    }
    //sound();
    rainOnce++;
    if (rainOnce == 1){
    rain.play();
    }
  }
  else {
    rain.stop();
    rainOnce = 0;
  }
 }

public void Hour(float value)
{
  sliderHour = int(value);
  if (curDataIn == null || int(value) != curDataIn.hour)
  {
    trackIn = 0;
  }
  if (curDataOut == null || int(value) != curDataOut.hour)
  {
    trackOut = 0;
  }
  if (curDataRAIN == null || int(value) != curDataRAIN.hour)
  {
    rainStatusDRIZZLE = false;
    rainStatusFULL = false;
  }
}
public void Day(float value)
{
  sliderDay = int(value);
  if (curDataIn == null || int(value) != curDataIn.weekDay)
  {
    trackIn = 0;
  }
  if (curDataOut == null || int(value) != curDataOut.weekDay)
  {
    trackOut = 0;
  }
  if (curDataRAIN == null || int(value) != curDataRAIN.weekDay)
  {
    rainStatusDRIZZLE = false;
    rainStatusFULL = false;
  }
}
