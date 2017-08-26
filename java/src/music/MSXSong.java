/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package music;

import java.io.PrintStream;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author santi
 */
public class MSXSong {
    public static final int N_CHANNELS = 3;
    
    public List<MSXNote> channels[];
    public int loopBackTime = -1;
    
    public MSXSong() {
        channels = new List[N_CHANNELS];
        for(int i = 0;i<N_CHANNELS;i++) {
            channels[i] = new ArrayList<>();
        }
    }
    
    
    public void addNote(MSXNote note, int channel) {
        channels[channel].add(note);
    }
    
    
    public int channelLength(int channel) {
        int l = 0;
        for(MSXNote n:channels[channel]) {
            l+=n.duration;
        }
        return l;
    }
    
    
    public int getNextIndex(int channel) {
        return channels[channel].size();
    }
    
    
    public void convertToAssembler(String songName, PrintStream w)
    {
        int instrument[] = new int[N_CHANNELS];
        int index[] = new int[N_CHANNELS];
        int channelTime[] = new int[N_CHANNELS];
        int currentTime = 0;
        
        for(int i = 0;i<N_CHANNELS;i++) {
            instrument[i] = MSXNote.INSTRUMENT_SQUARE_WAVE;
            index[i] = 0;
            channelTime[i] = 0;
        }
        currentTime = 0;
        
        w.println("  include \"../spelunk-constants.asm\"");
        w.println("  org #0000");
        w.println(songName + ":");
        w.println("  db 7,184");   // set all three channels to wave
        
        while(true) {
            boolean done = true;
            boolean advanceTime = true;
            if (currentTime == loopBackTime) {
                w.println(songName + "_loop:");
            }
            for(int i = 0;i<N_CHANNELS;i++) {
                if (index[i]<channels[i].size()) {
                    done = false;
                    if (currentTime >= channelTime[i]) {
                        // channel note:
                        MSXNote note = channels[i].get(index[i]);
                        index[i]++;
                        
                        if (note.absoluteNote==-1) {
                            // silence:
                            if (instrument[i] != MSXNote.INSTRUMENT_SQUARE_WAVE) {
                                w.println("  db MUSIC_CMD_SET_INSTRUMENT, MUSIC_INSTRUMENT_SQUARE_WAVE, " + i);
                                instrument[i] = MSXNote.INSTRUMENT_SQUARE_WAVE;
                            }
                            w.println("  db " + (8+i) + ", 0");
                            channelTime[i] += note.duration;
                        } else if (note.absoluteNote == MSXNote.SFX) {
                            w.println("  db MUSIC_CMD_PLAY_SFX, " + note.sfx);
                            channelTime[i] += note.duration;
                        } else if (note.absoluteNote == MSXNote.START_REPEAT) {
                            w.println("  db MUSIC_CMD_REPEAT, " + note.volume);
                            advanceTime = false;
                        } else if (note.absoluteNote == MSXNote.END_REPEAT) {
                            w.println("  db MUSIC_CMD_END_REPEAT");
                            advanceTime = false;
                        } else {
                            if (instrument[i] != note.instrument) {
                                w.println("  db MUSIC_CMD_SET_INSTRUMENT, " + MSXNote.instrumentNames[note.instrument] + ", " + i);
                                instrument[i] = note.instrument;
                            }  
                            int period = note.PSGNotePeriod();        
                            w.println("  db MUSIC_CMD_PLAY_INSTRUMENT_CH" + (i+1) + ", " + (period/256) + ", " + (period%256));
                            channelTime[i] += note.duration;
                        }
                    }
                } else {
                    if (currentTime < channelTime[i]) done = false;
                }
            }
            if (done) break;
            if (advanceTime) {
                w.println("  db MUSIC_CMD_SKIP");
                currentTime++;
            }
        }
        if (loopBackTime==-1) {
            w.println("  db MUSIC_CMD_END");
        } else {
            w.println("  db MUSIC_CMD_GOTO");
            w.println("  dw (" + songName + "_loop - " + songName + ")");
        }
        
        System.out.println("Channel times: " + channelTime[0] + ", " + channelTime[1] + ", " + channelTime[2]);
    }    
}
