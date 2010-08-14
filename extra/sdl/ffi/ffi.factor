! Copyright (C) 2010 Dmitry Shubin.
! See http://factorcode.org/license.txt for BSD license.
USING: alien alien.c-types alien.libraries alien.syntax ;
IN: sdl.ffi

<< "libsdl" "libSDL.so" cdecl add-library >>

LIBRARY: libsdl

TYPEDEF: char      Sint8
TYPEDEF: uchar     Uint8
TYPEDEF: short     Sint16
TYPEDEF: ushort    Uint16
TYPEDEF: int       Sint32
TYPEDEF: uint      Uint32
TYPEDEF: longlong  Sint64
TYPEDEF: ulonglong Uint64
ENUM: SDL_bool SDL_FALSE SDL_TRUE ;

! SDL.h

CONSTANT: TIMER        HEX: 00000001
CONSTANT: AUDIO        HEX: 00000010
CONSTANT: VIDEO        HEX: 00000020
CONSTANT: CDROM        HEX: 00000100
CONSTANT: JOYSTICK     HEX: 00000200
CONSTANT: NOPARACHUTE  HEX: 00100000
CONSTANT: EVENTTHREAD  HEX: 01000000
CONSTANT: EVERYTHING   HEX: 0000FFFF

FUNCTION: int SDL_Init ( Uint32 flags ) ;
FUNCTION: int SDL_InitSubSystem ( Uint32 flags ) ;
FUNCTION: void SDL_QuitSubSystem ( Uint32 flags ) ;
FUNCTION: Uint32 SDL_WasInit ( Uint32 flags ) ;
FUNCTION: void SDL_Quit ( ) ;

! SDL_error.h

FUNCTION: void SDL_SetError ( c-string fmt ) ;
FUNCTION: c-string SDL_GetError ( ) ;
FUNCTION: void SDL_ClearError ( ) ;
