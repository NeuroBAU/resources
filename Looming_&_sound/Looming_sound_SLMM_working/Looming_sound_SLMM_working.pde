// Arduino integration
import processing.serial.*;
Serial myPort;

// Initialize AUDIO
import processing.sound.*;
SinOsc sine;

//--- VISUAL | variables ----
float reset_diameter = 40; /// ---> check W/ original reference!
float diameter = 40;
float speedDiameter = 25;
boolean flag = false;

//--- PROTOCOL | variables ----
int n_stimuli = 5;          // total number of stimuli
float counter = 0;          // Defines speed of stimulus enlargement (together with frame_rate)
int stimuli_per_trial = 5;  // Number of stimuli per trial
int count_stimuli; 
int start_time;
boolean opto_onset = false;

//--- AUDIO | variables ----
int timer, duration;
int audio_duration = 3;

int frame_rate = 50;  // frame rate defines the speed at wich the stimulus is delivered
// --> to-do: calculate the framerate / counter to define stimulus speed conversion rate

void setup() {
  fill(0);                  // black stimulus
  frameRate(frame_rate);    // framerate 
  //size(1280, 768);        // enable for debugging
  fullScreen();             // enable full screen
  sine = new SinOsc(this);
  sine.amp(0.5);
  sine.freq(300);
  String portName = Serial.list()[0]; // !!! MAC
  //String portName = Serial.list()[0]; // !!! Windows
  myPort = new Serial(this, portName, 9600);
}

void draw() {
  myPort.write('0');
  background(89, 89, 89);  // neutral background

  if (flag) {
    loomingOnset();
    //myPort.write('0'); // to turn OFF
    //myPort.write('1'); // tu turn ON
  }
}


// Enable key press to repeat the stimului
// 'a' for VISUAL
// 'l' for AUDIO
// ---> !!! CAREFUL: missing condition to stop if pressed for long time
// ---> !!! CAREFUL: missing condition to enforce serial execution of the stimuli
void keyPressed() {
  start_time = millis();
  if (key == 'a') {
    count_stimuli = 0;
    flag = true;
    opto_onset = true;
  } else if (key == 'l') {
    soundON();
  }
}


// play SOUND
void soundON() {
  duration = 0;
  timer = second();

  while (duration < audio_duration) {
    sine.play();
    duration = second() - timer;
  }

  sine.stop();
}

// LOOMING
void loomingOnset() {
  int stop_time = millis();


  if (count_stimuli < stimuli_per_trial) {

    if ((stop_time - start_time >= 1000) && (opto_onset)) {
      println(stop_time - start_time);
      start_time = millis();
      opto_onset = false;
    }

    diameter = diameter + speedDiameter;    // increase stimulus size

    // stop stimulus at max size
    if (diameter >= 700) {
      diameter = 700;
    }

    // reset the stimulus to minimum size
    if (counter >= 50) {
      diameter = reset_diameter;
      counter = 0;
      count_stimuli++;
    }

    ellipse(width/2, height/2, diameter, diameter);    // stimulus : center screen

    counter ++;
  }
}
