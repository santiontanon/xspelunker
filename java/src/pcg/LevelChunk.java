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
import org.jdom.Element;
import org.jdom.input.SAXBuilder;

/**
 *
 * @author santi
 */
public class LevelChunk {
    public int width, height;
    public int[][] layer1;
    public int[][] layer2 = null;  // I hardcode only the use of two layers, since I really only need one, and the second is only
                                   // for debugging purposes (to create TMX files to visualize the output of the generator before
                                   // translating it to an assembler file)
    public List<Item> items;
    
    public LevelChunk(int w, int h) {
        width = w;
        height = h;
        layer1 = new int[width][height];
        items = new ArrayList<>();
    }    


    public LevelChunk(String TMXFileName) throws Exception {
        Element e = new SAXBuilder().build(TMXFileName).getRootElement();
        
        width = Integer.parseInt(e.getAttributeValue("width"));
        height = Integer.parseInt(e.getAttributeValue("height"));;
        layer1 = new int[width][height];
        items = new ArrayList<>();
        
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
        
        Element objects_e = e.getChild("objectgroup");
        if (objects_e!=null) {
            for(Object o_o:objects_e.getChildren()) {
                Element object_e = (Element)o_o;
                int x = Integer.parseInt(object_e.getAttributeValue("x"));
                int y = Integer.parseInt(object_e.getAttributeValue("y"));
                String types = object_e.getAttributeValue("name");
                List<String> typeList = new ArrayList<>();
                for(String type:types.split(",")) typeList.add(type);
                Item item = new Item(x,y,types,typeList);
                items.add(item);
            }
        }
    }
    
    
    public boolean emptySpace(int x0, int y0, int width, int height)
    {
        for(int y = 0;y<height;y++) {
            for(int x = 0;x<width;x++) {
                if (!isBackground(layer1[x0+x][y0+y])) return false;
                for(Item item:items) {
                    if (item.types.get(0).equals("boulder") && 
                        item.x<=x0+x && item.x+1>=x0+x &&
                        item.y<=y0+y && item.y+1>=y0+y) return false;
                }
            }
        }
        return true;
    }
    
    
    public void instantiate(LevelChunk c, int x0, int y0, Random r) throws Exception {
        for(int x = 0;x<c.width;x++) {
            for(int y = 0;y<c.height;y++) {
                if (c.layer1[x][y]>1) layer1[x0+x][y0+y] = c.layer1[x][y];
            }
        }
        
        for(Item item:c.items) {
            Item i2 = item.instantiate(r);
            if (i2!=null) {
                i2.x += x0*8;
                i2.y += y0*8;
                items.add(i2);
            }
        }
    }
    
    
    public boolean isBackground(int tile)
    {
        return tile<=(113+1);
    }


    public boolean isWall(int tile)
    {
        return tile>=(140+1);
    }
    
    
    public boolean isRock(int tile) 
    {
        return tile>=(140+1) && tile<=(151+1);
    }
    
    
    public boolean isBranch(int tile)
    {
        return tile>=(136+1) && tile<=(139+1);
    }
    

    public boolean isWater(int tile)
    {
        return tile>=(128+1) && tile<=(131+1);
    }   

    public boolean isPlatform(int tile)
    {
        return tile>=(136+1) && tile<=(139+1);
    }   
    
    
    public void saveTMX(String TMCFileName, String tileSetPaths[]) throws Exception {
        FileWriter fw = new FileWriter(new File(TMCFileName));
        fw.write("<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n");
        fw.write("<map version=\"1.0\" orientation=\"orthogonal\" renderorder=\"right-down\" width=\""+width+"\" height=\""+height+"\" tilewidth=\"8\" tileheight=\"8\" nextobjectid=\"1\">\n");
        int firstID = 1;
        for(String tileSetPath:tileSetPaths) {
            fw.write("<tileset firstgid=\""+firstID+"\" name=\"tiles\" tilewidth=\"8\" tileheight=\"8\" tilecount=\"256\" columns=\"16\">\n");
            fw.write("<image source=\""+tileSetPath+"\" width=\"128\" height=\"128\"/>\n");
            fw.write("</tileset>\n");
            firstID+=256;
        }
        fw.write("<layer name=\"Tile Layer 1\" width=\""+width+"\" height=\""+height+"\">\n");
        fw.write("<data encoding=\"csv\">\n");
        for(int i = 0;i<height;i++) {
            for(int j = 0;j<width;j++) {
                if (i<height-1 || j<width-1) fw.write(layer1[j][i] + ",");
                                                             else fw.write(layer1[j][i] + "");
            }
            fw.write("\n");
        }        
        fw.write("</data>\n");
        fw.write("</layer>\n");
        if (layer2!=null) {
            fw.write("<layer name=\"Tile Layer 2\" width=\""+width+"\" height=\""+height+"\">\n");
            fw.write("<data encoding=\"csv\">\n");
            for(int i = 0;i<height;i++) {
                for(int j = 0;j<width;j++) {
                    if (i<height-1 || j<width-1) fw.write(layer2[j][i] + ",");
                                                                 else fw.write(layer2[j][i] + "");
                }
                fw.write("\n");
            }        
            fw.write("</data>\n");
            fw.write("</layer>\n");
        }
        fw.write("<objectgroup name=\"Object Layer 1\">\n");
        int item_ID = 1;
        for(Item item:items) {
            fw.write("<object id=\""+item_ID+"\" name=\"");
            String name = "";
            boolean first = true;
            for(String type:item.types) {
                if (!first) name+=",";
                name += type;
                first = false;
            }
            fw.write(name + "\" x=\""+item.x+"\" y=\""+item.y+"\" width=\"16\" height=\"16\"/>\n");
            item_ID++;
        }
        fw.write("</objectgroup>\n");
        fw.write("</map>\n");
        fw.flush();
        fw.close();    
    }
}
