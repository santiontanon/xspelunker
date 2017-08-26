/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package pcg;

import java.util.ArrayList;
import java.util.List;
import java.util.Random;
import utils.Sampler;

/**
 *
 * @author santi
 */
public class Item {
    public int x,y;
    public List<String> types;   // this is a list, since an item in a map can specify a choice of types
    public String type_string = null;
    
    public Item(int a_x, int a_y, String a_type_string, List<String> a_types) {
        x = a_x;
        y = a_y;
        types = a_types;
        type_string = a_type_string;
    }
    
    
    public Item instantiate(Random r) throws Exception {
        if (types.isEmpty()) return null;
        List<String> l = new ArrayList<>();
        List<Double> weights = new ArrayList<>();
        List<String> values = new ArrayList<>();
        
        for(String type:types) {
            String []tokens = type.split(":");
            if (tokens.length==1) {
                weights.add(1.0);
                values.add(tokens[0]);
            } else {
                weights.add(Double.parseDouble(tokens[1]));
                values.add(tokens[0]);
            }
        }
        
        String type = (String)Sampler.weighted(weights, values);            
        if (type.equals("")) return null;
        l.add(type);
        return new Item(x,y,type_string, l);
    }
}
