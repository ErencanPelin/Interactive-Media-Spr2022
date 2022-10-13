public class DataStore
{
  public Date date;
  public String weekDayName; // Sunday = 0 ; Monday = 1; ...; Saturay = 6;
  public int weekDay;
  
  
  public int hour;

  public float value;
  
  public DataStore(Date date,String weekDayName,int weekDay, int hour, float value)
  {
    this.date = date;
    this.weekDayName = weekDayName;
    this.weekDay = weekDay;
    this.hour = hour;
    this.value = value;
  }
}
