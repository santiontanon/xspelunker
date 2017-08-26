/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package music;

import java.io.File;
import java.io.PrintStream;
import java.util.List;

/**
 *
 * @author santi
 */
public class XSpelunkyMusic {
    
    
    public static void main(String args[]) throws Exception {
        String path = args[0];
        MSXSong s1 = SpelunkIntroSong();
        PrintStream w1 = new PrintStream(new File(path+"/spelunk-intro-song.asm"));
        s1.convertToAssembler("spelunk_intro_song", w1);
        w1.close();  

        MSXSong s2 = SpelunkGameStartSong();
        PrintStream w2 = new PrintStream(new File(path+"/spelunk-gamestart-song.asm"));
        s2.convertToAssembler("spelunk_gamestart_song", w2);
        w2.close();  

        MSXSong s3 = SpelunkLetterSong();
        PrintStream w3 = new PrintStream(new File(path+"/spelunk-letter-song.asm"));
        s3.convertToAssembler("spelunk_letter_song", w3);
        w3.close();  

        MSXSong s4 = SpelunkGameOverSong();
        PrintStream w4 = new PrintStream(new File(path+"/spelunk-gameover-song.asm"));
        s4.convertToAssembler("spelunk_gameover_song", w4);
        w4.close();  

        MSXSong s5 = SpelunkInGameSong();
        PrintStream w5 = new PrintStream(new File(path+"/spelunk-ingame-song.asm"));
        s5.convertToAssembler("spelunk_ingame_song", w5);
        w5.close();  

        MSXSong s6 = SpelunkInGame2Song();
        PrintStream w6 = new PrintStream(new File(path+"/spelunk-ingame2-song.asm"));
        s6.convertToAssembler("spelunk_ingame2_song", w6);
        w6.close();  
        
    }   
    
    
    public static MSXSong SpelunkIntroSong()
    {
        MSXSong song = new MSXSong();
        List<MSXNote> channel1 = song.channels[0];
        List<MSXNote> channel2 = song.channels[1];
        List<MSXNote> channel3 = song.channels[2];
        
        int ch1_instrument = MSXNote.INSTRUMENT_PIANO;
        int ch2_instrument = MSXNote.INSTRUMENT_SQUARE_WAVE;
        int ch3_instrument = MSXNote.INSTRUMENT_SQUARE_WAVE;

        song.loopBackTime = 0;

        // channel 1:
        channel1.add(new MSXNote(0,MSXNote.LA,15,4, ch1_instrument));
        channel1.add(new MSXNote(3));
        channel1.add(new MSXNote(0,MSXNote.LA,15,1, ch1_instrument));
        channel1.add(new MSXNote(1,MSXNote.DO,15,4, ch1_instrument));
        channel1.add(new MSXNote(3));
        channel1.add(new MSXNote(0,MSXNote.LA,15,1, ch1_instrument));

        channel1.add(new MSXNote(1,MSXNote.DO,15,3, ch1_instrument));
        channel1.add(new MSXNote(1,MSXNote.MI_FLAT,15,1, ch1_instrument));
        channel1.add(new MSXNote(1,MSXNote.MI,15,3, ch1_instrument));
        channel1.add(new MSXNote(1,MSXNote.LA,15,8, ch1_instrument));
        channel1.add(new MSXNote(1,MSXNote.MI,15,1, ch1_instrument));

        channel1.add(new MSXNote(1,MSXNote.LA,15,3, ch1_instrument));
        channel1.add(new MSXNote(1,MSXNote.LA,15,1, ch1_instrument));
        channel1.add(new MSXNote(1,MSXNote.SOL_SHARP,15,3, ch1_instrument));
        channel1.add(new MSXNote(1,MSXNote.SOL_SHARP,15,1, ch1_instrument));
        channel1.add(new MSXNote(1,MSXNote.SOL,15,3, ch1_instrument));
        channel1.add(new MSXNote(1,MSXNote.SOL,15,1, ch1_instrument));
        channel1.add(new MSXNote(1,MSXNote.FA_SHARP,15,3, ch1_instrument));
        channel1.add(new MSXNote(1,MSXNote.FA_SHARP,15,1, ch1_instrument));
        
        channel1.add(new MSXNote(1,MSXNote.FA,15,3, ch1_instrument));
        channel1.add(new MSXNote(1,MSXNote.RE,15,1, ch1_instrument));
        channel1.add(new MSXNote(1,MSXNote.RE_SHARP,15,3, ch1_instrument));
        channel1.add(new MSXNote(1,MSXNote.MI,15,5, ch1_instrument));
        channel1.add(new MSXNote(4));
        
        channel1.add(new MSXNote(0,MSXNote.LA,15,4, ch1_instrument));
        channel1.add(new MSXNote(3));
        channel1.add(new MSXNote(0,MSXNote.LA,15,1, ch1_instrument));
        channel1.add(new MSXNote(1,MSXNote.DO,15,4, ch1_instrument));
        channel1.add(new MSXNote(3));
        channel1.add(new MSXNote(0,MSXNote.LA,15,1, ch1_instrument));

        channel1.add(new MSXNote(1,MSXNote.DO,15,3, ch1_instrument));
        channel1.add(new MSXNote(1,MSXNote.MI_FLAT,15,1, ch1_instrument));
        channel1.add(new MSXNote(1,MSXNote.MI,15,3, ch1_instrument));
        channel1.add(new MSXNote(1,MSXNote.LA,15,8, ch1_instrument));
        channel1.add(new MSXNote(1,MSXNote.MI,15,1, ch1_instrument));

        channel1.add(new MSXNote(1,MSXNote.LA,15,3, ch1_instrument));
        channel1.add(new MSXNote(1,MSXNote.LA,15,1, ch1_instrument));
        channel1.add(new MSXNote(1,MSXNote.SOL_SHARP,15,3, ch1_instrument));
        channel1.add(new MSXNote(1,MSXNote.SOL_SHARP,15,1, ch1_instrument));
        channel1.add(new MSXNote(1,MSXNote.SOL,15,3, ch1_instrument));
        channel1.add(new MSXNote(1,MSXNote.SOL,15,1, ch1_instrument));
        channel1.add(new MSXNote(1,MSXNote.FA_SHARP,15,3, ch1_instrument));
        channel1.add(new MSXNote(1,MSXNote.FA_SHARP,15,1, ch1_instrument));
        
        channel1.add(new MSXNote(1,MSXNote.FA_SHARP,15,3, ch1_instrument));
        channel1.add(new MSXNote(1,MSXNote.MI,15,1, ch1_instrument));
        channel1.add(new MSXNote(1,MSXNote.DO,15,3, ch1_instrument));
        channel1.add(new MSXNote(0,MSXNote.LA,15,5, ch1_instrument));
        channel1.add(new MSXNote(4));        
        
        // channel 2:
//        channel2.add(new MSXNote(4));   // silence
//        channel2.add(new MSXNote(1,MSXNote.LA,15,2, ch2_instrument));
        
        // channel 3:
        channel3.add(new MSXNote("SFX_OPEN_HIHAT",4));
        channel3.add(new MSXNote("SFX_PEDAL_HIHAT",3));
        channel3.add(new MSXNote("SFX_OPEN_HIHAT",1));
        channel3.add(new MSXNote("SFX_OPEN_HIHAT",4));
        channel3.add(new MSXNote("SFX_PEDAL_HIHAT",3));
        channel3.add(new MSXNote("SFX_OPEN_HIHAT",1));

        channel3.add(new MSXNote("SFX_OPEN_HIHAT",4));
        channel3.add(new MSXNote("SFX_PEDAL_HIHAT",3));
        channel3.add(new MSXNote("SFX_OPEN_HIHAT",1));
        channel3.add(new MSXNote("SFX_OPEN_HIHAT",4));
        channel3.add(new MSXNote("SFX_PEDAL_HIHAT",3));
        channel3.add(new MSXNote("SFX_OPEN_HIHAT",1));

        channel3.add(new MSXNote("SFX_OPEN_HIHAT",4));
        channel3.add(new MSXNote("SFX_PEDAL_HIHAT",3));
        channel3.add(new MSXNote("SFX_OPEN_HIHAT",1));
        channel3.add(new MSXNote("SFX_OPEN_HIHAT",4));
        channel3.add(new MSXNote("SFX_PEDAL_HIHAT",3));
        channel3.add(new MSXNote("SFX_OPEN_HIHAT",1));

        channel3.add(new MSXNote("SFX_OPEN_HIHAT",4));
        channel3.add(new MSXNote("SFX_PEDAL_HIHAT",3));
        channel3.add(new MSXNote("SFX_OPEN_HIHAT",1));
        channel3.add(new MSXNote("SFX_OPEN_HIHAT",4));
        channel3.add(new MSXNote("SFX_PEDAL_HIHAT",3));
        channel3.add(new MSXNote("SFX_OPEN_HIHAT",1));

        channel3.add(new MSXNote("SFX_OPEN_HIHAT",4));
        channel3.add(new MSXNote("SFX_PEDAL_HIHAT",3));
        channel3.add(new MSXNote("SFX_OPEN_HIHAT",1));
        channel3.add(new MSXNote("SFX_OPEN_HIHAT",4));
        channel3.add(new MSXNote("SFX_PEDAL_HIHAT",3));
        channel3.add(new MSXNote("SFX_OPEN_HIHAT",1));

        channel3.add(new MSXNote("SFX_OPEN_HIHAT",4));
        channel3.add(new MSXNote("SFX_PEDAL_HIHAT",3));
        channel3.add(new MSXNote("SFX_OPEN_HIHAT",1));
        channel3.add(new MSXNote("SFX_OPEN_HIHAT",4));
        channel3.add(new MSXNote("SFX_PEDAL_HIHAT",3));
        channel3.add(new MSXNote("SFX_OPEN_HIHAT",1));

        channel3.add(new MSXNote("SFX_OPEN_HIHAT",4));
        channel3.add(new MSXNote("SFX_PEDAL_HIHAT",3));
        channel3.add(new MSXNote("SFX_OPEN_HIHAT",1));
        channel3.add(new MSXNote("SFX_OPEN_HIHAT",4));
        channel3.add(new MSXNote("SFX_PEDAL_HIHAT",3));
        channel3.add(new MSXNote("SFX_OPEN_HIHAT",1));

        channel3.add(new MSXNote("SFX_OPEN_HIHAT",4));
        channel3.add(new MSXNote("SFX_PEDAL_HIHAT",3));
        channel3.add(new MSXNote("SFX_OPEN_HIHAT",1));
        channel3.add(new MSXNote("SFX_OPEN_HIHAT",4));
        channel3.add(new MSXNote("SFX_PEDAL_HIHAT",3));
        channel3.add(new MSXNote("SFX_OPEN_HIHAT",1));
        
        return song;
    }
    
    
    public static MSXSong SpelunkGameStartSong()
    {
        MSXSong song = new MSXSong();
        List<MSXNote> channel1 = song.channels[0];
        List<MSXNote> channel2 = song.channels[1];
        List<MSXNote> channel3 = song.channels[2];
        
        int ch1_instrument = MSXNote.INSTRUMENT_PIANO;
        int ch2_instrument = MSXNote.INSTRUMENT_PIANO;
        int ch3_instrument = MSXNote.INSTRUMENT_PIANO;

//        song.loopBackTime = 0;

        // channel 1:
        channel1.add(new MSXNote(3,MSXNote.RE,15,2, ch1_instrument));
        channel1.add(new MSXNote(3,MSXNote.RE,15,1, ch1_instrument));
        channel1.add(new MSXNote(3,MSXNote.RE,15,1, ch1_instrument));
        channel1.add(new MSXNote(3,MSXNote.RE,15,2, ch1_instrument));
        channel1.add(new MSXNote(3,MSXNote.MI,15,2, ch1_instrument));
        
        channel1.add(new MSXNote(3,MSXNote.FA,15,2, ch1_instrument));
        channel1.add(new MSXNote(3,MSXNote.MI,15,2, ch1_instrument));
        channel1.add(new MSXNote(3,MSXNote.FA,15,2, ch1_instrument));
        channel1.add(new MSXNote(3,MSXNote.SOL,15,2, ch1_instrument));
        
        channel1.add(new MSXNote(3,MSXNote.LA,15,8, ch1_instrument));
        

        // channels 2/3:
        channel2.add(new MSXNote(1,MSXNote.RE,15,4, ch2_instrument));
        channel3.add(new MSXNote(1,MSXNote.LA,15,4, ch3_instrument));

        channel2.add(new MSXNote(1,MSXNote.RE,15,4, ch2_instrument));
        channel3.add(new MSXNote(1,MSXNote.LA,15,4, ch3_instrument));

        channel2.add(new MSXNote(1,MSXNote.DO,15,4, ch2_instrument));
        channel3.add(new MSXNote(1,MSXNote.LA,15,4, ch3_instrument));

        channel2.add(new MSXNote(1,MSXNote.DO,15,4, ch2_instrument));
        channel3.add(new MSXNote(1,MSXNote.LA,15,4, ch3_instrument));

        channel2.add(new MSXNote(1,MSXNote.MI,15,8, ch2_instrument));
        channel3.add(new MSXNote(1,MSXNote.LA,15,8, ch3_instrument));

        channel1.add(new MSXNote(1));
        channel2.add(new MSXNote(1));
        channel3.add(new MSXNote(1));
        
        return song;
    }    


