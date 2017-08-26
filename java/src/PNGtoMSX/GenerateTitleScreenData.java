/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package PNGtoMSX;

import java.awt.Graphics;
import java.awt.image.BufferedImage;
import java.io.File;
import java.util.ArrayList;
import java.util.List;
import javax.imageio.ImageIO;

/**
 *
 * @author santi
 */
public class GenerateTitleScreenData {
    public static void main(String args[]) throws Exception {
        File f1 = new File(args[0]);
        BufferedImage title_image_patterns = ImageIO.read(f1);
        File f2 = new File(args[1]);
//        System.out.println("opening " + f2.getAbsolutePath());
        BufferedImage title_image_sprites = ImageIO.read(f2);
//        ImageIO.write(title_image_sprites, "png", new File("graphics/wtf.png"));
        File f3 = new File(args[2]);
        BufferedImage title_patterns = ImageIO.read(f3);
        
        int title_start_y = 32;
        int nameTable[][] = new int[32][10];
        
        for(int y = 0;y<10;y++) {
            for(int x = 0;x<32;x++) {
                if (!isPatternEmpty(title_image_patterns,x,y)) {
                    int idx = addNewPatternToImage(title_patterns, title_image_patterns, x, y);;
                    if (idx==-1) {
                        System.err.println("Ran out of space!!");
                        System.exit(1);
                    }
//                    System.out.println("non empty tile at " + x + "," + y + " -> " + idx);
                    nameTable[x][y] = idx;
                } else {
                    nameTable[x][y] = 0;
                }
            }
        }
        
        // write title patterns image:
        ImageIO.write(title_patterns, "png", new File(args[3]));
        
        // generate assembler file:
        System.out.println("  org #0000");
        System.out.println("");
        System.out.println("title_name_table:");
        for(int y = 0;y<10;y++) {
            System.out.print("  db " + nameTable[0][y]);
            for(int x = 1;x<32;x++) {
                System.out.print(", " + nameTable[x][y]);
            }
            System.out.println("");
        }
        
        List<int []> sprite_patterns = new ArrayList<>();
        List<int []> sprite_attributes = new ArrayList<>();
        for(int y = 0;y<10*8;y++) {
            for(int x = 0;x<32*8;x++) {
                int color = GenerateAssemblerPatternPatch.findMSXColor(x,y,title_image_sprites);
                if (color==-1) System.err.println("non MSX color in sprite image!");
                if (color!=0) {
                    int sprite_x = x;
                    int sprite_y = y;
                    // sprite found!!
                    // 1) find the top-left corner:
                    for(int y1 = -15;y1<16;y1++) {
                        if (y+y1>=0 && y+y1<title_image_sprites.getHeight()) {
                            for(int x1 = -15;x1<15;x1++) {
                                if (x+x1>=0 && x+x1<title_image_sprites.getWidth()) {
                                    int color2 = GenerateAssemblerPatternPatch.findMSXColor(x+x1,y+y1,title_image_sprites);
                                    if (color2==color) {
                                        sprite_x = Math.min(sprite_x,x+x1);
                                        sprite_y = Math.min(sprite_y,y+y1);
                                    }
                                }
                            }
                        }
                    }
                    // align the coordinates to an 8x8 grid:
                    sprite_x = sprite_x - (sprite_x%8);
                    sprite_y = sprite_y - (sprite_y%8);
                    
                    // 2) get the pattern, and clear the pixels, so we don't get confused later on:
                    int pattern[] = new int[32];
                    for(int i = 0;i<16;i++) {
                        for(int j = 0;j<16;j++) {
                            int color2 = GenerateAssemblerPatternPatch.findMSXColor(sprite_x+j,sprite_y+i,title_image_sprites);
                            if (color2==color) {
                                // first clear the pixel:
                                title_image_sprites.setRGB(sprite_x+j, sprite_y+i, 0);
                                int byte_idx = i+(j>=8 ? 16:0);
                                int bit_idx = 7-j%8;
                                pattern[byte_idx] += (int)Math.pow(2, bit_idx);
                            }
                        }
                    }
                    sprite_patterns.add(pattern);
                    
                    // 3) store the sprite attributes for later:
                    sprite_attributes.add(new int[] {title_start_y+sprite_y-1, sprite_x, sprite_attributes.size()*4, color});
                }
            }
        }

        System.out.println("title_n_sprites:");
        System.out.println("  db " + sprite_attributes.size());
        System.out.println("title_sprites:");
        for(int []pattern:sprite_patterns) {
            // 3) write the pattern data:
            System.out.print("  db " + pattern[0]);
            for(int i = 1;i<32;i++) System.out.print("," + pattern[i]);
            System.out.println("");            
        }
        System.out.println("title_sprite_table:");
        for(int[] attributes:sprite_attributes) {
            System.out.print("  db " + attributes[0]);
            for(int i = 1;i<attributes.length;i++) {
                System.out.print("," + attributes[i]);
            }
            System.out.println("");
        }
    }
    
    public static boolean isPatternEmpty(BufferedImage img, int x, int y) throws Exception
    {
//        System.out.println(x + "," + y + " image is: " + img.getWidth() + "x" + img.getHeight());
        List<Integer> differentColors = new ArrayList<>();
        for(int i = 0;i<8;i++) {
            List<Integer> pixels = ConvertPatternsToAssembler.patternColors(x, y, i, img);
            for(int c:pixels) if (!differentColors.contains(c)) differentColors.add(c);
        }
        if (differentColors.size()==1 && differentColors.get(0)==0) return true;
        return false;
    }

    private static int addNewPatternToImage(BufferedImage title_base_patterns, BufferedImage title_image, int x, int y) throws Exception {
        for(int y2 = 0;y2<16;y2++) {
            for(int x2 = 0;x2<16;x2++) {
                // first see if we already have the pattern:
                int differentPixels = differences(title_base_patterns, x2, y2, title_image, x, y);
                if (differentPixels==0) return y2*16+x2;
//                if (differentPixels==1) System.err.println(x+","+y + " only has 1 pixel difference with respect to " + x2+","+y2);
            }
        }
        for(int y2 = 0;y2<16;y2++) {
            for(int x2 = 0;x2<16;x2++) {
                // otherwise, look for an empty one:
                if (y2*16+x2!=0 &&
                    y2*16+x2!=32 &&
                    isPatternEmpty(title_base_patterns,x2,y2)) {
                    Graphics g = title_base_patterns.getGraphics();
                    g.drawImage(title_image, x2*8, y2*8, (x2+1)*8, (y2+1)*8, 
                                             x*8, y*8, (x+1)*8, (y+1)*8, null);
                    return y2*16+x2;
                }
            }
        }
        return -1;
    }

    private static int differences(BufferedImage img1, int x1, int y1, BufferedImage img2, int x2, int y2) throws Exception {
        int differences = 0;
        for(int i = 0;i<8;i++) {
            List<Integer> colors1 = GenerateAssemblerPatternPatch.patternColors(x1,y1,i,img1);
            List<Integer> colors2 = GenerateAssemblerPatternPatch.patternColors(x2,y2,i,img2);
            
            for(int j = 0;j<8;j++) {
                if (colors1.get(j) != colors2.get(j)) differences++;
            }
        }
        
        return differences;
    }
}
