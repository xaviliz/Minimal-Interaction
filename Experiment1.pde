import oscP5.*;        // Open Sound Control library
import netP5.*;        // Network library
import ddf.minim.*;    // Sound library
import javax.sound.sampled.Control;
//import ddf.minim.analysis.*;
import java.io.*;
import java.util.HashMap;  // Necessary for vibration
//import pitaru.sonia_v2_9.*; // automatically created when importing sonia using the processing menu.


// Object Constructors 
OscP5 oscP5;
NetAddress myRemoteLocation;
// Minim library
Minim minim;
AudioSample sound1, sound2;
AudioBuffer left;
AudioOutput out;
Control controls;
PrintWriter out_txt;
//PrintWriter out_txtB;
//PrintWriter out_crosses;
Table data_out;

// specifiy either Minim.MONO or Minim.STEREO for type
//AudioOutput getLineOut(Minim.MONO);
private String remoteIp;
private int remotePort;
ThreadTimer tTimer;
// HashMap for timed vibration
private HashMap<Integer, ThreadTimer> timers;

/**
 * Experiment1 
 * 
 * This code is based on the Example script named PolygonPShape 
 * from Create Shapes Folder. Torus scene is simply implemented.
 * Also Acoustic feedback with ddf.min.* library. 
 * 11-3-15
 * Wiimote is available to control the target1 and the feedback vibration is configured by 
 **/

// Initialize variables
PShape line, square1, shadow1, static1, square2, shadow2,static2;
PFont font;
// Graphics variables
int edgeSquare = 50, distanceAlias = 150, fillVal = 0, mapValue1, mapValue2;
int pos = 70, move = 0, pmove = 0,
    vel = 0, torus_pos = 0, ptorus_pos, ppos = pos,
    posb = 0, pbpos = posb, ptorus_posB, torus_posB,
    rpos = 0, n_cross = 0, n_shad1 = 0, n_stat1 = 0,
    n_shad2 = 0, n_stat2 = 0, dis = 0, disb = 0, vel_factor = 8;
//OSC variables width-pos-distanceAlias
int in_port = 9000, out_port = 8000;
float yawValue1, yawValue2, displayValue1, displayValue2;  // OSC Values received
float click1 = 0.0, click2 = 0.0;
// Wii variables
int wiiNumber1 = 1, wiiNumber2 = 2;
boolean vibrate;
boolean led1, led2, led3, led4;
// Timer variables
int nframe; float time;

