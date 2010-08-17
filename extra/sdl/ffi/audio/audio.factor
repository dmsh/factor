! Copyright (C) 2010 Dmitry Shubin.
! See http://factorcode.org/license.txt for BSD license.
USING: alien.c-types alien.syntax classes.struct literals sdl.ffi ;
IN: sdl.ffi.audio

LIBRARY: libsdl

CALLBACK: void NeedMoreData ( void* userdata, Uint8* stream, int len ) ;

STRUCT: SDL_AudioSpec
    { freq     int          }
    { format   Uint16       }
    { channels Uint8        }
    { silence  Uint8        }
    { samples  Uint16       }
    { padding  Uint16       }
    { size     Uint32       }
    { callback NeedMoreData }
    { userdata void*        } ;

<<
CONSTANT: AUDIO_U8       HEX: 0008
CONSTANT: AUDIO_S8       HEX: 8008
CONSTANT: AUDIO_U16LSB   HEX: 0010
CONSTANT: AUDIO_S16LSB   HEX: 8010
CONSTANT: AUDIO_U16MSB   HEX: 1010
CONSTANT: AUDIO_S16MSB   HEX: 9010
>>
CONSTANT: AUDIO_U16   $ AUDIO_U16LSB
CONSTANT: AUDIO_S16   $ AUDIO_S16LSB


! #if SDL_BYTEORDER == SDL_LIL_ENDIAN
! #define AUDIO_U16SYS  AUDIO_U16LSB
! #define AUDIO_S16SYS  AUDIO_S16LSB
! #else
! #define AUDIO_U16SYS  AUDIO_U16MSB
! #define AUDIO_S16SYS  AUDIO_S16MSB
! #endif

DEFER: SDL_AudioCVT
CALLBACK: void Filter ( SDL_AudioCVT* cvt, Uint16 format ) ;

STRUCT: SDL_AudioCVT
    { needed       int        }
    { src_format   Uint16     }
    { dst_format   Uint16     }
    { rate_incr    double     }
    { buf          Uint8*     }
    { len          int        }
    { len_cvt      int        }
    { len_mult     int        }
    { len_ratio    double     }
    { filters      Filter[10] }
    { filter_index int        } ;

FUNCTION: int SDL_AudioInit ( c-string driver_name ) ;
FUNCTION: void SDL_AudioQuit ( ) ;
FUNCTION: char* SDL_AudioDriverName ( char* namebuf, int maxlen ) ;
FUNCTION: int SDL_OpenAudio ( SDL_AudioSpec* desired, SDL_AudioSpec* obtained ) ;

ENUM: SDL_audiostatus
    SDL_AUDIO_STOPPED
    SDL_AUDIO_PLAYING
    SDL_AUDIO_PAUSED ;

FUNCTION: SDL_audiostatus SDL_GetAudioStatus ( ) ;
FUNCTION: void SDL_PauseAudio ( int pause_on ) ;
! TODO FUNCTION: SDL_AudioSpec* SDL_LoadWAV_RW ( SDL_RWops* src, int freesrc, SDL_AudioSpec* spec, Uint8** audio_buf, Uint32* audio_len ) ;

!  #define SDL_LoadWAV(file, spec, audio_buf, audio_len) \
!          SDL_LoadWAV_RW(SDL_RWFromFile(file, "rb"),1, spec,audio_buf,audio_len)

FUNCTION: void SDL_FreeWAV ( Uint8* audio_buf ) ;
FUNCTION: int SDL_BuildAudioCVT ( SDL_AudioCVT* cvt, Uint16 src_format, Uint8 src_channels, int src_rate, Uint16 dst_format, Uint8 dst_channels, int dst_rate ) ;
FUNCTION: int SDL_ConvertAudio ( SDL_AudioCVT* cvt ) ;
FUNCTION: void SDL_MixAudio ( Uint8* dst, Uint8* src, Uint32 len, int volume ) ;
FUNCTION: void SDL_LockAudio ( ) ;
FUNCTION: void SDL_UnlockAudio ( ) ;
FUNCTION: void SDL_CloseAudio ( ) ;
