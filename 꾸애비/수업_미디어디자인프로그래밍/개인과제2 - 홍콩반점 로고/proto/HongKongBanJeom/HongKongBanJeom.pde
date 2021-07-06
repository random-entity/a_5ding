import shiffman.box2d.*;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.joints.*;
import org.jbox2d.collision.shapes.*;
import org.jbox2d.collision.shapes.Shape;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.*;
import org.jbox2d.dynamics.contacts.*;

Box2DProcessing box2d;
ArrayList<Bridge> bridges = new ArrayList<Bridge>();
int numBridges = 30;
Box box;
Spring spring;


void setup() {
  size(300, 800, P2D);
  frameRate(24);
  box2d = new Box2DProcessing(this);
  box2d.createWorld();

  for (int i = 0; i < numBridges; i++) {
    bridges.add(new Bridge(height * .66 + random(-5, 5), height/10, map(i, 0, numBridges, 20, width-20)));
  }

  box = new Box(width/2, height/3);
  spring = new Spring();
}

void mousePressed() {
  // Check to see if the mouse was clicked on the box
  if (box.contains(mouseX, mouseY)) {
    // And if so, bind the mouse location to the box with a spring
    spring.bind(mouseX, mouseY, box);
  }
}

void draw() {
  background(255);
  box2d.step();

  spring.update(mouseX, mouseY);

  for (Bridge bridge : bridges) {
    bridge.display();
  }
  box.display();
  spring.display();
}
