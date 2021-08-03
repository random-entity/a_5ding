float groundY;

public class character {
  PVector pos, vel, acc;
  //float mass;
  PVector g;
  //PVector addedForce;

  public character() {
    pos = new PVector(50, 0);
    vel = new PVector(0, 0);
    acc = new PVector(0, 0);
    //mass = 1;
    g = new PVector(0, 5);
    //addedForce = new PVector(0, 0);
  }

  public void runPhysics() {
    //acc = PVector.add(g, addedForce.mult(1 / mass));

    acc = g;
    
    vel.add(acc);
    pos.add(vel);

    if (pos.y >= groundY) {
      acc = new PVector(0, 0);
      vel.y = 0;
      pos.y = groundY;
    }
  }

  public void display() {
    ellipse(pos.x, pos.y, 20, 20);
  }
}

public character mario;

void setup() {
  size(800, 600);
  mario = new character();
  groundY = height / 2;
}

void draw() {  
  line(0, groundY, width, groundY);

  mario.runPhysics();
  mario.display();
}
