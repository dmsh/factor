! Copyright (C) 2010 Dmitry Shubin.
! See http://factorcode.org/license.txt for BSD license.
USING: alien.destructors continuations destructors fry graphviz.ffi
kernel locals namespaces ;
IN: graphviz

<PRIVATE

SYMBOL: gvc

: free-context ( x -- ) gvFreeContext drop ;

DESTRUCTOR: free-context
DESTRUCTOR: agclose

PRIVATE>

: with-gvc ( quot -- )
    '[ gvContext &free-context gvc _ with-variable ]
    with-destructors ; inline

:: with-layout ( graph engine quot -- )
    gvc get :> gvc'
    gvc' graph engine gvLayout drop
    graph quot
    [ gvc' graph gvFreeLayout drop ] [ ] cleanup ; inline

: render-to-file ( graph format file -- )
    [ gvc get ] 3dip gvRenderFilename drop ;

: with-graph ( name kind quot -- )
    [ agopen &agclose ] prepose with-destructors ; inline

ALIAS: find-node agfindnode

ALIAS: add-node* agnode

: add-node ( graph id -- ) agnode drop ;

:: add-edge ( gr n1 n2 -- )
    gr gr n1 gr n2 [ agfindnode ] 2bi@ agedge drop ;

:: set-attr ( value attr obj -- )
    obj attr value "" agsafeset drop ;

: get-attr ( attr obj -- value ) swap agget ;
