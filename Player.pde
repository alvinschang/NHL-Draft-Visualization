class Player {
  //Movement variables for objects
  PVector loc;
  PVector vel;
  PVector acc;
  
  //Attributes of each object
  String draftedby;
  String name;
  int time;
  int num;
  float GVT;
  float pointsGP;
  float ht;
  float wt;
  float expectedGVT;
  
  //Determines how fast objects move
  float maxspeed = 7;
  float maxforce = 3;

  //Size and color of objects
  float circleSizeX;
  float circleSizeY;
  color expectedColor = color(255, 0);

//Bringing in the data to the object
  Player(String _draftedby, String _name, int _time, int _num, float _GVT, float _pointsGP, float _ht, float _wt, float _expectedGVT) {
    draftedby = _draftedby;
    name = _name;
    time = _time;
    num = _num;
    GVT = _GVT;
    pointsGP = _pointsGP;
    ht = _ht;
    wt = _wt;
    expectedGVT = _expectedGVT;
    circleSizeX = 10;
    circleSizeY = 10;
    loc = new PVector((time-1990)*20+30, height-num*20-50);
    acc = new PVector(0, 0);
    vel = new PVector(0, 0);
  } 

// Arrive function moves object to the target 
  void arrive(PVector target) {
    acc.add(steer(target));
  }

// Steer function returns a vector that changes (as necessary) as we move to the desired location
  PVector steer(PVector target) {
    PVector steer;  
    PVector desired = PVector.sub(target, loc);  
    float d = desired.mag(); 

    if (d > 0) {
      desired.normalize();
      if (d < 1000) desired.mult(maxspeed*(d/100.0f)); 
      steer = PVector.sub(desired, vel);
      steer.limit(maxforce);
    } 
    else {
      steer = new PVector(0, 0);
    }
    return steer;
  }

//Adding up the acceleration to velocity, limiting max speed and implementing to our location
  void update() {
    vel.add(acc);
    vel.limit(maxspeed);
    loc.add(vel);
    acc.mult(0);
  }

//Drawing the object
  void display() {
    noStroke();
    fill(expectedColor);
    ellipse(loc.x, loc.y, expectedGVT*1.9, expectedGVT*1.9);
    fill(100, 140, 200, 200);
    ellipse(loc.x, loc.y, circleSizeX, circleSizeY);
  }

//This function determines how each object moves, based on its attributes and what 'mode' we are in.
  void perform() {
    if (GVTtrigger) {
      expectedColor = color(255, 100, 100, 100);
      arrive(new PVector((time-1990)*20+30, height-GVT*20-50));
      circleSizeX = lerp(circleSizeX, GVT*1.9, 0.01);
      circleSizeY = lerp(circleSizeY, GVT*1.9, 0.01);
    }

    if (HTtrigger) {
      expectedColor = color(255, 0);
      arrive(new PVector((time-1990)*20+30, height-num*20-50));
      if (ht > 60) {
        circleSizeY = lerp(circleSizeY, (ht-65)*1.5, 0.1);
      } 

      if (wt > 130) {
        circleSizeX = lerp(circleSizeX, (wt-160)/5+5, 0.1);
      }
    }

    if (resettrigger) {
      expectedColor = color(255, 0);
      arrive(new PVector((time-1990)*20+30, height-num*20-50));
      circleSizeX = lerp(circleSizeX, 10, 0.1);
      circleSizeY = lerp(circleSizeY, 10, 0.1);
    }
  }



//Packaging up all the functions in the object
  void run() {
    update();
    perform(); 
    display();
  }

//Displaying the words associated with objects
  void words() {
    fill(0);
    if (!GVTtrigger && !HTtrigger) {
      if (dist(mouseX, mouseY, loc.x+transX, loc.y+transY) < circleSizeX/2+4) {
        if (GVT < expectedGVT) {
          fill(230, 180, 180);
        } 
        else {
          fill(180, 180, 240);
        }
        ellipse(522, height-num*20-55, 8, 8);
        fill(255);
        textSize(12);
        text(name + ", " + draftedby + " (" + time + ")", 530, height-num*20-50);
      }
    } 
    else if (GVTtrigger) {
      if (dist(mouseX, mouseY, loc.x+transX, loc.y+transY) < circleSizeX/2+4) {
        if (GVT < expectedGVT) {
          fill(230, 180, 180);
        } 
        else {
          fill(180, 180, 230);
        }
        ellipse(522, height-num*20-55, 8, 8);
        fill(255);
        textSize(12);
        text(name + ", GVT: " + round(GVT*10.0f)/10.0f + " | Expected: " + round(expectedGVT*10.0f)/10.0f, 530, height-num*20-50);
      }
    } 
    else if (HTtrigger) {
      if (dist(mouseX, mouseY, loc.x+transX, loc.y+transY) < circleSizeX/2+4) {
        if (GVT < expectedGVT) {
          fill(230, 180, 180);
        } 
        else {
          fill(180, 180, 230);
        }
        ellipse(522, height-num*20-55, 8, 8);
        fill(255);
        textSize(12);
        text(name + ", " + ht + " in, " + wt + " lbs", 530, height-num*20-50);
      }
    }
  }
}

