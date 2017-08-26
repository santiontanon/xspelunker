/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package PNGtoMSX;

import java.awt.image.BufferedImage;
import java.io.File;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import javax.imageio.ImageIO;

/**
 *
 * @author santi
 */
public class ConvertPNGtoAssemblerSprites {
    public static void main(String args[]) throws Exception {
        //System.out.println("  org #0000");
        convert(args[0], args[1]);
    }
    
    
    public static void convert(String fileName, String prefix) throws Exception
    {
        File f = new File(fileName);
        BufferedImage sourceImage = ImageIO.read(f);
        int r0 = 0;
        int r1 = sourceImage.getHeight()/16;
        int c0 = 0;
        int c1 = sourceImage.getWidth()/16;
        int sprite_ID = 1;
        for(int i = r0;i<r1;i++) {
            for(int j = c0;j<c1;j++) {
                List<Integer> colors = new ArrayList<>();
                int sprite[][] = new int[16][16];
                for(int y = 0;y<16;y++) {
                    for(int x = 0;x<16;x++) {
                        int color = sourceImage.getRGB(x+j*16, y+i*16);
                        int r = (color & 0xff0000)>>16;
                        int g = (color & 0x00ff00)>>8;
                        int b = color & 0x0000ff;
                        if (r!=0 || g!=0 || b!=0) {
                            if (!colors.contains(color)) colors.add(color);
                        }
                    }
                }
                Collections.sort(colors);
                for(int y = 0;y<16;y++) {
                    for(int x = 0;x<16;x++) {
                        int color = sourceImage.getRGB(x+j*16, y+i*16);
                        int idx = colors.indexOf(color)+1;
                        if (idx>=0) sprite[x][y] = idx;
                    }
                }
                if (!colors.isEmpty()) {
                    System.out.println(prefix+sprite_ID+":");
                    for(int c = 1;c<=colors.size();c++) {
                        System.out.println("  ; " + prefix+sprite_ID + " (color " + c + ")");
                        System.out.print("  db ");
                        for(int k = 0;k<16;k++) {
                            int v = 0;
                            if (sprite[0][k]==c) v = v|0x80;
                            if (sprite[1][k]==c) v = v|0x40;
                            if (sprite[2][k]==c) v = v|0x20;
                            if (sprite[3][k]==c) v = v|0x10;
                            if (sprite[4][k]==c) v = v|0x08;
                            if (sprite[5][k]==c) v = v|0x04;
                            if (sprite[6][k]==c) v = v|0x02;
                            if (sprite[7][k]==c) v = v|0x01;

                            String h = toHex8bit(v);
                            if (k!=15) {
                                System.out.print(h+", ");                    
                            } else {
                                System.out.println(h+"");
                            }
                        }
                        System.out.print("  db ");
                        for(int k = 0;k<16;k++) {
                            int v = 0;
                            if (sprite[8][k]==c) v = v|0x80;
                            if (sprite[9][k]==c) v = v|0x40;
                            if (sprite[10][k]==c) v = v|0x20;
                            if (sprite[11][k]==c) v = v|0x10;
                            if (sprite[12][k]==c) v = v|0x08;
                            if (sprite[13][k]==c) v = v|0x04;
                            if (sprite[14][k]==c) v = v|0x02;
                            if (sprite[15][k]==c) v = v|0x01;

                            String h = toHex8bit(v);
                            if (k!=15) {
                                System.out.print(h+", ");                    
                            } else {
                                System.out.println(h+"");
                            }
                        }       
                    }
                    sprite_ID++;
                }
            }
        }
    }
    
    
    public static String toHex8bit(int value) {
        char table[] = {'0','1','2','3','4','5','6','7','8','9','a','b','c','d','e','f'};
        return "#" + table[value/16] + table[value%16];
    }
    
}
