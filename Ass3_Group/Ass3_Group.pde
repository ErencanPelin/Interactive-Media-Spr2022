import java.util.List;
import java.util.Date;
import java.text.SimpleDateFormat;

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
List<DataStore> datastoreIN = new ArrayList();
List<DataStore> datastoreOUT = new ArrayList();


Table peopleIN;
Table peopleOUT;
Table rainTable;
int index;

// variables to save actualDataTable People Data into DataStore
Table actualDataTableIN;
Table actualDataTableOUT;

 Date date;
 int weekDay;
 String weekDayName;
 int hour;
 int value;

// slider data
int sliderDay;
int sliderHour;


//RAIN
rain[] r;
int n = 300; //number of rain droplets
boolean rainStatus; //toggle rain on or off



void setup()
{
  noStroke();
  //init screen
  //CHANGE
  size(1500, 900);
  
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


//StringToDate
  
  //display data in console - DEBUGGING
  for(int i = 0; i < actualDataTableIN.getRowCount(); i++)
  {
    for (int x = 0; x < actualDataTableIN.getColumnCount(); x++)
    {
      System.out.println(actualDataTableIN.getString(i, x));
    }
  }
  
  //RAIN
  r = new rain[n];
  for(int i = 0; i < r.length; i++) {
    r[i] = new rain(random(width), random(200), random(5, 20));
  }
 
  
  for (int i = 0; i < peopleData.length; i++) //this should be replaced with the data from the API
  {
    peopleData[i] = random(0, 20);
  }
   // tempData[i] = random(0, 10);
  
}

void draw()
{
  // match data with slider and save in a current variable
   
  /*  for(DataStore d : datastoreIN){
      if( d.weekDay == sliderDay && d.hour == sliderHour){
    currentDataIn= d.value;
  
    println(d.weekDayName + " " + sliderHour);
   
  // println(d.weekDay);
  // println(d.weekDayName);
  // println("Slider" + sliderDay);
   }
  }*/
  
 
  //refresh screen
  clear();
  drawSkybox();

rainStatus = false; //turns rain on if set to true
if (rainStatus == true) {
for(int i = 0; i < r.length; i++) {
  r[i].raindrop();
  r[i].update();
  }
}

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
    for (int i = 0; i < peopleData[dataPoint] /*some value from the peopleIN[slider value] array*/; i++)
      particles.add(new Particle(random(-40, 0), (height * 0.5f) + random(-5, 25), random(5, 6), random(0, 0), #00ff00));
    //create human particles: (EXIT)
    for (int i = 0; i < peopleData[dataPoint] /*some value from the peopleOUT array*/; i++)
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
  
  if (index < peopleIN.getRowCount()) {
    int p = peopleIN.getInt(index, 1);
    String s = Integer.toString(p);
    textSize(30);
    text("People in: " + s, 200, 100);
    index++;
    //DISPLAYS DATA ON SCREEN  FOR PEOPLE ENTERING
  }
  
  if (index < peopleOUT.getRowCount()) {
    int o = peopleOUT.getInt(index, 1);
    String s = Integer.toString(o);
    textSize(30);
    text("People out: " + s, 200, 200);
    index++;
    //DISPLAYS DATA ON SCREEN FOR PEOPLE LEAVING
  }
  
//  drawHourTime();
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
  fill(#ffffff);
  rect(width * 0.5f, height * 0.5f, width, height);
  fill(#C1C1C1);
  rect(width * 0.5f, height * 0.75f, width, height * 0.5f);
}

void drawBuilding() //draws building 11
{
  rectMode(LEFT);
  fill(#666687);
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

void savePeopleDataINinDataStore(){
  actualDataTableIN = new Table();
  actualDataTableIN.addColumn();
  actualDataTableIN.addColumn();
  int t = 0;
  for(int i = 0; i < peopleIN.getRowCount(); i++)
  {
    if (!peopleIN.getString(i, 0).split(" ")[1].split(":")[1].equals("00"))
    {
      t += Integer.parseInt(peopleIN.getString(i, 1));
      continue;
    }
    TableRow newRow = actualDataTableIN.addRow();
    newRow.setString(0, peopleIN.getString(i, 0));
    newRow.setInt(1, t);
    actualDataTableIN.addRow(newRow);
    t = 0;
  }
  
  
   SimpleDateFormat dateFormatIN = new SimpleDateFormat("yy-mm-dd");
  for(int i = 0; i < actualDataTableIN.getRowCount(); i++){
  
    try
    {
      date = dateFormatIN.parse(actualDataTableIN.getString(i, 0).split(" ")[0]); //actualDataTable.getString(i, 0).split(" ")[0].StringToDate();
       weekDay = date.getDay();
      weekDayName = dayName[weekDay];
      //System.out.println(dayName[weekDay]);
  }catch(Exception e) {}
  try 
  {   hour = int(actualDataTableIN.getString(i, 0).split(" ")[1].split(":")[0]); //actualDataTable.getString(i, 0).split(" ")[0].StringToDate();
     //System.out.println(hour);
  
  }catch (Exception e) {}
   try 
  {  value = int(actualDataTableIN.getString(i, 1).split(" ")[0]); //actualDataTable.getString(i, 0).split(" ")[0].StringToDate();
     //System.out.println(value);
  
  }catch (Exception e) {}
  datastoreIN.add(new DataStore(date,weekDayName,weekDay,hour,value));
  
  }
  
}

void savePeopleDataOUTinDataStore(){
  actualDataTableOUT = new Table();
  actualDataTableOUT.addColumn();
  for(int i = 0; i < peopleOUT.getRowCount(); i++)
  {
    if (!peopleOUT.getString(i, 0).split(" ")[1].split(":")[1].equals("00")) continue;
    actualDataTableOUT.addRow(peopleOUT.getRow(i));
  }
  
   SimpleDateFormat dateFormatOUT = new SimpleDateFormat("yy-mm-dd");
  for(int i = 0; i < actualDataTableOUT.getRowCount(); i++){
  
    try
    {
      date = dateFormatOUT.parse(actualDataTableOUT.getString(i, 0).split(" ")[0]); //actualDataTable.getString(i, 0).split(" ")[0].StringToDate();
      weekDay = date.getDay();
      weekDayName = dayName[weekDay];
     // System.out.println(weekDay);
     // System.out.println(dayName[weekDay]);
  }catch(Exception e) {}
  try 
  {   hour = int(actualDataTableOUT.getString(i, 0).split(" ")[1].split(":")[0]); //actualDataTable.getString(i, 0).split(" ")[0].StringToDate();
     //System.out.println(hour);
  
  }catch (Exception e) {}
   try 
  {  value = int(actualDataTableOUT.getString(i, 1).split(" ")[0]); //actualDataTable.getString(i, 0).split(" ")[0].StringToDate();
     //System.out.println(value);
  
  }catch (Exception e) {}
  datastoreOUT.add(new DataStore(date,weekDayName,weekDay,hour,value));
  
  }
  
}

public void Hour(float value)
{
  sliderHour = int(value);
  //println(int(value));
}
public void Day(float value)
{
  sliderDay = int(value);
// println(sliderDay);
}
