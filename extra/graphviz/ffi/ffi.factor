! Copyright (C) 2010 Dmitry Shubin.
! See http://factorcode.org/license.txt for BSD license.
USING: alien alien.c-types alien.libraries alien.syntax ;
IN: graphviz.ffi


<< "libgvc" "libgvc.so" cdecl add-library >>
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


<< "libgraph" "libgraph.so" cdecl add-library >>

LIBRARY: libgraph

C-TYPE: Agraph_
C-TYPE: Agnode_
C-TYPE: Agedge_
! C-TYPE: Agsym_

TYPEDEF: Agraph_*  Agraph
TYPEDEF: Agnode_*  Agnode
TYPEDEF: Agedge_*  Agedge
! TYPEDEF: Agsym_*   Agsym

ENUM: graph-kind
    undirected
    directed
    strict-undirected
    strict-directed ;

FUNCTION: c-string agget ( void* obj, c-string attr ) ;
! char *agxget(void *, int);
! FUNCTION: int agset ( void* obj, c-string attr, c-string value ) ;
FUNCTION: int agsafeset ( void* obj, c-string attr, c-string value, c-string default ) ;
! int agxset(void *, int, char *);
! int agindex(void *, char *);

! void aginitlib(int, int, int);
FUNCTION: Agraph agopen ( c-string name, graph-kind kind ) ;
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
! Agsym_t *agfstattr(void *);
! Agsym_t *agnxtattr(void *, Agsym_t *);
! Agsym_t *aglstattr(void *);
! Agsym_t *agprvattr(void *, Agsym_t *);
! int      agcopyattr(void *, void *);	

! typedef enum { AGWARN, AGERR, AGMAX, AGPREV } agerrlevel_t;
! agerrlevel_t agerrno;
! void agseterr(agerrlevel_t);
! char *aglasterr(void);
