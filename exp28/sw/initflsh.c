/*
Compilar con:
sdcc -mz80 --reserve-regs-iy --opt-code-size --max-allocs-per-node 10000
--nostdlib --nostdinc --no-std-crt0 --code-loc 8192 readspi.c
*/

typedef unsigned char BYTE;
typedef unsigned short WORD;

enum {IBLACK=0, IBLUE, IRED, IMAG, IGREEN, ICYAN, IYELLOW, IWHITE};
enum {PBLACK=0, PBLUE=8, PRED=16, PMAG=24, PGREEN=32, PCYAN=40, PYELLOW=48, PWHITE=56};
#define BRIGHT 64
#define FLASH 128

__sfr __at (0xfe) ULA;
__sfr __at (0xff) ATTR;
__sfr __at (0x1f) KEMPSTONADDR;
__sfr __at (0x7f) FULLERADDR;

__sfr __banked __at (0xf7fe) SEMIFILA1;   // 1 - 5
__sfr __banked __at (0xeffe) SEMIFILA2;   // 6 - 0
__sfr __banked __at (0xfbfe) SEMIFILA3;   // Q - T
__sfr __banked __at (0xdffe) SEMIFILA4;   // Y - P
__sfr __banked __at (0xfdfe) SEMIFILA5;   // A - G
__sfr __banked __at (0xbffe) SEMIFILA6;   // H - ENT
__sfr __banked __at (0xfefe) SEMIFILA7;   // CS - V
__sfr __banked __at (0x7ffe) SEMIFILA8;   // B - SPC
__sfr __banked __at (0x00fe) ANYKEY;

#define ATTRP 23693
#define ATTRT 23695
#define BORDR 23624
#define LASTK 23560

#define WAIT_VRETRACE __asm halt __endasm
#define WAIT_HRETRACE while(ATTR!=0xff)
#define SETCOLOR(x) (*(BYTE *)(ATTRP)=(x))
#define LASTKEY (*(BYTE *)(LASTK))
#define ATTRPERMANENT (*((BYTE *)(ATTRP)))
#define ATTRTEMPORARY (*((BYTE *)(ATTRT)))
#define BORDERCOLOR (*((BYTE *)(BORDR)))

#define MAKEWORD(d,h,l) { ((BYTE *)&(d))[0] = (l) ; ((BYTE *)&(d))[1] = (h); }

__sfr __banked __at (0xfc3b) ZXUNOADDR;
__sfr __banked __at (0xfd3b) ZXUNODATA;

#define MASTERCONF  0x00
#define FLASHSPI    0x02
#define FLASHCS     0x03
#define SCANCODE    0x04
#define KEYBSTAT    0x05
#define JOYCONF     0x06
#define SCANDBLR    0x0B
#define MEMCONFIG   0x10
#define EXTSPI      0x82
#define EXTCS       0x83
#define SRAMDATA    0xfd
#define SRAMADDRINC 0xfc
#define SRAMADDR    0xfb
#define COREID      0xff

/* Some ESXDOS system calls */
#define HOOK_BASE   128
#define MISC_BASE   (HOOK_BASE+8)
#define FSYS_BASE   (MISC_BASE+16)
#define M_GETSETDRV (MISC_BASE+1)
#define F_OPEN      (FSYS_BASE+2)
#define F_CLOSE     (FSYS_BASE+3)
#define F_READ      (FSYS_BASE+5)
#define F_WRITE     (FSYS_BASE+6)
#define F_SEEK      (FSYS_BASE+7)
#define F_GETPOS    (FSYS_BASE+8)

#define FMODE_READ	     0x1 // Read access
#define FMODE_WRITE      0x2 // Write access
#define FMODE_OPEN_EX    0x0 // Open if exists, else error
#define FMODE_OPEN_AL    0x8 // Open if exists, if not create
#define FMODE_CREATE_NEW 0x4 // Create if not exists, if exists error
#define FMODE_CREATE_AL  0xc // Create if not exists, else open and truncate

#define SEEK_START       0
#define SEEK_CUR         1
#define SEEK_BKCUR       2

#define BUFSIZE 1024
BYTE errno;
BYTE buffer[BUFSIZE];

BYTE main (char *p);
void getcoreid(BYTE *s);
void usage (void);
BYTE commandlinemode (char *p);

void __sdcc_enter_ix (void) __naked;
void cls (BYTE);

void puts (BYTE *);
void u16tohex (WORD n, char *s);
void u8tohex (BYTE n, char *s);
void print8bhex (BYTE n);
void print16bhex (WORD n);

void memset (BYTE *, BYTE, WORD);
void memcpy (BYTE *, BYTE *, WORD);

BYTE open (char *filename, BYTE mode);
void close (BYTE handle);
WORD read (BYTE handle, BYTE *buffer, WORD nbytes);
WORD write (BYTE handle, BYTE *buffer, WORD nbytes);
void seek (BYTE handle, WORD hioff, WORD looff, BYTE from);

