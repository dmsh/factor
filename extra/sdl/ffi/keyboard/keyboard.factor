! Copyright (C) 2010 Dmitry Shubin.
! See http://factorcode.org/license.txt for BSD license.
USING: alien.c-types alien.syntax classes.struct sdl.ffi
sdl.ffi.keysym ;
IN: sdl.ffi.keyboard

LIBRARY: libsdl

TYPEDEF: int SDLMod

STRUCT: SDL_keysym
    { scancode Uint8  }
    { sym      SDLKey }
    { mod      SDLMod }
    { unicode  Uint16 } ;

CONSTANT: ALL_HOTKEYS HEX: FFFFFFFF

CONSTANT: DEFAULT_REPEAT_DELAY    500
CONSTANT: DEFAULT_REPEAT_INTERVAL 30

FUNCTION: int SDL_EnableUNICODE ( int enable ) ;
FUNCTION: int SDL_EnableKeyRepeat ( int delay, int interval ) ;
FUNCTION: void SDL_GetKeyRepeat ( int* delay, int* interval ) ;
FUNCTION: Uint8* SDL_GetKeyState ( int* numkeys ) ;
FUNCTION: SDLMod SDL_GetModState ( ) ;
FUNCTION: void SDL_SetModState ( SDLMod modstate ) ;
FUNCTION: c-string SDL_GetKeyName ( SDLKey key ) ;
