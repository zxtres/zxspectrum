# How to update

Copy the relevant BIT file (a35t for ZXTRES, a100t for ZXTRES+ or a200t for ZXTRES++) into the BIN directory of your ESXDOS enabled SD card. Make sure you have the UPDCORE command (available at the SW directory of the ZX Spectrum repository).

Now boot the ZXTRES , type .updcore and follow directions.

If a message tells you that you are not in root mode, do a master reboot (Ctrl-Alt-Bkspace) and keep pressing SYMBOL SHIFT+V until you see a red border, indicating you are now in root mode, and repeat the procedure.

SYMBOL SHIFT key is mapped to Alt Gr (or right Alt) key in the PC keyboard.

# Changelog

## Version 070823

-   Fixed SRAM management. Now the core correctly detects and use the complete 2 MB SRAM chip. You should see that in the boot screen.
-   PZX player now can handle up to to 1728 KB for a PZX file.
-   VGA output fixed. Now it uses 24 bits instead of 18.
-   RTC and MIDI connections are implemented. Waiting for MIDI implementation on the middle board for further testing.
-   Easter egg (!!) restored for A100T and A200T versions (A35T took all the available memory so we couldn't keep the easter egg code in it)
    -   Wait! You don't know about the ZXUNO easter egg? Just ask ;)
-   Current issues
    -   RTC module doesn't seem to work, although it could be just my unit.
    -   No sound through DisplayPort yet :(

## Version 280723 First public version for ZXTRES platform. Features:

-   All features from ZXUNO project, including optional features (SAA1099, monochrome/green/amber palette, wifi, and many more I can't remember right now :P )
-   DisplayPort output (640x480, 60 fps, no sound atm)
-   VGA output (640x480, 60 fps)
-   I2S and sigma-delta sound output
-   Monochrome switcher is activated using key END (FIN on spanish keyboard). Cycles through: colour, green, amber, grayscale
-   For A100T and A200T (ZXTRES+ and ZXTRES++ platforms), full line framescaler, so interlace modes are enabled. Key HOME (INICIO on spanish keyboard). Cycles through: off, auto, on, blend. Auto and On use full field display (384 lines in paper area). Auto detects whether a gigascreen/interlaced picture is about to be displayed (detects when main/shadow VRAM are switched on every vertical retrace interrupt) and enables full field scan only at those moments. "On" allows full field at all times. Blend takes the information from both fields and creates a single field screen with colours created by mixing colours from both fields.
