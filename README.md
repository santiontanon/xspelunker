## XSpelunker (MSX) by Santiago Ontañón Villar

#XSpelunker won the MXC Classic MSXDev 2017 competition!!! https://www.msxdev.org/2017/12/01/msxdev17-is-over-time-to-meet-the-winners/

<img src="https://raw.githubusercontent.com/santiontanon/xspelunker/master/data/xspelunker-cover.jpg?raw=true" alt="cover" width="400"/> 

Cover art by Sirelion!

You can buy a physical copy of the game via (Thanks to STAR from matra.net!): http://www.matranet.net/boutique/msx/card/xspelunker/xspelunker.php

Download latest compiled ROMs (v1.4.3) from: https://github.com/santiontanon/xspelunker/releases/tag/1.4.3

You will need an MSX emulator to play the game on a PC, for example OpenMSX: http://openmsx.org

Or you can play directly on your browser thanks to Arnaud De Klerk (TFH)!: http://www.file-hunter.com/MSX/XSpelunker.html

## Introduction

XSpelunker waS heavily inspired by Spelunky (http://www.spelunkyworld.com), which is simply genious, and also by other classic games such as Livingstone Supongo (https://es.wikipedia.org/wiki/Livingstone_supongo). Of course, XSpelunker, being an 8bit version running on MSX1 hardware, it is a much more limited game than Spelunky, but I've tried to keep the core mechanics of the original game while making it significantly different, in order to create a different game experience.

Being a game inspired by Spelunky, the game levels are procedurally generated. So, each time you play, you will have to face different challenges, and might encounter different subsets of equipment. Make sure you collect as much equipment as you can in order to face the later stages of the game where difficulty grows rapidly, and you might need to use larger amounts of items to complete the levels.


## Instructions

Screenshots (of version 1.0):

<img src="https://raw.githubusercontent.com/santiontanon/xspelunker/master/data/instructions/xspelunker-title.png" alt="title" width="400"/> <img src="https://raw.githubusercontent.com/santiontanon/xspelunker/master/data/instructions/xspelunker-ingame1.png" alt="in game 1" width="400"/>

<img src="https://raw.githubusercontent.com/santiontanon/xspelunker/master/data/instructions/xspelunker-ingame2.png" alt="in game 2" width="400"/> <img src="https://raw.githubusercontent.com/santiontanon/xspelunker/master/data/instructions/xspelunker-ingame3.png" alt="in game 3" width="400"/>


You can see a video of the game at: https://www.youtube.com/watch?v=OaTt0T8O0N0

In XSpelunker you play the role of Michael S. Xavier, an explorer who adventures into the Maya territory in Yucatan to investigate some mysterious Mayan ruins. Along the way, our hero will have to overcome countless traps, beasts and other enemies that will try to put an early end to his expedition. 

The following image show the basic elements of the game screen:

<img src="https://raw.githubusercontent.com/santiontanon/xspelunker/master/data/instructions/instructions.png" alt="in game screen" width="800"/>

Pay special attention to:
* Xavier's health: our hero starts with a limited amount of health. Each time a trap or enemy hits him, he will lose one point of health. If health reaches zero, the game will be over. There is only one way to gain health in the game: Xavier will gain an extra health point each time you complete a level.
* Time: time is of essence to Xavier's mission. So, you will only have 3 minutes to complete each level. If time runs out in any level, the game will be over. 3 minutes should be more than enough to complete any level though.
* Inventory: At the start of the game Xavier starts with his trusty machete, some bombs and some climbing ropes. You can use those items by selecting them (see the controls section below). Also, remember that you can only carry a limited amount of items, and that you can drop items if you don't want them.
* Some times you will come across doors that can be open by stepping on a button. If you want to keep the door open, you will have to drag/put some heavy item onto the button.
* Xavier cannot fall from an arbitrary height, so be careful!
* Xavier's jump can be controller mid-air, but he will have inertia towards the initial jumping direction. So, be careful when jumping!
* Xavier can swim, but not dive unless equipped ed with the appropriate gear. So, unless you have the diving mask, stay on the surface of water!
* If you crouch, you can see further down, to plan for long drops.
* If you are near the edge of the screen and want to see what's beyond, just crouch. Each time you crouch, the game will center the screen on Xavier, letting you see what is around.
* Keep a healthy supply of bombs and ropes around: in the earlier stages of the game, all the levels are guaranteed to be solveable without requiring the use of bombs and ropes. But as the game progresses there is a small chance that that is not the case. So, you might need to rely on ropes or bombs (or even on some rarely found items such as the diving mask) to be able to complete levels. 


## Controls

Keyboard:
* Walk                  - left/right
* Jump                  - up
* Crouch                - down
* Climb up/down         - up/down
* Grab a rope           - hold up when in the air
* Jump when on a rope   - up twice (this can be configured in the config screen to be changed to space/trigger A)
* Drop when on a rope   - down twice
* Change selected item  - M / Z / joystick trigger B or number keys 1 through 8
* Attack with machete   - space / X / joystick trigger A
* Pick up items         - crouch then space / X / joystick trigger A
* Drop items            - select them, then crouch plus space / X / joystick trigger A
* Throw bombs/ropes/etc.- select them, hold space, then point in the direction you want to throw, and release space
* Push boulders         - just keep walking onto them
* Pause                 - P


In the title screen:
* Space/trigger A to start the game
* M/trigger B to go to the configuration screen

In the configuration screen:
* Space / X / joystick trigger A to change a config option
* up/down to change the configuration variable to edit
* M / Z / joystick trigger B to go back to the title screen

Each time you start a new level, it will have to be generated. Wait until the "WAIT..." message disappears, and then you can press space/trigger A to start playing.

## Items

* ![Machete](https://raw.githubusercontent.com/santiontanon/xspelunker/master/data/instructions/item-machete.png) Machete: This is the main weapon of Xavier, use it by pressing Space/Trigger A. It cannot be dropped, and also, it cannot be used when grabbing a rope or when swimming.
* ![Bomb](https://raw.githubusercontent.com/santiontanon/xspelunker/master/data/instructions/item-bomb.png) Bomb: use it to either destroy a wall if you need to make a new path, or to kill enemies. You can either drop it (crouch plus Space/Trigger A), or throw it (hold Space/Trigger A, then point the direction to throw and then release Space/Trigger A).
* ![Rope](https://raw.githubusercontent.com/santiontanon/xspelunker/master/data/instructions/item-rope.png) Rope: can be thrown (hold Space/Trigger A, then point the direction to throw and then release Space/Trigger A), and if it hits a ceiling, it'll get attached and drop, so you can climb it.
* ![Stone](https://raw.githubusercontent.com/santiontanon/xspelunker/master/data/instructions/item-stone.png) Stone: can be thrown and used as a mid-range weapon. To throw hold Space/Trigger A, then point the direction to throw and then release Space/Trigger A.
* ![Shield](https://raw.githubusercontent.com/santiontanon/xspelunker/master/data/instructions/item-shield.png) Shield: can deflect bullets/stones thrown at you. To use it just stay still, and Xavier will use it automatically (no need to select it). But if you are walking/jumping/attacking/climbing/etc. Xavier will not have enough reflexes to use it!
* ![Arrow](https://raw.githubusercontent.com/santiontanon/xspelunker/master/data/instructions/item-arrow.png) Arrow: can be thrown and used as a mid-range weapon. To throw hold Space/Trigger A, then point the direction to throw and then release Space/Trigger A. But it is better used in combination with a bow, which can throw arrows at greater distances!
* ![Bow](https://raw.githubusercontent.com/santiontanon/xspelunker/master/data/instructions/item-bow.png) Bow: can be used to throw arrows at great distances. To shoot, select the bow, then hold Space/Trigger A, then point the direction to throw and then release Space/Trigger A.
* ![Boots](https://raw.githubusercontent.com/santiontanon/xspelunker/master/data/instructions/item-boots.png) Boots: increase jumping height.
* ![Diving Mask](https://raw.githubusercontent.com/santiontanon/xspelunker/master/data/instructions/item-mask.png) Diving Mask: allow Xavier to go under water without losing health.
* ![Idol](https://raw.githubusercontent.com/santiontanon/xspelunker/master/data/instructions/item-idol.png) Idol: it has no obvious use. But it's very heavy!
* ![Phaser](https://raw.githubusercontent.com/santiontanon/xspelunker/master/data/instructions/item-phaser.png) Phaser: the ultimate weapon! it never runs out of bullets (it's quite rare though and can only be found in later levels). To use it select the phaser, then hold Space/Trigger A, then point the direction to shoot and then release Space/Trigger A.
* ![Antigravity Belt](https://raw.githubusercontent.com/santiontanon/xspelunker/master/data/instructions/item-belt.png) Antigravity Belt: slows down falls, letting Xavier fall from arbitrary heights without being hurt.


## Compatibility

The game was designed to be played on MSX1 computers with at least 16KB of RAM. I used the Philips VG8020 as the reference machine (since that's the MSX I owned as a kid), but I've tested it in some other machines using OpenMSX v0.14. If you detect an incompatibility, please let me know!


## Notes:

Some notes and useful links I used when coding XSpelunker

* There is a "build" script in the home folder. Use it to re-build the game from sources.
* Also, XSpelunker uses many different data files (graphics/sounds/maps/etc.). Most of those are generated automatically from PNG images, or TMX map files. You can re-generate those data files by running the "regenerateData" script.
* To measure code execution time I used: http://msx.jannone.org/bit/
* Math routines: http://z80-heaven.wikidot.com/math
* PSG (sound) registers: http://www.angelfire.com/art2/unicorndreams/msx/RR-PSG.html
* Z80 tutorial: http://sgate.emt.bme.hu/patai/publications/z80guide/part1.html
* Z80 user manual: http://www.zilog.com/appnotes_download.php?FromPage=DirectLink&dn=UM0080&ft=User%20Manual&f=YUhSMGNEb3ZMM2QzZHk1NmFXeHZaeTVqYjIwdlpHOWpjeTk2T0RBdlZVMHdNRGd3TG5Ca1pnPT0=
* MSX system variables: http://map.grauw.nl/resources/msxsystemvars.php
* MSX bios calls: 
    * http://map.grauw.nl/resources/msxbios.php
    * https://sourceforge.net/p/cbios/cbios/ci/master/tree/
* VDP reference: http://bifi.msxnet.org/msxnet/tech/tms9918a.txt
* VDP manual: http://map.grauw.nl/resources/video/texasinstruments_tms9918.pdf
* The game was compiled with Grauw's Glass compiler (cannot thank him enough for creating it): https://bitbucket.org/grauw/glass
* In order to compress data I used Pletter v0.5b - XL2S Entertainment 2008 (there is a Java port of the Pletter compressor in the Java source code in the repository).

