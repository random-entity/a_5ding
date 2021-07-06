import toxi.physics2d.*;
import toxi.physics2d.behaviors.*;
import toxi.geom.*;

VerletPhysics2D physics;
Particle p1;
Particle p2;
Particle p3;

void setup() {
  size(500, 500);
  physics = new VerletPhysics2D();
  physics.addBehavior(new GravityBehavior(new Vec2D(0, .5)));
  physics.setWorldBounds(new Rect(0, 0, width, height));

  p1 = new Particle(new Vec2D(width/2, 20));
  p2 = new Particle(new Vec2D(width/2 + 70, 60));
  p3 = new Particle(new Vec2D(width/2 - 70, 10));
  //p1.lock();
  

  VerletSpring2D spring12 = new VerletSpring2D(p1, p2, 160, .1);
  VerletSpring2D spring13 = new VerletSpring2D(p1, p3, 160, .1);
  VerletSpring2D spring23 = new VerletSpring2D(p2, p3, 160, .1);

  physics.addParticle(p1);
  physics.addParticle(p2);
  physics.addParticle(p3);
  physics.addSpring(spring12);
  physics.addSpring(spring13);
  physics.addSpring(spring23);
}


void draw() {
  physics.update();
  background(255);

  p1.display(); 
  p2.display();
  p3.display();
}
