import grafica.*;
import g4p_controls.*;
import processing.serial.*;
import java.util.*;

//Bio page:
int name_ok = 0;
int age_ok = 0;
int gender_ok = 0;
int height_ok = 0;
int set_age = 0;
int set_gender = 0;
int set_height = 0;
int set_weight = 0;

String name;
String gender;
int age;
int height_user;
int weight;
int bio_inserted = 0;

//Plots define:
GPlot plot1;
GPointsArray points1 = new GPointsArray(2000);
color[] pointColors1 = new color[2000];

GPlot plot2;
GPointsArray points = new GPointsArray(2000);
color[] pointColors = new color[2000];

int count1 = 0;
int xvar1 = -5;

int count = 0;
int xvar = -5;

//Serial Communication:
Serial myPort;
String val;    
Vector<Integer> val1 = new Vector<Integer>();
Vector<Integer> val2 = new Vector<Integer>();
int lastStepTime = 0;

//Signals:

int emg = 0;
int sum_emg = 0;
int count_emg = 0;
int fsr = 0;
int sum_fsr = 0;
int count_fsr = 0;

int initTimer = 0;
int get20Sec = 0;
int get15Sec = 0;
int time_init = 0;
int time_now = 0;
int time = 0;

int startTime = 0;
int restEMG = 0;
int restFSR = 0;
int after_restEMG = 0;
int after_restFSR = 0;
int workoutEMG = 0;
int workoutFSR = 0;
int pumpEMG = 0;
int pumpFSR = 0;
int percentageFSR_workout = 0;
int percentageEMG_workout = 0;
int percentageFSR_pump = 0;
int percentageEMG_pump = 0;

//Steps:
int init = 0;
int rest = 0;
int workout = 0;
int pump = 0;
int after_rest = 0;
int stop = 1;
int check = 0;

//Stored data:
/*int[] train1 = {1075, 1289, 112, 200};
int[] train2 = {688, 1400, 32, 321};
int[] train3 = {448, 4450, 57, 550};*/

int[] train1 = {0,0,0,0};
int[] train2 = {0,0,0,0};
int[] train3 = {0,0,0,0};

public void setup(){
  size(800, 800, JAVA2D);
  
  createGUI();
  customGUI();
  
  // Create the heartrate plot:
  plot1 = new GPlot(this);
  plot1.setPos(20, 250);
  plot1.setDim(600, 200);
  plot1.setXLim(0, 300);
  plot1.setYLim(0, 1050);
  plot1.getTitle().setText("EMG");
  plot1.getXAxis().getAxisLabel().setText("sample number");
  plot1.getYAxis().getAxisLabel().setText("ADC unit");
  plot1.activatePanning();
  
  // Create the respiration plot:
  plot2 = new GPlot(this);
  plot2.setPos(20, 510);
  plot2.setDim(600, 200);
  plot2.setXLim(0, 300);
  plot2.setYLim(0, 1050);
  plot2.getTitle().setText("Biceps Force");
  plot2.getXAxis().getAxisLabel().setText("sample number");
  plot2.getYAxis().getAxisLabel().setText("ADC unit");
  plot2.activatePanning();
  
  String portName = Serial.list()[0];
  myPort = new Serial(this, portName, 115200);
  println(train1[3]);
}

