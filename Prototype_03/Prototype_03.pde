Direction directions;

int sizeX;
int sizeY;
int gridSize;
int offset;
int objectSize;
Map map;
Player player;
int startX;
int startY;
int lives;
ArrayList<Enemy> enemies;
ArrayList<Card> deck;
ArrayList<Card> hand;
int numOfBlocks;
int numOfLava;
int numOfEnemies;
boolean power;
//lazy
int winX = 0;
int winY = 0;
int timer = 0;
int timer2 = 0;
int nomX = 0;
int nomY = 0;
boolean dead = false;
int sizeOfDeck;
int handSize;
int cardWidth = 120;
int cardHeight = 85;
boolean win = false;
boolean lock = false;
Card current = new Card();

void setup() {
  size(800, 600);
  sizeX = 13;
  sizeY = 13;
  startX = 1;
  startY = 1;
  lives = 3;
  numOfBlocks = 45;
  numOfLava = 25;
  numOfEnemies = 6;
  gridSize = 40;
  offset = 40;
  objectSize = 40;
  power = false;
  sizeOfDeck = 30;
  handSize = 5;
  
  enemies = new ArrayList<Enemy>(); //ref gridIdx-5
  deck = new ArrayList<Card>();
  hand = new ArrayList<Card>();
  generateDeck(sizeOfDeck); //genDeck
  map = new Map(sizeX, sizeY);
  map.genMap();
  player = new Player(startX,startY);
  drawHand();
}

void test(Direction d) {
  if (d == directions.UP) {
    print("up");
  } else{
    print("asasas");
  }
}

void resetGame() {
  lives = 3;
  timer = 0;
  timer2 = 0;
  current = new Card();
  win = false;
  power = false;
  map.resetGrid();
  enemies = new ArrayList<Enemy>(); //clearEnemy() //later
  hand = new ArrayList<Card>(); //fix later
  clearDeck();
  map.genMap();
  player = new Player(startX,startY);
  generateDeck(sizeOfDeck);
  drawHand();
}

void draw() {
  clear();
  background ( 11, 83, 131 );
  map.render();
  if (lives < 1) {
    player.removePlayer();
    fill(255, 255, 255);
    text("You Lose!", 300, 400);
  }
  textSize(20);
  fill(255, 255, 255);
  text("Lives: " + lives, 10, 20);
  if (timer > 0) {
    drawEat();
  }
  if (hasWon()) {
    win = true;
  }
  
  for (Card c : hand) {
    c.display();
  }
  //draw activate power button
  fill(10,247,152);
  rect(750,0, 50,50);
  textSize(20);
  fill(0,0,0);
  text("POW", 755, 30);
  
  //draw reshuffle button
  fill(187,90,232);
  rect(750,50, 50,50);
  textSize(20);
  fill(0,0,0);
  text("RS", 755, 80);
  
  if (lock && !win && timer == 0) {
    current.effect();
  }
  
  if(win) {
    textSize(80);
    fill(72,24,82);
    text("You Win!", 200, 300);
    textSize(40);
    text("Press R to reset", 200, 400);
  }
  if(timer2 > 0) {
    timer2--;
  }
}

class Map {
  int[][] grid;
  int x;
  int y;
  
  Map(int x1, int y1) {
    x = x1;
    y = y1;
    grid = new int[x][y];
    resetGrid();
  }
  
