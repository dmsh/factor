! Copyright (C) 2010 Dmitry Shubin.
! See http://factorcode.org/license.txt for BSD license.
USING: alien.destructors continuations destructors fry graphviz.ffi
kernel locals math namespaces strings ;
IN: graphviz

<PRIVATE

SYMBOL: gvc

: free-context ( x -- ) gvFreeContext drop ;

DESTRUCTOR: free-context
DESTRUCTOR: agclose

PRIVATE>


CONSTANT: undirected        0
CONSTANT: directed          1
CONSTANT: strict-undirected 2
CONSTANT: strict-directed   3

: with-gvc ( quot -- )
    '[ gvContext &free-context gvc _ with-variable ]
    with-destructors ; inline

ERROR: unknown-layout ;

:: with-layout ( graph engine quot -- )
    gvc get :> gvc'
    gvc' graph engine gvLayout 0 = [ unknown-layout ] unless
    graph quot
    [ gvc' graph gvFreeLayout drop ] [ ] cleanup ; inline

ERROR: rendering-error ;

: render-to-file ( graph format file -- )
    [ gvc get ] 3dip gvRenderFilename
    0 = [ rendering-error ] unless ;

ERROR: graph-opening-error ;

: <graph> ( name type -- graph )
    agopen dup f = [ graph-opening-error ] when ;

: with-graph ( name type quot -- )
    [ <graph> &agclose ] prepose with-destructors ; inline

ALIAS: find-node agfindnode

ALIAS: add-node* agnode

: add-node ( graph id -- ) agnode drop ;

:: add-edge* ( gr n1 n2 -- edge )
    gr gr n1 gr n2 [ agfindnode ] 2bi@ agedge ;

: add-edge ( gr n1 n2 -- ) add-edge* drop ;

ERROR: bad-attr-index ;

: set-attr-check ( ret -- ) 0 = [ bad-attr-index ] unless ;

GENERIC: set-attr ( obj attr value -- )
GENERIC: get-attr ( obj attr -- value )

M: string set-attr "" agsafeset set-attr-check ;
M: integer set-attr agxset set-attr-check ;

M: string get-attr agget ;
M: integer get-attr agxget ;
