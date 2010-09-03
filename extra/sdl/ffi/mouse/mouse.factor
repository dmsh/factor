! Copyright (C) 2010 Dmitry Shubin.
! See http://factorcode.org/license.txt for BSD license.
USING: alien.c-types alien.syntax classes.struct kernel literals math
sdl.ffi sdl.ffi.video ;
IN: sdl.ffi.mouse

LIBRARY: libsdl

C-TYPE: WMcursor
STRUCT: SDL_Cursor
    { area      SDL_Rect  }
    { hot_x     Sint16    }
    { hot_y     Sint16    }
    { data      Uint8*    }
    { mask      Uint8*    }
    { save      Uint8*[2] }
    { wm_cursor WMcursor* } ;

FUNCTION: Uint8 SDL_GetMouseState ( int* x, int* y ) ;
FUNCTION: Uint8 SDL_GetRelativeMouseState ( int* x, int* y ) ;
FUNCTION: void SDL_WarpMouse ( Uint16 x, Uint16 y ) ;
FUNCTION: SDL_Cursor* SDL_CreateCursor ( Uint8* data, Uint8* mask, int w, int h, int hot_x, int hot_y ) ;
FUNCTION: void SDL_SetCursor ( SDL_Cursor* cursor ) ;
FUNCTION: SDL_Cursor* SDL_GetCursor ( ) ;
FUNCTION: void SDL_FreeCursor ( SDL_Cursor* cursor ) ;
FUNCTION: int SDL_ShowCursor ( int toggle ) ;

<<
CONSTANT: BUTTON_LEFT         1
CONSTANT: BUTTON_MIDDLE       2
CONSTANT: BUTTON_RIGHT        3
CONSTANT: BUTTON_WHEELUP      4
CONSTANT: BUTTON_WHEELDOWN    5
CONSTANT: BUTTON_X1           6
CONSTANT: BUTTON_X2           7

<PRIVATE
: button-mask ( n -- m ) 1 swap 1 - shift ;
PRIVATE>

>>

CONSTANT: BUTTON_LMASK    $[ BUTTON_LEFT   button-mask ]
CONSTANT: BUTTON_MMASK    $[ BUTTON_MIDDLE button-mask ]
CONSTANT: BUTTON_RMASK    $[ BUTTON_RIGHT  button-mask ]
CONSTANT: BUTTON_X1MASK   $[ BUTTON_X1     button-mask ]
CONSTANT: BUTTON_X2MASK   $[ BUTTON_X2     button-mask ]
