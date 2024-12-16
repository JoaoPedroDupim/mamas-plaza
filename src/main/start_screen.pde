class StartScreen implements Screen {
  boolean ready = false;
  
  Gif icon;
  PImage background;
  
  PImage[][] capas;
  int selected = 0;
  
  SoundFile coin_sound;
  SoundFile soundtrack;
  SoundFile select_sound;
  SoundFile confirm_sound;
  
  boolean tick = true;
  int tickSpeed = 10;
  int tickAlpha = 255;
  
  boolean backspacePressed = false;
  
  PFont determination;
  
  StartScreen(PApplet applet) {
    this.icon = new Gif(applet, "mamas_plaza_icon.gif");
    
    this.coin_sound = new SoundFile(applet, "insert_coin.mp3");
    this.soundtrack = new SoundFile(applet, "Jeremy Blake - Powerup!.mp3");
    this.select_sound = new SoundFile(applet, "selected_sound.mp3");
    this.confirm_sound = new SoundFile(applet, "asteroid/asteroid_confirm_sound.mp3");
    
    this.icon.play();
    
    this.background = loadImage("vaporwave4.jpg");
    
    this.capas = new PImage[4][2];
    this.capas[0][0] = loadImage("asteroid/asteroid_mini.png");
    this.capas[1][0] = loadImage("pikomon/pikomon_mini.jpg");
    this.capas[2][0] = loadImage("frogger/frogger_mini_black.jpg");
    this.capas[3][0] = loadImage("pong/pong_mini_black.jpg");
    this.capas[0][1] = loadImage("asteroid/asteroid_s_mini.png");
    this.capas[1][1] = loadImage("pikomon/pikomon_s_mini.jpg");
    this.capas[2][1] = loadImage("frogger/frogger_mini_white.jpg");
    this.capas[3][1] = loadImage("pong/pong_mini_white.jpg");
    
    this.soundtrack.play();
    this.soundtrack.amp(0.3);
    
    this.determination = loadFont("DeterminationSansWeb-48.vlw");
  }
  
  void display() {
    if(this.ready) return;
    
    image(this.background, 0, 0, width, height);
    
    if(backspacePressed) {
      image(this.icon, width/2 - (700)/2, -100, 700, 400);
      float imageWidth = 300, imageHeight = 300, padding = 100;
      float startX = width / 2 - (2 * imageWidth + padding) / 2;
      float startY = height / 2 - (2 * imageHeight + padding) / 2;
      
      for (int i = 0; i < 4; i++) {
        int row = i / 2;
        int col = i % 2;
        float x = startX + col * (imageWidth + padding);
        float y = startY + row * (imageHeight + padding);
        if(this.selected == i) {
          image(this.capas[i][1], x, y, imageWidth, imageHeight);
        } else {
          image(this.capas[i][0], x, y, imageWidth, imageHeight);
        }
      }
      return;
    }
    
    image(this.icon, width/2 - (700)/2, 100, 700, 400);

    fill(255, 255, 255, this.tickAlpha);
    textFont(this.determination, 30);
    textSize(45);
    textAlign(CENTER);
    text("INSIRA UMA MOEDA PARA COMEÇAR", width/2, height - 100);
    fill(255, 255, 255, 255);
    
    this.tickUpdate();
  }
  
  void tickUpdate() {
    if(this.ready) return;
    if(this.tick) {
      this.tickAlpha += this.tickSpeed;
      if(this.tickAlpha >= 400) {
        this.tick = false;
      }
    } else {
      this.tickAlpha -= this.tickSpeed;
      if (this.tickAlpha <= 0) {
        this.tick = true;
      }
    }
  }
  
  void keyPressed(int keyCode) {
    if(this.ready) return;
    if (keyCode == ' ') {
      if (!backspacePressed) {
        backspacePressed = true;
        this.coin_sound.play();
        this.coin_sound.amp(0.5);
      }
    }
    if(backspacePressed) {
      if (keyCode == LEFT) {
        if(!this.select_sound.isPlaying()) {
          this.select_sound.play();
          this.select_sound.amp(0.3);
        }
        if(this.selected <= 3 && this.selected > 0) {
          this.selected--;
        } else {
          this.selected = 3;
        }
      }
      if (keyCode == RIGHT) {
        if(!this.select_sound.isPlaying()) {
          this.select_sound.play();
          this.select_sound.amp(0.3);
        }
        if(this.selected >= 0 && this.selected < 3) {
          this.selected++;
        } else {
          this.selected = 0;
        }
      }
      if (keyCode == 'Z' || keyCode == 'z') {
        if(!this.confirm_sound.isPlaying()) {
          this.soundtrack.stop();
          this.confirm_sound.play();
          this.confirm_sound.amp(0.3);
          this.ready = true;
        }
      }
    }
  }
}