  void render() {
    //0 = empty
    //1 = player
    //2 = walls
    //3 = objective?
    //4 = hazards
    //5+ = enemies?
    
    //drawing empty grid
    for(int i = 0; i < y; i++) {
      for (int j = 0; j < x; j++) {
        fill(255,255,255);
        rect(j*(gridSize) + offset, (i*(gridSize)) + offset, gridSize, gridSize);
      }
    }
    
    //fill in grid
    for(int i = 0; i < y; i++) {
      for (int j = 0; j < x; j++) {
        if (grid[j][i] == 1) { 
          if (power) {
            fill(80,242,240);
          } else {
            fill(0,0,255);
          }
          ellipse(j*(gridSize) + (gridSize/2) + offset, (i*(gridSize)) + (gridSize/2) + offset, objectSize, objectSize);
         } else if(grid[j][i] == 2) {
           fill(0,255,0);
           rect(j*(gridSize) + offset, (i*(gridSize)) + offset, gridSize, gridSize);
         } else if(grid[j][i] == 3) {
           fill(242,174,27);
           ellipse(j*(gridSize) + (gridSize/2) + offset, (i*(gridSize)) + (gridSize/2) + offset, objectSize, objectSize);
         } else if(grid[j][i] == 4) {
           fill(255,0,0);
           rect(j*(gridSize) + offset, (i*(gridSize)) + offset, gridSize, gridSize);
         } else if(grid[j][i] > 4) {
           fill(255,0,0);
           ellipse(j*(gridSize) + (gridSize/2) + offset, (i*(gridSize)) + (gridSize/2) + offset, objectSize, objectSize);
         }
      }
    }
  }
  
  void resetGrid() {
    for(int i = 0; i < y; i++) {
      for (int j = 0; j < x; j++) {
        grid[j][i] = 0;
      }
    }
  }
  
  void genMap() {
    //boolean occ = true;
    int randX = 0;
    int randY = 0;
    
    for (int i = 0; i < numOfBlocks; i++) {
      while(true) {
        randX = int(random(0, sizeX));
        randY = int(random(0, sizeY));
        if(checkOccupied(randX, randY)) {
          break;
        }
      }
      grid[randX][randY] = 2;
    }
    
    for (int i = 0; i < numOfLava; i++) {
      while(true) {
        randX = int(random(0, 10));
        randY = int(random(0, 10));
        if(checkOccupied(randX, randY)) {
          break;
        }
      }
      grid[randX][randY] = 4;
    }
    
    for (int i = 0; i < numOfEnemies; i++) {
      while(true) {
        randX = int(random(0, 10));
        randY = int(random(0, 10));
        if(checkOccupied(randX, randY)) {
          break;
        }
      }
      Enemy temp = new Enemy(randX, randY, enemies.size()+5);
      enemies.add(temp);
    }
    
    while(true) {
      randX = int(random(0, 10));
      randY = int(random(0, 10));
      if(checkOccupied(randX, randY)) {
        break;
      }
    }
    grid[randX][randY] = 3;
    winX = randX;
    winY = randY;
  }
  
  boolean checkOccupied(int x1, int y1) {
    if (grid[x1][y1] != 0) {
      return false;
    }
    return true;
  }
}

class Player {
  //this is grid coords
  int x;
  int y;
  
  Player(int x1, int y1) {
    x = x1;
    y = y1;
    //check if anything is there?
    map.grid[x][y] =1;
  }
  
  void move(int d) {  //deprecated
    //if (d.equals(WEST) && x != 0) {
    if (d == 0 && x != 0) { //left
      if (map.grid[x-1][y] == 0) {
        map.grid[x][y] = 0;
        x = x-1;
        map.grid[x][y] = 1;
      } else if (map.grid[x-1][y] > 3) {
        player.dies(); //flash red?
      } 
    } else if (d == 1 && x != sizeX-1) { //right
      if (map.grid[x+1][y] == 0) {
        map.grid[x][y] = 0;
        x = x+1;
        map.grid[x][y] = 1;
      } else if (map.grid[x+1][y] > 3) {
        player.dies();
      }
    } else if (d == 2 && y != 0) { //up
      if (map.grid[x][y-1] == 0) {
        map.grid[x][y] = 0;
        y = y-1;
        map.grid[x][y] = 1;
      } else if (map.grid[x][y-1] > 3) {
        player.dies();
      }
    } else if (d == 3 && y != sizeY-1) { //down
      if (map.grid[x][y+1] == 0) {
      map.grid[x][y] = 0;
      y = y+1;
      map.grid[x][y] = 1;
      } else if (map.grid[x][y+1] > 3) {
        player.dies();
      }
    }
  }
  
