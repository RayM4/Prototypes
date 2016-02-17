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
int numOfBlocks;
int numOfLava;
int numOfEnemies;
boolean power;
//lazy
int winX = 0;
int winY = 0;
int timer = 0;
int nomX = 0;
int nomY = 0;

//enum Direction {NORTH, SOUTH, WEST, EAST};

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
  
  enemies = new ArrayList<Enemy>(); //ref gridIdx-5
  map = new Map(sizeX, sizeY);
  map.genMap();
  player = new Player(startX,startY);
}

void resetGame() {
  map.resetGrid();
  enemies = new ArrayList<Enemy>();
  map.genMap();
  player = new Player(startX,startY);
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
    textSize(80);
    fill(72,24,82);
    text("You Win!", 200, 300);
    textSize(40);
    text("Press R to reset", 200, 400);
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
  
  //void move(Direction d) {
  void move(int d) {  
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
  
  void powerMove(int d) {
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

void keyPressed() {
  if(key == CODED) {
    if(keyCode == LEFT) {
      if (power) {
        player.powerMove(0);
      } else {
        player.move(0);
      }
    } else if (keyCode == RIGHT) {
      if (power) {
        player.powerMove(1);
      } else {
        player.move(1);
      }
    } else if (keyCode == UP) {
      if (power) {
        player.powerMove(2);
      } else {
        player.move(2);
      }
    } else if (keyCode == DOWN) {
      if (power) {
        player.powerMove(3);
      } else {
        player.move(3);
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

void drawEat() {
  fill(0,0,0);
  textSize(30);
  text("nom", nomX, nomY);
  timer--;
}