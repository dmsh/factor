! Copyright (C) 2010 Dmitry Shubin.
! See http://factorcode.org/license.txt for BSD license.
USING: accessors fry graphviz.ffi kernel ;
IN: graphviz.iterators

<PRIVATE

TUPLE: node-iter graph node ;
TUPLE: node-iter-rev < node-iter ;
TUPLE: edge-iter < node-iter edge ;
TUPLE: edge-in-iter < edge-iter ;
TUPLE: edge-out-iter < edge-iter ;
TUPLE: attr-iter item sym ;
TUPLE: attr-iter-rev < attr-iter ;


GENERIC: current ( iter -- value )
GENERIC: next ( iter -- iter )

: end? ( iter -- ? ) current f = ;


M: node-iter current node>> ;
M: edge-iter current edge>> ;
M: attr-iter current sym>> ;

: <node-iter> ( graph -- iter )
    dup agfstnode node-iter boa ;

: <node-iter-rev> ( graph -- iter )
    dup aglstnode node-iter-rev boa ;

: <edge-iter> ( graph node -- iter )
    2dup agfstedge edge-iter boa ;

: <edge-in-iter> ( graph node -- iter )
    2dup agfstin edge-in-iter boa ;

: <edge-out-iter> ( graph node -- iter )
    2dup agfstout edge-out-iter boa ;

: <attr-iter> ( item -- iter )
    dup agfstattr attr-iter boa ;

: <attr-iter-rev> ( item -- iter )
    dup aglstattr attr-iter-rev boa ;


M: node-iter next
    dup [ graph>> ] [ node>> ] bi agnxtnode >>node ;

M: node-iter-rev next
    dup [ graph>> ] [ node>> ] bi agprvnode >>node ;

M: edge-iter next
    dup [ graph>> ] [ edge>> ] [ node>> ] tri agnxtedge >>edge ;

M: edge-in-iter next
    dup [ graph>> ] [ node>> ] bi agnxtin >>edge ;

M: edge-out-iter next
    dup [ graph>> ] [ node>> ] bi agnxtout >>edge ;

M: attr-iter next
    dup [ item>> ] [ sym>> ] bi agnxtattr >>sym ;

M: attr-iter-rev next
    dup [ item>> ] [ sym>> ] bi agprvattr >>sym ;


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

: each-attr ( item quot -- )
    [ <attr-iter> ] each-* ; inline

: each-attr-rev ( item quot -- )
    [ <attr-iter-rev> ] each-* ; inline
