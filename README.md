# Changelog

## Version 090923

- Enabled core loading using the middle board. Implemented a second UART for easier comunication with the RP2040.
- ZX3 core loading should work also.
- RTC issues. Working on that.

## Version 070823

-   Fixed SRAM management. Now the core correctly detects and use the complete 2 MB SRAM chip. You should see that in the boot screen.
-   PZX player now can handle up to to 1728 KB for a PZX file.
-   VGA output fixed. Now it uses 24 bits instead of 18.
-   RTC and MIDI connections are implemented. Waiting for MIDI implementation on the middle board for further testing.
-   Easter egg (!!) restored for A100T and A200T versions (A35T took all the available memory so we couldn't keep the easter egg code in it)
    -   Wait! You don't know about the ZXUNO easter egg? Just ask ;)
-   Current issues
    -   No sound through DisplayPort yet :(

## Version 280723 First public version for ZXTRES platform. Features:

-   All features from ZXUNO project, including optional features (SAA1099, monochrome/green/amber palette, wifi, and many more I can't remember right now :P )
-   DisplayPort output (640x480, 60 fps, no sound atm)
-   VGA output (640x480, 60 fps)
-   I2S and sigma-delta sound output
-   Monochrome switcher is activated using key END (FIN on spanish keyboard). Cycles through: colour, green, amber, grayscale
-   For A100T and A200T (ZXTRES+ and ZXTRES++ platforms), full line framescaler, so interlace modes are enabled. Key HOME (INICIO on spanish keyboard). Cycles through: off, auto, on, blend. Auto and On use full field display (384 lines in paper area). Auto detects whether a gigascreen/interlaced picture is about to be displayed (detects when main/shadow VRAM are switched on every vertical retrace interrupt) and enables full field scan only at those moments. "On" allows full field at all times. Blend takes the information from both fields and creates a single field screen with colours created by mixing colours from both fields.
