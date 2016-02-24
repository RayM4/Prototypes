//static variables
Direction directions; //imports Direction.java
ArrayList<Entity> stuff;
Player player;
int objectSize; //size of points and enemies, split maybe?
int spawnRate; //wait between spawns
int spawnCycle;
int bomb_count; //number spawn per cycle
int point_count;
float speed;

void setup() {
  size(800, 600);
  objectSize = 40;
  player = new Player();
  spawnCycle = 200;
  spawnRate = spawnCycle;
  bomb_count = 1;
  point_count = 2;
  speed = 1.66667;
  stuff = new ArrayList<Entity>();
  
  //generateObjs(point_count, bomb_count);
  //Point p = new Point(directions.UP);
  //print(p.x);
}


void resetGame() {
  player = new Player();
  spawnCycle = 200;
  spawnRate = spawnCycle;
  bomb_count = 1;
  point_count = 3;
  for (int i = 0; i < stuff.size(); i++) {
    stuff.remove(i);
    i--;
  }
  stuff = new ArrayList<Entity>();
}

void draw() {
  clear();
  background(165,202,214);
  player.growPlayer();
  if(player.shield) {
    player.renderShield();
  }
  
  if (spawnRate == spawnCycle) {
    generateObjs(point_count, bomb_count);
    spawnRate -= 1;
  } else if (spawnRate == 0) {
    spawnRate = spawnCycle;
  } else {
    spawnRate -= 1;
  }
  
  fill (0, 0, 0);
  textSize(25);
  text("Score: " + player.score, 10 , 30);
  text("Lives : " + player.lives, 10, 55);
  player.render();
  if (player.lives > 0) {
    moveCenter();
    pushObjects();
    renderObjects();
    handleContact();
  } else {
    textSize(40);
    fill(125, 72, 240);
    text("You Lose!", 200, 500);
    text("Press R to restart", 200, 540);
  }
}

class Player {
  float x;
  float y;
  int radius; //diameter but too late to change it...
  boolean shield;
  int score;
  int lives;
  boolean growthTrigger;
  
  Player() {
    x = 400;
    y = 300;
    score = 0;
    lives = 5;
    radius = objectSize * 3;
    shield = false;
    growthTrigger = true;
  }
  
  void toggleShield() {
    shield = !shield;
  }
  
  void render() {
    fill(0,191,255);
    ellipse(x, y,radius,radius);
  }
  
  void renderShield() {
    fill(156,230,255);
    ellipse(x, y,radius+20,radius+20);
  }
  
  void growPlayer() {
    if (score != 0 && score % 100 == 0 && growthTrigger) {
      radius += 20;
      scaleDifficulty();
      growthTrigger = false;
    }
    if (score % 100 != 0 && !growthTrigger) {
      growthTrigger = true;
    }
  }
  
}

class Entity {
  float x;
  float y;
  int r,g,b;
  String type;
  int value;
  
  Entity() {
    x = 0;
    y = 0;
    r = 0;
    g = 0;
    b = 0;
    type = "";
  }
  
  Entity(int x1, int y1) {
    x = x1;
    y = y1;
  }
  
  int randX() {
    return int(random(0, 800));
  }
  
  int randY() {
    return int(random(0, 600));
  }
  
  void render() {
    fill(r,g,b);
    ellipse(x, y,objectSize,objectSize);
  }
  
  void moveTowardsCenter() {
    float xSpeed = (400 - x) / 250;
    float ySpeed = (300 - y) / 250;
    float factor = speed / sqrt(pow(xSpeed, 2) + pow(ySpeed, 2));
    xSpeed = xSpeed * factor;
    ySpeed = ySpeed * factor;
    x += xSpeed;
    y += ySpeed;
  }
}


class Point extends Entity {
  Point() {
    x = 0;
    y = 0;
    r = 191;
    g = 239;
    b = 255;
    value = 10;
    type = "point";
  }
  
