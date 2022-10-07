import controlP5.*;

public static class GUI //all GUI functions go in here
{
  static ControlP5 cp5;
  static Ass3_Group main;
  
  public static void Init(Ass3_Group _main)
  {
    main = _main;
    
    //init UI
    cp5 = new ControlP5(main);
    Slider hourSlider = cp5.addSlider("HourSlider")
       .setPosition(500, main.height - 40)
       .setRange(00.00, 23.59)
       .setSize(800, 30)
       .setValueLabel("Hour")
       ;
     SetSliderColor(hourSlider, #ff0000);  
     
     Slider daySlider = cp5.addSlider("DaySlider")
       .setPosition(500, main.height - 80)
       .setRange(1, 7)
       .setSize(800, 30)
       .setValueLabel("Day")
       ;
     SetSliderColor(daySlider, #ff0000);
       
     cp5.addToggle("RealPauseToggle")
     .setPosition(500 + 800, main.height - 120)
     .setState(false)
     .setLabel("Pause Time")
     .setMode(ControlP5.SWITCH)
     .setSize(100, 50)
     ;
  }
  
  private static void SetSliderColor(Slider s, color col)
  {
    s.setColorBackground(col * 1)
    .setColorForeground(col)
    .setColorActive(col);
  }
}
