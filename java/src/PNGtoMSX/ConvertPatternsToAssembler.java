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
public class ConvertPatternsToAssembler {
    
    static int PW = 8;
    static int PH = 8;
    static int MSX1Palette[][] = {{0,0,0},
                                    {0,0,0},
                                    {43,221,81},
                                    {81,255,118},
                                    {81,81,255},
                                    {118,118,255},
                                    {221,81,81},
                                    {81,255,255},
                                    {255,81,81},
                                    {255,118,118},
                                    {255,221,81},
                                    {255,255,118},
                                    {43,187,43},
                                    {221,81,187},
                                    {221,221,221},
                                    {255,255,255}};     
    
    public static void main(String args[]) throws Exception {
        String inputFile = args[0];
        File f = new File(inputFile);
        BufferedImage sourceImage = ImageIO.read(f);
        System.out.println("  org #0000");
        System.out.println("");
        System.out.println("patterns:");
        for(int i = 0;i<256;i++) {
            int x = i%16;
            int y = i/16;
            String line = generateAssemblerPatternBitmap(x,y,sourceImage);
            System.out.println(line);
        }
        System.out.println("endpatterns:");
        System.out.println("patternattributes:");
        for(int i = 0;i<256;i++) {
            int x = i%16;
            int y = i/16;
            String line = generateAssemblerPatternattributes(x,y,sourceImage);
            System.out.println(line);
        }
        System.out.println("endpatternattributes:");
    }
    
    public static String generateAssemblerPatternBitmap(int x, int y, BufferedImage image) throws Exception {
        List<Integer> differentColors = new ArrayList<>();
        List<Integer> previousColors = null;
        String line = "    db ";
        for(int i = 0;i<PH;i++) {
            List<Integer> pixels = patternColors(x, y, i, image);
            differentColors = new ArrayList<>();
            for(int c:pixels) if (!differentColors.contains(c)) differentColors.add(c);
            if (differentColors.size()==1 && previousColors!=null && 
                previousColors.contains(differentColors.get(0))) {
                differentColors = previousColors;
            }
            if (differentColors.size()==1) differentColors.add(0);
            Collections.sort(differentColors);
//            System.out.println(differentColors);
            int bitmap = 0;
            int mask = (int)Math.pow(2, PW-1);
            for(int j = 0;j<PW;j++) {
                if (pixels.get(j).equals(differentColors.get(0))) {
                    // 0
                } else {
                    // 1
                    bitmap+=mask;
                }
                mask/=2;
            }
            line += toHex8bit(bitmap);
            if (i<PH-1) line+=",";
            previousColors = differentColors;
        }
        return line;
    }    

    
    public static String generateAssemblerPatternattributes(int x, int y, BufferedImage image) throws Exception {
        List<Integer> differentColors = new ArrayList<>();
        List<Integer> previousColors = null;
        String line = "    db ";
        for(int i = 0;i<PH;i++) {
            List<Integer> pixels = patternColors(x, y, i, image);
            differentColors = new ArrayList<>();
            for(int c:pixels) if (!differentColors.contains(c)) differentColors.add(c);
            if (differentColors.size()==1 && previousColors!=null && 
                previousColors.contains(differentColors.get(0))) {
                differentColors = previousColors;
            }
            if (differentColors.size()==1) differentColors.add(0);
            Collections.sort(differentColors);
            int bitmap = differentColors.get(0) + 16*differentColors.get(1);
            line += toHex8bit(bitmap);
            if (i<PH-1) line+=",";
            previousColors = differentColors;
        }
        return line;
    }    
    
    
    public static String toHex8bit(int value) {
        char table[] = {'0','1','2','3','4','5','6','7','8','9','a','b','c','d','e','f'};
        return "#" + table[value/16] + table[value%16];
    }
    

    public static List<Integer> patternColors(int x, int y, int line, BufferedImage image) throws Exception {
        List<Integer> pixels = new ArrayList<>();
        List<Integer> differentColors = new ArrayList<>();
        for(int j = 0;j<PW;j++) {
            int image_x = x*PW + j;
            int image_y = y*PH + line;
            int color = image.getRGB(image_x, image_y);
            int r = (color & 0xff0000)>>16;
            int g = (color & 0x00ff00)>>8;
            int b = color & 0x0000ff;
            int msxColor = findMSXColor(r, g, b);
            if (msxColor==-1) throw new Exception("Undefined color at " + image_x + ", " + image_y + ": " + r + ", " + g + ", " + b);
            if (!differentColors.contains(msxColor)) differentColors.add(msxColor);
            pixels.add(msxColor);
        }
        if (differentColors.size()>2) throw new Exception("more than 2 colors in tile coordinates " + x + ", " + y);
        return pixels;        
    }
    
    public static int findMSXColor(int r, int g, int b) {
        for(int i = 0;i<MSX1Palette.length;i++) {
            if (r==MSX1Palette[i][0] &&
                g==MSX1Palette[i][1] &&
                b==MSX1Palette[i][2]) {
                return i;
            }
        }
        return -1;
    }
}
