! Copyright (C) 2010 Dmitry Shubin.
! See http://factorcode.org/license.txt for BSD license.
USING: alien alien.c-types alien.libraries alien.syntax classes.struct
combinators system ;
IN: graphviz.ffi


<< "libgvc" {
    { [ os macosx? ] [ "libgvc.dylib" ] }
    { [ os unix?   ] [ "libgvc.so"    ] }
    { [ os winnt?  ] [ "gvc.dll"      ] }
} cond cdecl add-library >>

LIBRARY: libgvc

C-TYPE: GVC_
TYPEDEF: GVC_* GVC

FUNCTION: GVC gvContext ( ) ;
FUNCTION: int gvLayout ( GVC gvc, void* g, c-string engine ) ;
FUNCTION: int gvFreeLayout ( GVC gvc, void* g ) ;
FUNCTION: int gvFreeContext ( GVC gvc ) ;
FUNCTION: int gvRender ( GVC gvc, void* g, c-string format, void* out ) ;
FUNCTION: int gvRenderFilename ( GVC gvc, void* g, c-string format, c-string filename ) ;
! int gvRenderData ( GVC gvc, void* g, c-string format, char **result, uint* length ) ;


<< "libgraph" {
    { [ os macosx? ] [ "libgraph.dylib" ] }
    { [ os unix?   ] [ "libgraph.so"    ] }
    { [ os winnt?  ] [ "graph.dll"      ] }
} cond cdecl add-library >>

LIBRARY: libgraph

C-TYPE: Agraph_
C-TYPE: Agnode_
C-TYPE: Agedge_

STRUCT: Agsym_
    { name    c-string }
    { value   c-string }
    { index   int      }
    { printed uchar    }
    { fixed   uchar    } ;

TYPEDEF: Agraph_* Agraph
TYPEDEF: Agnode_* Agnode
TYPEDEF: Agedge_* Agedge
TYPEDEF: Agsym_*  Agsym

FUNCTION: c-string agget ( void* obj, c-string attr ) ;
FUNCTION: int agsafeset ( void* obj, c-string attr, c-string value, c-string default ) ;
FUNCTION: c-string agxget ( void* obj, int index ) ;
FUNCTION: int agxset ( void* obj, int index, c-string value ) ;

! FUNCTION: int agset ( void* obj, c-string attr, c-string value ) ;
! int agindex(void *, char *);

! void aginitlib(int, int, int);
FUNCTION: Agraph agopen ( c-string name, int type ) ;
FUNCTION: Agraph agsubg ( Agraph graph, c-string id ) ;
FUNCTION: Agraph agfindsubg ( Agraph graph, c-string id ) ;
FUNCTION: void agclose ( Agraph graph ) ;
! Agraph_t *agread(FILE *);
! Agraph_t *agread_usergets(FILE *, gets_f);
! void agreadline(int);
! void agsetfile(char *);
! Agraph_t *agmemread(char *);

FUNCTION: Agnode agnode ( Agraph graph, c-string id ) ;
FUNCTION: Agnode agfindnode ( Agraph graph, c-string id ) ;
FUNCTION: Agnode agfstnode ( Agraph graph ) ;
FUNCTION: Agnode agnxtnode ( Agraph graph, Agnode node ) ;
FUNCTION: Agnode aglstnode ( Agraph graph ) ;
FUNCTION: Agnode agprvnode ( Agraph graph, Agnode node ) ;

FUNCTION: Agedge agedge ( Agraph graph, Agnode node, Agnode node ) ;
FUNCTION: Agedge agfindedge ( Agraph graph, Agnode node, Agnode node ) ;
FUNCTION: Agedge agfstedge ( Agraph graph, Agnode node ) ;
FUNCTION: Agedge agnxtedge ( Agraph graph, Agedge edge, Agnode node ) ;
FUNCTION: Agedge agfstin ( Agraph graph, Agnode node ) ;
FUNCTION: Agedge agnxtin ( Agraph graph, Agedge edge ) ;
FUNCTION: Agedge agfstout ( Agraph graph, Agnode node ) ;
FUNCTION: Agedge agnxtout ( Agraph graph, Agedge edge ) ;

! Agsym_t *agattr(void *, char *, char *);
! Agsym_t *agraphattr(Agraph_t *, char *, char *);
! Agsym_t *agnodeattr(Agraph_t *, char *, char *);
! Agsym_t *agedgeattr(Agraph_t *, char *, char *);
! Agsym_t *agfindattr(void *, char *);
FUNCTION: Agsym agfstattr ( void* item ) ;
FUNCTION: Agsym agnxtattr ( void* item, Agsym sym ) ;
FUNCTION: Agsym aglstattr ( void* item ) ;
FUNCTION: Agsym agprvattr ( void* item, Agsym sym ) ;
! int      agcopyattr(void *, void *);	

! typedef enum { AGWARN, AGERR, AGMAX, AGPREV } agerrlevel_t;
! agerrlevel_t agerrno;
! void agseterr(agerrlevel_t);
! char *aglasterr(void);
