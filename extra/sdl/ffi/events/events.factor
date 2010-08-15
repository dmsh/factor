! Copyright (C) 2010 Dmitry Shubin.
! See http://factorcode.org/license.txt for BSD license.
USING: alien.c-types alien.syntax classes.struct sdl.ffi
sdl.ffi.keyboard ;
IN: sdl.ffi.events

LIBRARY: libsdl

STRUCT: SDL_ActiveEvent
    { type  Uint8 }
    { gain  Uint8 }
    { state Uint8 } ;

STRUCT: SDL_KeyboardEvent
    { type   Uint8 }
    { which  Uint8 }
    { state  Uint8 }
    { keysym SDL_keysym } ;

STRUCT: SDL_MouseMotionEvent
    { type  Uint8  }
    { which Uint8  }
    { state Uint8  }
    { x     Uint16 }
    { y     Uint16 }
    { xrel  Sint16 }
    { yrel  Sint16 } ;

STRUCT: SDL_MouseButtonEvent
    { type   Uint8  }
    { which  Uint8  }
    { button Uint8  }
    { state  Uint8  }
    { x      Uint16 }
    { y      Uint16 } ;

STRUCT: SDL_JoyAxisEvent
    { type   Uint8  }
    { which  Uint8  }
    { axis   Uint8  }
    { value  Sint16 } ;

STRUCT: SDL_JoyBallEvent
    { type  Uint8  }
    { which Uint8  }
    { ball  Uint8  }
    { xrel  Sint16 }
    { yrel  Sint16 } ;

STRUCT: SDL_JoyHatEvent
    { type  Uint8 }
    { which Uint8 }
    { hat   Uint8 }
    { value Uint8 } ;

STRUCT: SDL_JoyButtonEvent
    { type   Uint8 }
    { which  Uint8 }
    { button Uint8 }
    { state  Uint8 } ;

STRUCT: SDL_ResizeEvent
    { type Uint8 }
    { w    int   }
    { h    int   } ;

STRUCT: SDL_ExposeEvent
    { type Uint8 } ;

STRUCT: SDL_QuitEvent
    { type Uint8 } ;

STRUCT: SDL_UserEvent
    { type  Uint8 }
    { code  int   }
    { data1 void* }
    { data2 void* } ;

C-TYPE: SDL_SysWMmsg
STRUCT: SDL_SysWMEvent
    { type Uint8         }
    { msg  SDL_SysWMmsg* } ;

UNION-STRUCT: SDL_Event
    { type    Uint8                }
    { active  SDL_ActiveEvent      }
    { key     SDL_KeyboardEvent    }
    { motion  SDL_MouseMotionEvent }
    { button  SDL_MouseButtonEvent }
    { jaxis   SDL_JoyAxisEvent     }
    { jball   SDL_JoyBallEvent     }
    { jhat    SDL_JoyHatEvent      }
    { jbutton SDL_JoyButtonEvent   }
    { resize  SDL_ResizeEvent      }
    { expose  SDL_ExposeEvent      }
    { quit    SDL_QuitEvent        }
    { user    SDL_UserEvent        }
    { syswm   SDL_SysWMEvent       } ;

ENUM: SDL_eventaction
    ADDEVENT
    PEEKEVENT
    GETEVENT ;

CONSTANT: SDL_QUERY   -1
CONSTANT: SDL_IGNORE   0
CONSTANT: SDL_DISABLE  0
CONSTANT: SDL_ENABLE   1


CALLBACK: int SDL_EventFilter ( SDL_Event* event ) ;

FUNCTION: void SDL_PumpEvents ( ) ;
FUNCTION: int SDL_PeepEvents ( SDL_Event* events, int numevents, SDL_eventaction action, Uint32 mask ) ;
FUNCTION: int SDL_PollEvent ( SDL_Event* event ) ;
FUNCTION: int SDL_WaitEvent ( SDL_Event* event ) ;
FUNCTION: int SDL_PushEvent ( SDL_Event* event ) ;
FUNCTION: void SDL_SetEventFilter ( SDL_EventFilter filter ) ;
FUNCTION: SDL_EventFilter SDL_GetEventFilter ( ) ;
FUNCTION: Uint8 SDL_EventState ( Uint8 type, int state ) ;
