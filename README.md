XSpelunker (MSX) by Santiago Ontañón Villar

[insert here a cover image]

Download latest compiled ROMs (v1.0) from: [to be updated]

You will need an MSX emulator to play the game on a PC, for example OpenMSX: http://openmsx.org


## Introduction

XSpelunker waS heavily inspired by the genious Spelunky game (http://www.spelunkyworld.com), which I highly recommend. Of course, XSpelunker being an 8bit version running on MSX1 hardware, it is a much more limited game, but I've tried to keep the core mechanics of the original game while making it significantly different, as for creating a new game experience.

Being a game inspired by Spelunky, the game levels are procedurally generated. So, each time you play, you will have to face different challenges, and might encounter different subsets of equipment. Make sure you collect as much equipment as you can in order to face the later stages of the game where difficulty grows rapidly, and you might need to use larger amounts of items to complete the levels.


## Instructions

Screenshots (of version 1.0):

[insert screenshots]

You can see a video of the game at: [insert video here]

In XSpelunker you play the role of Michael S. Xavier, an explorer who adventures into the Maya territory in Yucatan to investigate some mysterious Mayan ruins. Along the way, our hero will have to overcome countless traps, beasts and other enemies that will try to put an early end to his expedition. 

The following image show the basic elements of the game screen:

[insert instructions screen here]

Pay special attention to:
* Xavier's health: our hero starts with a limited amount of health. Each time a trap or enemy hits him, he will lose one point of health. If health reaches zero, the game will be over. There is only one way to gain health in the game: Xavier will gain an extra health point each time you complete a level.
* Time: time is of essence to Xavier's mission. So, you will only have 3 minutes to complete each level. If time runs out in any level, the game will be over. 3 minutes should be more than enough to complete any level though.
* Inventory: At the start of the game Xavier starts with his trusty machete, some bombs and some climbing ropes. You can use those items by selecting them (see the controls section below). Also, remember that you can only carry a limited amount of items, and that you can drop items if you don't want them.
* Some times you will come across doors that can be open by stepping on a button. If you want to keep the door open, you will have to drag/put some heavy item onto the button.
* Xavier cannot fall from an arbitrary height, so be careful!
* Xavier's jump can be controller mid-air, but he will have inertia towards the initial jumping direction. So, be careful when jumping!
* If you are near the edge of the screen and want to see what's beyond, just crouch. Each time you crouch, the game will center the screen on Xavier, letting you see what is around.
* Keep a healthy supply of bombs and ropes around: in the earlier stages of the game, all the levels are guaranteed to be solveable without requiring the use of bombs and ropes. But as the game progresses there is a small chance that that is not the case. So, you might need to rely on ropes or bombs (or even on some rarely found items such as the diving mask) to be able to complete levels. 


## Controls

Keyboard:
* Walk                  - left/right
* Jump                  - up
* Crouch                - down
* Climb up/down         - up/down
* Grab a rope           - hold up when in the air
* Jump when on a rope   - up twice
* Drop when on a vine   - left or right twice
* Change selected item  - M/trigger B
* Attack with machete   - space/trigger A
* Pick up items         - crouch then space/trigger A
* Drop items            - select them, then crouch plus space/trigger A
* Throw bombs/ropes/etc.- select them, hold space, then point in the direction you want to throw, and release space
* Push boulders         - just keep walking onto them
* Pause                 - P

In the title screen:
* Space/trigger A to start the game

Each time you start a new level, it will have to be generated. Wait until the "WAIT..." message disappears, and then you can press space/trigger A to start playing.

## Items

[to do]


## Compatibility

The game was designed to be played on MSX1 computers with at least 16KB of RAM. I used the Philips VG8020 as the reference machine (since that's the MSX I owned as a kid), but I've tested it in some other machines using OpenMSX v0.14. If you detect an incompatibility, please let me know!


## Notes:

Some notes and useful links I used when coding XSpelunker

* There is a "build" script in the home folder. Use it to re-build the game from sources.
* Also, XSpelunker uses many different data files (graphics/sounds/maps/etc.). Most of those are generated automatically from PNG images, or TMX map files. You can re-generate those data files by running the "regenerateData" script.
* To measure code execution time I used: http://msx.jannone.org/bit/
* Math routines: http://z80-heaven.wikidot.com/math
* PSG (sound) registers: http://www.angelfire.com/art2/unicorndreams/msx/RR-PSG.html
* Z80 tutotial: http://sgate.emt.bme.hu/patai/publications/z80guide/part1.html
* Z80 user manual: http://www.zilog.com/appnotes_download.php?FromPage=DirectLink&dn=UM0080&ft=User%20Manual&f=YUhSMGNEb3ZMM2QzZHk1NmFXeHZaeTVqYjIwdlpHOWpjeTk2T0RBdlZVMHdNRGd3TG5Ca1pnPT0=
* MSX system variables: http://map.grauw.nl/resources/msxsystemvars.php
* MSX bios calls: 
    * http://map.grauw.nl/resources/msxbios.php
    * https://sourceforge.net/p/cbios/cbios/ci/master/tree/
* VDP reference: http://bifi.msxnet.org/msxnet/tech/tms9918a.txt
* VDP manual: http://map.grauw.nl/resources/video/texasinstruments_tms9918.pdf
* The game was compiled with Grauw's Glass compiler (cannot thank him enough for creating it): https://bitbucket.org/grauw/glass
* In order to compress data I used Pletter v0.5b - XL2S Entertainment 2008 (there is a Java port of the Pletter compressor in the Java source code in the repository).