  //overload with directions remove other one maybe
  void move(Direction d) {
    if (d == directions.LEFT && x != 0) { //left
      if (map.grid[x-1][y] == 0) {
        map.grid[x][y] = 0;
        x = x-1;
        map.grid[x][y] = 1;
      } else if (map.grid[x-1][y] > 3) {
        player.dies(); //flash red?
      } 
    } else if (d == directions.RIGHT && x != sizeX-1) { //right
      if (map.grid[x+1][y] == 0) {
        map.grid[x][y] = 0;
        x = x+1;
        map.grid[x][y] = 1;
      } else if (map.grid[x+1][y] > 3) {
        player.dies();
      }
    } else if (d == directions.UP && y != 0) { //up
      if (map.grid[x][y-1] == 0) {
        map.grid[x][y] = 0;
        y = y-1;
        map.grid[x][y] = 1;
      } else if (map.grid[x][y-1] > 3) {
        player.dies();
      }
    } else if (d == directions.DOWN && y != sizeY-1) { //down
      if (map.grid[x][y+1] == 0) {
      map.grid[x][y] = 0;
      y = y+1;
      map.grid[x][y] = 1;
      } else if (map.grid[x][y+1] > 3) {
        player.dies();
      }
    }
  }
  
  void powerMove(int d) { //deprecated
    if(power) { //just incase
      if (d == 0 && x != 0) { //left
        map.grid[x][y] = 0;
        x = x-1;
      } else if (d == 1 && x != sizeX-1) { //right
        map.grid[x][y] = 0;
        x = x+1;
      } else if(d == 2 && y != 0) { //up
        map.grid[x][y] = 0;
        y = y-1;
      } else if (d == 3 && y != sizeY-1) { //down
        map.grid[x][y] = 0;
        y = y+1;
      }
      if(map.grid[x][y] != 0) {eat(x,y);}
      map.grid[x][y] = 1;
    }
    power = false;
  }
  
  void powerMove(Direction d) {
    if(power) { //just incase
      if (d == directions.LEFT && x != 0) { //left
        map.grid[x][y] = 0;
        x = x-1;
      } else if (d == directions.RIGHT && x != sizeX-1) { //right
        map.grid[x][y] = 0;
        x = x+1;
      } else if(d == directions.UP && y != 0) { //up
        map.grid[x][y] = 0;
        y = y-1;
      } else if (d == directions.DOWN && y != sizeY-1) { //down
        map.grid[x][y] = 0;
        y = y+1;
      }
      if(map.grid[x][y] != 0) {eat(x,y);}
      map.grid[x][y] = 1;
    }
    //power = false;
  }
  
  void resetPosition() {
    map.grid[x][y] = 0;
    x = startX;
    y = startY;
    map.grid[x][y] = 1;
  }
  
  void dies() {
    lives = lives - 1;
    fill(255,0,0);
    rect(0,0, 800, 600);
    dead = true;
    resetPosition();
  }
  
  void removePlayer() {
    map.grid[x][y] = 0;
  }
}

class Enemy {
  int index;
  int x;
  int y;
  
  Enemy(int x1, int y1, int idx) {
    x = x1;
    y = y1;
    index = idx;
    //check if anything is there?
    map.grid[x][y] = idx;
  }
  
  void move(int d) { 
    if (d == 0 && x != 0) { //left
      if (map.grid[x-1][y] == 0) {
        map.grid[x][y] = 0;
        x = x-1;
        map.grid[x][y] = index;
      } else if (map.grid[x-1][y] == 1) {
        player.dies(); //flash red?
        map.grid[x][y] = 0;
        x = x-1;
        map.grid[x][y] = index;
      } 
    } else if (d == 1 && x != sizeX-1) { //right
      if (map.grid[x+1][y] == 0) {
        map.grid[x][y] = 0;
        x = x+1;
        map.grid[x][y] = index;
      } else if (map.grid[x+1][y] == 1) {
        map.grid[x][y] = 0;
        x = x+1;
        map.grid[x][y] = index;
        player.dies();
      }
    } else if (d == 2 && y != 0) { //up
      if (map.grid[x][y-1] == 0) {
        map.grid[x][y] = 0;
        y = y-1;
        map.grid[x][y] = index;
      } else if (map.grid[x][y-1] == 1) {
        map.grid[x][y] = 0;
        y = y-1;
        map.grid[x][y] = index;
        player.dies();
      }
    } else if (d == 3 && y != sizeY-1) { //down
      if (map.grid[x][y+1] == 0) {
      map.grid[x][y] = 0;
      y = y+1;
      map.grid[x][y] = index;
      } else if (map.grid[x][y+1] == 1) {
        map.grid[x][y] = 0;
        y = y+1;
        map.grid[x][y] = index;
        player.dies();
      }
    }
  }
}
//command cards
class Card {
  String type; //normal
  int moveNum;
  Direction moveDir;
  int handPos;
  boolean pow;
  
