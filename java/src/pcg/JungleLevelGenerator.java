/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package pcg;

import java.io.File;
import java.io.FileWriter;
import java.util.ArrayList;
import java.util.List;
import java.util.Random;

/**
 *
 * @author santi
 */
public class JungleLevelGenerator {
    public static int UP = 0;
    public static int RIGHT = 1;
    public static int DOWN = 2;
    public static int LEFT = 3;
    
    public static int ROOM_WIDTH = 16;
    public static int ROOM_HEIGHT = 16;
    
    /*
    Room type guaranteed paths:
    - type 0: no constraints (any of the patterns for any type would work)
    - type 1: L-R
    - type 2: L-D
    - type 3: L-U
    - type 4: U-R
    - type 5: D-U / U-D
    - type 6: D-R
    */
    
    public static void main(String args[]) throws Exception {
        generateJungleLevel(8,2);
    }
    
    /*
        - width and height are in "rooms"
        - Jungle levels always have the start position on the left, and target on the right
    */
    public static void generateJungleLevel(int width, int height) throws Exception {
        Random r = new Random();
        int [][]rooms = new int[width][height];
        List<LevelChunk> foliageChunks = new ArrayList<>();
        List<LevelChunk> roomPatterns[] = new List[6];
        List<LevelChunk> bottomRowRoomPatterns[] = new List[6];
        List<LevelChunk> doubleRoomPatterns = new ArrayList<>();
        int start_y = -1, end_y = -1;
        List<Enemy> enemies = new ArrayList<>();
        boolean idol_required = false;
        
        for(int i = 0;i<6;i++) {
            roomPatterns[i] = new ArrayList<>();
            bottomRowRoomPatterns[i] = new ArrayList<>();
        }
        
        foliageChunks.add(new LevelChunk("rooms-jungle/foliage-1.tmx"));
        foliageChunks.add(new LevelChunk("rooms-jungle/foliage-2.tmx"));
        roomPatterns[0].add(new LevelChunk("rooms-jungle/room1-1.tmx"));
        roomPatterns[0].add(new LevelChunk("rooms-jungle/room1-2.tmx"));
        roomPatterns[0].add(new LevelChunk("rooms-jungle/room1-3.tmx"));
        roomPatterns[0].add(new LevelChunk("rooms-jungle/room1-4.tmx"));
        roomPatterns[1].add(new LevelChunk("rooms-jungle/room2-1.tmx"));
        roomPatterns[1].add(new LevelChunk("rooms-jungle/room2-2.tmx"));
        roomPatterns[2].add(new LevelChunk("rooms-jungle/room3-1.tmx"));
        roomPatterns[2].add(new LevelChunk("rooms-jungle/room3-2.tmx"));
        roomPatterns[2].add(new LevelChunk("rooms-jungle/room3-3.tmx"));
        roomPatterns[3].add(new LevelChunk("rooms-jungle/room4-1.tmx"));
        roomPatterns[3].add(new LevelChunk("rooms-jungle/room4-2.tmx"));
        roomPatterns[4].add(new LevelChunk("rooms-jungle/room5-1.tmx"));
        roomPatterns[4].add(new LevelChunk("rooms-jungle/room5-2.tmx"));
        roomPatterns[4].add(new LevelChunk("rooms-jungle/room5-3.tmx"));
        roomPatterns[5].add(new LevelChunk("rooms-jungle/room6-1.tmx"));
        roomPatterns[5].add(new LevelChunk("rooms-jungle/room6-2.tmx"));
        roomPatterns[4].add(new LevelChunk("rooms-jungle/room6-3.tmx"));
        roomPatterns[4].add(new LevelChunk("rooms-jungle/room6-4.tmx"));

        bottomRowRoomPatterns[0].add(new LevelChunk("rooms-jungle/room1-bottom-1.tmx"));
        bottomRowRoomPatterns[0].add(new LevelChunk("rooms-jungle/room1-bottom-2.tmx"));
        bottomRowRoomPatterns[2].add(new LevelChunk("rooms-jungle/room3-bottom-1.tmx"));
        bottomRowRoomPatterns[3].add(new LevelChunk("rooms-jungle/room4-bottom-1.tmx"));
        
        doubleRoomPatterns.add(new LevelChunk("rooms-jungle/doubleroom-1.tmx"));
        doubleRoomPatterns.add(new LevelChunk("rooms-jungle/doubleroom-2.tmx"));
        
        for(int i = 0;i<width;i++) {
            for(int j = 0;j<height;j++) {
                rooms[i][j] = 0;
            }
        }
        
        // 1) Generate the path to the exit:
        {
            int previous_direction = RIGHT;
            int y = start_y = r.nextInt(height);
            int x = 0;
            do{
//                System.out.println(x + "," + y);
                int tmp = r.nextInt(5);
                int action = RIGHT;
                if ((tmp==1 || tmp==2)) {
                    if (previous_direction==DOWN) action = DOWN;
                                             else action = UP;
                }
                if ((tmp==3 || tmp==4)) {
                    if (previous_direction==UP) action = UP;
                                           else action = DOWN;
                }
                if (action==UP && y==0) action = RIGHT;
                if (action==DOWN && y==height-1) action = RIGHT;
                if (action==RIGHT) {
                    // move right
                    if (previous_direction==RIGHT) rooms[x][y] = 1;
                    else if (previous_direction==UP) rooms[x][y] = 6;
                    else if (previous_direction==DOWN) rooms[x][y] = 4;
                    x++;
                    previous_direction = RIGHT;
                } else if (action==UP) {
                    // move up
                    if (previous_direction==RIGHT) rooms[x][y] = 3;
                                              else rooms[x][y] = 5;
                    y--;
                    previous_direction = UP;
                } else {
                    // move down:
                    if (previous_direction==RIGHT) rooms[x][y] = 2;
                                              else rooms[x][y] = 5;
                    y++;
                    previous_direction = DOWN;
                }
            }while(x<width);
            end_y = y;

            for(int i = 0;i<height;i++) {
                for(int j = 0;j<width;j++) {
                    System.out.print(rooms[j][i] + " ");
                }
                System.out.println("");
            }
        }
        
        // 2) First pass on creating the background:
        LevelChunk m = new LevelChunk(width*ROOM_WIDTH, height*ROOM_HEIGHT);
        m.layer2 = new int[width*ROOM_WIDTH][height*ROOM_HEIGHT];
//        int m.layer1[][] = new int[width*ROOM_WIDTH][height*ROOM_HEIGHT];
//        int enemies_layer[][] = new int[width*ROOM_WIDTH][height*ROOM_HEIGHT];
        for(int x = 0;x<width*ROOM_WIDTH;x++) {
            for(int y = 0;y<height*ROOM_HEIGHT;y++) {
                m.layer1[x][y] = 0;
                m.layer2[x][y] = 0;
            }
        }
        
        for(int j = 0;j<width;j++) {
            LevelChunk c = foliageChunks.get(r.nextInt(foliageChunks.size()));
            for(int x = 0;x<ROOM_WIDTH;x++) {
                for(int y = 0;y<ROOM_HEIGHT;y++) {
                    if (c.layer1[x][y]>0) m.layer1[j*ROOM_WIDTH+x][y] = c.layer1[x][y];
                }
            }
        }

        // 3) Add doublerooms:
        for(int i = 0;i<height;i++) {
            for(int j = 0;j<width-1;j++) {
                if (rooms[j][i]==0 && rooms[j+1][i]==0 && !doubleRoomPatterns.isEmpty()) {
                    if (r.nextInt(10)==0) {
                        System.out.println("double room!");
                        rooms[j][i] = -1;
                        rooms[j+1][i] = -1;
                        
                        int selected = r.nextInt(doubleRoomPatterns.size());
                        LevelChunk c = doubleRoomPatterns.remove(selected);  // we remove it, since these special patterns can only be used once per level
                        m.instantiate(c,j*ROOM_WIDTH,i*ROOM_HEIGHT, r);
                    }
                }
            }
        }
        
        
        // 4) Select random chunks for each room:
        for(int i = 0;i<height;i++) {
            for(int j = 0;j<width;j++) {
                int type = rooms[j][i];
                if (type == -1) continue;   // this means we have already set this room (e.g., with a double room)
                if (type == 0) type = r.nextInt(6)+1;
                int n = roomPatterns[type-1].size();
                if (i==height-1) n += bottomRowRoomPatterns[type-1].size();
                int selected = r.nextInt(n);
                LevelChunk c = null;
                if (selected<roomPatterns[type-1].size()) c = roomPatterns[type-1].get(selected);
                                                     else c = bottomRowRoomPatterns[type-1].get(selected - roomPatterns[type-1].size());
                m.instantiate(c,j*ROOM_WIDTH,i*ROOM_HEIGHT, r);
            }
        }       
        
        // 4.1) See if there is any "required" item as a consequence of a pattern:
        for(Item i:m.items) {
            if (i.types.get(0).equals("button")) idol_required = true;
        }
        
        // 5.1) Add the exit sign:
        for(int i = ROOM_HEIGHT-1;i>0;i--) {
            if (m.isBackground(m.layer1[width*ROOM_WIDTH-2][end_y*ROOM_HEIGHT+i])) {
                // found sign position:
                m.layer1[width*ROOM_WIDTH-2][end_y*ROOM_HEIGHT+i-1] = 36;
                m.layer1[width*ROOM_WIDTH-1][end_y*ROOM_HEIGHT+i-1] = 37;
                m.layer1[width*ROOM_WIDTH-2][end_y*ROOM_HEIGHT+i] = 38;
                m.layer1[width*ROOM_WIDTH-1][end_y*ROOM_HEIGHT+i] = 39;
                break;
            }
        }
        
        // 5.2) Complete the tree trunks to reach the top:
        int trunkleft[] = {13,23};
        int trunkright[] = {14,24};
        int trunkstopper[] = {15,16};
        for(int x = 0;x<width*ROOM_WIDTH;x++) {
            boolean filling = false;
            for(int y = height*ROOM_HEIGHT-1;y>0;y--) {
                for(int i = 0;i<trunkleft.length;i++) {
                    if (m.layer1[x][y] == trunkleft[i]) {
                        filling = true;
                    } else if (m.layer1[x][y] == trunkstopper[0] ||
                               m.layer1[x][y] == trunkstopper[1]) {
                        filling = false;
                    } else if (m.layer1[x][y] == 0 && filling) {
                        m.layer1[x][y] = trunkleft[r.nextInt(trunkleft.length)];                        
                    }
                }
            }
            filling = false;
            for(int y = height*ROOM_HEIGHT-1;y>0;y--) {
                for(int i = 0;i<trunkright.length;i++) {
                    if (m.layer1[x][y] == trunkright[i]) {
                        filling = true;
                    } else if (m.layer1[x][y] == trunkstopper[0] ||
                               m.layer1[x][y] == trunkstopper[1]) {
                        filling = false;
                    } else if (m.layer1[x][y] == 0 && filling) {
                        m.layer1[x][y] = trunkright[r.nextInt(trunkright.length)];                        
                    }
                }
            }
        }
        
        // 5.3) "Beautify" the map:
        //  - ensure corner tiles are correctly set
        //  - replace empty tiles by background
        for(int x = 0;x<width*ROOM_WIDTH;x++) {
            for(int y = 0;y<height*ROOM_HEIGHT;y++) {
                // background:
                if (m.layer1[x][y] == 0) m.layer1[x][y] = 1;
                
                // fix rock tiles:
                if (m.isRock(m.layer1[x][y])) {
                    if (x>0 && !m.isRock(m.layer1[x-1][y])) {
                        if (y<height*ROOM_HEIGHT-1 && !m.isRock(m.layer1[x][y+1])) {
                            m.layer1[x][y] = 112+37;
                        } else if (y>0 && !m.isRock(m.layer1[x][y-1])) {
                            m.layer1[x][y] = 104+37;
                        } else {
                            m.layer1[x][y] = 108+37;
                        }       
                    } else if (x<width*ROOM_WIDTH-1 && !m.isRock(m.layer1[x+1][y])) {
                        if (y<height*ROOM_HEIGHT-1 && !m.isRock(m.layer1[x][y+1])) {
                            m.layer1[x][y] = 115+37;
                        } else if (y>0 && !m.isRock(m.layer1[x][y-1])) {
                            m.layer1[x][y] = 107+37;
                        } else {
                            m.layer1[x][y] = 111+37;
                        }
                    } else if (y>0 && !m.isRock(m.layer1[x][y-1])) {
                        m.layer1[x][y] = 105+37 + r.nextInt(2);
                    } else if (y<height*ROOM_HEIGHT-1 && !m.isRock(m.layer1[x][y+1])) {
                        m.layer1[x][y] = 113+37 + r.nextInt(2);                        
                    } else {
                        m.layer1[x][y] = 109+37 + r.nextInt(2);
                    }
                }                
            }
        }      
        
        
        // 6) Place enemies, traps, and additional items:
        for(int x = 2;x<width*ROOM_WIDTH-2;x++) {
            for(int y = 2;y<height*ROOM_HEIGHT-2;y++) {
                if (m.isBranch(m.layer1[x][y])) {
                    if (r.nextInt(12)==0) {
                        // place a pinecone:
                        enemies.add(new Enemy(x,y+1,Enemy.PINECONE,1));
                    }
                }
                
                if ((x%2)==0 &&
                    m.isRock(m.layer1[x][y+1]) && m.isRock(m.layer1[x+1][y+1]) &&
                    m.isBackground(m.layer1[x][y]) && m.isBackground(m.layer1[x+1][y]) &&
                    m.emptySpace(x,y-1,2,2)) {
                    if (r.nextInt(32)==0) {
                        // place a scorpion:
                        enemies.add(new Enemy(x,y-1,Enemy.SCORPION,2));
                    } else if (r.nextInt(64)==0) {
                        // place a stone
                        List<String> l = new ArrayList<>();
                        l.add("stone");
                        m.items.add(new Item(x*8,(y-1)*8,"stone",l));
                    } else if (r.nextInt(128)==0) {
                        // place an arrow
                        List<String> l = new ArrayList<>();
                        l.add("arrow");
                        m.items.add(new Item(x*8,(y-1)*8,"stone",l));
                    }
                }

                if ((x%2)==0 &&
                    m.isRock(m.layer1[x][y]) && m.isRock(m.layer1[x+1][y]) &&
                    m.emptySpace(x,y+1,2,2)) {
                    if (r.nextInt(40)==0) {
                        // place a bee nest:
                        enemies.add(new Enemy(x,y+1,Enemy.BEE_NEST,3));
                    }
                }

                if ((x%2)==0 &&
                    m.isWater(m.layer1[x][y+1]) && m.isWater(m.layer1[x+1][y+1]) &&
                    m.isBackground(m.layer1[x][y]) && m.isBackground(m.layer1[x+1][y]) &&
                    m.isBackground(m.layer1[x][y-1]) && m.isBackground(m.layer1[x+1][y-1])) {
                    if (r.nextInt(3)==0) {
                        // place a piranha:
                        enemies.add(new Enemy(x,y+1,Enemy.PIRANHA,1));
                    }
                }

                if ((y%2)==0 &&
                    (m.layer1[x][y]==14 || m.layer1[x][y]==8+16) &&
                    (m.layer1[x][y+1]==14 || m.layer1[x][y+1]==8+16)) {
                    if (r.nextInt(24)==0) {
                        // place a monkey:
                        enemies.add(new Enemy(x,y,Enemy.MONKEY,1));
                    }
                }
            }
        }
        
        while(idol_required) {
            for(int x = 2;x<width*ROOM_WIDTH-2 && idol_required;x+=2) {
                for(int y = 2;y<height*ROOM_HEIGHT-2 && idol_required;y++) {
                    int rx = x/ROOM_WIDTH;
                    int ry = y/ROOM_HEIGHT;
                    if (rooms[rx][ry]>0 &&
                        m.isRock(m.layer1[x][y+1]) && m.isRock(m.layer1[x+1][y+1]) &&
                        m.isBackground(m.layer1[x][y]) && m.isBackground(m.layer1[x+1][y]) &&
                        m.emptySpace(x,y-1,2,2)) {
                        if (r.nextInt(64)==0) {
                            // place idol:
                            List<String> l = new ArrayList<>();
                            l.add("idol");
                            m.items.add(new Item(x*8,(y-1)*8,"idol",l));
                            idol_required = false;
                        }
                    }
                }
            }
        }

        for(Enemy e:enemies) {
//            System.out.println("enemy " + e.type + " at " + e.x + "," + e.y);
            e.place(m.layer2);
        }
        System.out.println("Enemies: " + enemies.size());
        
        // Save the level as a TMX for visualization:
        m.saveTMX("JungleMap.tmx", new String[]{"tiles-jungle.png","enemies.png"});

        // Save the level as a Z80 asm file for using in the MSX engine:
        {
            FileWriter fw = new FileWriter(new File("JungleMap.asm"));
            fw.write("demo_mapwidth:\n");
            fw.write("  db " + width*ROOM_WIDTH+"\n");
            fw.write("demo_mapheight:\n");
            fw.write("  db " + height*ROOM_HEIGHT+"\n");
            fw.write("demo_map:\n");
            for(int i = 0;i<height*ROOM_HEIGHT;i++) {
                fw.write("  db ");
                for(int j = 0;j<width*ROOM_WIDTH;j++) {
                    if (j==0) {
                        fw.write(""+(m.layer1[j][i]-1));
                    } else {
                        fw.write(","+(m.layer1[j][i]-1));
                    }
                }
                fw.write("\n");
            }
            fw.write("demo_nenemies:\n");
            fw.write("  db " + enemies.size() + "\n");
            fw.write("demo_enemies:\n");
            for(Enemy e:enemies) {
                fw.write("  db "+e.assemblerString() + "\n");
            }
            fw.write("demo_nitems:\n");
            fw.write("  db " + m.items.size() + "\n");
            fw.write("demo_items:\n");
            for(Item i:m.items) {
                System.out.println("Item: " + i.types.get(0));
                fw.write("  db ITEM_"+i.types.get(0).toUpperCase()+","+i.x/8+","+i.y/8+",0,  0,0,0,0\n");
            }
            fw.flush();
            fw.close();
        }
    }
 
}
