//Primera Parte del codigo
PImage SpriteJefeEmmanuel, SpriteNaveJugador, SpriteVaderTie;
PImage SpaceBack, NaveLeft, NaveRight, SpriteJefeDavid;
int pixelsize = 4;
int gridsize  = pixelsize * 7 + 5;
Player player;
ArrayList enemies = new ArrayList();
ArrayList bullets = new ArrayList();
ArrayList jefes = new ArrayList(); 
int direction = 1;
boolean incy = false;
int score = 0;
PFont f;

void setup() {
    size(1900,1000);
    //Carga la foto
    SpriteJefeEmmanuel = loadImage("FotoEmmanuelJefe.png");
    SpriteJefeDavid = loadImage("FotoDavidJefe.png");
    SpriteNaveJugador = loadImage("spriteNaveJugador.png");
    SpriteVaderTie = loadImage("vaderTie.png");
    SpaceBack = loadImage("SpaceBg.png");
    NaveLeft = loadImage("NaveLeft.png");
    NaveRight = loadImage("NaveRight.png");
    background(SpaceBack);
    noStroke();
    player = new Player();
    createEnemies();
    createBosses();

    f = createFont("Arial", 36, true);
}

void draw() {
    background(SpaceBack);
    
    drawScore();

    player.draw();

    for (int i = 0; i < bullets.size(); i++) {
        Bullet bullet = (Bullet) bullets.get(i);
        bullet.draw();
    }

    for (int i = 0; i < enemies.size(); i++) {
        Enemy enemy = (Enemy) enemies.get(i);
        if (enemy.outside() == true) {
            direction *= (-1);
            incy = true;
            break;
        }
    }

    for (int i = 0; i < enemies.size(); i++) {
        Enemy enemy = (Enemy) enemies.get(i);
        if (!enemy.alive()) {
            enemies.remove(i);
        } else {
            enemy.draw();
        }
    }

    if (score==8400){

        for (int i = 0; i < jefes.size(); i++) {
        Enemy enemy = (Enemy) jefes.get(i);
        if (enemy.outside() == true) {
            direction *= (-1);
            incy = true;
            break;
        }
    }

    for (int i = 0; i < jefes.size(); i++) {
        Enemy enemy = (Enemy) jefes.get(i);
        if (!enemy.alive()) {
            jefes.remove(i);
        } else {
            enemy.draw();
        }
    }
    }
    incy = false;
}

void drawScore() {
    textFont(f);
    text("Score: " + String.valueOf(score), 300, 50);
}

void createEnemies() {
    for (int i = 0; i < width/gridsize/2; i++) {
        for (int j = 0; j <= 5; j++) {
            enemies.add(new Enemy(i*gridsize+20, j*gridsize + 70, SpriteVaderTie, 1));
        }
    }
}

void createBosses(){
    for (int i = 0; i <= 1; i++) {
        for (int j = 0; j <= 0; j++) {
            if (i == 0){
                jefes.add(new Enemy(i*gridsize, j*gridsize + 70, SpriteJefeEmmanuel,10));
            }else{
                jefes.add(new Enemy(i*gridsize + 200, j*gridsize + 70, SpriteJefeDavid,10));
            }
        }
    }
}



class SpaceShip {
    int x, y;
    PImage sprite;

    void draw() {
        updateObj();
        drawSprite(x, y);
    }

    public void SpriteSetter(PImage spriteTemporal){
        sprite = spriteTemporal;
    }

    void drawSprite(int xpos, int ypos) {
        image(sprite, xpos, ypos);
    }

    void updateObj() {
    }
}

class Player extends SpaceShip {
    boolean canShoot = true;
    int shootdelay = 0;

    Player() {
        x = width/gridsize/2;
        y = height - (20 * pixelsize);
        sprite = SpriteNaveJugador;  
    }

    void updateObj() {
        if (keyPressed && keyCode == LEFT) {
            x -= 5;
            sprite = NaveRight;
        }
        
        if (keyPressed && keyCode == RIGHT) {
            x += 5;
            sprite = NaveLeft;
        }
        
        if (keyPressed && keyCode == CONTROL && canShoot) {
            sprite = SpriteNaveJugador;
            bullets.add(new Bullet(x-10, y));
            bullets.add(new Bullet(x+49, y));
            canShoot = false;
            shootdelay = 0;
        }

        shootdelay++;
        
        if (shootdelay >= 20) {
            canShoot = true;
        }
    }
}


class Enemy extends SpaceShip {
    int life;
    
    Enemy(int xpos, int ypos, PImage spriteTemporal, int lifeTemp) {
        x = xpos;
        y = ypos;
        sprite = spriteTemporal;
        life = lifeTemp; 
    }

    void updateObj() {
        if (frameCount%30 == 0) {
            x += direction * gridsize;
        }
        
        if (incy == true) {
            y += gridsize / 2;
        }
    }

    boolean alive() {
        for (int i = 0; i < bullets.size(); i++) {
            Bullet bullet = (Bullet) bullets.get(i);
            
            if (bullet.x > x && bullet.x < x + 7 * pixelsize + 5 && bullet.y > y && bullet.y < y + 5 * pixelsize) {
                bullets.remove(i);
                
                life--;
                //nextColorErrase
                
                if (life == 0) {
                    score += 50;
                    return false;
                }
                
                break;
            }
        }

        return true;
    }

    boolean outside() {
        return x + (direction*gridsize) < 0 || x + (direction*gridsize) > width - gridsize;
    }
}

class Bullet {
    int x, y;

    Bullet(int xpos, int ypos) {
        x = xpos + gridsize/2 - 4;
        y = ypos;
    }

    void draw() {
        fill(255);
        rect(x, y, pixelsize, pixelsize);
        y -= pixelsize * 2;
    }
}
