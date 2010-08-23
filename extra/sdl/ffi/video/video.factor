! Copyright (C) 2010 Dmitry Shubin.
! See http://factorcode.org/license.txt for BSD license.
USING: alien.c-types alien.syntax classes.struct sdl.ffi  ;
IN: sdl.ffi.video

LIBRARY: libsdl

STRUCT: SDL_Rect
    { x Sint16 }
    { y Sint16 }
    { w Uint16 }
    { h Uint16 } ;

STRUCT: SDL_Color
    { r Uint8 }
    { g Uint8 }
    { b Uint8 }
    { unused Uint8 } ;

STRUCT: SDL_Palette
    { ncolors int }
    { colors SDL_Color* } ;

STRUCT: SDL_PixelFormat
    { palette       SDL_Palette* }
    { BitsPerPixel  Uint8  }
    { BytesPerPixel Uint8  }
    { Rloss         Uint8  }
    { Gloss         Uint8  }
    { Bloss         Uint8  }
    { Aloss         Uint8  }
    { Rshift        Uint8  }
    { Gshift        Uint8  }
    { Bshift        Uint8  }
    { Ashift        Uint8  }
    { Rmask         Uint32 }
    { Gmask         Uint32 }
    { Bmask         Uint32 }
    { Amask         Uint32 }
    { colorkey      Uint32 }
    { alpha         Uint8  } ;

C-TYPE: private_hwdata
C-TYPE: SDL_BlitMap
STRUCT: SDL_Surface
    { flags          Uint32           }
    { format         SDL_PixelFormat* }
    { w              int              }
    { h              int              }
    { pitch          Uint16           }
    { pixels         void*            }
    { offset         int              }
    { hwdata         private_hwdata*  }
    { clip_rect      SDL_Rect         }
    { unused1        Uint32           }
    { locked         Uint32           }
    { map            SDL_BlitMap*     }
    { format_version uint             }
    { refcount       int              } ;

! SDL_Surface Flags
! Available for SDL_CreateRGBSurface() or SDL_SetVideoMode()
CONSTANT: SWSURFACE   HEX: 00000000      ! Surface is in system memory
CONSTANT: HWSURFACE   HEX: 00000001      ! Surface is in video memory
CONSTANT: ASYNCBLIT   HEX: 00000004      ! Use asynchronous blits if possible

! Available for SDL_SetVideoMode()
CONSTANT: ANYFORMAT   HEX: 10000000      ! Allow any video depth/pixel-format
CONSTANT: HWPALETTE   HEX: 20000000      ! Surface has exclusive palette
CONSTANT: DOUBLEBUF   HEX: 40000000      ! Set up double-buffered video mode
CONSTANT: FULLSCREEN  HEX: 80000000      ! Surface is a full screen display
CONSTANT: OPENGL      HEX: 00000002      ! Create an OpenGL rendering context
CONSTANT: OPENGLBLIT  HEX: 0000000A      ! Create an OpenGL rendering context and use it for blitting
CONSTANT: RESIZABLE   HEX: 00000010      ! This video mode may be resized
CONSTANT: NOFRAME     HEX: 00000020      ! No window caption or edge frame

! Used internally (read-only)
CONSTANT: HWACCEL     HEX: 00000100      ! Blit uses hardware acceleration
CONSTANT: SRCCOLORKEY HEX: 00001000      ! Blit uses a source color key
CONSTANT: RLEACCELOK  HEX: 00002000      ! Private flag
CONSTANT: RLEACCEL    HEX: 00004000      ! Surface is RLE encoded
CONSTANT: SRCALPHA    HEX: 00010000      ! Blit uses source alpha blending
CONSTANT: PREALLOC    HEX: 01000000      ! Surface uses preallocated memory

STRUCT: SDL_VideoInfo
    { hw_available uint bits: 1   }
    { wm_available uint bits: 1   }
    { UnusedBits1  uint bits: 6   }
    { UnusedBits2  uint bits: 1   }
    { blit_hw      uint bits: 1   }
    { blit_hw_CC   uint bits: 1   }
    { blit_hw_A    uint bits: 1   }
    { blit_sw      uint bits: 1   }
    { blit_sw_CC   uint bits: 1   }
    { blit_sw_A    uint bits: 1   }
    { blit_fill    uint bits: 1   }
    { UnusedBits3  uint bits: 16  }
    { video_mem    Uint32           }
    { vfmt         SDL_PixelFormat* }
    { current_w    int              }
    { current_h    int              } ;

