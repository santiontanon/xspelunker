/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package pcg;

/**
 *
 * @author santi
 */
public class Enemy {
    public static int PINECONE = 1;
    public static int MONKEY = 2;
    public static int SCORPION = 3;
    public static int BEE_NEST = 4;
    public static int PIRANHA = 5;
    public static int SNAKE = 6;
    public static int MAYA = 7;
    public static int ALIEN = 8;
    public static int SENTINEL = 9;
    
    public static String enemy_names[] = {"0","ENEMY_PINECONE","ENEMY_MONKEY","ENEMY_SCORPION","ENEMY_BEE_NEST","ENEMY_PIRANHA","ENEMY_SNAKE","ENEMY_MAYA","ENEMY_ALIEN","ENEMY_SENTINEL"};
    
    public static int start_tile = 257;
    
    public int x,y;
    public int type;
    public int hp;
    
    public Enemy(int a_x, int a_y, int a_type, int a_hp) {
        x = a_x;
        y = a_y;
        type = a_type;
        hp = a_hp;
    }
    
    void place(int layer[][]) {
        if (type==PINECONE) {
            layer[x][y] = start_tile;
            layer[x][y+1] = start_tile+16;
        }
        if (type==MONKEY) {
            layer[x][y] = start_tile+32+4;
            layer[x+1][y] = start_tile+32+5;
            layer[x][y+1] = start_tile+48+4;
            layer[x+1][y+1] = start_tile+48+5;
        }
        if (type==PIRANHA) {
            if (y>=3) {
                layer[x][y-3] = start_tile+96;
                layer[x+1][y-3] = start_tile+96+1;
            }
            layer[x][y-2] = start_tile+112;
            layer[x+1][y-2] = start_tile+112+1;
            layer[x][y-1] = start_tile+112+4;
            layer[x+1][y-1] = start_tile+112+5;
        }
        if (type==SCORPION) {
            layer[x][y] = start_tile+128;
            layer[x+1][y] = start_tile+128+1;
            layer[x][y+1] = start_tile+144;
            layer[x+1][y+1] = start_tile+144+1;
        }
        if (type==BEE_NEST) {
            layer[x][y] = start_tile+160;
            layer[x+1][y] = start_tile+160+1;
            layer[x][y+1] = start_tile+176;
            layer[x+1][y+1] = start_tile+176+1;
        }
        if (type==SNAKE) {
            layer[x][y] = start_tile+256;
            layer[x+1][y] = start_tile+256+1;
            layer[x][y+1] = start_tile+272;
            layer[x+1][y+1] = start_tile+272+1;
        }
        if (type==MAYA) {
            layer[x][y] = start_tile+288;
            layer[x+1][y] = start_tile+288+1;
            layer[x][y+1] = start_tile+304;
            layer[x+1][y+1] = start_tile+304+1;
        }
        if (type==ALIEN) {
            layer[x][y] = start_tile+320;
            layer[x+1][y] = start_tile+320+1;
            layer[x][y+1] = start_tile+336;
            layer[x+1][y+1] = start_tile+336+1;
        }
        if (type==SENTINEL) {
            layer[x][y] = start_tile+352;
            layer[x+1][y] = start_tile+352+1;
            layer[x][y+1] = start_tile+368;
            layer[x+1][y+1] = start_tile+368+1;
        }
    }
    
    
    String assemblerString()
    {
        if (type == MONKEY) {
            return enemy_names[type]+","+hp+",1,0,"+y+",0,"+x+",0";
        } else {
            return enemy_names[type]+","+hp+",0,0,"+y+",0,"+x+",0";
        }
    }
}
