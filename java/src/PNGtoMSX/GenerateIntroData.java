/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package PNGtoMSX;

import java.awt.image.BufferedImage;
import java.io.File;
import java.util.ArrayList;
import javax.imageio.ImageIO;
import org.jdom.Element;
import org.jdom.input.SAXBuilder;

/**
 *
 * @author santi
 */
public class GenerateIntroData {
    public static void main(String args[]) throws Exception {
        System.out.println("  org #0000");
        generateIntroPatternData(args[0]);
        ConvertPNGtoAssemblerSprites.convert(args[1], "intro_sprites_");
    }
    
    
    public static void generateIntroPatternData(String TMXFileName) throws Exception {
        Element e = new SAXBuilder().build(TMXFileName).getRootElement();
        
        int width = Integer.parseInt(e.getAttributeValue("width"));
        int height = Integer.parseInt(e.getAttributeValue("height"));;
        int layer1[][] = new int[width][height];
        
        Element layer_e = e.getChild("layer");
        Element data_e = layer_e.getChild("data");
        if (data_e.getAttributeValue("encoding").equals("csv")) {
            String data = data_e.getValue().trim();
            String lines[] = data.split("\n");
            for(int i=0;i<height;i++) {
                String values[] = lines[i].split(",");
//                System.out.println(Arrays.toString(values));
                for(int j = 0;j<width;j++) {
                    layer1[j][i] = Integer.parseInt(values[j]);
                }
            }
        } else {
            int i = 0, j = 0;
            for(Object o2:data_e.getChildren("tile")) {
                Element tile_e = (Element)o2;
                int id = Integer.parseInt(tile_e.getAttributeValue("gid"))-1;
                if (id<0) id = 0;
                layer1[j][i] = id;
                j++;
                if (j>=width) {
                    j = 0;
                    i++;
                }
            }
        }    
        System.out.println("intro_patterns:");
        for(int i = 0;i<height;i++) {
            System.out.print("  db " + (layer1[0][i]-1));
            for(int j = 1;j<width;j++) {
                System.out.print("," + (layer1[j][i]-1));
            }
            System.out.println();
        }
    }
}