public void draw(){
  background(230);
  
  if(name_ok == 1){
    set_age = 1;
  }
  if(age_ok == 1){
    set_gender = 1;
  }
  if(gender_ok == 1){
    set_height = 1;
  }
  if(height_ok == 1){
    set_weight = 1;
  }
  
  if(bio_inserted == 1){
    background(255, 255, 255);
    PImage baseline = loadImage("rest.png");
    PImage exercise = loadImage("workout.png");
    PImage muscle = loadImage("muscle.png");
    PImage icon = loadImage("icon.png");
    PImage timer = loadImage("timer.png");
    
    fill(0); //text black
    textFont(createFont("calibri", 15));
    text("Rest: ",  147, 35);
    image(baseline, 127, 43, 70, 70);
    text("Workout: ", 245, 35);
    image(exercise, 237, 43, 70, 70);
    text("Pump: ", 360, 35);
    image(muscle, 343, 43, 70, 70);
    
    textFont(createFont("calibri bold", 28));
    image(icon, 550, 10, 50, 50);
    text("Pump test", 605, 35);
    
    textFont(createFont("calibri", 16));
    text("Name: " + name, 605, 60);
    text("Age: "+ age, 605, 80);
    text("Gender: " + gender, 605, 100);
    text("Height: " + height_user + "''", 605, 120);
    text("Weight: " + weight + "lb", 605, 140);
    
    text("workout", 207, 135);
    text("pump", 300, 135);
    textSize(13);
    text("EMG", 210, 150);
    text("Force", 240, 150);
    text("EMG", 290, 150);
    text("Force", 320, 150);
    
    fill(194,0,225);
    textFont(createFont("calibri bold", 20));
    text("Training session 1:", 15, 175);
    fill(0);
    textFont(createFont("calibri", 15));
    text(" " + train1[0] + "%,   " + train1[1] +  "%,    " + train1[2] + "%,  " + train1[3] + "%;", 175, 175);
    fill(0,225,0);
    textFont(createFont("calibri bold", 20));
    text("Training session 2:", 15, 205);
    fill(0);
    textFont(createFont("calibri", 15));
    text(" " + train2[0] + "%,   " + train2[1] + "%,    " + train2[2] + "%,  " + train2[3] + "%;", 175, 205);
    fill(255,128,0);
    textFont(createFont("calibri bold", 20));
    text("Training session 3:", 15, 235);
    fill(0);
    textFont(createFont("calibri", 15));
    text(" " + train3[0] + "%,   " + train3[1] + "%,    " + train3[2] + "%,  " + train3[3] + "%;", 175, 235);
    
    textSize(25);
    text("Timer: " + time + "s", 460, 160);
    image(timer, 415, 130, 40, 40);
    
    textFont(createFont("calibri", 15));
    fill(255, 0, 0);
    text("Rest force rest value: " + restFSR, 420, 186);
    text("Rest EMG value: " + restEMG, 420, 204);
    fill(0, 128, 255);
    text("After rest force value: " + after_restFSR, 420, 226);
    text("After rest EMG value: " + after_restEMG, 420, 244);
    fill(0);
    text("Workout force value: " + workoutFSR, 605, 186);
    text("Workout EMG value: " + workoutEMG, 605, 204);
    text("Pump force value: " + pumpFSR, 605, 226);
    text("Pump EMG value: " + pumpEMG, 605, 244);
  
    
    if (myPort.available() > 0) {
      val = myPort.readStringUntil('\n');
      if (millis() - lastStepTime > 200){
        if (val != null) {
          String[] arrOfStr = val.split(",");
         
          emg = Integer.parseInt(arrOfStr[1]);
          points1.add(xvar1+10, emg);
          xvar1 = xvar1+5;
          count1++;
         
          fsr = Integer.parseInt(arrOfStr[0]);
          points.add(xvar+10, fsr);
          pointColors[0]=color(0, 0, 0);
          xvar = xvar+5;
          count++;
         
          if(rest == 1){
            if(init == 0){
               startTime = millis();
               time = 20;
               init = 1;
            }
            if(init == 1){
                sum_emg += emg;
                count_emg++;
                sum_fsr += fsr;
                count_fsr++;
                if(initTimer == 0 && get20Sec == 0){
                  time_init = millis();
                  initTimer = 1;
                }
                if(initTimer == 1 && get20Sec == 0){
                  time_now = millis();
                  if(time_now-time_init > 1000){
                    time -=1;
                    initTimer = 0;
                    if(time == 0){
                      get20Sec = 1;
                    }
                  }
                }
                if(get20Sec == 1 && check == 0){  //20s of measurement
                  restEMG = sum_emg/count_emg;                 
                  restFSR = sum_fsr/count_fsr;
                  println("Rest values measured:" + restEMG + ", " + restFSR);
                  sum_emg = 0;
                  count_emg = 0;
                  sum_fsr = 0;
                  count_fsr = 0;
                  get20Sec = 0;
                  initTimer = 0;
                  init = 0;
                  rest = 0;
                  check = 1;
                }
                 if(get20Sec == 1 && check == 1){  //20s of measurement
                  after_restEMG = sum_emg/count_emg;
                  after_restFSR = sum_fsr/count_fsr;
                  println("After rest values measured:" + after_restEMG + ", " + after_restFSR);
                  sum_emg = 0;
                  sum_fsr = 0;
                  count_emg = 0;
                  count_fsr = 0;
                  get20Sec = 0;
                  initTimer = 0;
                  init = 0;
                  rest = 0;
                }
              }
            }
           
           if(workout == 1){
             if(init == 0){
               startTime = millis();
               time = 20;
               init = 1;
             }
            if(init == 1){
                sum_emg += emg;
                count_emg++;
                sum_fsr += fsr;
                count_fsr++;
                if(initTimer == 0 && get20Sec == 0){
                  time_init = millis();
                  initTimer = 1;
                }
                if(initTimer == 1 && get20Sec == 0){
                  time_now = millis();
                  if(time_now-time_init > 1000){
                    time -=1;
                    initTimer = 0;
                    if(time == 0){
                      get20Sec = 1;
                    }
                  }
                }
                if(get20Sec == 1){  //20sec of measurement
                  workoutEMG = sum_emg/count_emg;
                  workoutFSR = sum_fsr/count_fsr;
                  println("Workout values measured:" + workoutEMG + ", " + workoutFSR);
                  //compare with rest values:
                  if(restFSR == 0){
                    restFSR =1;
                  }
                  percentageEMG_workout = round(((workoutEMG-restEMG)*100)/restEMG);
                  percentageFSR_workout = round(((workoutFSR-restFSR)*100)/restFSR);
                  train1[0] = percentageEMG_workout;
                  train1[1] = percentageFSR_workout;
                  sum_emg = 0;
                  sum_fsr = 0;
                  count_emg = 0;
                  count_fsr = 0;
                  get20Sec = 0;
                  initTimer = 0;
                  init = 0;
                  workout = 0;
                }
              }
            }
            
           if(pump == 1){
             if(init == 0){
               startTime = millis();
               time = 15;
               init = 1;
             }
            if(init == 1){
                sum_emg += emg;
                count_emg++;
                sum_fsr += fsr;
                count_fsr++;
                if(initTimer == 0 && get15Sec == 0){
                  time_init = millis();
                  initTimer = 1;
                }
                if(initTimer == 1 && get15Sec == 0){
                  time_now = millis();
                  if(time_now-time_init > 1000){
                    time -=1;
                    initTimer = 0;
                    if(time == 0){
                      get15Sec = 1;
                    }
                  }
                }
                if(get15Sec == 1){  //15s of measurement
                  pumpEMG = sum_emg/count_emg;
                  pumpFSR = sum_fsr/count_fsr;
                  if(restFSR == 0){
                    restFSR =1;
                  }
                  percentageFSR_pump = round(((pumpFSR-restFSR)*100)/restFSR);
                  percentageEMG_pump = round(((pumpEMG-restEMG)*100)/restEMG);
                  train1[2] = percentageEMG_pump;
                  train1[3] = percentageFSR_pump;
                  sum_emg = 0;
                  sum_fsr = 0;
                  count_emg = 0;
                  count_fsr = 0;
                  get15Sec = 0;
                  initTimer = 0;
                  init = 0;
                  pump = 0;
                }
              }
            }
            
         }   
         if(xvar1>300 || xvar > 300){
         points1.removeRange(0, count1);
         points.removeRange(0, count);
         xvar1 = -5;
         xvar = -5;
         count1 = 0;
         count = 0;
         }
         lastStepTime = millis();
      }
     }
      //Plot1: 
    plot1.setPoints(points1);
    plot1.setPointColors(pointColors1);
    
    plot1.beginDraw();
    plot1.drawBackground();
    plot1.drawBox();
    //plot.drawXAxis();
    plot1.drawYAxis();
    plot1.drawTitle();
    plot1.drawLines();
    plot1.getMainLayer().drawPoints();
    if(restEMG != 0){
      //println("Show rest value horizontal line");
      plot1.getMainLayer().drawHorizontalLine(restEMG, color(255, 0, 0), 3);
    }
    if(after_restEMG != 0){
      //println("Show rest value horizontal line");
      plot1.getMainLayer().drawHorizontalLine(after_restEMG, color(0, 128, 255), 3);
    }
    plot1.endDraw();
    
    //Plot2:
    plot2.setPoints(points);
    plot2.setPointColors(pointColors);
    
    plot2.beginDraw();
    plot2.drawBackground();
    plot2.drawBox();
    //plot.drawXAxis();
    plot2.drawYAxis();
    plot2.drawTitle();
    plot2.drawLines();
    plot2.getMainLayer().drawPoints();
    if(restFSR != 0){
      //println("Show rest value horizontal line");
      plot2.getMainLayer().drawHorizontalLine(restFSR, color(255, 0, 0), 3);
    }
    if(after_restFSR != 0){
      //println("Show rest value horizontal line");
      plot2.getMainLayer().drawHorizontalLine(after_restFSR, color(0, 128, 255), 3);
    }
    plot2.endDraw(); 
    } 
  }

