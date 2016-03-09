Direction directions;

ArrayList<Entity> stuff;
ArrayList<Bomb> bombs;
ArrayList<Block> blocks;
int score;
int lives;
int timer;
int size;
int NUM_OF_BOMBS;
int speed;

int blockWidth;
int blockHeight;


void setup() {
  size(800, 800);
  stuff = new ArrayList();
  bombs = new ArrayList();
  
  score = 0;
  lives = 3;
  size = 80;
  speed = 40;
  blockWidth = 300;
  blockHeight = 50;
  NUM_OF_BOMBS = 2;
  //b = new Block(250, 0, directions.UP);
  blocks = new ArrayList();
  genPaddles();
}

void resetGame() {
  score = 0;
  lives = 3;
  stuff = new ArrayList();
  bombs = new ArrayList();
  genPaddles();
}

void draw() {
  clear(); //<>//
  background ( 11, 83, 131 );
  
  //b.display();
  for (Block b : blocks) {
    b.display();
  }
  fill (0, 0, 0);
  textSize(30);
  text("Score: " + score, 10 , 50);
  text("Lives: " + lives, 10, 80);

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
      //if (scores()) {
      if(checkCollide()) {
        clear();
        score += 2;
      }
      else if (x < 0 || x > 800 || y < 0 || y > 800) {
        clear();
        background(255,0,0);
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
  
  boolean checkCollide() {
    for (Block b : blocks) {
      if (b.checkCollision(x, y)) {
        print("a");
        return true;
      }
    }
    return false;
  }
}

class Block {
  float x = 0;
  float y = 0;
  Direction p;
  
  Block() {
    x = 0;
    y = 0;
    p = directions.STAY;
  }
  
  Block(float x1, float y1, Direction d) {
    x = x1;
    y = y1;
    p = d;
  }
  
  void display() {
    fill(212, 11, 11);
    if (checkSide()) {
      rect(x, y, blockHeight, blockWidth);
    } else if (checkVertical()){
      rect(x, y, blockWidth, blockHeight);
    }
  }
  
  void move(Direction d) {
    if (d == directions.UP && checkSide() && y > 0) {
      y -= speed;
    } else if (d == directions.DOWN && checkSide() && y < (height-blockWidth)) {
      y += speed;
    } else if (d == directions.LEFT && checkVertical() && x > 0) {
      x -= speed;
    } else if (d == directions.RIGHT && checkVertical() && x < (width-blockWidth)) {
      x += speed;
    }
  }
  
  /*boolean checkCollision(float x1, float y1) { //fix eventually
    if (checkSide()) {
      if (x1 > x-(blockHeight/2) && x1 < x+(blockHeight/2)
        && y1 > y-(blockWidth/2) && y1 < y+(blockWidth/2)) {
          return true;
      }
    } else {
      if (x1 > x-(blockWidth/2) && x1 < x+(blockWidth/2)
        && y1 > y-(blockHeight/2) && y1 < y+(blockHeight/2)) {
          return true;
        }
    }
    return false;
  }*/
  
  boolean checkCollision(float x1, float y1) {
    if (checkSide()) { //left and right
      if ((abs(x1 - x) * 2 < (size/2 + blockHeight)) &&
      (abs(y1 - y) * 2 < (size/2 + blockWidth) )) {
        return true;
      }
    } else {
      if ((abs(x1 - x) * 2 < (size/2 + blockWidth)) &&
      (abs(y1 - y) * 2 < (size/2 + blockHeight) )) {
        return true;
      }
    }
    return false;
  }
  
  boolean checkSide() {
    return (p == directions.LEFT || p == directions.RIGHT);
  }
  
  boolean checkVertical() {
    return (p == directions.UP || p == directions.DOWN);
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

void keyPressed() {
  if(key == CODED) {
    if(keyCode == LEFT) {
      //blocks.get(0).move(directions.LEFT);
      blocks.get(1).move(directions.LEFT);
    } else if (keyCode == RIGHT) {
      //blocks.get(0).move(directions.RIGHT);
      blocks.get(1).move(directions.RIGHT);
    } else if (keyCode == UP) {
      //blocks.get(2).move(directions.UP);
      blocks.get(3).move(directions.UP);
    } else if (keyCode == DOWN) {
      //blocks.get(2).move(directions.DOWN);
      blocks.get(3).move(directions.DOWN);
    }
  } else if (key == 'w') {
    blocks.get(2).move(directions.UP);
  } else if (key == 'a') {
    blocks.get(0).move(directions.LEFT);
  } else if (key == 's') {
    blocks.get(2).move(directions.DOWN);
  } else if (key == 'd') {
    blocks.get(0).move(directions.RIGHT);
  } else if (key == 'r') {
    resetGame();
  }
}

void genPaddles() {
  blocks = new ArrayList();
  Block a = new Block(250, 0, directions.UP);
  Block b = new Block(250, (height-blockHeight), directions.DOWN);
  Block c = new Block(0, 250, directions.LEFT);
  Block d = new Block((width-blockHeight), 250, directions.RIGHT);
  blocks.add(a);
  blocks.add(b);
  blocks.add(c);
  blocks.add(d);
}