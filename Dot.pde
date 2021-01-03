
class Dot {
  float dst, rMin, rMax, minSpeed, maxSpeed, r, maxPosX, maxPosY;
  PVector pos, speed;
  color col;
  int opc;
  boolean connected;
  Dot() {
    dst = 20;
    rMin = 4;
    rMax = 8;
    minSpeed = -0.4;
    maxSpeed = 0.4;
    r = random(this.rMin, this.rMax);
    col = color(255, 10, 55);
    connected = false;
    opc = 0;

    float ang = random(TWO_PI);
    maxPosX = random(irisMinRadius / 2);
    maxPosY = random(irisMinRadius / 2);
    pos = new PVector((width / 2) + maxPosX * cos(ang), (height / 2) + maxPosY * sin(ang));
    speed = new PVector(random(this.minSpeed, this.maxSpeed), random(this.minSpeed, this.maxSpeed));
  }

  void check(Dot d) {
    // checks this dot with another dot to see if they will connect
    // the dst variable controls the distance of the search
    // it also draws a line between connected dots
    if (dist(this.pos.x, this.pos.y, d.pos.x, d.pos.y) < this.dst) {
      stroke(0, 0, 255, map(this.opc, 0, 255, 0, 80));
      strokeWeight(2);
      line(this.pos.x, this.pos.y, d.pos.x, d.pos.y);
      this.col = color(10, 144, 134);
      this.connected = true;
      d.connected = true;
    }
  }

  void update(int o) {
    // updates the position and checks for the maximum positions
    this.connected = false;
    this.pos.add(this.speed);
    if (this.pos.dist(new PVector(width / 2, height / 2)) >= irisMinRadius / 2) {
      this.speed.mult(-1);
    }
    this.opc = o;
  }

  void render() {
    // renders the dots and changes color for connected dots
    if (connected) {
      col = color(10, 144, 134, opc);
    } else {
      col = color(255, 10, 55, opc);
    }
    noStroke();
    fill(this.col);
    circle(this.pos.x, this.pos.y, this.r);
  }
}
