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
    
    //Slider for Time
    cp5.addSlider("Hour")
       .setPosition(main.width/4, main.height - 90)
       .setRange(00.00, 23.59)
       .setSize(main.width/2, main.height/30)
       .setNumberOfTickMarks(24)
       .setLabelVisible(false)
       ;
       
     //Slider for Days
     cp5.addSlider("Day")  // Sunday = 7; Moday = 1; ....;Saturday = 6
       .setPosition(main.width/4, main.height - 150)
       .setRange(1, 7)
       .setSize(main.width/2, main.height/30)
       .setNumberOfTickMarks(7)
       .setLabelVisible(false)
       ;
       
     //Set slider labels 
     
     Slider d = cp5.get(Slider.class, "Day");
     d.getTickMark(0).setLabel("Monday");
     d.getTickMark(1).setLabel("Tuesday");
     d.getTickMark(2).setLabel("Wednesday");
     d.getTickMark(3).setLabel("Thurday");
     d.getTickMark(4).setLabel("Friday");
     d.getTickMark(5).setLabel("Saturday");
     d.getTickMark(6).setLabel("Sunday");
     
     Slider h = cp5.get(Slider.class, "Hour");
     h.getTickMark(0).setLabel("12AM");
     h.getTickMark(1).setLabel("1AM");
     h.getTickMark(2).setLabel("2AM");
     h.getTickMark(3).setLabel("3AM");
     h.getTickMark(4).setLabel("4AM");
     h.getTickMark(5).setLabel("5AM");
     h.getTickMark(6).setLabel("6AM");
     h.getTickMark(7).setLabel("7AM");
     h.getTickMark(8).setLabel("8AM");
     h.getTickMark(9).setLabel("9AM");
     h.getTickMark(10).setLabel("10AM");
     h.getTickMark(11).setLabel("11AM");
     h.getTickMark(12).setLabel("12PM");
     h.getTickMark(13).setLabel("1PM");
     h.getTickMark(14).setLabel("2PM");
     h.getTickMark(15).setLabel("3PM");
     h.getTickMark(16).setLabel("4PM");
     h.getTickMark(17).setLabel("5PM");
     h.getTickMark(18).setLabel("6PM");
     h.getTickMark(19).setLabel("7PM");
     h.getTickMark(20).setLabel("8PM");
     h.getTickMark(21).setLabel("9PM");
     h.getTickMark(22).setLabel("10PM");
     h.getTickMark(23).setLabel("11PM");
     
    
     //set slider colors
     SetSliderColor(d , #000000, #FFFFFF, #FFFFFF);
     SetSliderColor(h , #000000, #FFFFFF, #FFFFFF);
     
  }
  
  private static void SetSliderColor(Slider s, color backCol, color foreCol, color actCol)
  {
    s.setColorBackground(backCol * 1)
    .setColorForeground(foreCol)
    .setColorActive(actCol);
  }
    
}