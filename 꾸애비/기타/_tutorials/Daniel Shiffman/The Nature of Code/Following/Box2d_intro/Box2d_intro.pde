import shiffman.box2d.*;

Vec2 gravity = new Vec2(0, -10);
Vec2 mouseWorld = box2d.coordPixelsToWorld(mouseX, mouseY);

PBox2D box2d;

void setup() {
  box2d = new PBox2D(this);
  // Initializes a Box2D world with default settings
  box2d.createWorld();

  box2d.setGravity(0, -10);
}
