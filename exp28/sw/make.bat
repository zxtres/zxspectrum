@echo off
set progname=%1
del %progname%.bin
del %progname%.ihx
del %progname%

sdcc -mz80 --opt-code-size --reserve-regs-iy --max-allocs-per-node 10000 ^
--nostdlib --nostdinc --no-std-crt0 --code-loc 8192 --data-loc 12288 %progname%.c

makebin -p %progname%.ihx %progname%.bin
dd if=%progname%.bin of=%progname% bs=1 skip=8192