    public static MSXSong SpelunkLetterSong()
    {
        MSXSong song = new MSXSong();
        List<MSXNote> channel1 = song.channels[0];
        List<MSXNote> channel2 = song.channels[1];
        List<MSXNote> channel3 = song.channels[2];
        
        int ch1_instrument = MSXNote.INSTRUMENT_WIND;
        int ch2_instrument = MSXNote.INSTRUMENT_PIANO;
        int ch3_instrument = MSXNote.INSTRUMENT_SQUARE_WAVE;

        song.loopBackTime = 0;

        // channel 1:
        channel1.add(new MSXNote(64));

        channel1.add(new MSXNote(3,MSXNote.LA,15,16+8, ch1_instrument));
        channel1.add(new MSXNote(3,MSXNote.FA,15,8, ch1_instrument));
        channel1.add(new MSXNote(3,MSXNote.SOL,15,16, ch1_instrument));
        channel1.add(new MSXNote(3,MSXNote.MI,15,16, ch1_instrument));
        channel1.add(new MSXNote(3,MSXNote.LA,15,16+8, ch1_instrument));
        channel1.add(new MSXNote(3,MSXNote.FA,15,8, ch1_instrument));
        channel1.add(new MSXNote(3,MSXNote.SOL,15,16, ch1_instrument));
        channel1.add(new MSXNote(3,MSXNote.FA,15,8, ch1_instrument));
        channel1.add(new MSXNote(3,MSXNote.MI,15,8, ch1_instrument));
        channel1.add(new MSXNote(3,MSXNote.RE,15,32, ch1_instrument));
        channel1.add(new MSXNote(32));
        
        channel1.add(new MSXNote(3,MSXNote.LA,15,16+8, ch1_instrument));
        channel1.add(new MSXNote(3,MSXNote.LA,15,4, ch1_instrument));
        channel1.add(new MSXNote(3,MSXNote.SI,15,4, ch1_instrument));
        channel1.add(new MSXNote(4,MSXNote.DO,15,16, ch1_instrument));
        channel1.add(new MSXNote(3,MSXNote.SOL,15,16, ch1_instrument));
        channel1.add(new MSXNote(3,MSXNote.LA,15,16+8, ch1_instrument));
        channel1.add(new MSXNote(3,MSXNote.LA,15,4, ch1_instrument));
        channel1.add(new MSXNote(3,MSXNote.SI,15,4, ch1_instrument));
        channel1.add(new MSXNote(4,MSXNote.DO,15,16+8, ch1_instrument));
        channel1.add(new MSXNote(4,MSXNote.DO,15,4, ch1_instrument));
        channel1.add(new MSXNote(4,MSXNote.RE,15,4, ch1_instrument));
        channel1.add(new MSXNote(3,MSXNote.SI,15,16+8, ch1_instrument));
        channel1.add(new MSXNote(3,MSXNote.SOL,15,8, ch1_instrument));
        channel1.add(new MSXNote(3,MSXNote.LA,15,16+8, ch1_instrument));
        channel1.add(new MSXNote(3,MSXNote.SOL,15,4, ch1_instrument));
        channel1.add(new MSXNote(3,MSXNote.FA,15,4, ch1_instrument));
        channel1.add(new MSXNote(3,MSXNote.MI,15,32, ch1_instrument));
        
        // channels 2/3:
        for(int i = 0;i<3;i++) {
            channel2.add(new MSXNote(2,MSXNote.RE,15,2, ch2_instrument));
            channel2.add(new MSXNote(2,MSXNote.FA,15,2, ch2_instrument));
            channel2.add(new MSXNote(2,MSXNote.LA,15,2, ch2_instrument));
            channel2.add(new MSXNote(2,MSXNote.FA,15,2, ch2_instrument));
            channel2.add(new MSXNote(3,MSXNote.RE,15,2, ch2_instrument));
            channel2.add(new MSXNote(2,MSXNote.LA,15,2, ch2_instrument));
            channel2.add(new MSXNote(2,MSXNote.FA,15,2, ch2_instrument));
            channel2.add(new MSXNote(2,MSXNote.LA,15,2, ch2_instrument));
            channel3.add(new MSXNote(1,MSXNote.RE,8,16, ch3_instrument));

            channel2.add(new MSXNote(2,MSXNote.RE,15,2, ch2_instrument));
            channel2.add(new MSXNote(2,MSXNote.FA,15,2, ch2_instrument));
            channel2.add(new MSXNote(2,MSXNote.LA,15,2, ch2_instrument));
            channel2.add(new MSXNote(2,MSXNote.FA,15,2, ch2_instrument));
            channel2.add(new MSXNote(3,MSXNote.RE,15,2, ch2_instrument));
            channel2.add(new MSXNote(2,MSXNote.LA,15,2, ch2_instrument));
            channel2.add(new MSXNote(2,MSXNote.FA,15,2, ch2_instrument));
            channel2.add(new MSXNote(2,MSXNote.LA,15,2, ch2_instrument));
            channel3.add(new MSXNote(1,MSXNote.RE,8,16, ch3_instrument));

            channel2.add(new MSXNote(2,MSXNote.DO,15,2, ch2_instrument));
            channel2.add(new MSXNote(2,MSXNote.MI,15,2, ch2_instrument));
            channel2.add(new MSXNote(2,MSXNote.SOL,15,2, ch2_instrument));
            channel2.add(new MSXNote(2,MSXNote.MI,15,2, ch2_instrument));
            channel2.add(new MSXNote(3,MSXNote.DO,15,2, ch2_instrument));
            channel2.add(new MSXNote(2,MSXNote.SOL,15,2, ch2_instrument));
            channel2.add(new MSXNote(2,MSXNote.MI,15,2, ch2_instrument));
            channel2.add(new MSXNote(2,MSXNote.SOL,15,2, ch2_instrument));
            channel3.add(new MSXNote(1,MSXNote.DO,8,16, ch3_instrument));

            channel2.add(new MSXNote(2,MSXNote.DO,15,2, ch2_instrument));
            channel2.add(new MSXNote(2,MSXNote.MI,15,2, ch2_instrument));
            channel2.add(new MSXNote(2,MSXNote.SOL,15,2, ch2_instrument));
            channel2.add(new MSXNote(2,MSXNote.MI,15,2, ch2_instrument));
            channel2.add(new MSXNote(3,MSXNote.DO,15,2, ch2_instrument));
            channel2.add(new MSXNote(2,MSXNote.SOL,15,2, ch2_instrument));
            channel2.add(new MSXNote(2,MSXNote.MI,15,2, ch2_instrument));
            channel2.add(new MSXNote(2,MSXNote.SOL,15,2, ch2_instrument));
            channel3.add(new MSXNote(1,MSXNote.DO,8,16, ch3_instrument));            
        }
        channel2.add(new MSXNote(2,MSXNote.RE,15,2, ch2_instrument));
        channel2.add(new MSXNote(2,MSXNote.FA,15,2, ch2_instrument));
        channel2.add(new MSXNote(2,MSXNote.LA,15,2, ch2_instrument));
        channel2.add(new MSXNote(2,MSXNote.FA,15,2, ch2_instrument));
        channel2.add(new MSXNote(3,MSXNote.RE,15,2, ch2_instrument));
        channel2.add(new MSXNote(2,MSXNote.LA,15,2, ch2_instrument));
        channel2.add(new MSXNote(2,MSXNote.FA,15,2, ch2_instrument));
        channel2.add(new MSXNote(2,MSXNote.LA,15,2, ch2_instrument));
        channel3.add(new MSXNote(1,MSXNote.RE,8,16, ch3_instrument));

        channel2.add(new MSXNote(2,MSXNote.RE,15,2, ch2_instrument));
        channel2.add(new MSXNote(2,MSXNote.FA,15,2, ch2_instrument));
        channel2.add(new MSXNote(2,MSXNote.LA,15,2, ch2_instrument));
        channel2.add(new MSXNote(2,MSXNote.FA,15,2, ch2_instrument));
        channel2.add(new MSXNote(3,MSXNote.RE,15,2, ch2_instrument));
        channel2.add(new MSXNote(2,MSXNote.LA,15,2, ch2_instrument));
        channel2.add(new MSXNote(2,MSXNote.FA,15,2, ch2_instrument));
        channel2.add(new MSXNote(2,MSXNote.LA,15,2, ch2_instrument));
        channel3.add(new MSXNote(1,MSXNote.RE,8,16, ch3_instrument));

        channel2.add(new MSXNote(2,MSXNote.DO,15,2, ch2_instrument));
        channel2.add(new MSXNote(2,MSXNote.MI,15,2, ch2_instrument));
        channel2.add(new MSXNote(2,MSXNote.SOL,15,2, ch2_instrument));
        channel2.add(new MSXNote(2,MSXNote.MI,15,2, ch2_instrument));
        channel2.add(new MSXNote(3,MSXNote.DO,15,2, ch2_instrument));
        channel2.add(new MSXNote(2,MSXNote.SOL,15,2, ch2_instrument));
        channel2.add(new MSXNote(2,MSXNote.MI,15,2, ch2_instrument));
        channel2.add(new MSXNote(2,MSXNote.SOL,15,2, ch2_instrument));
        channel3.add(new MSXNote(1,MSXNote.DO,8,16, ch3_instrument));
        
        channel2.add(new MSXNote(2,MSXNote.DO,15,2, ch2_instrument));
        channel2.add(new MSXNote(2,MSXNote.MI,15,2, ch2_instrument));
        channel2.add(new MSXNote(2,MSXNote.SOL,15,2, ch2_instrument));
        channel2.add(new MSXNote(2,MSXNote.MI,15,2, ch2_instrument));
        channel2.add(new MSXNote(3,MSXNote.DO,15,2, ch2_instrument));
        channel2.add(new MSXNote(2,MSXNote.SOL,15,2, ch2_instrument));
        channel2.add(new MSXNote(2,MSXNote.MI,15,2, ch2_instrument));
        channel2.add(new MSXNote(2,MSXNote.SOL,15,2, ch2_instrument));
        channel3.add(new MSXNote(1,MSXNote.DO,8,16, ch3_instrument));

        channel2.add(new MSXNote(2,MSXNote.RE,15,2, ch2_instrument));
        channel2.add(new MSXNote(2,MSXNote.FA,15,2, ch2_instrument));
        channel2.add(new MSXNote(2,MSXNote.LA,15,2, ch2_instrument));
        channel2.add(new MSXNote(2,MSXNote.FA,15,2, ch2_instrument));
        channel2.add(new MSXNote(3,MSXNote.RE,15,2, ch2_instrument));
        channel2.add(new MSXNote(2,MSXNote.LA,15,2, ch2_instrument));
        channel2.add(new MSXNote(2,MSXNote.FA,15,2, ch2_instrument));
        channel2.add(new MSXNote(2,MSXNote.LA,15,2, ch2_instrument));
        channel3.add(new MSXNote(1,MSXNote.RE,8,16, ch3_instrument));

        channel2.add(new MSXNote(2,MSXNote.RE,15,2, ch2_instrument));
        channel2.add(new MSXNote(2,MSXNote.FA,15,2, ch2_instrument));
        channel2.add(new MSXNote(2,MSXNote.LA,15,2, ch2_instrument));
        channel2.add(new MSXNote(2,MSXNote.FA,15,2, ch2_instrument));
        channel2.add(new MSXNote(3,MSXNote.RE,15,2, ch2_instrument));
        channel2.add(new MSXNote(2,MSXNote.LA,15,2, ch2_instrument));
        channel2.add(new MSXNote(2,MSXNote.FA,15,2, ch2_instrument));
        channel2.add(new MSXNote(2,MSXNote.LA,15,2, ch2_instrument));
        channel3.add(new MSXNote(1,MSXNote.RE,8,16, ch3_instrument));

        channel2.add(new MSXNote(2,MSXNote.DO,15,2, ch2_instrument));
        channel2.add(new MSXNote(2,MSXNote.MI,15,2, ch2_instrument));
        channel2.add(new MSXNote(2,MSXNote.SOL,15,2, ch2_instrument));
        channel2.add(new MSXNote(2,MSXNote.MI,15,2, ch2_instrument));
        channel2.add(new MSXNote(3,MSXNote.DO,15,2, ch2_instrument));
        channel2.add(new MSXNote(2,MSXNote.SOL,15,2, ch2_instrument));
        channel2.add(new MSXNote(2,MSXNote.MI,15,2, ch2_instrument));
        channel2.add(new MSXNote(2,MSXNote.SOL,15,2, ch2_instrument));
        channel3.add(new MSXNote(1,MSXNote.DO,8,16, ch3_instrument));
        
        channel2.add(new MSXNote(2,MSXNote.DO,15,2, ch2_instrument));
        channel2.add(new MSXNote(2,MSXNote.MI,15,2, ch2_instrument));
        channel2.add(new MSXNote(2,MSXNote.SOL,15,2, ch2_instrument));
        channel2.add(new MSXNote(2,MSXNote.MI,15,2, ch2_instrument));
        channel2.add(new MSXNote(3,MSXNote.DO,15,2, ch2_instrument));
        channel2.add(new MSXNote(2,MSXNote.SOL,15,2, ch2_instrument));
        channel2.add(new MSXNote(2,MSXNote.MI,15,2, ch2_instrument));
        channel2.add(new MSXNote(2,MSXNote.SOL,15,2, ch2_instrument));
        channel3.add(new MSXNote(1,MSXNote.DO,8,16, ch3_instrument));

        channel2.add(new MSXNote(2,MSXNote.FA,15,2, ch2_instrument));
        channel2.add(new MSXNote(2,MSXNote.LA,15,2, ch2_instrument));
        channel2.add(new MSXNote(3,MSXNote.DO,15,2, ch2_instrument));
        channel2.add(new MSXNote(2,MSXNote.LA,15,2, ch2_instrument));
        channel2.add(new MSXNote(3,MSXNote.FA,15,2, ch2_instrument));
        channel2.add(new MSXNote(3,MSXNote.DO,15,2, ch2_instrument));
        channel2.add(new MSXNote(2,MSXNote.LA,15,2, ch2_instrument));
        channel2.add(new MSXNote(3,MSXNote.DO,15,2, ch2_instrument));
        channel3.add(new MSXNote(1,MSXNote.FA,8,16, ch3_instrument));

        channel2.add(new MSXNote(2,MSXNote.FA,15,2, ch2_instrument));
        channel2.add(new MSXNote(2,MSXNote.LA,15,2, ch2_instrument));
        channel2.add(new MSXNote(3,MSXNote.DO,15,2, ch2_instrument));
        channel2.add(new MSXNote(2,MSXNote.LA,15,2, ch2_instrument));
        channel2.add(new MSXNote(3,MSXNote.FA,15,2, ch2_instrument));
        channel2.add(new MSXNote(3,MSXNote.DO,15,2, ch2_instrument));
        channel2.add(new MSXNote(2,MSXNote.LA,15,2, ch2_instrument));
        channel2.add(new MSXNote(3,MSXNote.DO,15,2, ch2_instrument));
        channel3.add(new MSXNote(1,MSXNote.FA,8,16, ch3_instrument));
        
        channel2.add(new MSXNote(2,MSXNote.LA,15,2, ch2_instrument));
        channel2.add(new MSXNote(3,MSXNote.DO,15,2, ch2_instrument));
        channel2.add(new MSXNote(3,MSXNote.MI,15,2, ch2_instrument));
        channel2.add(new MSXNote(3,MSXNote.DO,15,2, ch2_instrument));
        channel2.add(new MSXNote(3,MSXNote.LA,15,2, ch2_instrument));
        channel2.add(new MSXNote(3,MSXNote.MI,15,2, ch2_instrument));
        channel2.add(new MSXNote(3,MSXNote.DO,15,2, ch2_instrument));
        channel2.add(new MSXNote(3,MSXNote.MI,15,2, ch2_instrument));
        channel3.add(new MSXNote(1,MSXNote.LA,8,16, ch3_instrument));
        
        channel2.add(new MSXNote(2,MSXNote.LA,15,2, ch2_instrument));
        channel2.add(new MSXNote(3,MSXNote.DO,15,2, ch2_instrument));
        channel2.add(new MSXNote(3,MSXNote.MI,15,2, ch2_instrument));
        channel2.add(new MSXNote(3,MSXNote.DO,15,2, ch2_instrument));
        channel2.add(new MSXNote(3,MSXNote.LA,15,2, ch2_instrument));
        channel2.add(new MSXNote(3,MSXNote.MI,15,2, ch2_instrument));
        channel2.add(new MSXNote(3,MSXNote.DO,15,2, ch2_instrument));
        channel2.add(new MSXNote(3,MSXNote.MI,15,2, ch2_instrument));
        channel3.add(new MSXNote(1,MSXNote.LA,8,16, ch3_instrument));

        channel2.add(new MSXNote(2,MSXNote.SOL,15,2, ch2_instrument));
        channel2.add(new MSXNote(2,MSXNote.SI,15,2, ch2_instrument));
        channel2.add(new MSXNote(3,MSXNote.RE,15,2, ch2_instrument));
        channel2.add(new MSXNote(2,MSXNote.SI,15,2, ch2_instrument));
        channel2.add(new MSXNote(3,MSXNote.SOL,15,2, ch2_instrument));
        channel2.add(new MSXNote(3,MSXNote.RE,15,2, ch2_instrument));
        channel2.add(new MSXNote(2,MSXNote.SI,15,2, ch2_instrument));
        channel2.add(new MSXNote(3,MSXNote.RE,15,2, ch2_instrument));
        channel3.add(new MSXNote(1,MSXNote.SOL,8,16, ch3_instrument));

        channel2.add(new MSXNote(2,MSXNote.SOL,15,2, ch2_instrument));
        channel2.add(new MSXNote(2,MSXNote.SI,15,2, ch2_instrument));
        channel2.add(new MSXNote(3,MSXNote.RE,15,2, ch2_instrument));
        channel2.add(new MSXNote(2,MSXNote.SI,15,2, ch2_instrument));
        channel2.add(new MSXNote(3,MSXNote.SOL,15,2, ch2_instrument));
        channel2.add(new MSXNote(3,MSXNote.RE,15,2, ch2_instrument));
        channel2.add(new MSXNote(2,MSXNote.SI,15,2, ch2_instrument));
        channel2.add(new MSXNote(3,MSXNote.RE,15,2, ch2_instrument));
        channel3.add(new MSXNote(1,MSXNote.SOL,8,16, ch3_instrument));
        
        channel2.add(new MSXNote(2,MSXNote.FA,15,2, ch2_instrument));
        channel2.add(new MSXNote(2,MSXNote.LA,15,2, ch2_instrument));
        channel2.add(new MSXNote(3,MSXNote.DO,15,2, ch2_instrument));
        channel2.add(new MSXNote(2,MSXNote.LA,15,2, ch2_instrument));
        channel2.add(new MSXNote(3,MSXNote.FA,15,2, ch2_instrument));
        channel2.add(new MSXNote(3,MSXNote.DO,15,2, ch2_instrument));
        channel2.add(new MSXNote(2,MSXNote.LA,15,2, ch2_instrument));
        channel2.add(new MSXNote(3,MSXNote.DO,15,2, ch2_instrument));
        channel3.add(new MSXNote(1,MSXNote.FA,8,16, ch3_instrument));

        channel2.add(new MSXNote(2,MSXNote.FA,15,2, ch2_instrument));
        channel2.add(new MSXNote(2,MSXNote.LA,15,2, ch2_instrument));
        channel2.add(new MSXNote(3,MSXNote.DO,15,2, ch2_instrument));
        channel2.add(new MSXNote(2,MSXNote.LA,15,2, ch2_instrument));
        channel2.add(new MSXNote(3,MSXNote.FA,15,2, ch2_instrument));
        channel2.add(new MSXNote(3,MSXNote.DO,15,2, ch2_instrument));
        channel2.add(new MSXNote(2,MSXNote.LA,15,2, ch2_instrument));
        channel2.add(new MSXNote(3,MSXNote.DO,15,2, ch2_instrument));
        channel3.add(new MSXNote(1,MSXNote.FA,8,16, ch3_instrument));
        
        channel2.add(new MSXNote(2,MSXNote.LA,15,2, ch2_instrument));
        channel2.add(new MSXNote(3,MSXNote.DO,15,2, ch2_instrument));
        channel2.add(new MSXNote(3,MSXNote.MI,15,2, ch2_instrument));
        channel2.add(new MSXNote(3,MSXNote.DO,15,2, ch2_instrument));
        channel2.add(new MSXNote(3,MSXNote.LA,15,2, ch2_instrument));
        channel2.add(new MSXNote(3,MSXNote.MI,15,2, ch2_instrument));
        channel2.add(new MSXNote(3,MSXNote.DO,15,2, ch2_instrument));
        channel2.add(new MSXNote(3,MSXNote.MI,15,2, ch2_instrument));
        channel3.add(new MSXNote(1,MSXNote.LA,8,16, ch3_instrument));
        
        channel2.add(new MSXNote(2,MSXNote.LA,15,2, ch2_instrument));
        channel2.add(new MSXNote(3,MSXNote.DO,15,2, ch2_instrument));
        channel2.add(new MSXNote(3,MSXNote.MI,15,2, ch2_instrument));
        channel2.add(new MSXNote(3,MSXNote.DO,15,2, ch2_instrument));
        channel2.add(new MSXNote(3,MSXNote.LA,15,2, ch2_instrument));
        channel2.add(new MSXNote(3,MSXNote.MI,15,2, ch2_instrument));
        channel2.add(new MSXNote(3,MSXNote.DO,15,2, ch2_instrument));
        channel2.add(new MSXNote(3,MSXNote.MI,15,2, ch2_instrument));
        channel3.add(new MSXNote(1,MSXNote.LA,8,16, ch3_instrument));        
        
        return song;
    }    


