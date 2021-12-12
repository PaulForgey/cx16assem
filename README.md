# cx16assem

File-based 65c02 assembler for Commander-X16 (*Work in progress*)

Software License: MIT open source, see file LICENSE.

⚠️ requirements: patched v39 roms, sdcard image (no host filesystem passthrough) ⚠️
- requires [ZeroByte's patched Kernal](https://www.commanderx16.com/forum/index.php?/topic/2064-r39-patched-kernal-to-fix-load-into-hiram-functionality)
LOAD routine to deal with the HIRAM banks correctly!
Using the default unpatched V39 kernal Rom *will* crash the commander X16, and *can corrupt* your sd-card image!
- due to remaining kernal / emulator bugs, *the file loading mechanism only
works on an attached sdcard image in the emulator*. Host mounted filesystem doesn't work.

You'll need a very recent prog8 compiler to build the assembler from source, probably even a dev version
that hasn't been officially released yet.



## Compiling the assembler

The assembler requires some autogenerated code for instruction matching.
This code is created by a python script. You can do this manually and then use
the Prog8 compiler ``p8compile`` to finally compile the assembler, but
it's easier to use the supplied Makefile: 

Just type ``make`` to compile the assembler.
Type ``make emu`` to compile and immediately start the assembler in the Commander X16 emulator.


## Usage

Usage should be self-explanatory: when started, the assembler prints the available commands.
After successfully assembling a source file, a summary will be printed. 
You can then enter the filename to save the program as on disk (will overwrite existing file with the same name!).
It's always saved in PRG format, so you can load the program again with ``LOAD "NAME",8,1``

## Features

- reads source files (any size) from disk  (sdcard)
- write resulting output directly as PRG file to disk (sdcard)
- can assemble to any system memory location 
- set program counter with ```* = $9000```
- numbers can be written in decimal ``12345``, hex ``$abcd``, binary ``%1010011``
- symbolic labels
- use ``<value`` and ``>value`` to get the lsb and msb of a value respectively
- define data with ``.byte  1,2,3,4``, ``.word $a004,$ffff`` and ``.str  "hello!"``
- include binary data from a file using ``.incbin "filename"``   *being implemented*
- include source code from a file using ``.include "filename"``   *being implemented*
- disk device 8 and 9 selectable
- configurable text and screen colors
- can switch to (rom-based) x16edit to edit a file, to avoid having to swap-load programs all the time.
  You'll have to create a custom rom with x16edit embedded in it in bank 7, see [instructions](https://github.com/stefan-b-jakobsson/x16-edit/blob/master/docs/romnotes.pdf).
  (version 0.4.1 or later is required)


## How it works internally
- Files are read sequentially into the banked hiram $a000-$c000, starting from bank 1 (bank 0 is reserved)
  (uses kernal LOAD for this to achieve high load speeds)
- Metadata about the files (name, address, size) is stored in tables in regular system ram.
- Parsing is done on lines from the source files that are copied to a small buffer in system ram to be tokenized.
- Parse phase 1 just builds the symbol table in system ram. This is a hash table for fast lookups.
- Parse phase 2 actually outputs machine code into the last 8 himem banks (64 Kb max output size).
- Finally, the data in these output banks is written to the output prg file on disk.
- Mnemonics matching is done via an optimal prefix-tree match routine that takes very few instructions to find the match

## Todo

- simple expressions  (+, -, bitwise and/or/xor, bitwise shifts, maybe simple multiplication)

- local scoped labels, relative labels (+/-)

- macros?

- better error descriptions?
