! Copyright (C) 2010 Dmitry Shubin.
! See http://factorcode.org/license.txt for BSD license.
USING: accessors alien.destructors combinators.short-circuit
continuations destructors kernel literals math.bitwise sdl.ffi
sdl.ffi.video values ;
IN: sdl

<PRIVATE

TUPLE: sdl-error str ;

: sdl-error ( -- * ) SDL_GetError \ sdl-error boa throw ;

: check-error ( ret -- ) -1 = [ sdl-error ] when ;

: init-subsystem ( sub -- ) SDL_InitSubSystem check-error ;

PRIVATE>

: init-audio ( -- ) AUDIO init-subsystem ;
: quit-audio ( -- ) AUDIO SDL_QuitSubSystem ;

VALUE: sdl-screen
ERROR: sdl-video-mode-error ;

: with-screen ( width height bitness flags quot -- )
    [
        VIDEO SDL_Init check-error
        SDL_SetVideoMode [ sdl-video-mode-error ] unless*
        to: sdl-screen
    ] prepose [ SDL_Quit f to: sdl-screen ] [ ] cleanup ; inline

: must-lock? ( surface -- ? )
    {
        [ offset>> 0 = not ]
        [ flags>> flags{ HWSURFACE ASYNCBLIT RLEACCEL } mask? ]
    } 1|| ;

DESTRUCTOR: SDL_UnlockSurface
: (with-lock) ( surface quot -- )
    [
        dup [ SDL_LockSurface check-error ] [ &SDL_UnlockSurface ] bi
    ] prepose with-destructors ; inline

: with-lock ( surface quot -- )
    over must-lock? [ (with-lock) ] [ call ] if ; inline

: load-bmp ( filename -- surface )
    "rb" SDL_RWFromFile 1 SDL_LoadBMP_RW ;