GPoint calculatePoint(float i, float n) {
  return new GPoint(i, n);
}

void keyPressed()
{
  if(key == ENTER && name_ok == 0){
    name = ask_name.getText();
    println(name);
    name_ok = 1;
  }
  if(key == ENTER && name_ok == 1 && set_age == 1){
    age = int(ask_age.getText());
    println(age);
    age_ok = 1;
  }
  if(key == ENTER && age_ok == 1 && set_gender == 1){
    gender = ask_gender.getText();
    println(gender);
    gender_ok = 1;
  }
  if(key == ENTER && gender_ok == 1 && set_height == 1){
    height_user = int(ask_height.getText());
    println(height_user);
    height_ok = 1;
  }
  
  if(key == ENTER && height_ok == 1 && set_weight == 1){
    weight = int(ask_weight.getText());
    println(weight);   
    label1.setVisible(false);
    label2.setVisible(false);
    label3.setVisible(false);
    label4.setVisible(false);
    label5.setVisible(false);
    ask_name.setVisible(false);
    ask_age.setVisible(false);
    ask_gender.setVisible(false);
    ask_height.setVisible(false);
    ask_weight.setVisible(false);
    imgButton1.setVisible(false);
    bio_inserted = 1;
  }
  if (key == 'x' || key == 'X')
  {
    exit();
  }
}

void mousePressed() {
  if( sqrt( sq(160 - mouseX) + sq(75 - mouseY)) < 70/2){
    println("Rest");
    rest = 1;
  }
  if( sqrt( sq(270 - mouseX) + sq(75 - mouseY)) < 70/2){
    println("Workout");
    workout = 1;
  }
  if( sqrt( sq(360 - mouseX) + sq(75 - mouseY)) < 70/2){
    println("Muscle");
    pump = 1;
  }
  /*if( sqrt( sq(470 - mouseX) + sq(75- mouseY)) < 70/2){
    stop = 0;
    rest = 0;
    workout = 0;
    pump = 0;
  }*/  
}


public void customGUI(){

}
