class Asteroid implements Game {
  boolean start;
  boolean startSoundtrack = false;
  
  Gif background;
  Gif ship_base;
  Gif explosionGif;
  
  float x, y;
  float sizeA, sizeB;
  float speed = 25;
  
  SoundFile moviment_sound;
  SoundFile soundtrack;
  SoundFile shotsfire;
  SoundFile explosion_sound;
  
  boolean upPressed = false;
  boolean downPressed = false;
  boolean leftPressed = false;
  boolean rightPressed = false;
  boolean backspacePressed = false;
  boolean rPressed = false;
  
  ArrayList<Bullet> bullets;
  PImage bulletImage;
  long lastShotTime;
  long cooldown = 500;
  
  ArrayList<Meteor> meteors;
  ArrayList<Explosion> explosions;
  PImage meteorImage1, meteorImage2, meteorImage3, meteorImage4;
  long lastMeteorSpawnTime;
  long cooldownMetorSpawn = 3000;
  PImage meteorImages[];
  
  int score;
  int deaths;
  int health;
  PImage health_image;
  boolean isDeathSound;
  boolean statusDeath;
  
  PFont determination;

  Asteroid(PApplet applet) {
    this.start = true;
    
    this.background = new Gif(applet, "asteroid/asteroid_background.gif");
    this.ship_base = new Gif(applet, "asteroid/asteroid_moviment.gif");
    this.explosionGif = new Gif(applet, "asteroid/asteroid_explosao.gif");
    
    this.moviment_sound = new SoundFile(applet, "asteroid/asteroid_som_andar.mp3");
    this.soundtrack = new SoundFile(applet, "asteroid/asteroid_soundtrack.mp3");
    this.shotsfire = new SoundFile(applet, "asteroid/asteroid_tiro.mp3");
    this.explosion_sound = new SoundFile(applet, "asteroid/asteroid_boom.mp3");
    
    this.x = width / 2;
    this.y = height / 2;
    this.sizeA = 50;
    this.sizeB = 100;
    
    this.bullets = new ArrayList<Bullet>();
    this.bulletImage = loadImage("asteroid/asteroid_tiro.png");
    this.lastShotTime = 0;
    
    this.meteors = new ArrayList<Meteor>();
    this.explosions = new ArrayList<Explosion>();
    this.meteorImage1 = loadImage("asteroid/asteroid_pedra1.png");
    this.meteorImage2 = loadImage("asteroid/asteroid_pedra2.png");
    this.meteorImage3 = loadImage("asteroid/asteroid_pedra3.png");
    this.meteorImage4 = loadImage("asteroid/asteroid_pedra4.png");
    this.meteorImages = new PImage[4];
    this.meteorImages[0] = meteorImage1;
    this.meteorImages[1] = meteorImage2;
    this.meteorImages[2] = meteorImage2;
    this.meteorImages[3] = meteorImage3;
    this.lastMeteorSpawnTime = 0;
    
    this.background.play();
    this.ship_base.play();
    this.explosionGif.play();
    
    this.score = 0;
    this.deaths = 0;
    this.health = 5;
    this.health_image = loadImage("asteroid/asteroid_coracao.png");
    this.isDeathSound = false;
    this.statusDeath = false;
    
    this.determination = loadFont("DeterminationSansWeb-48.vlw");
  }

  void moviment() {
    if(!this.start) return;
    
    if(!this.soundtrack.isPlaying()) {
      this.soundtrack.play();
      this.soundtrack.loop();
      this.soundtrack.amp(0.3);
    }
    
    if(this.isDeath()) return;
    
    if (this.upPressed) {
      if ((this.y - this.speed) > 0) {
        this.y -= this.speed;
      } else {
        if(!this.moviment_sound.isPlaying()) this.moviment_sound.play();
      }
    }
    
    if (this.downPressed) {
      if ((this.y + this.speed) < height - 100) {
        this.y += this.speed;
      } else {
        if(!this.moviment_sound.isPlaying()) this.moviment_sound.play();
      }
    }
    
    if (this.leftPressed) {
      if ((this.x - this.speed) > 0) {
        this.x -= this.speed;
      } else {
        if(!this.moviment_sound.isPlaying()) this.moviment_sound.play();
      }
    }
    
    if (this.rightPressed) {
      if ((this.x + this.speed) < width - 60) {
        this.x += this.speed;
      } else {
        if(!this.moviment_sound.isPlaying()) this.moviment_sound.play();
      }
    }
    
    if (this.backspacePressed) {
      this.fire();
    }
    
    for (int i = this.bullets.size() - 1; i >= 0; i--) {
      Bullet b = this.bullets.get(i);
      b.update();
      if (b.y < 0) {
        this.bullets.remove(i);
      }
    }
    
    for (int i = this.meteors.size() - 1; i >= 0; i--) {
      Meteor m = this.meteors.get(i);
      m.update();
      if (m.y > height - 100) {
        this.meteors.remove(i);
        this.health--;
      }
    }
    
    this.checkExplosionMeteor();
  }
  
  void fire() {
    long currentTime = millis();
    if (currentTime - lastShotTime >= cooldown) {
      Bullet newBullet = new Bullet(this.x + this.sizeA / 2 - 10, this.y, this.bulletImage);
      this.bullets.add(newBullet);
      this.shotsfire.play();
      this.shotsfire.amp(0.30);
      lastShotTime = currentTime;
    }
  }
  