CONSTANT: YV12_OVERLAY  HEX: 32315659   ! Planar mode: Y + V + U  (3 planes)
CONSTANT: IYUV_OVERLAY  HEX: 56555949   ! Planar mode: Y + U + V  (3 planes)
CONSTANT: YUY2_OVERLAY  HEX: 32595559   ! Packed mode: Y0+U0+Y1+V0 (1 plane)
CONSTANT: UYVY_OVERLAY  HEX: 59565955   ! Packed mode: U0+Y0+V0+Y1 (1 plane)
CONSTANT: YVYU_OVERLAY  HEX: 55595659   ! Packed mode: Y0+V0+Y1+U0 (1 plane)

C-TYPE: private_yuvhwfuncs
C-TYPE: private_yuvhwdata
STRUCT: SDL_Overlay
    { format Uint32 }
    { w int }
    { h int }
    { planes int }
    { pitches Uint16* }
    { pixels Uint8** }
    { hwfuncs private_yuvhwfuncs* }
    { hwdata private_yuvhwdata*   }
    { hw_overlay uint bits: 1   }
    { UnusedBits uint bits: 31  }  ;

ENUM: SDL_GLattr
    RED_SIZE
    GREEN_SIZE
    BLUE_SIZE
    ALPHA_SIZE
    BUFFER_SIZE
    DOUBLEBUFFER
    DEPTH_SIZE
    STENCIL_SIZE
    ACCUM_RED_SIZE
    ACCUM_GREEN_SIZE
    ACCUM_BLUE_SIZE
    ACCUM_ALPHA_SIZE
    STEREO
    MULTISAMPLEBUFFERS
    MULTISAMPLESAMPLES
    ACCELERATED_VISUAL
    SWAP_CONTROL ;

ENUM: SDL_GrabMode
    { SDL_GRAB_QUERY -1 }
    { SDL_GRAB_OFF    0 }
    { SDL_GRAB_ON     1 }
    SDL_GRAB_FULLSCREEN ;