class StartScreenAsteroid implements Screen {
  boolean ready = false;
  
  SoundFile soundtrack;
  SoundFile confirm_sound;
  
  PImage background;
  
  float fadeSpeed = 1.5;
  int alpha = 0;
  boolean fadeingIn = true;
  
  boolean backspacePressed = false;
  
  boolean tick = true;
  int tickSpeed = 5;
  int tickAlpha = 255;
  
  PFont determination;

  StartScreenAsteroid(PApplet applet) {
    this.soundtrack = new SoundFile(applet, "asteroid/asteroid_soundtrack.mp3");
    this.confirm_sound = new SoundFile(applet, "asteroid/asteroid_confirm_sound.mp3");
    
    this.background = loadImage("asteroid/asteroid_tela_inicial.jpg");
    
    this.determination = loadFont("DeterminationSansWeb-48.vlw");
  }
  
  void display() {
    if(this.ready) return;
    
    if(!fadeingIn) {
      if(!this.soundtrack.isPlaying()) {
        this.soundtrack.play();
        this.soundtrack.amp(0.3);
        this.soundtrack.loop();
      }
      image(this.background, 0, 0, width, height);
      
      fill(255, 255, 255, this.tickAlpha);
      textFont(this.determination, 30);
      textSize(55);
      textAlign(CENTER);
      text("Pressione ESPAÇO\npara iniciar a jornada!", width/2, height/2 + 100);
      fill(255, 255, 255, 255);
      
      this.tickUpdate();
      return;
    }
    
    background(0);
    fill(255, 255, 255, alpha);
    textFont(this.determination, 30);
    textSize(70);
    textAlign(CENTER);
    text("- FABIN E DUPAS -", width/2, height/2 - 50);
    textSize(55);
    text("APRESENTA", width/2, height/2 + 10);
    fill(255, 255, 255, 255);
    
    this.textUpdate();
  }
  
  void textUpdate() {
    if(ready) return;
    if(this.fadeingIn) {
      this.alpha += this.fadeSpeed;
      if(this.alpha >= 400) {
        this.fadeingIn = false;
      }
    } else {
      this.alpha -= fadeSpeed;
      if (this.alpha <= 0) {
        this.fadeingIn = true;
        //this.ready = true;
      }
    }
  }
  
  void tickUpdate() {
    if(this.ready) return;
    if(this.tick) {
      this.tickAlpha += this.tickSpeed;
      if(this.tickAlpha >= 400) {
        this.tick = false;
      }
    } else {
      this.tickAlpha -= this.tickSpeed;
      if (this.tickAlpha <= 0) {
        this.tick = true;
      }
    }
  }
  
  void keyPressed(int keyCode) {
    if(this.ready) return;
    if(fadeingIn) return;
    if (keyCode == ' ') {
      if (!this.backspacePressed) {
        this.backspacePressed = true;
        this.confirm_sound.play();
        this.confirm_sound.amp(0.3);
        this.ready = true;
        this.soundtrack.stop();
        asteroid.setup();
      }
    }
  }
}

class StartScreenPokemon implements Screen {
  boolean ready = false;
  
  boolean backspacePressed = false;
  
  PImage background;
  
  SoundFile soundtrack;
  SoundFile confirm_sound;
  
  float fadeSpeed = 2;
  int alpha = 0;
  boolean fadeingIn = true;
  
  boolean tick = true;
  int tickSpeed = 5;
  int tickAlpha = 255;
  
  PFont determination;
   
  StartScreenPokemon(PApplet applet) {
    this.soundtrack = new SoundFile(applet, "pikomon/pikomon_title_soundtrack.mp3");
    this.confirm_sound = new SoundFile(applet, "pikomon/pikomon_click.mp3");
    
    this.background = loadImage("pikomon/pikomon_screen.jpg");
    
    this.determination = loadFont("DeterminationSansWeb-48.vlw");
  }
  
