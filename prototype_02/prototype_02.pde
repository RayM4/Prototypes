ArrayList<Entity> stuff;
ArrayList<Bomb> bombs;
int score;
int lives;
int timer;
int size;
int NUM_OF_BOMBS;

void setup() {
  size(800, 800);
  stuff = new ArrayList();
  bombs = new ArrayList();
  
  score = 0;
  lives = 3;
  size = 80;
  NUM_OF_BOMBS = 2;
}

void draw() {
  background ( 11, 83, 131 );
  fill (0, 0, 0);
  textSize(30);
  text("Score: " + score, 10 , 50);
  text("Lives: " + lives, 10, 80);
  fill(212, 11, 11); 
  //goals?
  rect(250, height-50, 300, height);
  rect(250, 0, 300, 50);
  
  rect(0, 250, 50, 300);
  rect(width-50, 250, width, 300);
  fill (32, 255, 20);
  
  if (lives > -1) {
    timer += 1;
    if( timer % 100 == 0 ) {
      stuff.add(new Entity());
      //maybe add more generation if timer is longer
    }
  } else {
    textSize(50);
    fill(255, 255, 255);
    text("You Lose!", 300, 400);
    fill (32, 255, 20);
  }
  
  for( Entity a : stuff ){
    a.updateAndRender();
   }
    
  for (Bomb b : bombs) {
    b.update();
  }
}

class Entity {
  float x;
  float y;
  boolean live;
  int lifespan;
  
  Entity() {
    //figure out what you want first
    //x = 80 * int(random(10));
    //y = 60 * int(random(10));
    x = 8 * int(random(15, 85));
    y = 6 * int(random(15, 85));
    live = true;
    lifespan = int(random(100));
  }
  
  void updateAndRender() {
    if (live) {
      lifespan -= 1;
      display();
      if (lifespan < 1) {
        explode();
      }
    }
    
  }
  
  //display and stuff
  void display() {
      //rect(x,y,60,60);
      ellipse(x,y,size,size);
    
  }
  
  void explode() {
    if (live) {
      live = false;
      for (int i = 0; i < NUM_OF_BOMBS; i++) {
        Bomb temp = new Bomb(x, y);
        bombs.add(temp);
      }
    }
  }
}

class Bomb {
  float x;
  float y;
  boolean live;
  
  float dirX;
  float dirY;
  
  Bomb(float x1, float y1) {
    x = x1;
    y = y1;
    live = true;
    randDir();
  }
  
  void randDir() {
    //run only after x and y are set
    dirX = random(-4, 4);
    dirY = random(-4, 4);
  }
  
  void update() {
    if (live) {
      //checks if offscreen and scores
      if (scores()) {
        clear();
        score += 2;
      }
      else if (x < 0 || x > 800 || y < 0 || y > 800) {
        clear();
        lives -= 1;
      } else {
        x += dirX;
        y += dirY;
        display();
      }
    }
  }
  
  void display() {
    if (live) {
      ellipse(x,y,size/2,size/2);
    }
  }
  
  void clear() {
    live = false;
  }
  
  boolean scores() {
    if ((x < width-250 && x > 250 && y > 0 && y < 50) || //top
    (x < width-250 && x > 250 && y > height-50 && y < height) || //bot
    (x > 0 && x < 50 && y > 250 && y < height-250) || //left
    (x > width-50 && x < width && y > 250 && y < height-250)) { //right
      return true;
    }
    return false;
  }
  
  boolean isHit(float a, float b) {
    
    if (a < x + (size/2) && a > x - (size/2)
    && b < y + (size/2) && b > y - (size/2)) {
      return true;
    }
    return false;
  }
}

void mousePressed() {
  for (Bomb b : bombs) {
    if(b.isHit(mouseX, mouseY)) {
      b.clear();
      score += 1;
    }
  }
}