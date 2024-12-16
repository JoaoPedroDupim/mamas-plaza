class Pong implements Game {
  SoundFile soundtrack;
  SoundFile pongSound;
  
  PImage background;
  
  float ballX, ballY;
  float ballSpeedX, ballSpeedY;
  float ballDiameter = 20;
  
  float leftPaddleY, rightPaddleY;
  float paddleWidth = 20;
  float paddleHeight = 100;
  float paddleSpeed = 5;
  
  boolean pressedUP = false;
  boolean pressedDOWN = false;
  boolean pressedW = false;
  boolean pressedS = false;
  
  int pointsLeft = 0;
  int pointsRight = 0;
  
  float multiplicator = 1.2;
  
  PFont font;
  
  Pong(PApplet applet) {
    this.soundtrack = new SoundFile(applet, "pong/ping_pong.mp3");
    this.pongSound = new SoundFile(applet, "pong/ping_pong_effect.mp3");
    
    this.background = loadImage("pong/pong_background.jpg");
    
    this.ballX = width / 2;
    this.ballY = height / 2;
    this.ballSpeedX = 4;
    this.ballSpeedY = 3;
    
    this.leftPaddleY = height / 2 - this.paddleHeight / 2;
    this.rightPaddleY = height / 2 - this.paddleHeight / 2;
    
    font = loadFont("Pixellari-48.vlw");
  }
  
  void display() {
    if(!startScreenPong.ready) return;
    
    image(this.background, 0, 0, width, height);
    
    if(!this.soundtrack.isPlaying()) {
      this.soundtrack.play();
      this.soundtrack.loop();
      this.soundtrack.amp(0.1);
    }
    
    textFont(this.font, 30);
    textSize(100);
    textAlign(CENTER);
    fill(255, 255, 255, 255 * 0.4);
    text(this.pointsLeft, 400, 300, 0.4);
    text(this.pointsRight, width - 400, 300);
    fill(255);
    
    this.moviment();
    
    ellipse(ballX, ballY, ballDiameter, ballDiameter);
    
    rect(10, this.leftPaddleY, this.paddleWidth, this.paddleHeight);
    rect(width - 30, this.rightPaddleY, this.paddleWidth, this.paddleHeight);
    
    this.ballX += this.ballSpeedX;
    this.ballY += this.ballSpeedY;
    
    if (this.ballY <= 0 || this.ballY >= height) {
      this.ballSpeedY *= -1;
    }
    
    if (this.ballX <= 30 && this.ballY > this.leftPaddleY && this.ballY < this.leftPaddleY + this.paddleHeight) {
      this.pongSound.play();
      this.ballSpeedX *= -1;
      this.ballSpeedX *= this.multiplicator;
      this.ballSpeedY *= this.multiplicator;
    }
    if (this.ballX >= width - 30 && this.ballY > this.rightPaddleY && this.ballY < this.rightPaddleY + this.paddleHeight) {
      this.pongSound.play();
      this.ballSpeedX *= -1;
      this.ballSpeedX *= this.multiplicator;
      this.ballSpeedY *= this.multiplicator;
    }
    
    if (this.ballX < 0) {
      this.ballX = width / 2;
      this.ballY = height / 2;
      this.pointsRight++;
      this.ballSpeedX = 4;
      this.ballSpeedY = 3;
    } else if(this.ballX > width){
      this.ballX = width / 2;
      this.ballY = height / 2;
      this.pointsLeft++;
      this.ballSpeedX = -4;
      this.ballSpeedY = 3;
    }
  }
  
  void moviment() {
    if(!startScreenPong.ready) return;
    if(this.pressedUP && this.rightPaddleY > 0) {
      this.rightPaddleY -= this.paddleSpeed;
    }
    if(this.pressedDOWN && this.rightPaddleY < height - this.paddleHeight) {
      this.rightPaddleY += this.paddleSpeed;
    }
    if(this.pressedW && this.leftPaddleY > 0) {
      this.leftPaddleY -= this.paddleSpeed;
    }
    if(this.pressedS && this.leftPaddleY < height - this.paddleHeight) {
      this.leftPaddleY += this.paddleSpeed;
    }
  }
  
  void keyPressed(int keyCode) {
    if(!startScreenPong.ready) return;
    if (keyCode == UP) {
      this.pressedUP = true;
    }
    if (keyCode == DOWN) {
      this.pressedDOWN = true;
    }
    if (keyCode == 'w' || keyCode == 'W') {
      this.pressedW = true;
    }
    if (keyCode == 's' || keyCode == 'S') {
      this.pressedS = true;
    }
  }
  
  void keyReleased(int keyCode) {
    if(!startScreenPong.ready) return;
    if (keyCode == UP) {
      this.pressedUP = false;
    }
    if (keyCode == DOWN) {
      this.pressedDOWN = false;
    }
    if (keyCode == 'w' || keyCode == 'W') {
      this.pressedW = false;
    }
    if (keyCode == 's' || keyCode == 'S') {
      this.pressedS = false;
    }
  }
}