  Card(String t) {
    type = t;
    moveNum = 0;
    moveDir = directions.STAY;
    handPos = -1;
    pow = false;
  }
  
  Card() {
    type = "none";
    moveNum = 0;
    moveDir = directions.STAY;
    handPos = -1;
    pow = false;
  }
  
  Card(String t, int m, Direction d) {
    type = t;
    moveNum = m;
    moveDir = d;
    handPos = -1;
    pow = false;
  }
  
  void effect() {
    lock = true;
    
    if(pow) {
      power = true;
    }
    /*
    for (int i = 0; i < moveNum; i++) {
      if (!dead) {
        if (power) {
          player.powerMove(moveDir);
        } else {
          player.move(moveDir);
        }
      } else {
        i = 100; //break
        dead = false;
      }
    }
    
    power = false;*/
    if (!dead && moveNum > 0) {
      if (power) {
        player.powerMove(moveDir);
        moveNum--;
      } else {
        player.move(moveDir);
        moveNum--;
      }
      timer2 = 20;
      moveEnemies();
    } else {
      moveNum = 0;
      dead = false;
      power = false;
      lock = false;
    }
  }
  
  String generateText() {
    String text = "" + moveNum;
    
    if (moveDir == directions.UP) {
      text = text + " UP";
    } else if (moveDir == directions.LEFT) {
      text = text + " LEFT";
    } else if (moveDir == directions.RIGHT) {
      text = text + " RIGHT";
    } else if (moveDir == directions.DOWN) {
      text = text + " DOWN";
    }
    
    return text;
  }
  
  void display() {
      //int x = getCardX(handPos);
      int x = 600;
      int y = getCardY(handPos);
      if (pow) {
        fill(10,247,152);
      } else {
        fill (23,176,227);
      }
      rect(x,y,cardWidth,cardHeight);
      textSize(15);
      fill(0,0,0);
      if (pow) {
        text("POWER", x+30, y+20);
      }
      text(generateText(), x+30, y+55);
  }
}

//turns halfway, not using yet
class turnCard extends Card {
  int move2;
  Direction dir2;
  
  turnCard() {
    type = "turn";
    moveNum = 0;
    move2 = 0;
    moveDir = directions.STAY;
    dir2 = directions.STAY;
    handPos = -1;
    pow = false;
  }
  
  turnCard(String t, int m1, int m2, Direction d1, Direction d2) {
    type = t;
    moveNum = m1;
    move2 = m2;
    moveDir = d1;
    dir2 = d2;
    handPos = -1;
    pow = false;
  }
  
  void effect() {
    boolean notDied = true;
    for (int i = 0; i < moveNum; i++) {
      if (!dead) {
        player.move(moveDir);
      } else {
        i = 100;
        notDied = false;
        dead = false;
      }
    }
    if (notDied) {
      for (int i = 0; i < move2; i++) { 
        if (!dead) {
          player.move(dir2);
        } else {
          i = 100;
          notDied = false;
          dead = false;
        }
      }
    }
  }
  
  String generateText() {
    String text = "";
    
    return text;
  }
  
}