    public static MSXSong SpelunkGameOverSong()
    {
        MSXSong song = new MSXSong();
        List<MSXNote> channel1 = song.channels[0];
        List<MSXNote> channel2 = song.channels[1];
        List<MSXNote> channel3 = song.channels[2];
        
        int ch1_instrument = MSXNote.INSTRUMENT_PIANO;
        int ch2_instrument = MSXNote.INSTRUMENT_PIANO;
        int ch3_instrument = MSXNote.INSTRUMENT_PIANO;

//        song.loopBackTime = 0;

        // channel 1:
        channel1.add(new MSXNote(4,MSXNote.MI, 15,2, ch1_instrument));
        channel1.add(new MSXNote(4,MSXNote.RE, 15,2, ch1_instrument));
        
        channel1.add(new MSXNote(4,MSXNote.DO, 15,2, ch1_instrument));
        channel1.add(new MSXNote(4,MSXNote.RE, 15,2, ch1_instrument));
        channel1.add(new MSXNote(3,MSXNote.SI, 15,2, ch1_instrument));
        channel1.add(new MSXNote(4,MSXNote.DO, 15,2, ch1_instrument));
        
        channel1.add(new MSXNote(3,MSXNote.SI, 15,3, ch1_instrument));
        channel1.add(new MSXNote(4,MSXNote.DO, 15,3, ch1_instrument));
        channel1.add(new MSXNote(3,MSXNote.LA, 15,4, ch1_instrument));
        channel1.add(new MSXNote(3,MSXNote.SOL,15,6, ch1_instrument));
        
        channel1.add(new MSXNote(3,MSXNote.LA, 15,16, ch1_instrument));
        
        // channels 2/3:
        channel2.add(new MSXNote(4));
        channel3.add(new MSXNote(4));
        
        channel2.add(new MSXNote(2,MSXNote.LA,15,8, ch2_instrument));
        channel3.add(new MSXNote(2,MSXNote.MI,15,8, ch3_instrument));

        channel2.add(new MSXNote(2,MSXNote.SI,15,16, ch2_instrument));
        channel3.add(new MSXNote(2,MSXNote.MI,15,16, ch3_instrument));

        channel2.add(new MSXNote(2,MSXNote.LA,15,16, ch2_instrument));
        channel3.add(new MSXNote(2,MSXNote.MI,15,16, ch3_instrument));

        channel1.add(new MSXNote(1));
        channel2.add(new MSXNote(1));
        channel3.add(new MSXNote(1));
        
        return song;
    }    



