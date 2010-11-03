! Copyright (C) 2010 Dmitry Shubin.
! See http://factorcode.org/license.txt for BSD license.
USING: fry graphviz kernel locals math.combinatorics sequences ;
IN: graphviz.examples


! helpers

: png-render ( graph alg file -- )
    '[ "png" _ render-to-file ] with-layout ;

:: plot ( file alg quot -- )
    "..." undirected
    [ quot [ alg file png-render ] bi ] with-graph ; inline


! K_{3,3}

: k33-nodes ( gr n1 n2 -- ) append [ add-node ] with each ;

: k33-edges ( gr n1 n2 -- )
    [ [ dup ] 2dip add-edge ] cartesian-each drop ;

: k33-graph ( graph -- )
    { "a1" "a2" "a3" } { "b1" "b2" "b3" }
    [ k33-nodes ] [ k33-edges ] 3bi ;


! K_5

: k5-nodes ( graph nodes -- ) [ add-node ]  with each ;

: k5-edges ( graph nodes -- )
    2 [ dupd first2 add-edge ] each-combination drop ;

: k5-graph ( graph -- )
    { "a" "b" "c" "d" "e" } [ k5-nodes ] [ k5-edges ] 2bi ;


! usage

: run-examples ( -- )
    [
        "k33.png" "dot"   [ k33-graph ] plot
        "k5.png"  "circo" [ k5-graph  ] plot
    ] with-graphviz ;
