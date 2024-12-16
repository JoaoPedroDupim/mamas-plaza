class Frogger implements Game {
  PImage background;
  PImage frog;
  PImage carImage;
  PImage truckImage;
  PImage[] logsImage;
  PImage littleFrog;
  PImage turtleImage;
  
  int screenX = width;
  int screenY = height - 90;
  
  SoundFile soundtrack;
  SoundFile effectSound;
  
  int frogX, frogY;
  int direction = 0;
  
  int spriteWidth, spriteHeight;
  int currentFrame = 0;
  int totalFrames = 8;
  int animationSpeed = 10;
  int frameCounter = 0;
  
  int lifes = 3;
  int deaths = 0;
  int score = 0;
  float speed = 1;
  int level = 1;
  
  int startTime = 0;
  int duration = 90000;
  boolean timerEnded = false;
   
  boolean moving = false;
  boolean frogOnLog = false;
  boolean frogOnTurtle = false;
  
  ArrayList<Car> cars;
  int[] carsSpawnY = {this.screenY - 140, this.screenY - 220, this.screenY - 320, this.screenY - 420};
  
  ArrayList<Log> logs;
  int[] logsSpawnY = {100, 200, 250, 300, 400};
  
  ArrayList<Turtle> turtles;
  int[] turtlesSpawnY = {150, 350};
  
  ArrayList<Integer> positions;
  int[] scoredPositions;
  
  int posX = -1;
  int posY = -1;
  
  PFont pixellari;
  
  Frogger(PApplet applet) {
    this.background = loadImage("frogger/frogger_background.png");
    this.frog = loadImage("frogger/frog.png");
    this.carImage = loadImage("frogger/frogger_cars.png");
    this.truckImage = loadImage("frogger/frogger_truck.png");
    this.logsImage = new PImage[3];
    this.littleFrog = loadImage("frogger/frogger_life.png");
    this.turtleImage = loadImage("frogger/frogger_turtle.png");
    
    for(int i = 0; i < 3; i++) {
      this.logsImage[i] = loadImage("frogger/frogger_log" + (i + 1) + ".png"); 
    }
    
    this.soundtrack = new SoundFile(applet, "frogger/frogger_soundtrack.mp3");
    this.effectSound = new SoundFile(applet, "frogger/frogger_death_sound.mp3");
    
    this.spriteWidth = this.frog.width / this.totalFrames;
    this.spriteHeight = this.frog.height;
    
    this.cars = new ArrayList<Car>();
    this.logs = new ArrayList<Log>();
    this.turtles = new ArrayList<Turtle>();
    this.positions = new ArrayList<Integer>();

    this.reset();
    
    this.pixellari = loadFont("Pixellari-48.vlw");
  }
  
  void display() {
    if(!startScreenFrogger.ready) return;
    
    if(!this.soundtrack.isPlaying()) {
      this.soundtrack.loop();
      this.soundtrack.amp(0.05);
      this.startTime = millis();
    }
    
    // mexer
    if(this.lifes == 0) {
      background(0);
      textAlign(LEFT);
      fill(255);
      background(0);
      textAlign(CENTER);
      text("Suas vidas acabaram.", width/2, height/2);
      return;
    }
    
    int elapsedTime = millis() - startTime;
    if(elapsedTime >= duration) {
      if (!timerEnded) {
        timerEnded = true;
      }
      fill(255);
      background(0);
      textAlign(CENTER);
      text("Tempo acabou.", width/2, height/2);
      return;
    }
    
    background(0);
    image(this.background, 0, 0, width, this.screenY);
    
    float barWidth = map(elapsedTime, 0, duration, width - 160, 0);
    stroke(0);
    strokeWeight(2);
    fill(0, 255, 0);
    rect((width - width + 20) / 2, height - 50, barWidth, 40);
    
    fill(#f4f702);
    textFont(pixellari, 30);
    textSize(60);
    textAlign(RIGHT);
    text("TIME", width - 5, height - 5);
    
    fill(255);
    textSize(35);
    text("SCORE: ", width - 5 - (textWidth(nf(this.score, 3))), this.screenY + 30);
    fill(255, 0, 0);
    text(nf(this.score, 3), width - 5, this.screenY + 30);
    
    fill(255);
    textSize(35);
    text("LEVEL: ", width - 5 - (textWidth(this.level + " SCORE: " + nf(this.score, 3))), this.screenY + 30);
    fill(255, 0, 0);
    text(this.level, width - 5 - (textWidth(" SCORE: " + nf(this.score, 3))), this.screenY + 30);
    
    for(int i = 0; i < this.lifes; i++) {
      image(this.littleFrog, 10 + (i * 40), this.screenY, 40, 43);
    }
    
    if (moving) {
      this.frameCounter++;
      int startFrame = this.direction * 2;
      this.currentFrame = startFrame + (this.frameCounter + 1 / this.animationSpeed) % 2; //<>//
    } else {
      this.currentFrame = this.direction * 2; //<>//
    }
    
    this.frogOnTurtle = false; 
    for(Turtle turtle : this.turtles) {
      turtle.display();
      if(turtle.intersects(this.frogX, this.frogY, this.spriteWidth - 10, this.spriteHeight - 10, turtle.x, turtle.y, turtle.spriteWidth, turtle.spriteHeight - 10)) {
        this.frogOnTurtle = true;
      }
    }
    
    this.frogOnLog = false; 
    for(Log log : this.logs) {
      log.update();
      log.display();
      if(log.intersects(this.frogX, this.frogY, this.spriteWidth - 10, this.spriteHeight - 10, log.x, log.y, log.logImage.width, log.logImage.height - 10)) {
        this.frogOnLog = true;
        if(!this.frogOnTurtle) this.frogX += log.speed;
      }
    }
    
    int frameX = this.currentFrame * this.spriteWidth; //<>//
    image(this.frog, this.frogX, this.frogY, this.spriteWidth, this.spriteHeight, frameX, 0, frameX + this.spriteWidth, this.spriteHeight);     //<>//
    
    if (!this.moving){
      this.frameCounter = 0;
    }
    
    for(Car car : this.cars) {
      car.update();
      car.display();
      if(car.intersects(this.frogX, this.frogY, this.spriteWidth, this.spriteHeight - 2, car.x, car.y, car.carImage.width/4 - 15, car.carImage.height - 20)) {
        this.death();
        return;
      }
    }
    
    if(!this.frogOnLog && !this.frogOnTurtle) {
      if(this.frogY >= 60 && this.frogY <= 440) {
        this.death();
        return;
      }
    }
    
    for(int i = 0; i < this.positions.size(); i++) {
      if(this.frogY <= this.positions.get(i)) {
        this.positions.remove(i);
        this.score += 10;
      }
    }
    
    if(this.frogX >= 0 && this.frogY <= 70) {
      this.score += 1000;
      this.lifes = 3;
      this.level++;
      this.speed *= 1.1;
      this.startTime = millis();
      this.effectSound.play();
      this.effectSound.amp(0.3);
      this.reset();
      return;
    }
    
    if (this.frogX < 0) this.frogX = 0;
    if (this.frogX > width - this.spriteWidth) this.frogX = width - this.spriteWidth;
    if (this.frogY < 0) frogY = 0;
    if (this.frogY > this.screenY - this.spriteHeight) this.frogY = this.screenY - this.spriteHeight;
  }
  
  void moviment() {}
  
  void keyPressed(int keyCode) {
    if(!startScreenFrogger.ready) return;
    // Movimenta a rã e muda a direção
    if (keyCode == UP) {
      this.frogY -= 40;
      this.direction = 0;
      this.moving = true;
    } else if (keyCode == DOWN) {
      this.frogY += 40;
      this.direction = 1;
      this.moving = true;
    } else if (keyCode == LEFT) {
      this.frogX -= 40;
      this.direction = 2;
      this.moving = true;
    } else if (keyCode == RIGHT) {
      this.frogX += 40;
      this.direction = 3;
      this.moving = true;
    }
  }
  
  void keyReleased(int keyCode) {
    if(!startScreenFrogger.ready) return;
    if (keyCode == UP) {
      this.moving = false;
    } else if (keyCode == DOWN) {
      this.moving = false;
    } else if (keyCode == LEFT) {
      this.moving = false;
    } else if (keyCode == RIGHT) {
      this.moving = false;
    }
  }
  
  void reset() {
    this.resetFrog();
    this.resetCars();
    this.resetLogs();
    this.resetTurtles();
    this.resetScore();
  }
  
  void resetFrog() {
    this.direction = 0;
    this.frogX = width / 2 - this.spriteWidth/2;
    this.frogY = this.screenY - this.spriteHeight;
  }
  
  void resetCars() {
    this.cars.clear();
    this.createCars((int)random(12, 25));
  }
  
  void createCars(int num) {
    for(int i = 0; i < num; i++) {
      int startX = (int) random(-this.carImage.width, width);
      int startY = (int) this.carsSpawnY[(int)random(this.carsSpawnY.length)];
      int speed = (int) random(10 * this.speed, 20 * this.speed);
      if(startY == this.screenY - 140 || startY == this.screenY - 320) {
        this.cars.add(new Car(this.carImage, this.truckImage, startX, startY, speed, true));
      } else {
        this.cars.add(new Car(this.carImage, this.truckImage, startX, startY, speed, false));
      }
    }
  }
  
  void resetLogs() {
    this.logs.clear();
    this.createLogs(5, 3, 4, 160, 350);
  }
  
  void createLogs(int numLines, int minLogsPerLine, int maxLogsPerLine, int minSpacing, int maxSpacing) {
    for (int i = 0; i < numLines; i++) {
      int logCount = (int) random(minLogsPerLine, maxLogsPerLine + 1);
      int logType = (int) random(this.logsImage.length);
      int yPos = logsSpawnY[i];
      int xOffset = -this.logsImage[logType].width;
      for (int j = 0; j < logCount; j++) {
        xOffset += (int) random(minSpacing, maxSpacing + 1);
        int startX = xOffset;
        int speed = (int) random(3 * this.speed, 7 * this.speed);
        this.logs.add(new Log(this.logsImage[logType], startX, yPos, speed));
        
        xOffset += this.logsImage[logType].width;
      }
      if (xOffset - this.logsImage[logType].width > width) {
        this.logs.add(new Log(this.logsImage[logType], xOffset - this.logsImage[logType].width - width, yPos, (int) random(3, 7)));
      }
    }
  }
  
  void resetTurtles() {
    this.turtles.clear();
    this.createTurtles();
  }
  
  void createTurtles() {
    for (int i = 0; i < this.turtlesSpawnY.length; i++) {
      int groupTurtles = (int)random(2, 4);
      int startY = (int) this.turtlesSpawnY[i];
      int previousEndX = 0;
      for (int j = 0; j < groupTurtles; j++) {
        int turtles = random(0, 1) > 0.5 ? 3 : 2;
        int baseX = previousEndX + (int) random(100, width - 300); 
        for(int k = 0; k < turtles; k++) {
          int startX = baseX + (k * (this.turtleImage.width / 9));
          int speed = (int) random(0 * this.speed, 9 * this.speed);
          this.turtles.add(new Turtle(this.turtleImage, startX, startY, speed));
        }
        previousEndX = baseX + (turtles * (this.turtleImage.width / 9)) + 50; 
      }
    }
  }
  
  void death() {
    this.deaths++;
    this.lifes--;
    this.resetFrog();
  }
  
  void resetScore() {
    this.positions.clear();
    for(int i : carsSpawnY) {
      this.positions.add(i);
    }
    for(int i : logsSpawnY) {
      this.positions.add(i);
    }
  }
}

class Car {
  PImage carImage;
  int x, y;
  int speed;
  boolean toRight;
  
  int spriteWidth, spriteHeight;
  int totalFrames = 4;
  int frameX;
  
  Car(PImage _carImage, PImage _truckImage, int startX, int startY, int _speed, boolean _toRight) {
    this.carImage = _carImage;
    this.x = startX;
    this.y = startY;
    this.speed = _speed;
    this.toRight = _toRight;
    
    this.spriteWidth = _carImage.width / this.totalFrames;
    this.spriteHeight = _carImage.height;
    this.frameX = (int)random(0, 4) * this.spriteWidth - 3;
  }
  
  void update() {
    if(this.toRight) {
      this.x += this.speed;
      if(this.x > width) {
        this.x = -this.spriteWidth;
      }
    } else {
      this.x -= this.speed;
      if(this.x < -this.spriteWidth) {
        this.x = width;
      }
    }
  }
  
  void display() {
    imageMode(CENTER);
    if(this.toRight) {
      image(this.carImage, this.x, this.y, this.spriteWidth, this.spriteHeight, this.frameX, 0, this.frameX + this.spriteWidth, this.spriteHeight);
    } else {
      pushMatrix();
      translate(this.x + this.spriteWidth / 2, this.y);
      scale(-1, 1);
      image(this.carImage, 0, 0, this.spriteWidth, this.spriteHeight, this.frameX, 0, this.frameX + this.spriteWidth, this.spriteHeight);
      popMatrix();
    }
    imageMode(CORNER);
  }
  
  boolean intersects(int x1, int y1, int w1, int h1, int x2, int y2, int w2, int h2) {
    return x1 < x2 + w2 && x1 + w1 > x2 && y1 < y2 + h2 && y1 + h1 > y2;
  }
}

class Log {
  PImage logImage;
  int x, y;
  int speed;
  
  int spriteWidth, spriteHeight;
  
  boolean onLog = false;
  
  Log(PImage _logImage, int _x, int _y, int _speed) {
    this.logImage = _logImage;
    this.x = _x;
    this.y = _y;
    this.speed = _speed;
    
    this.spriteWidth = _logImage.width;
    this.spriteHeight = _logImage.height;
  }
  
  void update() {
    x += speed;
    if(this.x + 10 > width) {
      this.x = -this.logImage.width;
      this.y = frogger.logsSpawnY[(int) random(frogger.logsSpawnY.length)];
    }
  }
  
  void display() {
    image(this.logImage, this.x, this.y);
  }
  
  boolean intersects(int x1, int y1, int w1, int h1, int x2, int y2, int w2, int h2) {
    if (x1 < x2 + w2 && x1 + w1 > x2 && y1 < y2 + h2 && y1 + h1 > y2) {
      this.onLog = true;
      return true;
    }
    this.onLog = false;
    return false;
  }
}

class Turtle {
  PImage turtleImage;
  int x, y;
  
  int spriteWidth, spriteHeight;
  int currentFrame;
  int totalFrames = 9;
  int animationSpeed = 10;
  int frameCounter = 0;
  
  boolean onTurtle = false;
  
  Turtle(PImage _turtleImage, int _x, int _y, int _currentFrame) {
    this.turtleImage = _turtleImage;
    this.x = _x;
    this.y = _y;
    this.currentFrame = _currentFrame;
    
    this.spriteWidth = this.turtleImage.width / this.totalFrames;
    this.spriteHeight = this.turtleImage.height;
  }
  
  void display() {
    int frameX = this.currentFrame * this.spriteWidth;
    image(this.turtleImage, this.x, this.y, this.spriteWidth, this.spriteHeight, frameX, 0, frameX + this.spriteWidth, this.spriteHeight);
    this.frameCounter++;
    if(this.frameCounter >= this.animationSpeed) {
      this.currentFrame = (this.currentFrame + 1) % this.totalFrames;
      this.frameCounter = 0;
    }
  }
  
  boolean intersects(int x1, int y1, int w1, int h1, int x2, int y2, int w2, int h2) {
    if (x1 < x2 + w2 && x1 + w1 > x2 && y1 < y2 + h2 && y1 + h1 > y2) {
      this.onTurtle = true;
      return true;
    }
    this.onTurtle = false;
    return false;
  }
}