    public static MSXSong SpelunkInGameSong()
    {
        MSXSong song = new MSXSong();
        List<MSXNote> channel1 = song.channels[0];
        List<MSXNote> channel2 = song.channels[1];
        List<MSXNote> channel3 = song.channels[2];
        
        int ch1_instrument = MSXNote.INSTRUMENT_PIANO;
        int ch2_instrument = MSXNote.INSTRUMENT_PIANO;
        int ch3_instrument = MSXNote.INSTRUMENT_PIANO;

        song.loopBackTime = 64;

        channel1.add(new MSXNote(3,MSXNote.LA, 15,16, ch1_instrument));
        channel1.add(new MSXNote(4,MSXNote.DO, 15,16, ch1_instrument));        
        channel1.add(new MSXNote(3,MSXNote.SI, 15,16, ch1_instrument));
        channel1.add(new MSXNote(3,MSXNote.SOL_SHARP, 15,16, ch1_instrument));
        channel2.add(new MSXNote(0,MSXNote.LA,15,4, ch2_instrument));
        channel2.add(new MSXNote(0,MSXNote.LA,15,4, ch2_instrument));
        channel2.add(new MSXNote(0,MSXNote.LA,15,4, ch2_instrument));
        channel2.add(new MSXNote(0,MSXNote.LA,15,4, ch2_instrument));
        channel3.add(new MSXNote(16));
        channel2.add(new MSXNote(0,MSXNote.LA,15,4, ch2_instrument));
        channel2.add(new MSXNote(0,MSXNote.LA,15,4, ch2_instrument));
        channel2.add(new MSXNote(0,MSXNote.LA,15,4, ch2_instrument));
        channel2.add(new MSXNote(0,MSXNote.LA,15,4, ch2_instrument));
        channel3.add(new MSXNote(16));
        channel2.add(new MSXNote(0,MSXNote.SOL_SHARP,15,4, ch2_instrument));
        channel2.add(new MSXNote(0,MSXNote.SOL_SHARP,15,4, ch2_instrument));
        channel2.add(new MSXNote(0,MSXNote.SOL_SHARP,15,4, ch2_instrument));
        channel2.add(new MSXNote(0,MSXNote.SOL_SHARP,15,4, ch2_instrument));
        channel3.add(new MSXNote(16));
        channel2.add(new MSXNote(0,MSXNote.SOL_SHARP,15,4, ch2_instrument));
        channel2.add(new MSXNote(0,MSXNote.SOL_SHARP,15,4, ch2_instrument));
        channel2.add(new MSXNote(0,MSXNote.SOL_SHARP,15,4, ch2_instrument));
        channel2.add(new MSXNote(0,MSXNote.SOL_SHARP,15,4, ch2_instrument));
        channel3.add(new MSXNote(16));
        
        
        channel1.add(new MSXNote(3,MSXNote.LA, 15,16, ch1_instrument));
        channel1.add(new MSXNote(4,MSXNote.DO, 15,16, ch1_instrument));        
        channel1.add(new MSXNote(3,MSXNote.SI, 15,16, ch1_instrument));
        channel1.add(new MSXNote(3,MSXNote.SOL_SHARP, 15,16, ch1_instrument));
        channel2.add(new MSXNote(0,MSXNote.LA,15,4, ch2_instrument));
        channel2.add(new MSXNote(0,MSXNote.LA,15,4, ch2_instrument));
        channel2.add(new MSXNote(0,MSXNote.LA,15,4, ch2_instrument));
        channel2.add(new MSXNote(0,MSXNote.LA,15,4, ch2_instrument));
        channel3.add(new MSXNote("SFX_PEDAL_HIHAT",4));
        channel3.add(new MSXNote("SFX_OPEN_HIHAT",2));
        channel3.add(new MSXNote("SFX_PEDAL_HIHAT",2));
        channel3.add(new MSXNote("SFX_PEDAL_HIHAT",4));
        channel3.add(new MSXNote("SFX_OPEN_HIHAT",2));
        channel3.add(new MSXNote("SFX_PEDAL_HIHAT",2));
        channel2.add(new MSXNote(0,MSXNote.LA,15,4, ch2_instrument));
        channel2.add(new MSXNote(0,MSXNote.LA,15,4, ch2_instrument));
        channel2.add(new MSXNote(0,MSXNote.LA,15,4, ch2_instrument));
        channel2.add(new MSXNote(0,MSXNote.LA,15,4, ch2_instrument));
        channel3.add(new MSXNote("SFX_PEDAL_HIHAT",4));
        channel3.add(new MSXNote("SFX_OPEN_HIHAT",2));
        channel3.add(new MSXNote("SFX_PEDAL_HIHAT",2));
        channel3.add(new MSXNote("SFX_PEDAL_HIHAT",4));
        channel3.add(new MSXNote("SFX_OPEN_HIHAT",2));
        channel3.add(new MSXNote("SFX_PEDAL_HIHAT",2));
        channel2.add(new MSXNote(0,MSXNote.SOL_SHARP,15,4, ch2_instrument));
        channel2.add(new MSXNote(0,MSXNote.SOL_SHARP,15,4, ch2_instrument));
        channel2.add(new MSXNote(0,MSXNote.SOL_SHARP,15,4, ch2_instrument));
        channel2.add(new MSXNote(0,MSXNote.SOL_SHARP,15,4, ch2_instrument));
        channel3.add(new MSXNote("SFX_PEDAL_HIHAT",4));
        channel3.add(new MSXNote("SFX_OPEN_HIHAT",2));
        channel3.add(new MSXNote("SFX_PEDAL_HIHAT",2));
        channel3.add(new MSXNote("SFX_PEDAL_HIHAT",4));
        channel3.add(new MSXNote("SFX_OPEN_HIHAT",2));
        channel3.add(new MSXNote("SFX_PEDAL_HIHAT",2));
        channel2.add(new MSXNote(0,MSXNote.SOL_SHARP,15,4, ch2_instrument));
        channel2.add(new MSXNote(0,MSXNote.SOL_SHARP,15,4, ch2_instrument));
        channel2.add(new MSXNote(0,MSXNote.SOL_SHARP,15,4, ch2_instrument));
        channel2.add(new MSXNote(0,MSXNote.SOL_SHARP,15,4, ch2_instrument));
        channel3.add(new MSXNote("SFX_PEDAL_HIHAT",4));
        channel3.add(new MSXNote("SFX_OPEN_HIHAT",2));
        channel3.add(new MSXNote("SFX_PEDAL_HIHAT",2));
        channel3.add(new MSXNote("SFX_PEDAL_HIHAT",4));
        channel3.add(new MSXNote("SFX_OPEN_HIHAT",2));
        channel3.add(new MSXNote("SFX_PEDAL_HIHAT",2));  
        
        
        channel1.add(new MSXNote(3,MSXNote.LA, 15,16, ch1_instrument));
        channel1.add(new MSXNote(3,MSXNote.FA, 15,16, ch1_instrument));        
        channel1.add(new MSXNote(3,MSXNote.MI, 15,16, ch1_instrument));
        channel1.add(new MSXNote(3,MSXNote.SOL_SHARP, 15,16, ch1_instrument));
        channel2.add(new MSXNote(0,MSXNote.LA,15,4, ch2_instrument));
        channel2.add(new MSXNote(0,MSXNote.LA,15,4, ch2_instrument));
        channel2.add(new MSXNote(0,MSXNote.LA,15,4, ch2_instrument));
        channel2.add(new MSXNote(0,MSXNote.LA,15,4, ch2_instrument));
        channel3.add(new MSXNote("SFX_PEDAL_HIHAT",4));
        channel3.add(new MSXNote("SFX_OPEN_HIHAT",2));
        channel3.add(new MSXNote("SFX_PEDAL_HIHAT",2));
        channel3.add(new MSXNote("SFX_PEDAL_HIHAT",4));
        channel3.add(new MSXNote("SFX_OPEN_HIHAT",2));
        channel3.add(new MSXNote("SFX_PEDAL_HIHAT",2));
        channel2.add(new MSXNote(1,MSXNote.FA,15,4, ch2_instrument));
        channel2.add(new MSXNote(1,MSXNote.FA,15,4, ch2_instrument));
        channel2.add(new MSXNote(1,MSXNote.FA,15,4, ch2_instrument));
        channel2.add(new MSXNote(1,MSXNote.FA,15,4, ch2_instrument));
        channel3.add(new MSXNote("SFX_PEDAL_HIHAT",4));
        channel3.add(new MSXNote("SFX_OPEN_HIHAT",2));
        channel3.add(new MSXNote("SFX_PEDAL_HIHAT",2));
        channel3.add(new MSXNote("SFX_PEDAL_HIHAT",4));
        channel3.add(new MSXNote("SFX_OPEN_HIHAT",2));
        channel3.add(new MSXNote("SFX_PEDAL_HIHAT",2));
        channel2.add(new MSXNote(1,MSXNote.MI,15,4, ch2_instrument));
        channel2.add(new MSXNote(1,MSXNote.MI,15,4, ch2_instrument));
        channel2.add(new MSXNote(1,MSXNote.MI,15,4, ch2_instrument));
        channel2.add(new MSXNote(1,MSXNote.MI,15,4, ch2_instrument));
        channel3.add(new MSXNote("SFX_PEDAL_HIHAT",4));
        channel3.add(new MSXNote("SFX_OPEN_HIHAT",2));
        channel3.add(new MSXNote("SFX_PEDAL_HIHAT",2));
        channel3.add(new MSXNote("SFX_PEDAL_HIHAT",4));
        channel3.add(new MSXNote("SFX_OPEN_HIHAT",2));
        channel3.add(new MSXNote("SFX_PEDAL_HIHAT",2));
        channel2.add(new MSXNote(0,MSXNote.SOL_SHARP,15,4, ch2_instrument));
        channel2.add(new MSXNote(0,MSXNote.SOL_SHARP,15,4, ch2_instrument));
        channel2.add(new MSXNote(0,MSXNote.SOL_SHARP,15,4, ch2_instrument));
        channel2.add(new MSXNote(0,MSXNote.SOL_SHARP,15,4, ch2_instrument));
        channel3.add(new MSXNote("SFX_PEDAL_HIHAT",4));
        channel3.add(new MSXNote("SFX_OPEN_HIHAT",2));
        channel3.add(new MSXNote("SFX_PEDAL_HIHAT",2));
        channel3.add(new MSXNote("SFX_PEDAL_HIHAT",4));
        channel3.add(new MSXNote("SFX_OPEN_HIHAT",2));
        channel3.add(new MSXNote("SFX_PEDAL_HIHAT",2));          

        // transition:
        ch1_instrument = MSXNote.INSTRUMENT_PIANO;
        channel1.add(new MSXNote(3,MSXNote.MI,15,2, ch1_instrument));
        channel2.add(new MSXNote(2,MSXNote.SI,15,2, ch1_instrument));
        channel3.add(new MSXNote(2,MSXNote.SOL_SHARP,15,2, ch1_instrument));

        channel1.add(new MSXNote(3,MSXNote.MI,15,2, ch1_instrument));
        channel2.add(new MSXNote(2,MSXNote.SI,15,2, ch1_instrument));
        channel3.add(new MSXNote(2,MSXNote.SOL_SHARP,15,2, ch1_instrument));

        channel1.add(new MSXNote(3,MSXNote.MI,15,2, ch1_instrument));
        channel2.add(new MSXNote(2,MSXNote.SI,15,2, ch1_instrument));
        channel3.add(new MSXNote(2,MSXNote.SOL_SHARP,15,2, ch1_instrument));

        channel1.add(new MSXNote(3,MSXNote.FA_SHARP,15,4, ch1_instrument));
        channel2.add(new MSXNote(2,MSXNote.SI,15,4, ch1_instrument));
        channel3.add(new MSXNote(2,MSXNote.FA_SHARP,15,4, ch1_instrument));

        channel1.add(new MSXNote(3,MSXNote.SOL_SHARP,15,6, ch1_instrument));
        channel2.add(new MSXNote(2,MSXNote.SI,15,6, ch1_instrument));
        channel3.add(new MSXNote(2,MSXNote.SOL_SHARP,15,6, ch1_instrument));
        
        
        // arpegios plus percusion
        int ch1_volume = 15;
        //for(int j = 0;j<2;j++) 
            channel1.add(new MSXNote(MSXNote.START_REPEAT,2));
            for(int i = 0;i<4;i++) {
                channel1.add(new MSXNote(2,MSXNote.LA, ch1_volume,1, ch1_instrument));
                channel1.add(new MSXNote(2,MSXNote.MI, ch1_volume,1, ch1_instrument));
                channel1.add(new MSXNote(2,MSXNote.LA, ch1_volume,1, ch1_instrument));
                channel1.add(new MSXNote(3,MSXNote.DO, ch1_volume,1, ch1_instrument));
                channel1.add(new MSXNote(3,MSXNote.MI, ch1_volume,1, ch1_instrument));
                channel1.add(new MSXNote(3,MSXNote.DO, ch1_volume,1, ch1_instrument));
                channel1.add(new MSXNote(2,MSXNote.LA, ch1_volume,1, ch1_instrument));
                channel1.add(new MSXNote(2,MSXNote.MI, ch1_volume,1, ch1_instrument));
            }

            for(int i = 0;i<4;i++) {
                channel1.add(new MSXNote(2,MSXNote.SOL_SHARP, ch1_volume,1, ch1_instrument));
                channel1.add(new MSXNote(2,MSXNote.MI, ch1_volume,1, ch1_instrument));
                channel1.add(new MSXNote(2,MSXNote.SOL_SHARP, ch1_volume,1, ch1_instrument));
                channel1.add(new MSXNote(2,MSXNote.SI, ch1_volume,1, ch1_instrument));
                channel1.add(new MSXNote(3,MSXNote.MI, ch1_volume,1, ch1_instrument));
                channel1.add(new MSXNote(2,MSXNote.SI, ch1_volume,1, ch1_instrument));
                channel1.add(new MSXNote(2,MSXNote.SOL_SHARP, ch1_volume,1, ch1_instrument));
                channel1.add(new MSXNote(2,MSXNote.MI, ch1_volume,1, ch1_instrument));
            }   
            channel2.add(new MSXNote(0,MSXNote.LA,15,2, ch2_instrument));
            channel2.add(new MSXNote(1,MSXNote.LA,15,2, ch2_instrument));
            channel2.add(new MSXNote(2,MSXNote.LA,15,2, ch2_instrument));
            channel2.add(new MSXNote(1,MSXNote.LA,15,2, ch2_instrument));
            channel2.add(new MSXNote(0,MSXNote.LA,15,2, ch2_instrument));
            channel2.add(new MSXNote(1,MSXNote.LA,15,2, ch2_instrument));
            channel2.add(new MSXNote(2,MSXNote.LA,15,2, ch2_instrument));
            channel2.add(new MSXNote(1,MSXNote.LA,15,2, ch2_instrument));
            channel3.add(new MSXNote("SFX_PEDAL_HIHAT",4));
            channel3.add(new MSXNote("SFX_OPEN_HIHAT",2));
            channel3.add(new MSXNote("SFX_PEDAL_HIHAT",2));
            channel3.add(new MSXNote("SFX_PEDAL_HIHAT",4));
            channel3.add(new MSXNote("SFX_OPEN_HIHAT",2));
            channel3.add(new MSXNote("SFX_PEDAL_HIHAT",2));
            channel2.add(new MSXNote(1,MSXNote.DO,15,2, ch2_instrument));
            channel2.add(new MSXNote(2,MSXNote.DO,15,2, ch2_instrument));
            channel2.add(new MSXNote(3,MSXNote.DO,15,2, ch2_instrument));
            channel2.add(new MSXNote(2,MSXNote.DO,15,2, ch2_instrument));
            channel2.add(new MSXNote(1,MSXNote.DO,15,2, ch2_instrument));
            channel2.add(new MSXNote(2,MSXNote.DO,15,2, ch2_instrument));
            channel2.add(new MSXNote(3,MSXNote.DO,15,2, ch2_instrument));
            channel2.add(new MSXNote(2,MSXNote.DO,15,2, ch2_instrument));
            channel3.add(new MSXNote("SFX_PEDAL_HIHAT",4));
            channel3.add(new MSXNote("SFX_OPEN_HIHAT",2));
            channel3.add(new MSXNote("SFX_PEDAL_HIHAT",2));
            channel3.add(new MSXNote("SFX_PEDAL_HIHAT",4));
            channel3.add(new MSXNote("SFX_OPEN_HIHAT",2));
            channel3.add(new MSXNote("SFX_PEDAL_HIHAT",2));
            channel2.add(new MSXNote(0,MSXNote.SI,15,2, ch2_instrument));
            channel2.add(new MSXNote(1,MSXNote.SI,15,2, ch2_instrument));
            channel2.add(new MSXNote(2,MSXNote.SI,15,2, ch2_instrument));
            channel2.add(new MSXNote(1,MSXNote.SI,15,2, ch2_instrument));
            channel2.add(new MSXNote(0,MSXNote.SI,15,2, ch2_instrument));
            channel2.add(new MSXNote(1,MSXNote.SI,15,2, ch2_instrument));
            channel2.add(new MSXNote(2,MSXNote.SI,15,2, ch2_instrument));
            channel2.add(new MSXNote(1,MSXNote.SI,15,2, ch2_instrument));
            channel3.add(new MSXNote("SFX_PEDAL_HIHAT",4));
            channel3.add(new MSXNote("SFX_OPEN_HIHAT",2));
            channel3.add(new MSXNote("SFX_PEDAL_HIHAT",2));
            channel3.add(new MSXNote("SFX_PEDAL_HIHAT",4));
            channel3.add(new MSXNote("SFX_OPEN_HIHAT",2));
            channel3.add(new MSXNote("SFX_PEDAL_HIHAT",2));
            channel2.add(new MSXNote(0,MSXNote.SOL_SHARP,15,2, ch2_instrument));
            channel2.add(new MSXNote(1,MSXNote.SOL_SHARP,15,2, ch2_instrument));
            channel2.add(new MSXNote(2,MSXNote.SOL_SHARP,15,2, ch2_instrument));
            channel2.add(new MSXNote(1,MSXNote.SOL_SHARP,15,2, ch2_instrument));
            channel2.add(new MSXNote(0,MSXNote.SOL_SHARP,15,2, ch2_instrument));
            channel2.add(new MSXNote(1,MSXNote.SOL_SHARP,15,2, ch2_instrument));
            channel2.add(new MSXNote(2,MSXNote.SOL_SHARP,15,2, ch2_instrument));
            channel2.add(new MSXNote(1,MSXNote.SOL_SHARP,15,2, ch2_instrument));
            channel3.add(new MSXNote("SFX_PEDAL_HIHAT",4));
            channel3.add(new MSXNote("SFX_OPEN_HIHAT",2));
            channel3.add(new MSXNote("SFX_PEDAL_HIHAT",2));
            channel3.add(new MSXNote("SFX_PEDAL_HIHAT",4));
            channel3.add(new MSXNote("SFX_OPEN_HIHAT",2));
            channel3.add(new MSXNote("SFX_PEDAL_HIHAT",2));   
                
            for(int i = 0;i<2;i++) {
                channel1.add(new MSXNote(2,MSXNote.LA, ch1_volume,1, ch1_instrument));
                channel1.add(new MSXNote(2,MSXNote.MI, ch1_volume,1, ch1_instrument));
                channel1.add(new MSXNote(2,MSXNote.LA, ch1_volume,1, ch1_instrument));
                channel1.add(new MSXNote(3,MSXNote.DO, ch1_volume,1, ch1_instrument));
                channel1.add(new MSXNote(3,MSXNote.MI, ch1_volume,1, ch1_instrument));
                channel1.add(new MSXNote(3,MSXNote.DO, ch1_volume,1, ch1_instrument));
                channel1.add(new MSXNote(2,MSXNote.LA, ch1_volume,1, ch1_instrument));
                channel1.add(new MSXNote(2,MSXNote.MI, ch1_volume,1, ch1_instrument));
            }
            for(int i = 0;i<2;i++) {
                channel1.add(new MSXNote(2,MSXNote.LA, ch1_volume,1, ch1_instrument));
                channel1.add(new MSXNote(2,MSXNote.FA, ch1_volume,1, ch1_instrument));
                channel1.add(new MSXNote(2,MSXNote.LA, ch1_volume,1, ch1_instrument));
                channel1.add(new MSXNote(3,MSXNote.DO, ch1_volume,1, ch1_instrument));
                channel1.add(new MSXNote(3,MSXNote.FA, ch1_volume,1, ch1_instrument));
                channel1.add(new MSXNote(3,MSXNote.DO, ch1_volume,1, ch1_instrument));
                channel1.add(new MSXNote(2,MSXNote.LA, ch1_volume,1, ch1_instrument));
                channel1.add(new MSXNote(2,MSXNote.FA, ch1_volume,1, ch1_instrument));
            }
            for(int i = 0;i<2;i++) {
                channel1.add(new MSXNote(2,MSXNote.LA, ch1_volume,1, ch1_instrument));
                channel1.add(new MSXNote(2,MSXNote.MI, ch1_volume,1, ch1_instrument));
                channel1.add(new MSXNote(2,MSXNote.LA, ch1_volume,1, ch1_instrument));
                channel1.add(new MSXNote(3,MSXNote.DO, ch1_volume,1, ch1_instrument));
                channel1.add(new MSXNote(3,MSXNote.MI, ch1_volume,1, ch1_instrument));
                channel1.add(new MSXNote(3,MSXNote.DO, ch1_volume,1, ch1_instrument));
                channel1.add(new MSXNote(2,MSXNote.LA, ch1_volume,1, ch1_instrument));
                channel1.add(new MSXNote(2,MSXNote.MI, ch1_volume,1, ch1_instrument));
            }
            for(int i = 0;i<2;i++) {
                channel1.add(new MSXNote(2,MSXNote.SOL_SHARP, ch1_volume,1, ch1_instrument));
                channel1.add(new MSXNote(2,MSXNote.MI, ch1_volume,1, ch1_instrument));
                channel1.add(new MSXNote(2,MSXNote.SOL_SHARP, ch1_volume,1, ch1_instrument));
                channel1.add(new MSXNote(2,MSXNote.SI, ch1_volume,1, ch1_instrument));
                channel1.add(new MSXNote(3,MSXNote.MI, ch1_volume,1, ch1_instrument));
                channel1.add(new MSXNote(2,MSXNote.SI, ch1_volume,1, ch1_instrument));
                channel1.add(new MSXNote(2,MSXNote.SOL_SHARP, ch1_volume,1, ch1_instrument));
                channel1.add(new MSXNote(2,MSXNote.MI, ch1_volume,1, ch1_instrument));
            }   
            channel2.add(new MSXNote(0,MSXNote.LA,15,2, ch2_instrument));
            channel2.add(new MSXNote(1,MSXNote.LA,15,2, ch2_instrument));
            channel2.add(new MSXNote(2,MSXNote.LA,15,2, ch2_instrument));
            channel2.add(new MSXNote(1,MSXNote.LA,15,2, ch2_instrument));
            channel2.add(new MSXNote(0,MSXNote.LA,15,2, ch2_instrument));
            channel2.add(new MSXNote(1,MSXNote.LA,15,2, ch2_instrument));
            channel2.add(new MSXNote(2,MSXNote.LA,15,2, ch2_instrument));
            channel2.add(new MSXNote(1,MSXNote.LA,15,2, ch2_instrument));
            channel3.add(new MSXNote("SFX_PEDAL_HIHAT",4));
            channel3.add(new MSXNote("SFX_OPEN_HIHAT",2));
            channel3.add(new MSXNote("SFX_PEDAL_HIHAT",2));
            channel3.add(new MSXNote("SFX_PEDAL_HIHAT",4));
            channel3.add(new MSXNote("SFX_OPEN_HIHAT",2));
            channel3.add(new MSXNote("SFX_PEDAL_HIHAT",2));
            channel2.add(new MSXNote(0,MSXNote.FA,15,2, ch2_instrument));
            channel2.add(new MSXNote(1,MSXNote.FA,15,2, ch2_instrument));
            channel2.add(new MSXNote(2,MSXNote.FA,15,2, ch2_instrument));
            channel2.add(new MSXNote(1,MSXNote.FA,15,2, ch2_instrument));
            channel2.add(new MSXNote(0,MSXNote.FA,15,2, ch2_instrument));
            channel2.add(new MSXNote(1,MSXNote.FA,15,2, ch2_instrument));
            channel2.add(new MSXNote(2,MSXNote.FA,15,2, ch2_instrument));
            channel2.add(new MSXNote(1,MSXNote.FA,15,2, ch2_instrument));
            channel3.add(new MSXNote("SFX_PEDAL_HIHAT",4));
            channel3.add(new MSXNote("SFX_OPEN_HIHAT",2));
            channel3.add(new MSXNote("SFX_PEDAL_HIHAT",2));
            channel3.add(new MSXNote("SFX_PEDAL_HIHAT",4));
            channel3.add(new MSXNote("SFX_OPEN_HIHAT",2));
            channel3.add(new MSXNote("SFX_PEDAL_HIHAT",2));
            channel2.add(new MSXNote(0,MSXNote.MI,15,2, ch2_instrument));
            channel2.add(new MSXNote(1,MSXNote.MI,15,2, ch2_instrument));
            channel2.add(new MSXNote(2,MSXNote.MI,15,2, ch2_instrument));
            channel2.add(new MSXNote(1,MSXNote.MI,15,2, ch2_instrument));
            channel2.add(new MSXNote(0,MSXNote.MI,15,2, ch2_instrument));
            channel2.add(new MSXNote(1,MSXNote.MI,15,2, ch2_instrument));
            channel2.add(new MSXNote(2,MSXNote.MI,15,2, ch2_instrument));
            channel2.add(new MSXNote(1,MSXNote.MI,15,2, ch2_instrument));
            channel3.add(new MSXNote("SFX_PEDAL_HIHAT",4));
            channel3.add(new MSXNote("SFX_OPEN_HIHAT",2));
            channel3.add(new MSXNote("SFX_PEDAL_HIHAT",2));
            channel3.add(new MSXNote("SFX_PEDAL_HIHAT",4));
            channel3.add(new MSXNote("SFX_OPEN_HIHAT",2));
            channel3.add(new MSXNote("SFX_PEDAL_HIHAT",2));
            channel2.add(new MSXNote(0,MSXNote.SOL_SHARP,15,2, ch2_instrument));
            channel2.add(new MSXNote(1,MSXNote.SOL_SHARP,15,2, ch2_instrument));
            channel2.add(new MSXNote(2,MSXNote.SOL_SHARP,15,2, ch2_instrument));
            channel2.add(new MSXNote(1,MSXNote.SOL_SHARP,15,2, ch2_instrument));
            channel2.add(new MSXNote(0,MSXNote.SOL_SHARP,15,2, ch2_instrument));
            channel2.add(new MSXNote(1,MSXNote.SOL_SHARP,15,2, ch2_instrument));
            channel2.add(new MSXNote(2,MSXNote.SOL_SHARP,15,2, ch2_instrument));
            channel2.add(new MSXNote(1,MSXNote.SOL_SHARP,15,2, ch2_instrument));
            channel3.add(new MSXNote("SFX_PEDAL_HIHAT",4));
            channel3.add(new MSXNote("SFX_OPEN_HIHAT",2));
            channel3.add(new MSXNote("SFX_PEDAL_HIHAT",2));
            channel3.add(new MSXNote("SFX_PEDAL_HIHAT",4));
            channel3.add(new MSXNote("SFX_OPEN_HIHAT",2));
            channel3.add(new MSXNote("SFX_PEDAL_HIHAT",2));   
            
            channel1.add(new MSXNote(MSXNote.END_REPEAT,0));
//        }
        
        
        return song;
    }            
    
    
    public static MSXSong SpelunkInGame2Song()
    {
        MSXSong song = new MSXSong();
        List<MSXNote> channel1 = song.channels[0];
        List<MSXNote> channel2 = song.channels[1];
        List<MSXNote> channel3 = song.channels[2];
        
        int ch1_instrument = MSXNote.INSTRUMENT_PIANO;
        int ch2_instrument = MSXNote.INSTRUMENT_PIANO;
        int ch3_instrument = MSXNote.INSTRUMENT_PIANO;

        song.loopBackTime = 0;

        channel1.add(new MSXNote(16));                
        channel2.add(new MSXNote(0,MSXNote.MI, 15,2, ch2_instrument));
        channel2.add(new MSXNote(1,MSXNote.MI, 15,2, ch2_instrument));
        channel2.add(new MSXNote(0,MSXNote.MI, 15,2, ch2_instrument));
        channel2.add(new MSXNote(1,MSXNote.MI, 15,2, ch2_instrument));
        channel2.add(new MSXNote(0,MSXNote.MI, 15,2, ch2_instrument));
        channel2.add(new MSXNote(1,MSXNote.MI, 15,2, ch2_instrument));
        channel2.add(new MSXNote(0,MSXNote.MI, 15,2, ch2_instrument));
        channel2.add(new MSXNote(1,MSXNote.MI, 15,2, ch2_instrument));
        channel3.add(new MSXNote("SFX_PEDAL_HIHAT",4));
        channel3.add(new MSXNote("SFX_OPEN_HIHAT",2));
        channel3.add(new MSXNote("SFX_OPEN_HIHAT",2));
        channel3.add(new MSXNote("SFX_PEDAL_HIHAT",4));
        channel3.add(new MSXNote("SFX_OPEN_HIHAT",4));

        channel1.add(new MSXNote(16));                
        channel2.add(new MSXNote(0,MSXNote.SOL, 15,2, ch2_instrument));
        channel2.add(new MSXNote(1,MSXNote.SOL, 15,2, ch2_instrument));
        channel2.add(new MSXNote(0,MSXNote.SOL, 15,2, ch2_instrument));
        channel2.add(new MSXNote(1,MSXNote.SOL, 15,2, ch2_instrument));
        channel2.add(new MSXNote(0,MSXNote.SOL, 15,2, ch2_instrument));
        channel2.add(new MSXNote(1,MSXNote.SOL, 15,2, ch2_instrument));
        channel2.add(new MSXNote(0,MSXNote.SOL, 15,2, ch2_instrument));
        channel2.add(new MSXNote(1,MSXNote.SOL, 15,2, ch2_instrument));
        channel3.add(new MSXNote("SFX_PEDAL_HIHAT",4));
        channel3.add(new MSXNote("SFX_OPEN_HIHAT",2));
        channel3.add(new MSXNote("SFX_OPEN_HIHAT",2));
        channel3.add(new MSXNote("SFX_PEDAL_HIHAT",4));
        channel3.add(new MSXNote("SFX_OPEN_HIHAT",4));

        channel1.add(new MSXNote(16));                
        channel2.add(new MSXNote(0,MSXNote.SI, 15,2, ch2_instrument));
        channel2.add(new MSXNote(1,MSXNote.SI, 15,2, ch2_instrument));
        channel2.add(new MSXNote(0,MSXNote.SI, 15,2, ch2_instrument));
        channel2.add(new MSXNote(1,MSXNote.SI, 15,2, ch2_instrument));
        channel2.add(new MSXNote(0,MSXNote.SI, 15,2, ch2_instrument));
        channel2.add(new MSXNote(1,MSXNote.SI, 15,2, ch2_instrument));
        channel2.add(new MSXNote(0,MSXNote.SI, 15,2, ch2_instrument));
        channel2.add(new MSXNote(1,MSXNote.SI, 15,2, ch2_instrument));
        channel3.add(new MSXNote("SFX_PEDAL_HIHAT",4));
        channel3.add(new MSXNote("SFX_OPEN_HIHAT",2));
        channel3.add(new MSXNote("SFX_OPEN_HIHAT",2));
        channel3.add(new MSXNote("SFX_PEDAL_HIHAT",4));
        channel3.add(new MSXNote("SFX_OPEN_HIHAT",4));
        
        
        channel1.add(new MSXNote(8));
        channel1.add(new MSXNote(2,MSXNote.SI, 15,4, ch1_instrument));
        channel1.add(new MSXNote(3,MSXNote.RE, 15,4, ch1_instrument));        
        
        channel2.add(new MSXNote(0,MSXNote.MI, 15,2, ch2_instrument));
        channel2.add(new MSXNote(1,MSXNote.MI, 15,2, ch2_instrument));
        channel2.add(new MSXNote(0,MSXNote.MI, 15,2, ch2_instrument));
        channel2.add(new MSXNote(1,MSXNote.MI, 15,2, ch2_instrument));
        channel2.add(new MSXNote(0,MSXNote.MI, 15,2, ch2_instrument));
        channel2.add(new MSXNote(1,MSXNote.MI, 15,2, ch2_instrument));
        channel2.add(new MSXNote(0,MSXNote.MI, 15,2, ch2_instrument));
        channel2.add(new MSXNote(1,MSXNote.MI, 15,2, ch2_instrument));
 
        channel3.add(new MSXNote("SFX_PEDAL_HIHAT",4));
        channel3.add(new MSXNote("SFX_OPEN_HIHAT",2));
        channel3.add(new MSXNote("SFX_OPEN_HIHAT",2));
        channel3.add(new MSXNote("SFX_PEDAL_HIHAT",4));
        channel3.add(new MSXNote("SFX_OPEN_HIHAT",4));

        
        channel1.add(new MSXNote(3,MSXNote.MI, 15,2, ch1_instrument));
        channel1.add(new MSXNote(3,MSXNote.MI, 15,1, ch1_instrument));
        channel1.add(new MSXNote(3,MSXNote.SOL, 15,1, ch1_instrument));
        channel1.add(new MSXNote(3,MSXNote.MI, 15,1, ch1_instrument));
        channel1.add(new MSXNote(3,MSXNote.RE, 15,1, ch1_instrument));
        channel1.add(new MSXNote(2,MSXNote.SI, 15,2, ch1_instrument));
        channel1.add(new MSXNote(3,MSXNote.RE, 15,8, ch1_instrument));        
        
        channel2.add(new MSXNote(0,MSXNote.MI, 15,2, ch2_instrument));
        channel2.add(new MSXNote(1,MSXNote.MI, 15,2, ch2_instrument));
        channel2.add(new MSXNote(0,MSXNote.MI, 15,2, ch2_instrument));
        channel2.add(new MSXNote(1,MSXNote.MI, 15,2, ch2_instrument));
        channel2.add(new MSXNote(0,MSXNote.SOL, 15,2, ch2_instrument));
        channel2.add(new MSXNote(1,MSXNote.SOL, 15,2, ch2_instrument));
        channel2.add(new MSXNote(0,MSXNote.SOL, 15,2, ch2_instrument));
        channel2.add(new MSXNote(1,MSXNote.SOL, 15,2, ch2_instrument));

        channel3.add(new MSXNote("SFX_PEDAL_HIHAT",4));
        channel3.add(new MSXNote("SFX_OPEN_HIHAT",2));
        channel3.add(new MSXNote("SFX_OPEN_HIHAT",2));
        channel3.add(new MSXNote("SFX_PEDAL_HIHAT",4));
        channel3.add(new MSXNote("SFX_OPEN_HIHAT",4));
        
        
        channel1.add(new MSXNote(8));
        channel1.add(new MSXNote(2,MSXNote.SI, 15,2, ch1_instrument));
        channel1.add(new MSXNote(2,MSXNote.SI, 15,1, ch1_instrument));
        channel1.add(new MSXNote(3,MSXNote.RE, 15,1, ch1_instrument));
        channel1.add(new MSXNote(2,MSXNote.SI, 15,1, ch1_instrument));
        channel1.add(new MSXNote(2,MSXNote.LA, 15,1, ch1_instrument));
        channel1.add(new MSXNote(2,MSXNote.SOL, 15,2, ch1_instrument));

        channel2.add(new MSXNote(0,MSXNote.SOL, 15,2, ch2_instrument));
        channel2.add(new MSXNote(1,MSXNote.SOL, 15,2, ch2_instrument));
        channel2.add(new MSXNote(0,MSXNote.SOL, 15,2, ch2_instrument));
        channel2.add(new MSXNote(1,MSXNote.SOL, 15,2, ch2_instrument));
        channel2.add(new MSXNote(0,MSXNote.SOL, 15,2, ch2_instrument));
        channel2.add(new MSXNote(1,MSXNote.SOL, 15,2, ch2_instrument));
        channel2.add(new MSXNote(0,MSXNote.SOL, 15,2, ch2_instrument));
        channel2.add(new MSXNote(1,MSXNote.SOL, 15,2, ch2_instrument));
    
        channel3.add(new MSXNote("SFX_PEDAL_HIHAT",4));
        channel3.add(new MSXNote("SFX_OPEN_HIHAT",2));
        channel3.add(new MSXNote("SFX_OPEN_HIHAT",2));
        channel3.add(new MSXNote("SFX_PEDAL_HIHAT",4));
        channel3.add(new MSXNote("SFX_OPEN_HIHAT",4));

        
        channel1.add(new MSXNote(2,MSXNote.MI, 15,8, ch1_instrument));
        channel1.add(new MSXNote(8));
        channel2.add(new MSXNote(0,MSXNote.MI, 15,2, ch2_instrument));
        channel2.add(new MSXNote(1,MSXNote.MI, 15,2, ch2_instrument));
        channel2.add(new MSXNote(0,MSXNote.MI, 15,2, ch2_instrument));
        channel2.add(new MSXNote(1,MSXNote.MI, 15,2, ch2_instrument));
        channel2.add(new MSXNote(0,MSXNote.MI, 15,2, ch2_instrument));
        channel2.add(new MSXNote(1,MSXNote.MI, 15,2, ch2_instrument));
        channel2.add(new MSXNote(0,MSXNote.MI, 15,2, ch2_instrument));
        channel2.add(new MSXNote(1,MSXNote.MI, 15,2, ch2_instrument));
        
        channel3.add(new MSXNote("SFX_PEDAL_HIHAT",4));
        channel3.add(new MSXNote("SFX_OPEN_HIHAT",2));
        channel3.add(new MSXNote("SFX_OPEN_HIHAT",2));
        channel3.add(new MSXNote("SFX_PEDAL_HIHAT",4));
        channel3.add(new MSXNote("SFX_OPEN_HIHAT",4));
      
        
        channel1.add(new MSXNote(2,MSXNote.SOL, 15,6, ch1_instrument));
        channel1.add(new MSXNote(2,MSXNote.LA, 15,2, ch1_instrument));
        channel1.add(new MSXNote(2,MSXNote.LA, 15,4, ch1_instrument));
        channel1.add(new MSXNote(2,MSXNote.SI, 15,6, ch1_instrument));
        channel1.add(new MSXNote(3,MSXNote.RE, 15,4, ch1_instrument));
        channel1.add(new MSXNote(2,MSXNote.SI, 15,2, ch1_instrument));
        channel1.add(new MSXNote(3,MSXNote.MI, 15,8, ch1_instrument));
        
        channel2.add(new MSXNote(0,MSXNote.SOL, 15,2, ch2_instrument));
        channel2.add(new MSXNote(1,MSXNote.SOL, 15,2, ch2_instrument));
        channel2.add(new MSXNote(0,MSXNote.SOL, 15,2, ch2_instrument));
        channel2.add(new MSXNote(1,MSXNote.SOL, 15,2, ch2_instrument));
        channel2.add(new MSXNote(0,MSXNote.MI, 15,2, ch2_instrument));
        channel2.add(new MSXNote(1,MSXNote.MI, 15,2, ch2_instrument));
        channel2.add(new MSXNote(0,MSXNote.MI, 15,2, ch2_instrument));
        channel2.add(new MSXNote(1,MSXNote.MI, 15,2, ch2_instrument));
        channel2.add(new MSXNote(0,MSXNote.SI, 15,2, ch2_instrument));
        channel2.add(new MSXNote(1,MSXNote.SI, 15,2, ch2_instrument));
        channel2.add(new MSXNote(0,MSXNote.SI, 15,2, ch2_instrument));
        channel2.add(new MSXNote(1,MSXNote.SI, 15,2, ch2_instrument));
        channel2.add(new MSXNote(0,MSXNote.MI, 15,2, ch2_instrument));
        channel2.add(new MSXNote(1,MSXNote.MI, 15,2, ch2_instrument));
        channel2.add(new MSXNote(0,MSXNote.MI, 15,2, ch2_instrument));
        channel2.add(new MSXNote(1,MSXNote.MI, 15,2, ch2_instrument));

        channel3.add(new MSXNote("SFX_PEDAL_HIHAT",4));
        channel3.add(new MSXNote("SFX_OPEN_HIHAT",2));
        channel3.add(new MSXNote("SFX_OPEN_HIHAT",2));
        channel3.add(new MSXNote("SFX_PEDAL_HIHAT",4));
        channel3.add(new MSXNote("SFX_OPEN_HIHAT",4));
        channel3.add(new MSXNote("SFX_PEDAL_HIHAT",4));
        channel3.add(new MSXNote("SFX_OPEN_HIHAT",2));
        channel3.add(new MSXNote("SFX_OPEN_HIHAT",2));
        channel3.add(new MSXNote("SFX_PEDAL_HIHAT",4));
        channel3.add(new MSXNote("SFX_OPEN_HIHAT",4));


        channel1.add(new MSXNote(16));                
        channel2.add(new MSXNote(0,MSXNote.MI, 15,2, ch2_instrument));
        channel2.add(new MSXNote(1,MSXNote.MI, 15,2, ch2_instrument));
        channel2.add(new MSXNote(0,MSXNote.MI, 15,2, ch2_instrument));
        channel2.add(new MSXNote(1,MSXNote.MI, 15,2, ch2_instrument));
        channel2.add(new MSXNote(0,MSXNote.MI, 15,2, ch2_instrument));
        channel2.add(new MSXNote(1,MSXNote.MI, 15,2, ch2_instrument));
        channel2.add(new MSXNote(0,MSXNote.MI, 15,2, ch2_instrument));
        channel2.add(new MSXNote(1,MSXNote.MI, 15,2, ch2_instrument));
        channel3.add(new MSXNote("SFX_PEDAL_HIHAT",4));
        channel3.add(new MSXNote("SFX_OPEN_HIHAT",2));
        channel3.add(new MSXNote("SFX_OPEN_HIHAT",2));
        channel3.add(new MSXNote("SFX_PEDAL_HIHAT",4));
        channel3.add(new MSXNote("SFX_OPEN_HIHAT",4));

        channel1.add(new MSXNote(16));                
        channel2.add(new MSXNote(0,MSXNote.SOL, 15,2, ch2_instrument));
        channel2.add(new MSXNote(1,MSXNote.SOL, 15,2, ch2_instrument));
        channel2.add(new MSXNote(0,MSXNote.SOL, 15,2, ch2_instrument));
        channel2.add(new MSXNote(1,MSXNote.SOL, 15,2, ch2_instrument));
        channel2.add(new MSXNote(0,MSXNote.SOL, 15,2, ch2_instrument));
        channel2.add(new MSXNote(1,MSXNote.SOL, 15,2, ch2_instrument));
        channel2.add(new MSXNote(0,MSXNote.SOL, 15,2, ch2_instrument));
        channel2.add(new MSXNote(1,MSXNote.SOL, 15,2, ch2_instrument));
        channel3.add(new MSXNote("SFX_PEDAL_HIHAT",4));
        channel3.add(new MSXNote("SFX_OPEN_HIHAT",2));
        channel3.add(new MSXNote("SFX_OPEN_HIHAT",2));
        channel3.add(new MSXNote("SFX_PEDAL_HIHAT",4));
        channel3.add(new MSXNote("SFX_OPEN_HIHAT",4));
        
        channel1.add(new MSXNote(16));                
        channel2.add(new MSXNote(0,MSXNote.SOL_FLAT, 15,2, ch2_instrument));
        channel2.add(new MSXNote(1,MSXNote.SOL_FLAT, 15,2, ch2_instrument));
        channel2.add(new MSXNote(0,MSXNote.SOL_FLAT, 15,2, ch2_instrument));
        channel2.add(new MSXNote(1,MSXNote.SOL_FLAT, 15,2, ch2_instrument));
        channel2.add(new MSXNote(0,MSXNote.SOL_FLAT, 15,2, ch2_instrument));
        channel2.add(new MSXNote(1,MSXNote.SOL_FLAT, 15,2, ch2_instrument));
        channel2.add(new MSXNote(0,MSXNote.SOL_FLAT, 15,2, ch2_instrument));
        channel2.add(new MSXNote(1,MSXNote.SOL_FLAT, 15,2, ch2_instrument));
        channel3.add(new MSXNote("SFX_PEDAL_HIHAT",4));
        channel3.add(new MSXNote("SFX_OPEN_HIHAT",2));
        channel3.add(new MSXNote("SFX_OPEN_HIHAT",2));
        channel3.add(new MSXNote("SFX_PEDAL_HIHAT",4));
        channel3.add(new MSXNote("SFX_OPEN_HIHAT",4));
        
        channel1.add(new MSXNote(16));                
        channel2.add(new MSXNote(0,MSXNote.RE, 15,2, ch2_instrument));
        channel2.add(new MSXNote(1,MSXNote.RE, 15,2, ch2_instrument));
        channel2.add(new MSXNote(0,MSXNote.RE, 15,2, ch2_instrument));
        channel2.add(new MSXNote(1,MSXNote.RE, 15,2, ch2_instrument));
        channel2.add(new MSXNote(0,MSXNote.RE, 15,2, ch2_instrument));
        channel2.add(new MSXNote(1,MSXNote.RE, 15,2, ch2_instrument));
        channel2.add(new MSXNote(0,MSXNote.RE, 15,2, ch2_instrument));
        channel2.add(new MSXNote(1,MSXNote.RE, 15,2, ch2_instrument));
        channel3.add(new MSXNote("SFX_PEDAL_HIHAT",4));
        channel3.add(new MSXNote("SFX_OPEN_HIHAT",2));
        channel3.add(new MSXNote("SFX_OPEN_HIHAT",2));
        channel3.add(new MSXNote("SFX_PEDAL_HIHAT",4));
        channel3.add(new MSXNote("SFX_OPEN_HIHAT",4));


        channel1.add(new MSXNote(3,MSXNote.MI, 15,2, ch1_instrument));
        channel1.add(new MSXNote(3,MSXNote.SOL, 15,2, ch1_instrument));
        channel1.add(new MSXNote(3,MSXNote.SOL_FLAT, 15,2, ch1_instrument));
        channel1.add(new MSXNote(3,MSXNote.RE, 15,2, ch1_instrument));
        channel1.add(new MSXNote(3,MSXNote.MI, 15,2, ch1_instrument));
        channel1.add(new MSXNote(3,MSXNote.SOL, 15,2, ch1_instrument));
        channel1.add(new MSXNote(3,MSXNote.SOL_FLAT, 15,2, ch1_instrument));
        channel1.add(new MSXNote(3,MSXNote.RE, 15,2, ch1_instrument));
        channel2.add(new MSXNote(0,MSXNote.MI, 15,2, ch2_instrument));
        channel2.add(new MSXNote(1,MSXNote.MI, 15,2, ch2_instrument));
        channel2.add(new MSXNote(0,MSXNote.MI, 15,2, ch2_instrument));
        channel2.add(new MSXNote(1,MSXNote.MI, 15,2, ch2_instrument));
        channel2.add(new MSXNote(0,MSXNote.MI, 15,2, ch2_instrument));
        channel2.add(new MSXNote(1,MSXNote.MI, 15,2, ch2_instrument));
        channel2.add(new MSXNote(0,MSXNote.MI, 15,2, ch2_instrument));
        channel2.add(new MSXNote(1,MSXNote.MI, 15,2, ch2_instrument));
        channel3.add(new MSXNote("SFX_PEDAL_HIHAT",4));
        channel3.add(new MSXNote("SFX_OPEN_HIHAT",2));
        channel3.add(new MSXNote("SFX_OPEN_HIHAT",2));
        channel3.add(new MSXNote("SFX_PEDAL_HIHAT",4));
        channel3.add(new MSXNote("SFX_OPEN_HIHAT",4));

        channel1.add(new MSXNote(3,MSXNote.MI, 15,2, ch1_instrument));
        channel1.add(new MSXNote(3,MSXNote.SOL, 15,2, ch1_instrument));
        channel1.add(new MSXNote(3,MSXNote.SOL_FLAT, 15,2, ch1_instrument));
        channel1.add(new MSXNote(3,MSXNote.RE, 15,2, ch1_instrument));
        channel1.add(new MSXNote(3,MSXNote.MI, 15,2, ch1_instrument));
        channel1.add(new MSXNote(3,MSXNote.SOL, 15,2, ch1_instrument));
        channel1.add(new MSXNote(3,MSXNote.SOL_FLAT, 15,2, ch1_instrument));
        channel1.add(new MSXNote(3,MSXNote.RE, 15,2, ch1_instrument));
        channel2.add(new MSXNote(0,MSXNote.SOL, 15,2, ch2_instrument));
        channel2.add(new MSXNote(1,MSXNote.SOL, 15,2, ch2_instrument));
        channel2.add(new MSXNote(0,MSXNote.SOL, 15,2, ch2_instrument));
        channel2.add(new MSXNote(1,MSXNote.SOL, 15,2, ch2_instrument));
        channel2.add(new MSXNote(0,MSXNote.SOL, 15,2, ch2_instrument));
        channel2.add(new MSXNote(1,MSXNote.SOL, 15,2, ch2_instrument));
        channel2.add(new MSXNote(0,MSXNote.SOL, 15,2, ch2_instrument));
        channel2.add(new MSXNote(1,MSXNote.SOL, 15,2, ch2_instrument));
        channel3.add(new MSXNote("SFX_PEDAL_HIHAT",4));
        channel3.add(new MSXNote("SFX_OPEN_HIHAT",2));
        channel3.add(new MSXNote("SFX_OPEN_HIHAT",2));
        channel3.add(new MSXNote("SFX_PEDAL_HIHAT",4));
        channel3.add(new MSXNote("SFX_OPEN_HIHAT",4));
        
        channel1.add(new MSXNote(3,MSXNote.MI, 15,2, ch1_instrument));
        channel1.add(new MSXNote(3,MSXNote.SOL, 15,2, ch1_instrument));
        channel1.add(new MSXNote(3,MSXNote.SOL_FLAT, 15,2, ch1_instrument));
        channel1.add(new MSXNote(3,MSXNote.RE, 15,2, ch1_instrument));
        channel1.add(new MSXNote(3,MSXNote.MI, 15,2, ch1_instrument));
        channel1.add(new MSXNote(3,MSXNote.SOL, 15,2, ch1_instrument));
        channel1.add(new MSXNote(3,MSXNote.SOL_FLAT, 15,2, ch1_instrument));
        channel1.add(new MSXNote(3,MSXNote.RE, 15,2, ch1_instrument));
        channel2.add(new MSXNote(0,MSXNote.SOL_FLAT, 15,2, ch2_instrument));
        channel2.add(new MSXNote(1,MSXNote.SOL_FLAT, 15,2, ch2_instrument));
        channel2.add(new MSXNote(0,MSXNote.SOL_FLAT, 15,2, ch2_instrument));
        channel2.add(new MSXNote(1,MSXNote.SOL_FLAT, 15,2, ch2_instrument));
        channel2.add(new MSXNote(0,MSXNote.SOL_FLAT, 15,2, ch2_instrument));
        channel2.add(new MSXNote(1,MSXNote.SOL_FLAT, 15,2, ch2_instrument));
        channel2.add(new MSXNote(0,MSXNote.SOL_FLAT, 15,2, ch2_instrument));
        channel2.add(new MSXNote(1,MSXNote.SOL_FLAT, 15,2, ch2_instrument));
        channel3.add(new MSXNote("SFX_PEDAL_HIHAT",4));
        channel3.add(new MSXNote("SFX_OPEN_HIHAT",2));
        channel3.add(new MSXNote("SFX_OPEN_HIHAT",2));
        channel3.add(new MSXNote("SFX_PEDAL_HIHAT",4));
        channel3.add(new MSXNote("SFX_OPEN_HIHAT",4));
       

        channel1.add(new MSXNote(3,MSXNote.MI, 15,8, ch1_instrument));
        channel1.add(new MSXNote(8));
        channel2.add(new MSXNote(0,MSXNote.MI, 15,2, ch2_instrument));
        channel2.add(new MSXNote(1,MSXNote.MI, 15,2, ch2_instrument));
        channel2.add(new MSXNote(0,MSXNote.MI, 15,2, ch2_instrument));
        channel2.add(new MSXNote(1,MSXNote.MI, 15,2, ch2_instrument));
        channel2.add(new MSXNote(0,MSXNote.MI, 15,2, ch2_instrument));
        channel2.add(new MSXNote(1,MSXNote.MI, 15,2, ch2_instrument));
        channel2.add(new MSXNote(0,MSXNote.MI, 15,2, ch2_instrument));
        channel2.add(new MSXNote(1,MSXNote.MI, 15,2, ch2_instrument));
        channel3.add(new MSXNote("SFX_PEDAL_HIHAT",4));
        channel3.add(new MSXNote("SFX_OPEN_HIHAT",2));
        channel3.add(new MSXNote("SFX_OPEN_HIHAT",2));
        channel3.add(new MSXNote("SFX_PEDAL_HIHAT",4));
        channel3.add(new MSXNote("SFX_OPEN_HIHAT",4));
        
        
        return song;
    }    
}