  void display() {  
    if(this.ready) return;
    
    if(!fadeingIn){
      if(!this.soundtrack.isPlaying()) {
        this.soundtrack.play();
        this.soundtrack.amp(0.1);
        this.soundtrack.loop();
      }
      image(this.background, 0, 0, width, height);
      
      fill(255, 255, 255, this.tickAlpha);
      textFont(this.determination, 30);
      textSize(55);
      textAlign(CENTER);
      text("Pressione ESPAÇO\npara iniciar a jornada!", width/2, height/2 + 100);
      fill(255, 255, 255, 255);
      this.tickUpdate();
      
      return;
    }
    
    background(0);
    fill(255, 255, 255, alpha);
    textFont(this.determination, 30);
    textSize(50);
    textAlign(LEFT, CENTER);
    String text = "© 2024 - 2024 PIKOMON\n© 2011 - 2024 MIMTENDO\n© 2011 - 2024 CRIATURAS INC.\n© 2011 - 2024 JOGO_MANIACO INC.";
    text(text, width/2 - textWidth(text)/2, height/2 - 50);
    fill(255, 255, 255, 255);
    
    fill(255, 255, 255, alpha);
    textAlign(CENTER);
    text("- FABIN E DUPAS -", width/2, height - 200);
    textSize(40);
    text("APRESENTA", width/2, height - 150);
    
    fill(255, 255, 255, 255);
    
    this.textUpdate();
  }
  
  void textUpdate() {
    if(ready) return;
    if(this.fadeingIn) {
      this.alpha += this.fadeSpeed;
      if(this.alpha >= 400) {
        this.fadeingIn = false;
      }
    } else {
      this.alpha -= fadeSpeed;
      if (this.alpha <= 0) {
        this.fadeingIn = true;
        //this.ready = true;
      }
    }
  }
  
  void tickUpdate() {
    if(this.ready) return;
    if(this.tick) {
      this.tickAlpha += this.tickSpeed;
      if(this.tickAlpha >= 400) {
        this.tick = false;
      }
    } else {
      this.tickAlpha -= this.tickSpeed;
      if (this.tickAlpha <= 0) {
        this.tick = true;
      }
    }
  }
  
  void keyPressed(int keyCode) {
    if(this.ready) return;
    if(fadeingIn) return;
    if (keyCode == ' ') {
      if (!this.backspacePressed) {
        this.backspacePressed = true;
        this.confirm_sound.play();
        this.confirm_sound.amp(0.3);
        this.ready = true;
        this.soundtrack.stop();
      }
    }
  }
}

class StartScreenFrogger implements Screen {
  boolean ready = false;
  
  boolean backspacePressed = false;
  
  PImage background;
  
  SoundFile soundtrack;
  SoundFile confirm_sound;
  
  float fadeSpeed = 2;
  int alpha = 0;
  boolean fadeingIn = true;
  
  boolean tick = true;
  int tickSpeed = 5;
  int tickAlpha = 255;
  
  PFont font;
   
  StartScreenFrogger(PApplet applet) {
    this.soundtrack = new SoundFile(applet, "frogger/frogger_soundtrack.mp3");
    this.confirm_sound = new SoundFile(applet, "frogger/frogger_death_sound.mp3");
    
    this.background = loadImage("frogger/frogguer_title.jpg");
    
    this.font = loadFont("Pixellari-48.vlw");
  }
  
  void display() {  
    if(this.ready) return;
    
    if(!fadeingIn){
      if(!this.soundtrack.isPlaying()) {
        this.soundtrack.loop();
        this.soundtrack.amp(0.2);
      }
      image(this.background, 0, 0, width, height);
      
      fill(255, 255, 255, this.tickAlpha);
      textFont(this.font, 30);
      textSize(55);
      textAlign(CENTER);
      text("Pressione ESPAÇO\npara jogar!", width/2, height/2 + 100);
      fill(255, 255, 255, 255);
      this.tickUpdate();
      
      return;
    }
    
    background(0);
    fill(255, 255, 255, alpha);
    textSize(50);
    textAlign(LEFT, CENTER);
    String text = "© 2024 - 2024 FROGGER\n© 2011 - 2024 KOMANI";
    text(text, width/2 - textWidth(text)/2, height/2 - 50);
    fill(255, 255, 255, 255);
    
    fill(255, 255, 255, alpha);
    textAlign(CENTER);
    text("- FABIN E DUPAS -", width/2, height - 200);
    textSize(40);
    text("APRESENTA", width/2, height - 150);
    
    fill(255, 255, 255, 255);
    
    this.textUpdate();
  }
  