  Point(Direction dir) {
    value = 10;
    r = 191;
    g = 239;
    b = 255;
    type = "point";
    switch(dir) {
      case UP:
        x = randX();
        y = 0;
        break;
      case DOWN:
        x = randX();
        y = 600;
        break;
      case LEFT:
        x = 0;
        y = randY();
      case RIGHT:
        x = 800;
        y = randY();
    }
  }
}

class Bomb extends Entity {
  Bomb() {
    x = 0;
    y = 0;
    r = 15;
    g = 34;
    b = 245;
    value = 1;
    type = "bomb";
  }
  
  Bomb(Direction dir) {
    value = 1;
    r = 15;
    g = 34;
    b = 245;
    type = "bomb";
    switch(dir) {
      case UP:
        x = randX();
        y = 0;
        break;
      case DOWN:
        x = randX();
        y = 600;
        break;
      case LEFT:
        x = 0;
        y = randY();
      case RIGHT:
        x = 800;
        y = randY();
    }
  }
}

void generateObjs(int numPoints, int numBombs) {
  Direction[] dir = {directions.UP, directions.DOWN, directions.LEFT, directions.RIGHT};
  int index = 0;
  for (int i = 0; i < numPoints; i++) {
    index = int(random(0, 4));
    Point p = new Point(dir[index]);
    stuff.add(p);
  }
  
  for (int i = 0; i < numBombs; i++) {
    index = int(random(0, 4));
    Bomb b = new Bomb(dir[index]);
    stuff.add(b);
  }
}

void moveCenter() {
  for(int i = 0; i < stuff.size(); i++) {
    stuff.get(i).moveTowardsCenter();
  }
}

void renderObjects() {
  for(int i = 0; i < stuff.size(); i++) {
    stuff.get(i).render();
  }
}

void handleContact() {
  if (!player.shield) {
    for(int i = 0; i < stuff.size(); i++) {
      if (collision(player.x, stuff.get(i).x, player.y, stuff.get(i).y)) {
        if (stuff.get(i).type == "point") {
          player.score += stuff.get(i).value;
          stuff.remove(i);
          i--;
        } else if (stuff.get(i).type == "bomb") {
          player.lives -= stuff.get(i).value;
          stuff.remove(i);
          i--;
        }
      }
    }
  } else {
    for(int i = 0; i < stuff.size(); i++) {
      if (collision2(player.x, stuff.get(i).x, player.y, stuff.get(i).y)) {
        stuff.remove(i);
      }
    }
  }
}

boolean collision(float x1, float x2, float y1, float y2) { 
  float xDifference = x1 - x2;
  float yDifference = y1 - y2;
  float distSq = pow(xDifference, 2) + pow(yDifference, 2);
  return distSq < pow((player.radius/2 + objectSize/2), 2); //player.radius is diameter
}

boolean collision2(float x1, float x2, float y1, float y2) { 
  float xDifference = x1 - x2;
  float yDifference = y1 - y2;
  float distSq = pow(xDifference, 2) + pow(yDifference, 2);
  return distSq < pow(((player.radius+20)/2 + objectSize/2), 2); //player.radius is diameter
}

void scaleDifficulty() {
  if (bomb_count % 2 == 0) {
    point_count += 1;
  }
  bomb_count += 1;
  //point_count += 1;
  spawnCycle -= 10;
}

void pushObjects() {
  for(int i = 0; i < stuff.size(); i++) {
    for (int j = 0; j < stuff.size(); j++) {
      float xDifference = stuff.get(i).x - stuff.get(j).x;
      float yDifference = stuff.get(i).y - stuff.get(j).y;
      float distSq = pow(xDifference, 2) + pow(yDifference, 2);
      //float step = 2 * objectSize - distSq;
      if (distSq < pow((objectSize), 2)) {
        stuff.get(i).x -= 6;
        stuff.get(i).y -= 6;
        stuff.get(j).x += 6;
        stuff.get(j).y += 6;
      }
    }
  }
}

void keyPressed() {
  if (key == ' ') {
    player.toggleShield();
  } else if (key == 'r') {
    resetGame();
  }
  
}