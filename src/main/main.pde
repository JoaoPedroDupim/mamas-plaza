import processing.sound.*;
import gifAnimation.*;

Asteroid asteroid;
Pikomon pikomon;
Pong pong;
Frogger frogger;
StartScreen startScreen;
StartScreenAsteroid startScreenAsteroid;
StartScreenPokemon startScreenPokemon;
StartScreenFrogger startScreenFrogger;
StartScreenPong startScreenPong;

void setup() {
  fullScreen();
  background(0);
  asteroid = new Asteroid(this);
  pikomon = new Pikomon(this);
  pong = new Pong(this);
  frogger = new Frogger(this);
  startScreen = new StartScreen(this);
  startScreenAsteroid = new StartScreenAsteroid(this);
  startScreenPokemon = new StartScreenPokemon(this);
  startScreenFrogger = new StartScreenFrogger(this);
  startScreenPong = new StartScreenPong(this);
}

void draw() {
  startScreen.display();
  if(startScreen.ready) {
    switch (startScreen.selected) {
      case 0: {   
        if(!startScreenAsteroid.ready) {
          startScreenAsteroid.display();
        } else {
          asteroid.moviment();
          asteroid.display();
        }
        break;
      }
      case 1: {
        if(!startScreenPokemon.ready) {
          startScreenPokemon.display();
        } else {
          pikomon.moviment();
          pikomon.display();
        }
        break;
      }
      case 2: {
        if(!startScreenFrogger.ready) {
          startScreenFrogger.display();
        } else {
          frogger.moviment();
          frogger.display();
        }
        break;
      }
      case 3: {
        if(!startScreenPong.ready) {
          startScreenPong.display();
        } else {
          pong.moviment();
          pong.display();
        }
        break;
      }
    }
  }
}

void keyPressed() {
  asteroid.keyPressed(keyCode);
  pikomon.keyPressed(keyCode);
  pong.keyPressed(keyCode);
  frogger.keyPressed(keyCode);
  startScreen.keyPressed(keyCode);
  startScreenAsteroid.keyPressed(keyCode);
  startScreenPokemon.keyPressed(keyCode);
  startScreenFrogger.keyPressed(keyCode);
  startScreenPong.keyPressed(keyCode);
}

void keyReleased() {
  asteroid.keyReleased(keyCode);
  pong.keyReleased(keyCode);
  frogger.keyReleased(keyCode);
}
