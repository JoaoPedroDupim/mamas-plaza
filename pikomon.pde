class Pikomon implements Game {  
  ArrayList<PokemonInfo> pokemonList;
  
  int selected = 0;
  
  SoundFile confirm_sound;
  
  PImage background;
  
  Pikomon(PApplet applet) {
    this.pokemonList = new PokeAPIv2().pokemonList;
    
    this.background = loadImage("pikomon/pikomon_pokedex.jpg");
    
    this.confirm_sound = new SoundFile(applet, "pikomon/pikomon_click.mp3");
  }
  
  void display() {
    imageMode(CORNER);
    image(this.background, 0, 0, width, height);
    
    if(this.pokemonList.size() == 0) {
      return;
    }
    
    imageMode(CENTER);
    image(this.pokemonList.get(selected).image, width/2, height/2, 400, 400);
    
    textAlign(CENTER);
    textSize(60);
    text(capitalizeFirstLetter(this.pokemonList.get(selected).name), width/2, height - 55);
    
    textSize(50);
    textAlign(LEFT);
    text("* Vida: " + this.pokemonList.get(selected).stats[0], 300, height/4);
    text("* Ataque: " + this.pokemonList.get(selected).stats[1], 300, height/4 + 50 * 1);
    text("* Ataque Especial: " + this.pokemonList.get(selected).stats[2], 300, height/4 + 50 * 2);
    text("* Defesa: " + this.pokemonList.get(selected).stats[3], width - 750, height/4);
    text("* Defesa Especial: " + this.pokemonList.get(selected).stats[4], width - 750, height/4  + 50 * 1);
    text("* Velocidade: " + this.pokemonList.get(selected).stats[5], width - 750, height/4  + 50 * 2);
    
    textAlign(CENTER);
    text("N° " + (int)(selected + 1), width/2, height/4);
  }
  
  void moviment() {}
  
  void keyPressed(int keyCode) {
    if(!startScreenPokemon.ready) return;
    if(this.pokemonList.size() <= 1) return;
    if(keyCode == RIGHT) {
      this.confirm_sound.play();
      this.confirm_sound.amp(0.3);
      if(this.selected + 1 > this.pokemonList.size() - 1) {
        this.selected = 0;
      } else {
        this.selected++;
      }
    }
    if(keyCode == LEFT) {
      this.confirm_sound.play();
      this.confirm_sound.amp(0.3);
      if(this.selected - 1 < 0) {
        this.selected = this.pokemonList.size() - 1;
      } else {
        this.selected--;
      }
    }
  }
}

class PokeAPIv2 {
  ArrayList<PokemonInfo> pokemonList = new ArrayList<PokemonInfo>();
  
  PokeAPIv2() {
    JSONArray jsonArray = loadJSONArray("pikomon/pokemons.json");
    for(int i = 0; i < jsonArray.size(); i++) {
      JSONObject json = jsonArray.getJSONObject(i);
      String name = json.getString("name");
      String[] types = json.getStringList("types").toArray();
      int[] stats = json.getJSONArray("stats").toIntArray();
      String imageUrl = json.getString("image");
      pokemonList.add(new PokemonInfo(name, types, stats, loadImage(imageUrl)));
    }
  }
}

class PokemonInfo {
  String name;
  String[] types;
  int[] stats;
  PImage image;
  
  PokemonInfo(String name, String[] types, int[] stats, PImage image) {
    this.name = name;
    this.types = types;
    this.stats = stats;
    this.image = image;
  }
}

String capitalizeFirstLetter(String input) {
  if (input == null || input.isEmpty()) {
    return input;
  }
  
  String firstLetter = input.substring(0, 1).toUpperCase();
  String restOfString = input.substring(1);
  
  return firstLetter + restOfString;
}
