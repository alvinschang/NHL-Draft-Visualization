/*
NHL DRAFT - FIRST ROUND VISUALIZATION (1990-2011)
 
 Acknowledgments: The GVT metric used here is from Tom Awad. 
 The "arrive" function is borrowed from the brilliant Dan Shiffman <shiffman.net>, who taught me in NYU ITP's 'Nature of Code.' 
*/

Player[] player;
float transX = 0;
float transY = 0;
float transZ = 1;
PFont font;

boolean GVTtrigger = false;
boolean HTtrigger = false;
boolean resettrigger = false;
int button1fill = 200;
int button2fill = 200;

void setup() {
  size(800, 700);
  smooth();
  font = loadFont("HelveticaNeue-48.vlw");
  String[] data = loadStrings("http://alvinschang.com/projects/data/firstround.csv");
  player = new Player[data.length];

  //The CSV has nine columns. I'm passing those values to each object below. 
  for (int i = 0; i < player.length; i++) {
    String[] values = split(data[i], ",");
    //Values are: Team drafting, Player Name, Year Drafted, Draft No., GVT, Points per Game Played, Height, Weight, Expected GVT (my metric)
    player[i] = new Player(values[0], values[1], int(values[2]), int(values[3]), float(values[4]), float(values[5]), float(values[6]), float(values[7]), float(values[8]));
  }
}

void draw() {
  background(221, 224, 213);

  //Running all the player objects
  for (int i = 0; i < player.length; i++) {
    player[i].run();
  }


  //RIGHT SIDEBAR

  //Right background
  noStroke();
  fill(138, 142, 127);
  rect(491, 0, 500, height);

  //Right Separator
  stroke(0);
  line(490, 0, 490, height);

  //Darkening background for every other player row
  for (int i = 0; i<30; i++) {
    if (i%2 == 1) {
      fill(162, 165, 155, 50);
      noStroke();
      rect(491, height-i*20-67, 500, 20);
    }
  }

  //Labeling the rows (Draft Nos.)
  for (int i = 0; i<30; i++) { 
    fill(255);
    textFont(font, 10);
    text(i+1, 500, height-i*20-70);
  }

  //The key
  fill(255, 100, 100, 100);
  ellipse(width-270, height-20, 10, 10);
  fill(255);
  textSize(11);
  text("Overperformed draft slot", width-259, height-36);
  fill(100, 140, 200, 200);
  ellipse(width-270, height-40, 10, 10);
  fill(255);
  text("Underperformed draft slot", width-259, height-16);

  //Player names
  for (int i = 0; i < player.length; i++) {
    player[i].words();
  }

  //The Header 
  textSize(20);
  fill(255);
  text("NHL DRAFT BOARD", width-240, 30);

  //ODDS AND ENDS

  //Running the button function (below)
  buttons();

  //Labeling the chart
  text("1990", 25, height-10);
  text("2000", 25+195, height-10);
  text("2011", 430, height-10);

  //Creating the key for "GVT" when button is pressed
  if (GVTtrigger) {
    fill(255);
    stroke(200);
    rect(300, 50, 150, 50);
    fill(255, 100, 100, 100);
    ellipse(35+280, 65, 10, 10);
    fill(50);
    text("Expected performance", 47+280, 68);

    fill(100, 140, 200, 200);
    ellipse(35+280, 85, 10, 10);
    fill(50);
    text("Actual performance", 47+280, 88);
  }



  //Outlining the entire sketch
  fill(50);
  line(0, 0, 0, height);
  line(0, 0, width, 0);
  line(width, height, width, 0);
  line(width, height, 0, height);
}

/*
// Right now, the zoom function isn't being used. 
// In the future, this can be another way of 'faking' 3D to explore the data.
// Or maybe I'll just implement real 3D...

void zoom() {
  if (keyPressed && keyCode == UP) {
    transY += 4;
  } 
  if (keyPressed && keyCode == DOWN) {
    transY -= 4;
  } 
  if (keyPressed && keyCode == LEFT) {
    transX += 4;
  } 
  if (keyPressed && keyCode == RIGHT) {
    transX -= 4;
  }


  if (keyPressed && key == 'a') {
    transZ += 0.06;
  } 
  if (keyPressed && key == 'z') {
    transZ -= 0.06;
  }
}
*/

//All the buttons
void buttons() {

  stroke(100);

//DRAWING THE BUTTONS
  //Reseting players
  fill(255, 160, 160);
  rect(115, 10, 110, 25);
  fill(0);
  textSize(11);
  text("Reset all players", 127, 27);
  //Performance
  fill(button1fill);
  rect(235, 10, 110, 25);
  fill(0);
  textSize(11);
  text("Sort by Performance", 240, 27);
  //Height/Weight
  fill(button2fill);
  rect(355, 10, 100, 25);
  fill(0);
  text("Visualize Ht/Wt", 368, 27);

//Creating function for 'Reset' ...
  if (mouseX > 115 && mouseX < 115+110 && mouseY > 10 && mouseY < 10+25 && mousePressed) {
    resettrigger = true;
    HTtrigger = false;
    GVTtrigger = false;
    button1fill = 200;
    button2fill = 200;
  }

// ... and now the 'Performance' button ...
  if (mouseX > 235 && mouseX < 235+110 && mouseY > 10 && mouseY < 10+25 && mousePressed) {
    GVTtrigger = true;
    resettrigger = false;
    HTtrigger = false;
    button1fill = 150;
    button2fill = 200;
  }

// ... and now the height/weight button.
  if (mouseX > 355 && mouseX < 355+100 && mouseY > 10 && mouseY < 10+25 && mousePressed) {
    HTtrigger = true;
    resettrigger = false;
    GVTtrigger = false;
    button2fill = 150;
    button1fill = 200;
  }
}