/* --------------------------------------------------------------------------------- */
/* --------------------------------------------------------------------------------- */
/* --------------------------------------------------------------------------------- */
BYTE getfilename (char *p, char *fname, WORD *kbytes);
void copyfromfile2spi (BYTE handle, BYTE palvga, BYTE scanlines);
WORD getflashid (void);

void init (void) __naked
{
     __asm
     xor a
     ld (#_errno),a
     push hl
     call _main
     inc sp
     inc sp
     ld a,l
     or a
     ret z
     scf
     ret
     __endasm;
}

BYTE main (char *p)
{
  BYTE res = 0;
  
  if (p)
  {
    if (p[1]=='h')
    {
      usage();
      res = 0;
    }
    else
      res = commandlinemode(p);
  }
  else
    res = commandlinemode(p);
  return res;
}

BYTE commandlinemode (char *p)
{
  char *fname;
  BYTE handle;
  BYTE palvga = 0;     // parche en 704D en la flash
  BYTE scanlines = 0;  // parche en 704E en la flash
  BYTE fpga = 0;
  BYTE root;
  BYTE tecla;
  WORD id;
  
  ZXUNOADDR = MASTERCONF;
  root = ZXUNODATA;
  ZXUNODATA = root & 0x7F;  // intento resetear el bit 7
  root = ZXUNODATA;

  if ((root & 0x80) != 0)
  {     // 01234567890123456789012345678901
    puts ("Must be root to write to flash\x0D"
          "Terminated.\x0D");
    return 0;
  }
  
  puts ("Flash ID: ");
  id = getflashid();
  print16bhex (id);
  puts("\x0D\x0D");
  if (id != 0xC220)
  {
    puts ("Not a valid ZXTRES flash chip\x0D");
    return 0;
  }
  
  ZXUNOADDR = MEMCONFIG;
  fpga = ZXUNODATA;
  fpga = (fpga>>5) & 0x7;
  
  ZXUNOADDR = SCANDBLR;
  palvga = ZXUNODATA;
  palvga &= 0x1;
  palvga <<= 1;
  scanlines = ZXUNODATA;
  scanlines = (scanlines>>1) & 0x1;
  
  while (*p=='-')
  {
    p++;
    if (*p=='a' && fpga == 0)
    {
      p++;
      if (*p=='3')
      {
        fpga = 1;
        p+=3;
      }
      else if (*p=='1')
      {
        fpga = 2;
        p+=4;
      }
      else if (*p=='2')
      {
        fpga = 3;        
        p+=4;
      }        
    }
    else if (*p=='p')
    {
      palvga = 0;
      p+=3;
    }
    else if (*p=='v')
    {
      palvga = 2;
      p+=3;
    }
    else
    {
      while (*p!=' ' && *p!=':' && *p!=0xd)
        p++;
      if (*p==' ')
        p++;
    }
    
    while (*p!=':' && *p!=0xd && *p!='-')
      p++;
  }
  
  if (fpga == 0)
  {     // 01234567890123456789012345678901
    puts ("Could not determine FPGA version"
          "Please use -a35t,-a100t,-a200t\x0D"
          "to provide specific version.\x0D");
    return 0;
  }
  
  if (fpga == 1)
    fname = (char *)"/bin/fl_a35t.bin";
  else if (fpga == 2)
    fname = (char *)"/bin/fl_a100t.bin";
  else
    fname = (char *)"/bin/fl_a200t.bin";
  
  handle = open (fname, FMODE_READ);
  if (handle==0xff)
  {
    puts ("Couldn't load ");
    puts (fname);
    puts ("\x0D");
    return errno;
  }
  
      // 01234567890123456789012345678901
  puts ("INITIAL FLASH UPLOADER FOR ZX3\x0D"
        "------------------------------\x0D"
        "\x0D"
        "Flash update is about to start.\x0D"
        "Don't turn off the machine.\x0D"
        "If update fails, neither turn\x0D"
        "off nor do a master reset. Per-\x0D"
        "form a ESXDOS reset (Ctrl-Alt-\x0D"
        "Supr, then, SPACE) and try again\x0D\x0D"
        "Now, press U to update flash, or"
        "SPACE to abort.\x0D");

  while (1)
  {
    if ((SEMIFILA4 & 0x08) == 0)
    {
      tecla = 'u';
      break;
    }
    else if ((SEMIFILA8 & 0x01) == 0)
    {
      tecla = ' ';
      break;
    }
  }
  
  if (tecla == 'u')
    copyfromfile2spi (handle, palvga, scanlines);
  else
    puts ("\x0D""Abort!\x0D");

  close (handle);
  return 0;
}

void usage (void)
{
        // 01234567890123456789012345678901
    puts (" INITFLSH [options]\x0D\x0D"
          "Writes initial flash contents\x0D"
          "from BIN file.\x0D"
          "Options:\x0D"
          "-vga   : VGA boot option\x0D"
          "-pal   : RGB 15kHz boot option\x0D"
          "-bit   : Updates FPGA core only\x0D"
          "-a35t  : FPGA is Artix 7-35\x0D"
          "-a100t : FPGA is Artix 7-100\x0D"
          "-a200t : FPGA is Artix 7-200\x0D\x0D"
          "The BIN file must reside in the\x0D"
          "BIN directory alonside this pro-\x0D"
          "gram. Must be one of these:\x0D"
          " fl_a35t.bin\x0D"
          " fl_a100t.bin or \x0D"
          " fl_a200t.bin");
}

void enablespi (void)
{
    ZXUNOADDR = FLASHCS;
    ZXUNODATA = 0;
}

void disablespi (void)
{
    ZXUNOADDR = FLASHCS;
    ZXUNODATA = 1;
}

void writespi (BYTE n)
{
    ZXUNOADDR = FLASHSPI;
    ZXUNODATA = n;
}

BYTE readspi (void)
{
    ZXUNOADDR = FLASHSPI;
    return ZXUNODATA;
}

void waitstatus (void)
{
    enablespi();
    writespi(5);
    readspi();
    while (readspi() & 1);
    disablespi();
}

WORD getflashid (void)
{
  WORD res;
  BYTE d;
  
  enablespi();
  writespi(0x9f);
  d = readspi();
  d = readspi();
  res = d<<8;
  d = readspi();
  disablespi();

  res |= d;
  return res;
}

void copyfromfile2spi (BYTE handle, BYTE palvga, BYTE scanlines)
{
    BYTE i, j;
    WORD pagina;  // una pagina = 256 bytes
    WORD leido;
    BYTE *p;
              // 01234567890123456789012345678901
    puts ("\x0D""Printing a * for each 64K block\x0D\x0D");
    
    pagina = 0;
    while(1)
    {
        if ((pagina & 0xf)==0)   // Borramos un sector (4KB)
        {
           enablespi();
           writespi(0x06);
           disablespi();

           enablespi();
           writespi(0x20);
           writespi((pagina>>8) & 0xFF);
           writespi(pagina & 0xFF);
           writespi(0x00);
           disablespi();
        }

        leido = read (handle, buffer, 1024);
        if (leido == 0 || leido == 0xFFFF)
          break;
        
        p = buffer;
        for (i=0; i<4; i++)   // escribo 4 páginas de golpe (1KB)
        {
          if (pagina == 112)
          {
            *(p+0x4D) = palvga;    // parche en 704D
            *(p+0x4E) = scanlines; // parche en 704E
          }
          
          waitstatus();

          enablespi();
          writespi(0x06);
          disablespi();

          enablespi();
          writespi(0x2);   // Escribimos una página (256 b)
          writespi((pagina>>8) & 0xFF);
          writespi(pagina & 0xFF);
          writespi(0x00);

          for (j=0; j<16; j++)
          {
              ZXUNODATA = *p++;  // writespi rapidito
              ZXUNODATA = *p++;  // writespi rapidito
              ZXUNODATA = *p++;  // writespi rapidito
              ZXUNODATA = *p++;  // writespi rapidito
              ZXUNODATA = *p++;  // writespi rapidito
              ZXUNODATA = *p++;  // writespi rapidito
              ZXUNODATA = *p++;  // writespi rapidito
              ZXUNODATA = *p++;  // writespi rapidito
              ZXUNODATA = *p++;  // writespi rapidito
              ZXUNODATA = *p++;  // writespi rapidito
              ZXUNODATA = *p++;  // writespi rapidito
              ZXUNODATA = *p++;  // writespi rapidito
              ZXUNODATA = *p++;  // writespi rapidito
              ZXUNODATA = *p++;  // writespi rapidito
              ZXUNODATA = *p++;  // writespi rapidito
              ZXUNODATA = *p++;  // writespi rapidito
          }
          disablespi();
          waitstatus();

          if ((pagina & 0xff) == 0x00)  // asterisco cada 64K escritos
          {
             __asm
                  ld a,#'*'
                  rst #16
                  ld a,#255
                  ld (#23692),a
             __endasm;
          }
          pagina++;
        }    
    }
    
    puts ("\x0D""Done!");
}

/* --------------------------------------------------------------------------------- */
/* --------------------------------------------------------------------------------- */
/* --------------------------------------------------------------------------------- */
#pragma disable_warning 85
#pragma disable_warning 59
void memset (BYTE *dir, BYTE val, WORD nby)
{
  __asm
  push bc
  push de
  ld l,4(ix)
  ld h,5(ix)
  ld a,6(ix)
  ld c,7(ix)
  ld b,8(ix)
  ld d,h
  ld e,l
  inc de
  dec bc
  ld (hl),a
  ldir
  pop de
  pop bc
  __endasm;
}

void memcpy (BYTE *dst, BYTE *fue, WORD nby)
{
  __asm
  push bc
  push de
  ld e,4(ix)
  ld d,5(ix)
  ld l,6(ix)
  ld h,7(ix)
  ld c,8(ix)
  ld b,9(ix)
  ldir
  pop de
  pop bc
  __endasm;
}

void puts (BYTE *str)
{
  __asm
  push bc
  push de
  ld a,(#ATTRT)
  push af
  ld a,(#ATTRP)
  ld (#ATTRT),a
  ld l,4(ix)
  ld h,5(ix)
buc_print:
  ld a,(hl)
  or a
  jp z,fin_print
  cp #4
  jr nz,no_attr
  inc hl
  ld a,(hl)
  ld (#ATTRT),a
  inc hl
  jr buc_print
no_attr:
  rst #16
  inc hl
  jp buc_print

fin_print:
  pop af
  ld (#ATTRT),a
  pop de
  pop bc
  __endasm;
}

void u16tohex (WORD n, char *s)
{
 u8tohex((n>>8)&0xFF,s);
 u8tohex(n&0xFF,s+2);
}

void u8tohex (BYTE n, char *s)
{
 BYTE i=1;
 BYTE resto;

 resto=n&0xF;
 s[1]=(resto>9)?resto+55:resto+48;
 resto=n>>4;
 s[0]=(resto>9)?resto+55:resto+48;
 s[2]='\0';
}

void print8bhex (BYTE n)
{
   char s[3];

   u8tohex(n,s);
   puts(s);
}

void print16bhex (WORD n)
{
   char s[5];

   u16tohex(n,s);
   puts(s);
}

void __sdcc_enter_ix (void) __naked
{
    __asm
    pop	hl	; return address
    push ix	; save frame pointer
    ld ix,#0
    add	ix,sp	; set ix to the stack frame
    jp (hl)	; and return
    __endasm;
}

BYTE open (char *filename, BYTE mode)
{
    __asm
    push bc
    push de
    xor a
    rst #8
    .db #M_GETSETDRV   ;Default drive in A
    ld l,4(ix)  ;Filename pointer
    ld h,5(ix)  ;in HL
    ld b,6(ix)  ;Open mode in B
    rst #8
    .db #F_OPEN
    jr nc,open_ok
    ld (#_errno),a
    ld a,#0xff

open_ok:

    ld l,a
    pop de
    pop bc
    __endasm;
}

void close (BYTE handle)
{
    __asm
    push bc
    push de
    ld a,4(ix)  ;Handle
    rst #8
    .db #F_CLOSE
    pop de
    pop bc
    __endasm;
}

WORD read (BYTE handle, BYTE *buffer, WORD nbytes)
{
    __asm
    push bc
    push de
    ld a,4(ix)  ;File handle in A
    ld l,5(ix)  ;Buffer address
    ld h,6(ix)  ;in HL
    ld c,7(ix)
    ld b,8(ix)  ;Buffer length in BC
    rst #8
    .db #F_READ
    jr nc,read_ok
    ld (#_errno),a
    ld bc,#65535

read_ok:

    ld h,b
    ld l,c
    pop de
    pop bc
    __endasm;
}

WORD write (BYTE handle, BYTE *buffer, WORD nbytes)
{
    __asm
    push bc
    push de
    ld a,4(ix)  ;File handle in A
    ld l,5(ix)  ;Buffer address
    ld h,6(ix)  ;in HL
    ld c,7(ix)
    ld b,8(ix)  ;Buffer length in BC
    rst #8
    .db #F_WRITE
    jr nc,write_ok
    ld (#_errno),a
    ld bc,#65535
  
write_ok:

    ld h,b
    ld l,c
    pop de
    pop bc
    __endasm;
}

void seek (BYTE handle, WORD hioff, WORD looff, BYTE from)
{
    __asm
    push bc
    push de
    ld a,4(ix)  ;File handle in A
    ld c,5(ix)  ;Hiword of offset in BC
    ld b,6(ix)
    ld e,7(ix)  ;Loword of offset in DE
    ld d,8(ix)
    ld l,9(ix)  ;From where: 0: start, 1:forward current pos, 2: backwards current pos
    rst #8
    .db #F_SEEK
    pop de
    pop bc
    __endasm;
}

void getcoreid(BYTE *s)
{
  BYTE cont;
  volatile BYTE letra;

  ZXUNOADDR = COREID;
  cont=0;

  do
  {
    letra = ZXUNODATA;
    *(s++) = letra;
    cont++;
  }
  while (letra!=0 && cont<32);
  *s='\0';
}
