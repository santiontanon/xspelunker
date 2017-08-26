
import java.io.BufferedReader;
import java.io.FileReader;
import java.util.Random;

/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

/**
 *
 * @author santi
 */
public class GenerateLetter {
    public static void main(String args[]) throws Exception {
        Random r = new Random();
        BufferedReader br = new BufferedReader(new FileReader(args[0]));
        int patterns[][] = new int[32][24];
        
        // clear the letter:
        for(int i = 0;i<24;i++) {
            for(int j = 0;j<32;j++) {
                patterns[j][i] = ' ';
            }
        }
        
        // create the frame:
        patterns[0][0] = 144;
        patterns[31][0] = 147;
        patterns[0][23] = 152;
        patterns[31][23] = 155;
        for(int i = 1;i<31;i++) {
            if (r.nextInt(8)==0) patterns[i][0] = 146;
                            else patterns[i][0] = 145;
            if (r.nextInt(8)==0) patterns[i][23] = 154;
                            else patterns[i][23] = 153;
        }
        for(int i = 1;i<23;i++) {
            if (r.nextInt(8)==0) patterns[0][i] = 149;
                            else patterns[0][i] = 148;
            if (r.nextInt(8)==0) patterns[31][i] = 151;
                            else patterns[31][i] = 150;
        }
        
        // add the text: 
        {
            int i = 0;
            while(true) {
                String line = br.readLine();
                if (line==null) break;
                for(int j = 0;j<line.length();j++) {
                    patterns[j+1][i+1] = line.charAt(j);
                }
                i++;
            }
        }
        
        // save the data as an ASM file:
        System.out.println("  org #0000");
        System.out.println("letter:");
        for(int i = 0;i<24;i++) {
            System.out.print("  db " + patterns[0][i]);
            for(int j = 1;j<32;j++) {
                System.out.print("," + patterns[j][i]);
            }
            System.out.println("");
        }
    }
}
