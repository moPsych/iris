
// array list for iris frames
ArrayList <PImage> irisFrames = new ArrayList<PImage>();

// keyframes of the animation
int startFrame = 120;
int irisFrameCount = 150;
int dotsStartFrame = 240;
int eyeLidStartFrame = startFrame + irisFrameCount + 495;
int dotsEndFrame = eyeLidStartFrame + 968;
int eyeLidCloseFrame = dotsEndFrame + 300;

// the iris size and parameters
float irisMaxRadius = 450;
float irisMidRadius = 275;
float irisMinRadius = 100;
int irisOffset = 30;
int irisRnd = 40;
int bezierRnd = 10;

// dots parameters
int dotsNum = 30;
Dot dots[] = new Dot[dotsNum];
int dotsOpc = 0;

float eye = PI / -2;

void setup() {
  size(1920, 1080);
  generateIris();
  generateDots();
}

void draw() {
  background(0, 0, 0);
  renderIris();
  renderDots();
  renderEyeLids();
  //saveAnimation();
}

void renderEyeLids() {
  // renders the bezier curves for the eyelid
  if (frameCount > eyeLidStartFrame) {
    float h = map(sin(eye), -1, 1, -height / 15, height / 2);

    noStroke();
    fill(0);

    beginShape();
    vertex(0, 0);
    vertex(width * 0.1, height / 2);
    bezierVertex(width * 0.4, h, width * 0.6, h, width * 0.9, height / 2);
    vertex(width, 0);
    endShape(CLOSE);

    beginShape();
    vertex(0, height);
    vertex(width * 0.1, height / 2);
    bezierVertex(width * 0.4, height - h, width * 0.6, height - h, width * 0.9, height / 2);
    vertex(width, height);
    endShape(CLOSE);

    stroke(0, 8, 8);
    noFill();
    if (frameCount > eyeLidStartFrame && frameCount < eyeLidStartFrame + 560) {
      if ((eye % TWO_PI) >= radians(90) && (eye % TWO_PI) <= radians(92)) {
        eye += radians(0.01);
      } else {
        eye += radians(1);
      }
    } else if (frameCount >= eyeLidStartFrame + 650 && frameCount < eyeLidStartFrame + 686) {
      eye += radians(10);
    } else if (frameCount >= eyeLidStartFrame + 950 && frameCount < eyeLidStartFrame + 986) {
      eye += radians(10);
    } else if (frameCount >= eyeLidCloseFrame && eye % TWO_PI <= radians(90)) {
      eye += radians(1);
    } else {
      if (frameCount <= eyeLidCloseFrame) {
        eye = -PI/2;
      }
    }
  }
}

void generateIris() {
  // generates PGraphics frames for the iris animation and pushes them to the array list
  int count = 1;
  for (float n = 0; n <= 1; n += 1.0 / irisFrameCount) {
    PGraphics g = createGraphics(width, height);
    g.beginDraw();
    g.background(0, 0, 0);
    g.colorMode(HSB, 255, 255, 255, 255);
    g.noFill();
    for (float a = 0; a < TWO_PI + 0; a += 0.002) {
      int num = floor(random(irisMinRadius, irisMinRadius + irisOffset));
      float col = map(noise(width / 2 + num * cos(a), height / 2 + num * sin(a)), 0, 1, 50, 250);

      float l1x1 = width / 2 + (irisMidRadius + random(-irisRnd, irisRnd)) * cos(a);
      float l1y1 = height / 2 + (irisMidRadius + random(-irisRnd, irisRnd)) * sin(a);
      float l1x2 = width / 2 + irisMaxRadius * cos(a);
      float l1y2 = height / 2 + irisMaxRadius * sin(a);
      float l1h1x = ((l1x1 + l1x2) / 2) + random(-bezierRnd, bezierRnd);
      float l1h1y = ((l1y1 + l1y2) / 2) + random(-bezierRnd, bezierRnd);
      float l1h2x = ((l1x1 + l1x2) / 2) + random(-bezierRnd, bezierRnd);
      float l1h2y = ((l1y1 + l1y2) / 2) + random(-bezierRnd, bezierRnd);

      float l2x1 = width / 2 + num * cos(a + 0.001);
      float l2y1 = height / 2 + num * sin(a + 0.001);
      float l2x2 = width / 2 + (irisMidRadius + random(-irisRnd, irisRnd)) * cos(a + 0.001);
      float l2y2 = height / 2 + (irisMidRadius + random(-irisRnd, irisRnd)) * sin(a + 0.001);
      float l2h1x = ((l2x1 + l2x2) / 2) + random(-bezierRnd, bezierRnd);
      float l2h1y = ((l2y1 + l2y2) / 2) + random(-bezierRnd, bezierRnd);
      float l2h2x = ((l2x1 + l2x2) / 2) + random(-bezierRnd, bezierRnd);
      float l2h2y = ((l2y1 + l2y2) / 2) + random(-bezierRnd, bezierRnd);

      g.stroke(140, 255, col, 100);
      g.bezier(l1x1, l1y1, l1h1x, l1h1y, l1h2x, l1h2y, l1x2, l1y2);
      g.stroke(20, 255, col, 80);
      g.bezier(l2x1, l2y1, l2h1x, l2h1y, l2h2x, l2h2y, l2x2, l2y2);
    }
    g.noFill();
    g.stroke(130, 255, 150, 2);
    g.strokeWeight(3);
    for (int i = 0; i < 40; i++) {
      g.circle(width / 2 + random(-2, 2), height / 2 + random(-2, 2), irisMaxRadius * 2);
    }
    g.noStroke();
    g.fill(255, 20);
    g.endDraw();
    PImage img = createImage(width, height, ARGB);
    img.copy(g, 0, 0, width, height, 0, 0, width, height);
    irisFrames.add(img);
    println("Finished " + count + " frame(s)");
    count++;
    irisMinRadius = lerp(100, 200, n);
    irisMidRadius = irisMinRadius + (irisMaxRadius - irisMinRadius) / 2;
  }
}

void renderIris() {
  // renders each frame of the iris corrisponding to its position in the array list
  if (frameCount >= startFrame && frameCount < startFrame + irisFrameCount) {
    image(irisFrames.get(frameCount - startFrame), 0, 0);
  } else if (frameCount < startFrame) {
    image(irisFrames.get(0), 0, 0);
  } else if (frameCount >=  startFrame + irisFrameCount) {
    image(irisFrames.get(irisFrameCount - 1), 0, 0);
  }
}

void generateDots() {
  // populates the dots array
  for (int i = 0; i < dotsNum; i++) {
    dots[i] = new Dot();
  }
}

void renderDots() {
  // renders the dots and controls their transparency
  if (frameCount >= dotsStartFrame && frameCount < dotsEndFrame + 255) {
    if (dotsOpc < 255 && frameCount < dotsEndFrame) {
      dotsOpc++;
    } else {
      dotsOpc--;
    }
    for (int i = 0; i < dotsNum; i++) {
      dots[i].update(dotsOpc);
      for (int j = 0; j < dotsNum; j++) {
        if (j != i) {
          dots[i].check(dots[j]);
        }
      }
      dots[i].render();
    }
  }
}

void saveAnimation() {
  // saves the animation as jpeg frames
  if (frameCount <= eyeLidCloseFrame + 200) saveFrame("/out/" + frameCount + ".jpeg");
  if (frameCount == eyeLidCloseFrame + 201) println("Finished Saving Frames");
}
