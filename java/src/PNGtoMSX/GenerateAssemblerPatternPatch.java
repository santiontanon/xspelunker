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
import utils.Pair;

/**
 *
 * @author santi
 * 
 * This file takes two PNG images as input, and generates an assembler file that contains
 * a "patch" to convert the first image into the second. This is used to prevent storing redundant data
 * in a cartridge when multiple pattern sets overlap.
 * The path is of the form:
 * n_patches:
 *   db 1 NUM_PATCHES
 * ...
 * patch_n:
 *   dw 1 starting pointer
 *   dw 1 LENGTH (in bytes)
 *   db ... (the patch)
 * ...
 * 
 */
public class GenerateAssemblerPatternPatch {
    
    static int PW = 8;
    static int PH = 8;
    static int num_patterns = 256;
    static int patterns_per_line = 16;
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
        int CHRTBL1[] = new int[num_patterns*PH*2];
        int CHRTBL2[] = new int[num_patterns*PH*2];
        
        String inputFile1 = args[0];
        File f1 = new File(inputFile1);
        BufferedImage image1 = ImageIO.read(f1);
        generateCHRandCLRTable(image1, CHRTBL1);

        String inputFile2 = args[1];
        File f2 = new File(inputFile2);
        BufferedImage image2 = ImageIO.read(f2);
        generateCHRandCLRTable(image2, CHRTBL2);

        // Now we find all the contiguous parts that need to be updated (any 4 bytes in a row that are identical will break the patch)
        List<Pair<Integer,Integer>> differentSections = findDifferentSections(CHRTBL1, CHRTBL2);
//        System.out.println(differentSections);

        // verify the result:
        int CHRTBL3[] = new int[num_patterns*PH*2];
        for(int i = 0;i<CHRTBL3.length;i++) CHRTBL3[i] = CHRTBL1[i];
        for(Pair<Integer,Integer> p:differentSections) {
            for(int i = 0;i<p.m_b;i++) {
                CHRTBL3[p.m_a+i] = CHRTBL2[p.m_a+i];
            }
        }
        for(int i = 0;i<CHRTBL3.length;i++) {
            if (CHRTBL3[i] != CHRTBL2[i]) System.out.println(";  inconsistency in byte " + i);
        }
        

        int nPatches = differentSections.size();
        int accumPatchSize = 1;
        for(Pair<Integer,Integer> p:differentSections) accumPatchSize+= p.m_b;

        String prefix = args[2];
        
        System.out.println("  org #0000");
        System.out.println("");
        System.out.println("; number of patches: " + nPatches);
        System.out.println("; accumulated patch size: 1 + 4*" + nPatches + " + " + accumPatchSize + " = " + 
                                (1 + 4*nPatches + accumPatchSize));
        System.out.println(prefix + "_n_patches:");
        System.out.println("  db " + nPatches);
        for(int i = 0;i<differentSections.size();i++) {
            Pair<Integer,Integer> patch = differentSections.get(i);
            System.out.println(prefix + "_patch_" + (i+1) + "_start:");
            System.out.println("  dw " + patch.m_a);
            System.out.println(prefix + "_patch_" + (i+1) + "_length:");
            System.out.println("  dw " + patch.m_b);
            System.out.println(prefix + "_patch_" + (i+1) + "_data:");
            System.out.print("  db ");
            boolean comma = false;
            for(int j = 0;j<patch.m_b;j++) {
                if (comma) System.out.print(", ");
                System.out.print("" + CHRTBL2[patch.m_a+j]);
                if ((j%16)==15) {
                    if (j == patch.m_b-1) {
                        System.out.print("\n");                        
                    } else {
                        System.out.print("\n  db ");
                    }
                    comma = false;
                } else {
                    comma = true;
                }
            }
            if (comma) System.out.println("");
        }
    }
    
    
    public static void generateCHRandCLRTable(BufferedImage image, int[] CHRTBL1) throws Exception {
        for(int i = 0;i<num_patterns;i++) {
            int x = i%patterns_per_line;
            int y = i/patterns_per_line;
            
            generateCHRandCLRTable(image, x, y, i, CHRTBL1);
        }        
    }


    public static void generateCHRandCLRTable(BufferedImage image, int x, int y, int idx, int[] CHRTBL1) throws Exception {
        List<Integer> differentColors = new ArrayList<>();
        List<Integer> previousColors = null;
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
            CHRTBL1[idx*PH + i] = bitmap;
            CHRTBL1[num_patterns*PH + idx*PH + i] = differentColors.get(0) + 16*differentColors.get(1);
            previousColors = differentColors;
        }    
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


    public static int findMSXColor(int x, int y, BufferedImage image) {
        int color = image.getRGB(x, y);
        int r = (color & 0xff0000)>>16;
        int g = (color & 0x00ff00)>>8;
        int b = color & 0x0000ff;
        for(int i = 0;i<MSX1Palette.length;i++) {
            if (r==MSX1Palette[i][0] &&
                g==MSX1Palette[i][1] &&
                b==MSX1Palette[i][2]) {
                return i;
            }
        }
        return -1;
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

    private static List<Pair<Integer, Integer>> findDifferentSections(int[] CHRTBL1, int[] CHRTBL2) {
        List<Pair<Integer, Integer>> differentSections = new ArrayList<>();
        
        int size = num_patterns*PH*2;
        boolean insideADifferentSection = false;
        int firstDifferent = -1;
        int numEqualInARow = 0;
        
        for(int i = 0;i<size;i++) {
            if (CHRTBL1[i] == CHRTBL2[i]) {
                if (insideADifferentSection) {
                    numEqualInARow++;
                    if (numEqualInARow>4) {
                        differentSections.add(new Pair<>(firstDifferent,1+(i-firstDifferent)-numEqualInARow));
                        insideADifferentSection = false;
                    }
                }
            } else {
                if (!insideADifferentSection) {
                    firstDifferent = i;
                    insideADifferentSection = true;
                }
                numEqualInARow = 0;
            }
        }
        if (insideADifferentSection) {
            differentSections.add(new Pair<>(firstDifferent,(size-firstDifferent)-numEqualInARow));
        }
        
        return differentSections;
    }

}