void keyPressed() {
  if(key == CODED) {
    if(keyCode == LEFT) {
      if (power) {
        player.powerMove(directions.LEFT);
      } else {
        player.move(directions.LEFT);
      }
    } else if (keyCode == RIGHT) {
      if (power) {
        player.powerMove(directions.RIGHT);
      } else {
        player.move(directions.RIGHT);
      }
    } else if (keyCode == UP) {
      if (power) {
        player.powerMove(directions.UP);
      } else {
        player.move(directions.UP);
      }
    } else if (keyCode == DOWN) {
      if (power) {
        player.powerMove(directions.DOWN);
      } else {
        player.move(directions.DOWN);
      }
    }
    moveEnemies();
  } else if(key == ' ') {
    if (power) {
      power = false;
    } else {
      power = true;
    }
    moveEnemies();
  } else if(key == 'r') {
    resetGame();
  }
}

boolean hasWon() {
  if (player.x == winX && player.y == winY) {
    return true;
  }
  return false;
}

void moveEnemies() {
  int rand;
  for (int i = 0; i < enemies.size(); i++) {
    rand = int(random(-1, 4));
    enemies.get(i).move(rand);
  }
}

void eat(int x, int y) {
  timer = 30;
  nomX = x * gridSize;
  nomY = y * gridSize;
}

void generateDeck(int deckSize) {
  for (int i = 0; i < deckSize; i++) {
    Card card = generateCard("normal");
    deck.add(card);
  }
}

Card generateCard(String cardType) {
  int moveNum = int(random(1,4));
  int powChance = int(random(0, 4));
  Card card = new Card(cardType, moveNum, randomDir());
  if (powChance == 1) {
    card.pow = true;
  }
  return card;
}

void clearDeck() {
  /*
  for (int i = 0; i < deck.size(); i++) {
    
  }*/
  //for now
  deck = new ArrayList<Card>();
}

void drawHand() {
  int i = 0;
  while(i < handSize) {
    drawCard(i);
    i++;
  }
}

void playCard(int handIdx) {
  current = hand.get(handIdx);
  current.effect();
  //hand.get(handIdx).effect();
  //some animation
  hand.remove(handIdx);
  for(int i = 0; i < hand.size(); i++) {
    hand.get(i).handPos = i;
  }
  drawCard(hand.size()); //should work
}

void drawCard(int i) {
  hand.add(deck.get(deck.size()-1));
  hand.get(hand.size() - 1).handPos = i;
  deck.remove(deck.size()-1);
  Card card = generateCard("normal");
  deck.add(card);
}
/*
int getCardX(int handIdx) {
  switch(handIdx) {
    case 0:
    case 2:
    case 4:
      return 600;
    case 1:
    case 3:
    case 5:
      return 700;
  }
  return -1;
}*/

int getCardY(int handIdx) {
  switch(handIdx) {
    case 0:
      return 50;
    case 1:
      return 150;
    case 2:
      return 250;
    case 3:
      return 350;
    case 4:
      return 450;
  }
  return -1;
}

Direction randomDir() {
  int rand = int(random(-1, 4));
  
  switch(rand) {
    case 0:
      return directions.UP;
    case 1:
      return directions.DOWN;
    case 2:
      return directions.LEFT;
    case 3:
      return directions.RIGHT;
  }
  
  return directions.STAY;
}

void mulligan() {
  hand = new ArrayList<Card>();
  drawHand();
}

void drawEat() {
  fill(0,0,0);
  textSize(30);
  text("nom", nomX, nomY);
  timer--;
}

void mousePressed() {
  if (mouseX > 599 && mouseX < 720) {
    if (mouseY > 49 && mouseY < 135) {
      //card 0
      playCard(0);
    } else if (mouseY > 149 && mouseY < 235) {
      //card 1
      playCard(1);
    } else if (mouseY > 249 && mouseY < 335) {
      //card 2
      playCard(2);
    } else if (mouseY > 349 && mouseY < 435) {
      //card 3
      playCard(3);
    } else if (mouseY > 449 && mouseY < 535) {
      //card 4
      playCard(4);
    } 
  } else if (mouseX > 745 && mouseX < 800 && mouseY > 0 && mouseY < 50) {
    power = true;
    moveEnemies();
  } else if (mouseX > 745 && mouseX < 800 && mouseY > 50 && mouseY < 100) {
    mulligan();
    moveEnemies();
  }
}