  void textUpdate() {
    if(ready) return;
    if(this.fadeingIn) {
      this.alpha += this.fadeSpeed;
      if(this.alpha >= 400) {
        this.fadeingIn = false;
      }
    } else {
      this.alpha -= fadeSpeed;
      if (this.alpha <= 0) {
        this.fadeingIn = true;
        //this.ready = true;
      }
    }
  }
  
  void tickUpdate() {
    if(this.ready) return;
    if(this.tick) {
      this.tickAlpha += this.tickSpeed;
      if(this.tickAlpha >= 400) {
        this.tick = false;
      }
    } else {
      this.tickAlpha -= this.tickSpeed;
      if (this.tickAlpha <= 0) {
        this.tick = true;
      }
    }
  }
  
  void keyPressed(int keyCode) {
    if(this.ready) return;
    if(fadeingIn) return;
    if (keyCode == ' ') {
      if (!this.backspacePressed) {
        this.backspacePressed = true;
        this.confirm_sound.play();
        this.confirm_sound.amp(0.3);
        this.ready = true;
        this.soundtrack.stop();
      }
    }
  }
}

class StartScreenPong implements Screen {
  boolean ready = false;
  
  boolean backspacePressed = false;
  
  PImage background;
  
  SoundFile soundtrack;
  SoundFile confirm_sound;
  
  float fadeSpeed = 2;
  int alpha = 0;
  boolean fadeingIn = true;
  
  boolean tick = true;
  int tickSpeed = 5;
  int tickAlpha = 255;
  
  PFont font;
   
  StartScreenPong(PApplet applet) {
    this.soundtrack = new SoundFile(applet, "frogger/frogger_soundtrack.mp3");
    this.confirm_sound = new SoundFile(applet, "frogger/frogger_death_sound.mp3");
    
    this.background = loadImage("pong/pong_title.jpg");
    
    this.font = loadFont("Pixellari-48.vlw");
  }
  
  void display() {  
    if(this.ready) return;
    
    if(!fadeingIn){
      if(!this.soundtrack.isPlaying()) {
        this.soundtrack.loop();
        this.soundtrack.amp(0.2);
      }
      image(this.background, 0, 0, width, height);
      
      fill(255, 255, 255, this.tickAlpha);
      textFont(this.font, 30);
      textSize(55);
      textAlign(CENTER);
      text("Pressione ESPAÇO\npara jogar!", width/2, height/2 + 100);
      fill(255, 255, 255, 255);
      this.tickUpdate();
      
      return;
    }
    
    background(0);
    fill(255, 255, 255, alpha);
    textSize(50);
    textAlign(LEFT, CENTER);
    String text = "© 2024 - 2024 PING-PONG\n© 2011 - 2024 ATARO";
    text(text, width/2 - textWidth(text)/2, height/2 - 50);
    fill(255, 255, 255, 255);
    
    fill(255, 255, 255, alpha);
    textAlign(CENTER);
    text("- FABIN E DUPAS -", width/2, height - 200);
    textSize(40);
    text("APRESENTA", width/2, height - 150);
    
    fill(255, 255, 255, 255);
    
    this.textUpdate();
  }
  
  void textUpdate() {
    if(ready) return;
    if(this.fadeingIn) {
      this.alpha += this.fadeSpeed;
      if(this.alpha >= 400) {
        this.fadeingIn = false;
      }
    } else {
      this.alpha -= fadeSpeed;
      if (this.alpha <= 0) {
        this.fadeingIn = true;
        //this.ready = true;
      }
    }
  }
  
  void tickUpdate() {
    if(this.ready) return;
    if(this.tick) {
      this.tickAlpha += this.tickSpeed;
      if(this.tickAlpha >= 400) {
        this.tick = false;
      }
    } else {
      this.tickAlpha -= this.tickSpeed;
      if (this.tickAlpha <= 0) {
        this.tick = true;
      }
    }
  }
  
  void keyPressed(int keyCode) {
    if(this.ready) return;
    if(fadeingIn) return;
    if (keyCode == ' ') {
      if (!this.backspacePressed) {
        this.backspacePressed = true;
        this.confirm_sound.play();
        this.confirm_sound.amp(0.3);
        this.ready = true;
        this.soundtrack.stop();
      }
    }
  }
}
