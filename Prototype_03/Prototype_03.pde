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
//enum Direction {NORTH, SOUTH, WEST, EAST};

void setup() {
  size(800, 600);
  sizeX = 10;
  sizeY = 10;
  startX = 1;
  startY = 1;
  lives = 3;
  gridSize = 40;
  offset = 40;
  objectSize = 40;
  map = new Map(sizeX, sizeY);
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
    //grid[1][1] = 1;
    grid[0][0] = 2;
    grid[4][2] = 2;
    grid[6][3] = 2;
    grid[2][2] = 4;
    grid[7][7] = 4;
  }
  
  void render() {
    //0 = empty
    //1 = player
    //2 = walls
    //3 = hazards
    //4+ = enemies?
    
    
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
          fill(0,0,255);
          ellipse(j*(gridSize) + (gridSize/2) + offset, (i*(gridSize)) + (gridSize/2) + offset, objectSize, objectSize);
         } else if(grid[j][i] == 2) {
           fill(0,255,0);
           rect(j*(gridSize) + offset, (i*(gridSize)) + offset, gridSize, gridSize);
         } else if(grid[j][i] == 4) {
           fill(255,0,0);
           rect(j*(gridSize) + offset, (i*(gridSize)) + offset, gridSize, gridSize);
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
      } else if (map.grid[x-1][y] == 4) {
        player.dies(); //flash red?
      }
      
    } else if (d == 1 && x != sizeX-1) { //right
      if (map.grid[x+1][y] == 0) {
        map.grid[x][y] = 0;
        x = x+1;
        map.grid[x][y] = 1;
      } else if (map.grid[x+1][y] == 4) {
        player.dies();
      }
    } else if (d == 2 && y != 0) { //up
      if (map.grid[x][y-1] == 0) {
        map.grid[x][y] = 0;
        y = y-1;
        map.grid[x][y] = 1;
      } else if (map.grid[x][y-1] == 4) {
        player.dies();
      }
    } else if (d == 3 && y != sizeY-1) { //down
      if (map.grid[x][y+1] == 0) {
      map.grid[x][y] = 0;
      y = y+1;
      map.grid[x][y] = 1;
      } else if (map.grid[x][y+1] == 4) {
        player.dies();
      }
    }
  }
  
  void resetPosition() {
    map.grid[x][y] = 0;
    x = startX;
    y = startY;
    map.grid[x][y] = 1;
  }
  
  void dies() {
    lives = lives - 1;
    resetPosition();
  }
  
  void removePlayer() {
    map.grid[x][y] = 0;
  }
}

void keyPressed() {
  if(key == CODED) {
    if(keyCode == LEFT) {
      player.move(0);
    } else if (keyCode == RIGHT) {
      player.move(1);
    } else if (keyCode == UP) {
      player.move(2);
    } else if (keyCode == DOWN) {
      player.move(3);
    }
  }
}