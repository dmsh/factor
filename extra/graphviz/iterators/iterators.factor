! Copyright (C) 2010 Dmitry Shubin.
! See http://factorcode.org/license.txt for BSD license.
USING: accessors combinators fry graphviz.ffi kernel ;
IN: graphviz.iterators

<PRIVATE

TUPLE: node-iter graph node ;
TUPLE: node-iter-rev < node-iter ;
TUPLE: edge-iter < node-iter edge ;
TUPLE: edge-in-iter < edge-iter ;
TUPLE: edge-out-iter < edge-iter ;

GENERIC: current ( iter -- value )
GENERIC: next ( iter -- iter )

: end? ( iter -- ? ) current f = ;


M: node-iter current node>> ;
M: edge-iter current edge>> ;


: <node-iter> ( graph -- iter ) dup agfstnode node-iter boa ;

: <node-iter-rev> ( graph -- iter )
    dup aglstnode node-iter-rev boa ;

: <edge-iter> ( graph node -- iter )
    2dup agfstedge edge-iter boa ;

: <edge-in-iter> ( graph node -- iter )
    2dup agfstin edge-in-iter boa ;

: <edge-out-iter> ( graph node -- iter )
    2dup agfstout edge-out-iter boa ;


M: node-iter next
    [ ] [ graph>> ] [ node>> ] tri agnxtnode >>node ;

M: node-iter-rev next
    [ ] [ graph>> ] [ node>> ] tri agprvnode >>node ;

M: edge-iter next
    { [ ] [ graph>> ] [ edge>> ] [ node>> ] } cleave
    agnxtedge >>edge ;

M: edge-in-iter next
    [ ] [ graph>> ] [ node>> ] tri agnxtin >>edge ;

M: edge-out-iter next
    [ ] [ graph>> ] [ node>> ] tri agnxtout >>edge ;


: (each-*) ( it q -- )
    '[ [ current @ ] keep next dup end? not ] loop drop ; inline

: each-* ( iter quot quot  -- )
    dip over end? [ 2drop ] [ (each-*) ] if ; inline

PRIVATE>


: each-node ( graph quot -- )
    [ <node-iter> ] each-* ; inline

: each-node-rev ( graph quot -- )
    [ <node-iter-rev> ] each-* ; inline

: each-edge ( graph node quot -- )
    [ <edge-iter> ] each-* ; inline

: each-in-edge ( graph node quot -- )
    [ <edge-in-iter> ] each-* ; inline

: each-out-edge ( graph node quot -- )
    [ <edge-out-iter> ] each-* ; inline
