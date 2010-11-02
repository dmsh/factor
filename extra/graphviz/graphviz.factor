! Copyright (C) 2010 Dmitry Shubin.
! See http://factorcode.org/license.txt for BSD license.
USING: accessors alien.destructors continuations destructors fry
graphviz.ffi kernel locals namespaces strings ;
IN: graphviz

ERROR: unknown-layout ;
ERROR: rendering-error ;
ERROR: graph-opening-error ;
ERROR: bad-attr-index ;

CONSTANT: undirected        0
CONSTANT: directed          1
CONSTANT: strict-undirected 2
CONSTANT: strict-directed   3


<PRIVATE

SYMBOL: gvc

: free-context ( x -- ) gvFreeContext drop ;

DESTRUCTOR: free-context
DESTRUCTOR: agclose

: ok? ( ret quot -- ) [ 0 = ] dip unless ; inline

: <graph> ( name type -- graph )
    agopen dup f = [ graph-opening-error ] when ;

PRIVATE>


: with-graphviz ( quot -- )
    '[ gvContext &free-context gvc _ with-variable ]
    with-destructors ; inline

:: with-layout ( graph engine quot -- )
    gvc get :> gvc'
    gvc' graph engine gvLayout [ unknown-layout ] ok?
    graph quot
    [ gvc' graph gvFreeLayout drop ] [ ] cleanup ; inline

: render-to-file ( graph format file -- )
    [ gvc get ] 3dip gvRenderFilename [ rendering-error ] ok? ;

: with-graph ( name type quot -- )
    [ <graph> &agclose ] prepose with-destructors ; inline

ALIAS: find-node agfindnode

ALIAS: add-node* agnode

: add-node ( graph id -- ) agnode drop ;

:: add-edge* ( gr n1 n2 -- edge )
    gr gr n1 gr n2 [ agfindnode ] 2bi@ agedge ;

: add-edge ( gr n1 n2 -- ) add-edge* drop ;

GENERIC: set-attr ( obj attr value -- )
GENERIC: get-attr ( obj attr -- value )

M: string set-attr "" agsafeset [ bad-attr-index ] ok? ;
M: Agsym_ set-attr index>> agxset [ bad-attr-index ] ok? ;

M: string get-attr agget ;
M: Agsym_ get-attr index>> agxget ;
