# cx16assem

File-based 65c02 assembler for Commander-X16 (Work in progress)

Requires recent prog8 compiler to build from source.

## Compiling the assembler

The assembler requires some autogenerated code for instruction matching.
This code is created by a python script. You can do this manually and then use
the Prog8 compiler ``p8compile`` to finally compile the assembler, but
it's easier to use the supplied Makefile:

Just type 'make'.

Type 'make emu' to immediately boot the assembler in the Commander X16 emulator.


## Usage

*Note:* requires using a SD-card image to be mounted as drive 8 in the emulator, doesn't work currently on a host filesystem passthrough.

Usage should be self-explanatory.
When started, the assembler prints the available commands.
After successfully assembling a source file, a summary will be printed. 
You can then enter the filename to save the program as on disk (will overwrite existing file with the same name!).
It's always saved in PRG format, so you can load the program again with ``LOAD "NAME",8,1``

At the moment, the source file is cached in (V)RAM and so is limited to 62 Kb for now.

## Features

- read source files (up to 62 Kb) straight from disk  (sdcard in the emulator)
- write output as PRG file to disk (sdcard in the emulator)
- set program counter with "* = $9000"
- numbers in decimal 12345, hex $abcd, binary %1010011
- symbolic labels
- define data with ``.byte  1,2,3,4`` and ``.str  "hello!"`` 


## Todo

- more assembler directives such as ".word"

- command to switch to (the rom-based) x16edit to avoid having to swap-load programs all the time

- can we get it to work on a host mounted filesystem in the emulator?
  
- write output machine code to upper banked RAM instead of main memory, so we can assemble larger programs,
  and it doesn't potentially overwrite the assembler itself or the symbol table in system ram.
  (this also means we can't simply use SAVE routine anymore)
  
- optimize phase 1, it now does too many things that are actually only needed in phase 2


### Maybe some day:

  
- include / incbin  to read in separate files

- relative labels (+ / -)

- simple expressions  (+, -, bitwise and/or/xor, bitwise shifts, maybe simple multiplication)

- local scoped labels

- macros

- better error descriptions?