FUNCTION: int SDL_VideoInit ( c-string driver_name, Uint32 flags ) ;
FUNCTION: void SDL_VideoQuit ( ) ;
! TODO FUNCTION: char* SDL_VideoDriverName ( char* namebuf, int maxlen ) ;
FUNCTION: SDL_Surface* SDL_GetVideoSurface ( ) ;
FUNCTION: SDL_VideoInfo* SDL_GetVideoInfo ( ) ;
FUNCTION: int SDL_VideoModeOK ( int width, int height, int bpp, Uint32 flags ) ;
! TODO FUNCTION: SDL_Rect* * SDL_ListModes ( SDL_PixelFormat* format, Uint32 flags ) ;
FUNCTION: SDL_Surface* SDL_SetVideoMode ( int width, int height, int bpp, Uint32 flags ) ;
FUNCTION: void SDL_UpdateRects ( SDL_Surface* screen, int numrects, SDL_Rect* rects ) ;
FUNCTION: void SDL_UpdateRect ( SDL_Surface* screen, Sint32 x, Sint32 y, Uint32 w, Uint32 h ) ;
FUNCTION: int SDL_Flip ( SDL_Surface* screen ) ;
FUNCTION: int SDL_SetGamma ( float red, float green, float blue ) ;
FUNCTION: int SDL_SetGammaRamp ( Uint16* red, Uint16* green, Uint16* blue ) ;
FUNCTION: int SDL_GetGammaRamp ( Uint16* red, Uint16* green, Uint16* blue ) ;
FUNCTION: int SDL_SetColors ( SDL_Surface* surface, SDL_Color* colors, int firstcolor, int ncolors ) ;
FUNCTION: int SDL_SetPalette ( SDL_Surface* surface, int flags, SDL_Color* colors, int firstcolor, int ncolors ) ;
FUNCTION: Uint32 SDL_MapRGB ( SDL_PixelFormat* format, Uint8 r, Uint8 g, Uint8 b ) ;
FUNCTION: Uint32 SDL_MapRGBA ( SDL_PixelFormat* format, Uint8 r, Uint8 g, Uint8 b, Uint8 a ) ;
FUNCTION: void SDL_GetRGB ( Uint32 pixel, SDL_PixelFormat* fmt, Uint8* r, Uint8* g, Uint8* b ) ;
FUNCTION: void SDL_GetRGBA ( Uint32 pixel, SDL_PixelFormat* fmt, Uint8* r, Uint8* g, Uint8* b, Uint8* a ) ;
FUNCTION: SDL_Surface* SDL_CreateRGBSurface ( Uint32 flags, int width, int height, int depth, Uint32 Rmask, Uint32 Gmask, Uint32 Bmask, Uint32 Amask ) ;
FUNCTION: SDL_Surface* SDL_CreateRGBSurfaceFrom ( void* pixels, int width, int height, int depth, int pitch, Uint32 Rmask, Uint32 Gmask, Uint32 Bmask, Uint32 Amask ) ;
FUNCTION: void SDL_FreeSurface ( SDL_Surface* surface ) ;
FUNCTION: int SDL_LockSurface ( SDL_Surface* surface ) ;
FUNCTION: void SDL_UnlockSurface ( SDL_Surface* surface ) ;
! TODO FUNCTION: SDL_Surface* SDL_LoadBMP_RW ( SDL_RWops* src, int freesrc ) ;
! TODO FUNCTION: int SDL_SaveBMP_RW ( SDL_Surface* surface, SDL_RWops* dst, int freedst ) ;
FUNCTION: int SDL_SetColorKey ( SDL_Surface* surface, Uint32 flag, Uint32 key ) ;
FUNCTION: int SDL_SetAlpha ( SDL_Surface* surface, Uint32 flag, Uint8 alpha ) ;
FUNCTION: SDL_bool SDL_SetClipRect ( SDL_Surface* surface, SDL_Rect* rect ) ;
FUNCTION: void SDL_GetClipRect ( SDL_Surface* surface, SDL_Rect* rect ) ;
FUNCTION: SDL_Surface* SDL_ConvertSurface ( SDL_Surface* src, SDL_PixelFormat* fmt, Uint32 flags ) ;
FUNCTION: int SDL_UpperBlit ( SDL_Surface* src, SDL_Rect* srcrect, SDL_Surface* dst, SDL_Rect* dstrect ) ;
FUNCTION: int SDL_LowerBlit ( SDL_Surface* src, SDL_Rect* srcrect, SDL_Surface* dst, SDL_Rect* dstrect ) ;
FUNCTION: int SDL_FillRect ( SDL_Surface* dst, SDL_Rect* dstrect, Uint32 color ) ;
FUNCTION: SDL_Surface* SDL_DisplayFormat ( SDL_Surface* surface ) ;
FUNCTION: SDL_Surface* SDL_DisplayFormatAlpha ( SDL_Surface* surface ) ;
FUNCTION: SDL_Overlay* SDL_CreateYUVOverlay ( int width, int height, Uint32 format, SDL_Surface* display ) ;
FUNCTION: int SDL_LockYUVOverlay ( SDL_Overlay* overlay ) ;
FUNCTION: void SDL_UnlockYUVOverlay ( SDL_Overlay* overlay ) ;
FUNCTION: int SDL_DisplayYUVOverlay ( SDL_Overlay* overlay, SDL_Rect* dstrect ) ;
FUNCTION: void SDL_FreeYUVOverlay ( SDL_Overlay* overlay ) ;
FUNCTION: int SDL_GL_LoadLibrary ( char* path ) ;
FUNCTION: void* SDL_GL_GetProcAddress ( char* proc ) ;
FUNCTION: int SDL_GL_SetAttribute ( SDL_GLattr attr, int value ) ;
FUNCTION: int SDL_GL_GetAttribute ( SDL_GLattr attr, int* value ) ;
FUNCTION: void SDL_GL_SwapBuffers ( ) ;
FUNCTION: void SDL_GL_UpdateRects ( int numrects, SDL_Rect* rects ) ;
FUNCTION: void SDL_GL_Lock ( ) ;
FUNCTION: void SDL_GL_Unlock ( ) ;
FUNCTION: void SDL_WM_SetCaption ( c-string title, c-string icon ) ;
! TODO FUNCTION: void SDL_WM_GetCaption ( char* * title, char* * icon ) ;
FUNCTION: void SDL_WM_SetIcon ( SDL_Surface* icon, Uint8* mask ) ;
FUNCTION: int SDL_WM_IconifyWindow ( ) ;
FUNCTION: int SDL_WM_ToggleFullScreen ( SDL_Surface* surface ) ;
FUNCTION: SDL_GrabMode SDL_WM_GrabInput ( SDL_GrabMode mode ) ;
FUNCTION: int SDL_SoftStretch ( SDL_Surface* src, SDL_Rect* srcrect, SDL_Surface* dst, SDL_Rect* dstrect ) ;
