// ready for arduino integration
import processing.serial.*;

import processing.sound.*;
SinOsc sine;


//--- stimulus variables ----
float reset_diameter = 40; /// ---> check W/ original reference!
float diameter = 40;
float speedDiameter = 25;
boolean flag = false;

int n_stimuli = 5;          // total number of stimuli
float counter = 0;          // Defines speed of stimulus enlargement (together with frame_rate)
int stimuli_per_trial = 5;  // Number of stimuli per trial
int count_stimuli; 

int s, e;

int frame_rate = 50;  // frame rate defines the speed at wich the stimulus is delivered
// --> to-do: calculate the framerate / counter to find stimulus speed conversion rate

void setup() {
  fill(0);                  // black stimulus
  frameRate(frame_rate);    // framerate 
  //size(1280, 768);          // enable for debugging
  fullScreen();           // enable full screen
  sine = new SinOsc(this);
  sine.amp(0.5);
  sine.freq(300);
}

void draw() {
  background(89, 89, 89);  // neutral background
  if (flag) {
    stimulusOnset();
  }
}

// enable key press to repeat the stimulus
void keyPressed() {
  if (key == 'a') {
    count_stimuli = 0;
    flag = true;
  } else if (key == 'l') {
    soundON();
  }
}

void soundON() {
  e = 0;
  s = second();
  while (e < 2) {
    sine.play();
    e = second() - s;
  }
  sine.stop();
}

void stimulusOnset() {

  if (count_stimuli < stimuli_per_trial) {

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