  void spawnMeteor() {
    if(this.health == 0) return;
    long currentTime = millis();
    if (currentTime - lastMeteorSpawnTime >= cooldownMetorSpawn) {
      Meteor newMeteor = new Meteor(random(0, width -  100), 0,this.getRandomImage());
      this.meteors.add(newMeteor);
      lastMeteorSpawnTime = currentTime;
    }
  }
  
  PImage getRandomImage() {
    return meteorImages[(int)random(meteorImages.length)];
  }
  
  void checkExplosionMeteor() {
    for (int i = bullets.size() - 1; i >= 0; i--) {
      Bullet b = bullets.get(i);
      for (int j = meteors.size() - 1; j >= 0; j--) {
        Meteor m = meteors.get(j);
        if (b.intersects(m)) {
          this.explosion_sound.play();
          this.explosion_sound.amp(0.2);
          this.score++;
          explosions.add(new Explosion(m.x, m.y, m.size, this.explosionGif));
          meteors.remove(j); 
          bullets.remove(i);
          break;
        }
      }
    }
  }
  
  void keyPressed(int keyCode) {
    if (keyCode == UP) {
      upPressed = true;
    }
    if (keyCode == DOWN) {
      downPressed = true;
    }
    if (keyCode == LEFT) {
      leftPressed = true;
    }
    if (keyCode == RIGHT) {
      rightPressed = true;
    }
    if (keyCode == ' ') {
      backspacePressed = true;
    }
    if (keyCode == 'R' || keyCode == 'r') {
      rPressed = true;
    }
  }
  
  void keyReleased(int keyCode) {
    if (keyCode == UP) {
      upPressed = false;
    }
    if (keyCode == DOWN) {
      downPressed = false;
    }
    if (keyCode == LEFT) {
      leftPressed = false;
    }
    if (keyCode == RIGHT) {
      rightPressed = false;
    }
    if (keyCode == ' ') {
      backspacePressed = false;
    }
    if (keyCode == 'R' || keyCode == 'r') {
      rPressed = false;
    }
  }
  
  void display() {
    if(!this.start) return;
    
    image(this.background, 0, 0, width, height);
    for (int i = explosions.size() - 1; i >= 0; i--) {
      Explosion e = this.explosions.get(i);
      e.update();
      e.display();
      if (e.isFinished()) {
        explosions.remove(i);
      }
    }
    if(this.isDeath()) return;
    this.spawnMeteor();
    image(this.ship_base, this.x, this.y, this.sizeA, this.sizeB);
    for (Bullet b : bullets) {
      b.display();
    }
    for (Meteor m : meteors) {
      m.display();
    }
    textFont(determination, 30);
    textSize(30);
    textAlign(RIGHT);
    text("Pontuação: " + this.score + "\nMortes: " + this.deaths, width - 30, 45);
    for (int i = 0; i < this.health; i++) {
      image(this.health_image, 20 + (i * 35), 20, 30, 30);
    }
  }
  
  void reset() {
    this.deaths++;
    this.health = 5;
    this.score = 0;
    this.isDeathSound = false;
    this.meteors.clear();
    this.explosions.clear();
    this.x = width / 2;
    this.y = height / 2;
    this.sizeA = 50;
    this.sizeB = 100;
    this.statusDeath = false;
  }
  
  void setup() {
    this.reset();
    this.deaths = 0;
  }
  
  boolean isDeath() {
    if(this.health == 0) {
      if(!this.statusDeath) {
        this.explosions.add(new Explosion(this.x - 50, this.y, 150, this.explosionGif));
        this.explosion_sound.play();
        this.explosion_sound.amp(0.5);
        this.statusDeath = true;
      }
     
      if(this.explosion_sound.isPlaying()) return true;
      
      textFont(this.determination, 30);
      textSize(55);
      textAlign(CENTER);
      text("Você perdeu!\n\nAperte R para recomeçar.", width/2, height/2 - 50);
      if(this.rPressed) {
        if(this.health == 0) {
          this.reset();
        }
      }
      return true;
    }
    return false;
  }
}

class Bullet {
  float x, y;
  float speed;
  float size;
  PImage img;
  
  Bullet(float x, float y, PImage img) {
    this.x = x;
    this.y = y;
    this.speed = 30;
    this.size = 20;
    this.img = img;
  }
  
  void update() {
    this.y -= this.speed;
  }
  
  void display() {
    image(this.img, this.x, this.y, this.size, this.size);
  }
  
  boolean intersects(Meteor m) {
    float distance = dist(this.x, this.y, m.x, m.y);
    return distance < (this.size / 2 + m.size / 2);
  }
}

class Meteor {
  float x, y;
  float speed;
  float size;
  PImage img;
  
  Meteor(float x, float y, PImage img) {
    this.x = x;
    this.y = y;
    this.speed = random(5, 15);
    this.size = random(50, 70);
    this.img = img;
  }
  
  void update() {
    this.y += this.speed;
  }
  
  void display() {
    image(this.img, this.x, this.y, this.size, this.size);
  }
}

class Explosion {
  float x, y;
  Gif gif;
  long startTime;
  long duration = 1000;
  float size;
  
  Explosion(float x, float y, float size, Gif gif) {
    this.x = x;
    this.y = y;
    this.gif = gif;
    this.size = size + 5;
    this.startTime = millis();
  }
  
  void update() {
    this.gif.updatePixels();
  }
  
  void display() {
    image(gif, this.x, this.y, this.size, this.size);
  }
  
  boolean isFinished() {
    return millis() - startTime > duration;
  }
}