void setup() {
  
  // Display settings (width and height)
  // Change this values if you use a shorter screen
  size(1440,990,P3D); // 1440x990
  frameRate(25); 
  /* start oscP5, listening for incoming messages at port 9000*/
  oscP5 = new OscP5(this,in_port);
  this.oscP5 = oscP5;
  this.remoteIp = "localhost";
  this.remotePort = 8000;
  myRemoteLocation = new NetAddress("127.0.0.1",out_port);
  timers = new HashMap<Integer, ThreadTimer>();
  /* Charge font */
  font = loadFont("Delicious-Roman-24.vlw");
  textAlign(LEFT);
  /* Sonia Library - http://sonia.pitaru.com/ */
  //Sonia.start(this);
  //mySample1 = new Sample("flipp1.wav");
  //mySample2 = new Sample("flipp1.wav");
  
  /* start Minim Library for charge sounds */
  /* http://code.compartmental.net/minim/javadoc/ddf/minim/AudioPlayer.html */
  minim = new Minim(this);
  out = minim.getLineOut();
  //l_out = getLineOut(0);
  sound1 = minim.loadSample("woing_L.wav");
  sound2 = minim.loadSample("woing_R.wav");
  
  // Initialize position for avatar B
  posb = width-pos-distanceAlias;
  
  /* Draws all geometry with smooth (anti-aliased) edges
  https://processing.org/reference/smooth_.html */
  smooth();
  
  /* Create shapes --> https://processing.org/tutorials/pshape/ */
  // Create a line
  int heightLine = 5;
  line = createShape();
  line.beginShape();
  line.fill(0);
  line.stroke(50);
  // Here, we are hardcoding a series of vertices
  line.vertex(0, height/2);
  line.vertex(0, (height/2)-heightLine);
  line.vertex(width, (height/2)-heightLine);
  line.vertex(width, height/2);
  line.endShape(CLOSE);
  
  // First create the shape
  square1 = createShape();
  square1.beginShape();
  // You can set fill and stroke
  //square1.fill(102);
  square1.fill(#3aff82);            // green color
  square1.stroke(50);
  square1.strokeWeight(2);          // stroke color
  // Here, we are hardcoding a series of vertices
  square1.vertex(pos,  (height/2)-heightLine-edgeSquare);
  square1.vertex(pos,  (height/2)-heightLine);
  square1.vertex(pos+edgeSquare,  height/2-heightLine);
  square1.vertex(pos+edgeSquare, (height/2)-edgeSquare-heightLine);
  square1.endShape(CLOSE);
  
  // mobile lure shape
  shadow1 = createShape();
  shadow1.beginShape();
  // You can set fill and stroke
  shadow1.fill(25);
  shadow1.stroke(50);
  //shadow1.strokeWeight(2);
  // Here, we are hardcoding a series of vertices
  shadow1.vertex(pos+distanceAlias, (height/2)-heightLine-edgeSquare);
  shadow1.vertex(pos+distanceAlias, (height/2)-heightLine);
  shadow1.vertex(pos+edgeSquare+distanceAlias, height/2-heightLine);
  shadow1.vertex(pos+edgeSquare+distanceAlias, (height/2)-heightLine-edgeSquare);
  shadow1.endShape(CLOSE);
  
// First create the shape
  square2 = createShape();
  square2.beginShape();
  // You can set fill and stroke
  //square2.fill(102);
  square2.fill(#ff3a54);
  square2.stroke(200);
  //square2.strokeWeight(2);
  
  // TODO correct stroke
  // Search for a way to plot data
  // Think in how to modify the code to work with two environments
  
  // Here, we are hardcoding a series of vertices
  square2.vertex(width-pos-distanceAlias,  (height/2)-heightLine-edgeSquare);
  square2.vertex(width-pos-distanceAlias,  (height/2)-heightLine);
  square2.vertex(width-pos-distanceAlias+edgeSquare,  height/2-heightLine);
  square2.vertex(width-pos-distanceAlias+edgeSquare, (height/2)-edgeSquare-heightLine);
  square2.endShape(CLOSE);

  // Mobile lure shape
  fill(0);
  stroke(50);
  //strokeWeight(2);
  shadow2 = createShape(RECT,width-pos, (height/2)-5-50, 50,50);
  // Static objects
  fill(200);
  stroke(50);
  strokeWeight(2); 
  static1 = createShape(RECT,width/4, (height/2)-5-50, 50,50);
  static2 = createShape(RECT,3*width/4, (height/2)-5-50, 50,50);
  
  // PrintWriter class to extract data in txt file.
  out_txt = createWriter("positions.txt");
  // Create a csv file with each feature by columns
  data_out = new Table();
  data_out.addColumn("Time"); // in seconds
  data_out.addColumn("AvatarA"); // postion Avatar A
  data_out.addColumn("AvatarB"); // postion Avatar B
  data_out.addColumn("Distance"); // postion Avatar B
  data_out.addColumn("nCrosses");
  data_out.addColumn("n_shadow1");
  data_out.addColumn("n_shadow2");
  data_out.addColumn("n_stat1");
  data_out.addColumn("n_stat2");
  data_out.addColumn("clickA");
  data_out.addColumn("clickB"); 
}

public void test(int theA, int theB) {
  println("### plug event method. received a message /test.");
  println(" 2 ints received: "+theA+", "+theB);  
}

void draw() {
  nframe = nframe + 1;
  time = float(nframe)/25;
  /* Background settings */
  background(240);              // background luminance
  /* Text on screen */
  beginShape();
  fill (0,0,0);                 // Text in black color
  endShape();
  // Text on the background
  textFont(font, 24);            // Load font file and set the size
  // Time data on the screen
  text ("TIME:", 20, 30);
  text(nf(time, 1,1),225, 30);
  /* User A statistics - Left side */
  text ("USER A:", 20, 60);
  text ("YawValue (y-axis) = ", 20,90);
  text(nf(yawValue1, 1,1),225, 90);
  text ("Arrows keys = ", 20,120);
  text(nf(fillVal, 1,1),225, 120);
  text ("Mouse movement = ", 20,150);
  text(nf(move, 1,1),225, 150);
  text ("Target1 position = [", 20,180);
  text(nf(pos, 1,1),215, 180);
  text(", 445]", 275,180);
  text ("Velocity A = ", 20,210);
  text(nf(torus_pos, 1,1),215, 210);
  text ("Avatar Crosses = ", 20,240);
  text(nf(n_cross, 1,1),225, 240);
  text ("Shadow Crosses = ", 20,270);
  text(nf(n_shad1, 1,1),225, 270);
  text ("Static Crosses = ", 20,300);
  text(nf(n_stat1, 1,1),225, 300);
  text ("Distance A/B = ", 20,330);
  text(nf(dis, 1,1),225, 330);
  
  /* User B Statistics - Right side */
  text ("USER B:", 1020, 60);
  text ("YawValue (y-axis) = ", 1020,90);
  text(nf(yawValue2, 1,1),1225, 90);
  text ("Arrows keys = ", 1020,120);
  text(nf(fillVal, 1,1),1225, 120);
  text ("Mouse movement = ", 1020,150);
  text ("Target2 position = [", 1020,180);
  text(nf(posb, 1,1),1215, 180);
  text(", 445]", 1275,180);
  
  text ("Velocity B = ", 1020,210);
  text(nf(torus_posB, 1,1),1215, 210);
  text ("Avatar Crosses = ", 1020,240);
  text(nf(n_cross, 1,1),1225, 240);
  text ("Shadow Crosses = ", 1020,270);
  text(nf(n_shad2, 1,1),1225, 270);
  text ("Static Crosses = ", 1020,300);
  text(nf(n_stat2, 1,1),1225, 300);
  
  /* Draw static shapes */
  shape(line);                  // show the line in the display
  shape(static1);               // show the shape in the display
  shape(static2);               // show the shape in the display
  
  // Target A parameters
  // Update move and pmove in each frame
  //pmove = move;                  // assinging the last move
  //move = mouseX - pmouseX;       // compute the present move
  //vel = move - pmove;            // compute the velocity of mouse position
  ppos = pos;                      // last position
  pos = pos + mapValue1+fillVal;//+move    // move is for mouse control, fillVall for arrow key control
  pos = pos % width;               // Modul of position, force avaratar to be inside the screen
  // Correction of position when it is negative
  if (pos <= 0){
    //println("Negative position avatarA: ", pos - width);
    pos = abs(pos - width);
  }else
    pos = pos;
  // Save position data
  out_txt.println(pos);  // Write the coordinate to the file
  // Torus display for avatar A
  ptorus_pos = torus_pos;
  if (pos>=0){
    // for right side
    torus_pos = pos-ppos;
    //println("torus_posA:",torus_pos);
    // We can use translate() to move the PShape square and the mobile lure
    square1.translate(torus_pos, 0);
    shadow1.translate(torus_pos, 0);
  }else{
    // for left side
    //println("Crossing left side with avatarA: ", width + pos - ppos);
    torus_pos = width + pos - ppos + 1;
    square1.translate(torus_pos, 0);
    shadow1.translate(torus_pos, 0);
  }
  //println("width: ",width-pos-distanceAlias);
  // Target B parameters
  pbpos = posb;
  posb = posb + mapValue2; //+ mapValue2;
  //println("posB: ", posb);
  posb = posb % width;
  // Correction of position when it is negative
  if (posb<=0)
    posb = abs(posb - width);
  else
    posb = posb;
 
  // Torus display for avatar B
  ptorus_posB = torus_posB;
  if (posb>=0){
    // for right side
    torus_posB = posb-pbpos;
    // We can use translate() to move the PShape square and the mobile lure
    square2.translate(torus_posB, 0);
    shadow2.translate(torus_posB, 0);
  }else{
    // for left side
    torus_posB = width + posb-pbpos+1;
    square2.translate(torus_posB, 0);
    shadow2.translate(torus_posB, 0);
  }
  
  // Torus position (velocity)
  //println("Torus position: ",torus_pos);
  //println("torus_posB:",torus_posB);
  
  // Display the avatar_A and the mobile lure
  shape(shadow1);
  shape(square1);
  shape(shadow2);
  shape(square2);
  
  // Acoustic and Vibration FeedBack
  // Launch Sounds  depending on the position
  int a_pos = pos; int  pa_pos = ppos;    // last position corrected
  int b_pos = abs(posb-width-25); int  pb_pos = abs(pbpos-width-25); // position with the flipped range
  /* Condition to avoid sounds when the target cross the torus */
  if (abs(pa_pos-a_pos) < 1000){ //|| abs(pb_pos-b_pos) < 1000 ){
    /* First static object - Zero crossing 1 */
    if ((pa_pos <= width/4 && a_pos >= width/4) || (pa_pos >= width/4 && a_pos <= width/4)){
      playSound1();            // Play acoustic feedback for avatar B
      //println("pa_pos: ",pa_pos, "; a_pos: ", a_pos, "; abs(pa_pos-a_pos): ", abs(pa_pos-a_pos));
      vibrate(wiiNumber1,  true);
      delay(150);              // Duration of vibration in miliseconds
      vibrate(wiiNumber1, false);
      n_stat1 = n_stat1 + 1;  // Static crossed by avatar counter
    }
  }
  if (abs(pb_pos-b_pos) < 1000 ){
    /* Second static object static object - Zero crossing 2 */
    if ((pb_pos <= width/4 && b_pos >= width/4) || (pb_pos >= width/4 && b_pos <= width/4)){
      //println("pb_pos: ",pb_pos, "; b_pos: ", b_pos, "; abs(pb_pos-b_pos): ", abs(pb_pos-b_pos));
      // Acoustic and vibration feedback for userB
      playSound2();            // Play acoustic feedback for avatar B
      vibrate(wiiNumber2,  true);
      delay(150);             // Duration of vibration in miliseconds
      vibrate(wiiNumber2, false);
      n_stat2 = n_stat2 + 1;  // Static crossed by avatar counter
    }
  }
  // Vibration when both avatars cross
      // it will depends on the last position and the present position
      // and evaluate if avatars have crossed in this frame.
      disb = dis;
      dis = pos-posb;
      //println("Distance between avatars: ", dis);
  if ((ppos>pbpos && pos<posb) || (ppos<pbpos && pos>posb)){
    //println("*** /// Crossing between avatars: ", (pos-posb));
    // Avoid feedback when some of them is crossing the scene
    if ((dis < 0 && disb>=0) || (dis>0 && disb<=0)){
      if ((abs(ppos-pos) < 1000) && (abs(pbpos-posb) < 1000)){
        playSound1(); playSound2();
        // Vibration in avatar 1
        vibrate(wiiNumber1,  true);
        // vibration in avatar 2
        vibrate(wiiNumber2,  true);
        delay(150);              // Duration of vibration in miliseconds
        vibrate(wiiNumber1, false);
        vibrate(wiiNumber2, false);
        n_cross = n_cross + 1;
      }
    }
  }
  // Vibration when the avatar A cross with the shadow B
  int sB_pos = (posb+distanceAlias) % width; int psB_pos = (pbpos+distanceAlias) % width;
  if ((ppos>psB_pos && pos<sB_pos) || (ppos<psB_pos && pos>sB_pos)){
    //println("*** /// Crossing between avatars: ", (pos-posb));
    // Avoid feedback when some of them is crossing the scene
    if ((abs(ppos-pos) < 1000) && (abs(psB_pos-sB_pos) < 1000)){
      playSound1();
      // Vibration in avatar 1
      vibrate(wiiNumber1,  true);
      delay(150);              // Duration of vibration in miliseconds
      vibrate(wiiNumber1, false);
      n_shad1 = n_shad1 + 1;
    }
  }
  // Vibration when the avatar B cross with the shadow A
  int sA_pos = (pos+distanceAlias) % width; int psA_pos = (ppos+distanceAlias) % width;
  if ((pbpos>psA_pos && posb<sA_pos) || (pbpos<psA_pos && posb>sA_pos)){
    //println("*** /// Crossing between avatars: ", (pos-posb));
    // Avoid feedback when some of them is crossing the scene
    if ((abs(psA_pos-sA_pos) < 1000) && (abs(pbpos-posb) < 1000)){
      playSound2();
      // Vibration in avatar 1
      vibrate(wiiNumber2,  true);
      delay(150);              // Duration of vibration in miliseconds
      vibrate(wiiNumber2, false);
      n_shad2 = n_shad2 + 1;
    }
  }
  // Add row in csv file
  TableRow newRow = data_out.addRow();
  newRow.setFloat("Time", time);
  newRow.setInt("AvatarA", pos);
  newRow.setInt("AvatarB", posb);
  newRow.setInt("Distance", dis);
  newRow.setInt("nCrosses", n_cross);
  newRow.setInt("n_shadow1", n_shad1);
  newRow.setInt("n_shadow2", n_shad2);
  newRow.setInt("n_stat1", n_stat1);
  newRow.setInt("n_stat2", n_stat2);
  newRow.setFloat("clickA", click1);
  newRow.setFloat("clickB", click2);
  // Save the row every frame
  saveTable(data_out, "data/new.csv");
  click1 = 0.0;
  click2 = 0.0;
}

// OSC Messages Receiver 
void oscEvent(OscMessage theOscMessage) {
  String addr = theOscMessage.addrPattern();
  // Avatar A control
  if(addr.indexOf("wii/1/accel/pry/2")!=-1){
    // Yaw value from wii1
    yawValue1 = theOscMessage.get(0).floatValue();
    mapValue1 = round(vel_factor * (yawValue1 - 0.5));
  }
  // Avartar A click (button B)
  if(addr.indexOf("wii/1/button/B")!=-1){
    click1 = theOscMessage.get(0).floatValue();
  }
  // Avatar B control
  if(addr.indexOf("wii/2/accel/pry/2")!=-1){
    // Yaw value from Wii2 (Osculator)
    yawValue2 = theOscMessage.get(0).floatValue();
    println("OSC value", yawValue2);
    mapValue2 = round(vel_factor * (yawValue2 - 0.5));
    displayValue2 = yawValue2;
    println(addr);
    println("Mapped OSC value", mapValue2);
  }
  // Avartar B click (button B)
  if(addr.indexOf("wii/2/button/B")!=-1){
    click2 = theOscMessage.get(0).floatValue();
    //println("Mapped B OSC value to button B", click2);
  }
}

/* --- Key control messages --- */
/* https://processing.org/reference/keyCode.html */
void keyPressed() {
  switch(key) {
    case 'b':
      //vibrateForMillis(wiiNumber, 300);
      // use this instead to turn vibration on and off (no timing)
      //vibrate = !vibrate;
      //println(vibrate);
      vibrate(wiiNumber1,  true);
      delay(150);              // Duration of vibration in miliseconds
      vibrate(wiiNumber1, false);
      break;
   case 'e':
      out_txt.flush();  // Writes the remaining data to the file
      out_txt.close();  // Finishes the file
      exit();  // Stops the program
  }
  if (key == CODED) {
    if (keyCode == RIGHT) {
      fillVal = fillVal + 5;
      println("RIGHT ARROW");
    } else if (keyCode == LEFT) {
      fillVal = fillVal - 5;
      println("LEFT ARROW");
    } else if (keyCode == SHIFT) {
      fillVal = 0;
      println("SHIFT KEY");
    }
    } else {
    fillVal = 0;
  }
}

void playSound1() {
  /* This function play and rewind sound1 instance */
  //println("Control PAN",sound1.hasControl(Controller.PAN));
  sound1.trigger();
}

void playSound2() {
  /* This function play and rewind sound1 instance */
  //println("Balance in sound2", sound2.getGain());
  sound2.trigger();
}

public void stop() {
  // always close Minim audio classes when you are done with them
  sound1.close();
  sound2.close();
  minim.stop();
  super.stop();
}

void vibrate(int wiiNumber, boolean b){
  // From OSCControllerKit Examples, WiiLeedandVibrateExample
    if(myRemoteLocation == null){
      /*LOGGER.log(Level.WARNING, "you need to call setRemote() before sending messages. "
          + "if you want to send messages on the same machine, use 127.0.0.1 and the osc-imput-port");*/
    }
    OscMessage message = new OscMessage("/wii/" + wiiNumber + "/vibrate/");
    //println(b);
    message.add(b ? 1.0 : 0.0);
    oscP5.send(message, myRemoteLocation);
    //println("OSC message sended: ", message);
    //println(myRemoteLocation);
}
public void led(boolean led1, boolean led2, boolean led3, boolean led4, int wiiNumber){
  led(wiiNumber, led1, led2, led3, led4);
}
public void led(int wiiNumber, boolean led1, boolean led2, boolean led3, boolean led4){
  // we need to reverse the order of the led booleans and convert it to decimal
  int revHexValue = Conversion.getInstance().boolArrayToDec(new boolean[] {led4, led3, led2, led1});
  led(wiiNumber, revHexValue);
}
  
public void led(int wiiNumber, int decVal){
  if(myRemoteLocation == null){
    System.err.println("you need to call setRemote() before sending messages. "
          + "if you want to send messages on the same machine, use 127.0.0.1 and the osc-imput-port");
  }
  OscMessage message = new OscMessage("/wii/" + wiiNumber + "/led/");
  message.add(decVal);
  oscP5.send(message, myRemoteLocation);
}
