/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package pcg;

import java.awt.image.BufferedImage;
import java.io.File;
import javax.imageio.ImageIO;

/**
 *
 * @author santi
 */
public class ChangeTileSet {
    public static void main(String args[]) throws Exception {
        String oldtmxpath = "graphics/rooms-old/";
        String newtmxpath = "graphics/rooms-jungle/";
        String originalTileSet = "tiles-jungle-old.png";
        String newTileSet = "tiles-jungle.png";
        
        for(String map:new String[]{"foliage-1.tmx","foliage-2.tmx",
                                    "room1-1.tmx", "room1-2.tmx", "room1-3.tmx", "room1-4.tmx", "room1-bottom-1.tmx", "room1-bottom-2.tmx",
                                    "room2-1.tmx", "room2-2.tmx",
                                    "room3-1.tmx", "room3-2.tmx", "room3-3.tmx", "room3-bottom-1.tmx",
                                    "room4-1.tmx", "room4-2.tmx", "room4-bottom-1.tmx",
                                    "room5-1.tmx", "room5-2.tmx", "room5-3.tmx",
                                    "room6-1.tmx", "room6-2.tmx", "room6-3.tmx",
                                    "doubleroom-1.tmx",
                                    "doubleroom-2.tmx"
                                    }) {
            changeTMXTileSet(oldtmxpath+map, newtmxpath+map, originalTileSet, newTileSet);
        }
    }
    
    
    public static void changeTMXTileSet(String tmxfile, String newtmxfile, 
                                        String originalTileSet, String newTileSet) throws Exception {
        
        // find the tile correspondence:
        int correspondence[] = new int[256];
        File f1 = new File("graphics/"+originalTileSet);
        BufferedImage originalImage = ImageIO.read(f1);
        File f2 = new File("graphics/"+newTileSet);
        BufferedImage newImage = ImageIO.read(f2);
        for(int i = 0;i<16;i++) {
            for(int j = 0;j<16;j++) {
                correspondence[j+i*16] = findTheMostSimilarTile(originalImage, j, i, newImage);
            }
        }        
        /*
        for(int i = 0;i<16;i++) {
            for(int j = 0;j<16;j++) {
                System.out.print(correspondence[j+i*16] + " ");
            }
            System.out.println("");
        }*/
        
        // load the TMX file:
        LevelChunk map = new LevelChunk(tmxfile);
        
        for(int i = 0;i<map.height;i++) {
            for(int j = 0;j<map.width;j++) {
                int oldidx = map.layer1[j][i];
                if (oldidx>0) {
                    int idx = correspondence[oldidx-1]+1;
                    if (idx==-1) throw new Exception("missing tile " + (map.layer1[j][i]-1) + " in " + newTileSet);
                    map.layer1[j][i] = idx;
                }
            }
        }
        
        // save the new TMX file:
        map.saveTMX(newtmxfile, new String[]{newTileSet});
    }

    private static int findTheMostSimilarTile(BufferedImage originalImage, int x, int y, BufferedImage newImage) {
        for(int i = 0;i<16;i++) {
            for(int j = 0;j<16;j++) {
                if (tileMatch(originalImage, x, y, newImage, j, i)) return j+i*16;
            }
        }
        return -1;
    }

    
    private static boolean tileMatch(BufferedImage originalImage, int x, int y, BufferedImage newImage, int x2, int y2) {
        for(int i = 0;i<8;i++) {
            for(int j = 0;j<8;j++) {
                int color1 = originalImage.getRGB(x*8+j, y*8+i);
                int color2 = newImage.getRGB(x2*8+j, y2*8+i);
                if (color1 != color2) return false;
            }
        }
        return true;
    }
}
