! Copyright (C) 2004, 2010 Slava Pestov.
! See http://factorcode.org/license.txt for BSD license.
USING: alien alien.strings arrays byte-arrays generic hashtables
hashtables.private io io.binary io.files io.encodings.binary
io.pathnames kernel kernel.private math namespaces make parser
prettyprint sequences strings sbufs vectors words quotations
assocs system layouts splitting grouping growable classes
classes.private classes.builtin classes.tuple
classes.tuple.private vocabs vocabs.loader source-files
definitions debugger quotations.private combinators
combinators.short-circuit math.order math.private accessors
slots.private generic.single.private compiler.units
compiler.constants fry locals bootstrap.image.syntax
generalizations ;
IN: bootstrap.image

: arch ( os cpu -- arch )
    [ dup "winnt" = "winnt" "unix" ? ] dip
    {
        { "ppc" [ drop "-ppc" append ] }
        { "x86.32" [ nip "-x86.32" append ] }
        { "x86.64" [ nip "-x86.64" append ] }
    } case ;

: my-arch ( -- arch )
    os name>> cpu name>> arch ;

: boot-image-name ( arch -- string )
    "boot." ".image" surround ;

: my-boot-image-name ( -- string )
    my-arch boot-image-name ;

: images ( -- seq )
    {
        "winnt-x86.32" "unix-x86.32"
        "winnt-x86.64" "unix-x86.64"
        "linux-ppc" "macosx-ppc"
    } ;

<PRIVATE

! Object cache; we only consider numbers equal if they have the
! same type
TUPLE: eql-wrapper { obj read-only } ;

C: <eql-wrapper> eql-wrapper

M: eql-wrapper hashcode* obj>> hashcode* ;

GENERIC: (eql?) ( obj1 obj2 -- ? )

: eql? ( obj1 obj2 -- ? )
    { [ [ class ] bi@ = ] [ (eql?) ] } 2&& ;

M: fixnum (eql?) eq? ;

M: bignum (eql?) = ;

M: float (eql?) fp-bitwise= ;

M: sequence (eql?) 2dup [ length ] bi@ = [ [ eql? ] 2all? ] [ 2drop f ] if ;

M: object (eql?) = ;

M: eql-wrapper equal?
    over eql-wrapper? [ [ obj>> ] bi@ eql? ] [ 2drop f ] if ;

TUPLE: eq-wrapper { obj read-only } ;

C: <eq-wrapper> eq-wrapper

M: eq-wrapper equal?
    over eq-wrapper? [ [ obj>> ] bi@ eq? ] [ 2drop f ] if ;

M: eq-wrapper hashcode*
    nip obj>> identity-hashcode ;

SYMBOL: objects

: cache-eql-object ( obj quot -- value )
    [ <eql-wrapper> objects get ] dip '[ obj>> @ ] cache ; inline

: cache-eq-object ( obj quot -- value )
    [ <eq-wrapper> objects get ] dip '[ obj>> @ ] cache ; inline

: lookup-object ( obj -- n/f ) <eq-wrapper> objects get at ;

: put-object ( n obj -- ) <eq-wrapper> objects get set-at ;

! Constants

CONSTANT: image-magic HEX: 0f0e0d0c
CONSTANT: image-version 4

CONSTANT: data-base 1024

CONSTANT: special-objects-size 70

CONSTANT: header-size 10

CONSTANT: data-heap-size-offset 3
CONSTANT: t-offset              6
CONSTANT: 0-offset              7
CONSTANT: 1-offset              8
CONSTANT: -1-offset             9

SYMBOL: sub-primitives

SYMBOL: jit-relocations

SYMBOL: jit-offset

: compute-offset ( -- offset )
    building get length jit-offset get + ;

: jit-rel ( rc rt -- )
    compute-offset 3array jit-relocations get push-all ;

SYMBOL: jit-parameters

: jit-parameter ( parameter -- )
    jit-parameters get push ;

SYMBOL: jit-literals

: jit-literal ( literal -- )
    jit-literals get push ;

: jit-vm ( offset rc -- )
    [ jit-parameter ] dip rt-vm jit-rel ;

: jit-dlsym ( name rc -- )
    rt-dlsym jit-rel string>symbol jit-parameter f jit-parameter ;

:: jit-conditional ( test-quot false-quot -- )
    [ 0 test-quot call ] B{ } make length :> len
    building get length jit-offset get + len +
    [ jit-offset set false-quot call ] B{ } make
    [ length test-quot call ] [ % ] bi ; inline

: make-jit ( quot -- jit-parameters jit-literals jit-code )
    [
        0 jit-offset set
        V{ } clone jit-parameters set
        V{ } clone jit-literals set
        V{ } clone jit-relocations set
        call( -- )
        jit-parameters get >array
        jit-literals get >array
        jit-relocations get >array
    ] B{ } make prefix ;

: jit-define ( quot name -- )
    [ make-jit 2nip ] dip set ;

: define-sub-primitive ( quot word -- )
    [ make-jit 3array ] dip sub-primitives get set-at ;

: define-combinator-primitive ( quot non-tail-quot tail-quot word -- )
    [
        [ make-jit ]
        [ make-jit 2nip ]
        [ make-jit 2nip ]
        tri* 5 narray
    ] dip
    sub-primitives get set-at ;

! The image being constructed; a vector of word-size integers
SYMBOL: image

! Image output format
SYMBOL: big-endian

! Bootstrap architecture name
SYMBOL: architecture

RESET

! Boot quotation, set in stage1.factor
SPECIAL-OBJECT: bootstrap-startup-quot 20

! Bootstrap global namesapce
SPECIAL-OBJECT: bootstrap-global 21

! JIT parameters
SPECIAL-OBJECT: jit-prolog 23
SPECIAL-OBJECT: jit-primitive-word 24
SPECIAL-OBJECT: jit-primitive 25
SPECIAL-OBJECT: jit-word-jump 26
SPECIAL-OBJECT: jit-word-call 27
SPECIAL-OBJECT: jit-if-word 28
SPECIAL-OBJECT: jit-if 29
SPECIAL-OBJECT: jit-epilog 30
SPECIAL-OBJECT: jit-return 31
SPECIAL-OBJECT: jit-profiling 32
SPECIAL-OBJECT: jit-push 33
SPECIAL-OBJECT: jit-dip-word 34
SPECIAL-OBJECT: jit-dip 35
SPECIAL-OBJECT: jit-2dip-word 36
SPECIAL-OBJECT: jit-2dip 37
SPECIAL-OBJECT: jit-3dip-word 38
SPECIAL-OBJECT: jit-3dip 39
SPECIAL-OBJECT: jit-execute 40
SPECIAL-OBJECT: jit-declare-word 41

SPECIAL-OBJECT: c-to-factor-word 42
SPECIAL-OBJECT: lazy-jit-compile-word 43
SPECIAL-OBJECT: unwind-native-frames-word 44

SPECIAL-OBJECT: callback-stub 48

! PIC stubs
SPECIAL-OBJECT: pic-load 49
SPECIAL-OBJECT: pic-tag 50
SPECIAL-OBJECT: pic-tuple 51
SPECIAL-OBJECT: pic-check-tag 52
SPECIAL-OBJECT: pic-check-tuple 53
SPECIAL-OBJECT: pic-hit 54
SPECIAL-OBJECT: pic-miss-word 55
SPECIAL-OBJECT: pic-miss-tail-word 56

! Megamorphic dispatch
SPECIAL-OBJECT: mega-lookup 57
SPECIAL-OBJECT: mega-lookup-word 58
SPECIAL-OBJECT: mega-miss-word 59

! Default definition for undefined words
SPECIAL-OBJECT: undefined-quot 60

: special-object-offset ( symbol -- n )
    special-objects get at header-size + ;

: emit ( cell -- ) image get push ;

: emit-64 ( cell -- )
    bootstrap-cell 8 = [
        emit
    ] [
        d>w/w big-endian get [ swap ] unless emit emit
    ] if ;

: emit-seq ( seq -- ) image get push-all ;

: fixup ( value offset -- ) image get set-nth ;

: heap-size ( -- size )
    image get length header-size - special-objects-size -
    bootstrap-cells ;

: here ( -- size ) heap-size data-base + ;

: here-as ( tag -- pointer ) here bitor ;

: (align-here) ( alignment -- )
    [ here neg ] dip rem
    [ bootstrap-cell /i [ 0 emit ] times ] unless-zero ;

: align-here ( -- )
    data-alignment get (align-here) ;

: emit-fixnum ( n -- ) tag-fixnum emit ;

: emit-header ( n -- ) tag-header emit ;

: emit-object ( class quot -- addr )
    [ type-number ] dip over here-as
    [ swap emit-header call align-here ] dip ;
    inline

! Write an object to the image.
GENERIC: ' ( obj -- ptr )

! Image header

: emit-image-header ( -- )
    image-magic emit
    image-version emit
    data-base emit ! relocation base at end of header
    0 emit ! size of data heap set later
    0 emit ! reloc base of code heap is 0
    0 emit ! size of code heap is 0
    0 emit ! pointer to t object
    0 emit ! pointer to bignum 0
    0 emit ! pointer to bignum 1
    0 emit ! pointer to bignum -1
    special-objects-size [ f ' emit ] times ;

: emit-special-object ( symbol -- )
    [ get ' ] [ special-object-offset ] bi fixup ;

! Bignums

: bignum-bits ( -- n ) bootstrap-cell-bits 2 - ;

: bignum-radix ( -- n ) bignum-bits 2^ 1 - ;

: bignum>seq ( n -- seq )
    #! n is positive or zero.
    [ dup 0 > ]
    [ [ bignum-bits neg shift ] [ bignum-radix bitand ] bi ]
    produce nip ;

: emit-bignum ( n -- )
    dup dup 0 < [ neg ] when bignum>seq
    [ nip length 1 + emit-fixnum ]
    [ drop 0 < 1 0 ? emit ]
    [ nip emit-seq ]
    2tri ;

M: bignum '
    [
        bignum [ emit-bignum ] emit-object
    ] cache-eql-object ;

! Fixnums

M: fixnum '
    #! When generating a 32-bit image on a 64-bit system,
    #! some fixnums should be bignums.
    dup
    bootstrap-most-negative-fixnum
    bootstrap-most-positive-fixnum between?
    [ tag-fixnum ] [ >bignum ' ] if ;

TUPLE: fake-bignum n ;

C: <fake-bignum> fake-bignum

M: fake-bignum ' n>> tag-fixnum ;

! Floats

M: float '
    [
        float [
            8 (align-here) double>bits emit-64
        ] emit-object
    ] cache-eql-object ;

! Special objects

! Padded with fixnums for 8-byte alignment

: t, ( -- ) t t-offset fixup ;

M: f ' drop \ f type-number ;

:  0, ( -- )  0 >bignum '  0-offset fixup ;
:  1, ( -- )  1 >bignum '  1-offset fixup ;
: -1, ( -- ) -1 >bignum ' -1-offset fixup ;

! Words

: word-sub-primitive ( word -- obj )
    global [ target-word ] bind sub-primitives get at ;

: emit-word ( word -- )
    [
        [ subwords [ emit-word ] each ]
        [
            [
                {
                    [ hashcode <fake-bignum> , ]
                    [ name>> , ]
                    [ vocabulary>> , ]
                    [ def>> , ]
                    [ props>> , ]
                    [ pic-def>> , ]
                    [ pic-tail-def>> , ]
                    [ drop 0 , ] ! count
                    [ word-sub-primitive , ]
                    [ drop 0 , ] ! xt
                    [ drop 0 , ] ! code
                    [ drop 0 , ] ! profiling
                } cleave
            ] { } make [ ' ] map
        ] bi
        \ word [ emit-seq ] emit-object
    ] keep put-object ;

: word-error ( word msg -- * )
    [ % dup vocabulary>> % " " % name>> % ] "" make throw ;

: transfer-word ( word -- word )
    [ target-word ] keep or ;

: fixup-word ( word -- offset )
    transfer-word dup lookup-object
    [ ] [ "Not in image: " word-error ] ?if ;

: fixup-words ( -- )
    image get [ dup word? [ fixup-word ] when ] map! drop ;

M: word ' ;

! Wrappers

M: wrapper '
    [ wrapped>> ' wrapper [ emit ] emit-object ] cache-eql-object ;

! Strings
: native> ( object -- object )
    big-endian get [ [ be> ] map ] [ [ le> ] map ] if ;

: emit-bytes ( seq -- )
    bootstrap-cell <groups> native> emit-seq ;

: pad-bytes ( seq -- newseq )
    dup length bootstrap-cell align 0 pad-tail ;

: extended-part ( str -- str' )
    dup [ 128 < ] all? [ drop f ] [
        [ -7 shift 1 bitxor ] { } map-as
        big-endian get
        [ [ 2 >be ] { } map-as ]
        [ [ 2 >le ] { } map-as ] if
        B{ } join
    ] if ;

: ascii-part ( str -- str' )
    [
        [ 128 mod ] [ 128 >= ] bi
        [ 128 bitor ] when
    ] B{ } map-as ;

: emit-string ( string -- ptr )
    [ length ] [ extended-part ' ] [ ] tri
    string [
        [ emit-fixnum ]
        [ emit ]
        [ f ' emit ascii-part pad-bytes emit-bytes ]
        tri*
    ] emit-object ;

M: string '
    #! We pool strings so that each string is only written once
    #! to the image
    [ emit-string ] cache-eql-object ;

: assert-empty ( seq -- )
    length 0 assert= ;

: emit-dummy-array ( obj type -- ptr )
    [ assert-empty ] [
        [ 0 emit-fixnum ] emit-object
    ] bi* ;

M: byte-array '
    [
        byte-array [
            dup length emit-fixnum
            bootstrap-cell 4 = [ 0 emit 0 emit ] when
            pad-bytes emit-bytes
        ] emit-object
    ] cache-eq-object ;

! Tuples
ERROR: tuple-removed class ;

: require-tuple-layout ( word -- layout )
    dup tuple-layout [ ] [ tuple-removed ] ?if ;

: (emit-tuple) ( tuple -- pointer )
    [ tuple-slots ]
    [ class transfer-word require-tuple-layout ] bi prefix [ ' ] map
    tuple [ emit-seq ] emit-object ;

: emit-tuple ( tuple -- pointer )
    dup class name>> "tombstone" =
    [ [ (emit-tuple) ] cache-eql-object ]
    [ [ (emit-tuple) ] cache-eq-object ]
    if ;

M: tuple ' emit-tuple ;

M: tombstone '
    state>> "((tombstone))" "((empty))" ?
    "hashtables.private" lookup def>> first
    [ emit-tuple ] cache-eql-object ;

! Arrays
: emit-array ( array -- offset )
    [ ' ] map array [ [ length emit-fixnum ] [ emit-seq ] bi ] emit-object ;

M: array ' [ emit-array ] cache-eq-object ;

! This is a hack. We need to detect arrays which are tuple
! layout arrays so that they can be internalized, but making
! them a built-in type is not worth it.
PREDICATE: tuple-layout-array < array
    dup length 5 >= [
        [ first tuple-class? ]
        [ second fixnum? ]
        [ third fixnum? ]
        tri and and
    ] [ drop f ] if ;

M: tuple-layout-array '
    [
        [ dup integer? [ <fake-bignum> ] when ] map
        emit-array
    ] cache-eql-object ;

! Quotations

M: quotation '
    [
        array>> '
        quotation [
            emit ! array
            f ' emit ! cached-effect
            f ' emit ! cache-counter
            0 emit ! xt
            0 emit ! code
        ] emit-object
    ] cache-eql-object ;

! End of the image

: emit-words ( -- )
    all-words [ emit-word ] each ;

: emit-global ( -- )
    {
        dictionary source-files builtins
        update-map implementors-map
    } [ [ bootstrap-word ] [ get ] bi ] H{ } map>assoc
    {
        class<=-cache class-not-cache classes-intersect-cache
        class-and-cache class-or-cache next-method-quot-cache
    } [ H{ } clone ] H{ } map>assoc assoc-union
    bootstrap-global set ;

: emit-jit-data ( -- )
    \ if jit-if-word set
    \ do-primitive jit-primitive-word set
    \ dip jit-dip-word set
    \ 2dip jit-2dip-word set
    \ 3dip jit-3dip-word set
    \ inline-cache-miss pic-miss-word set
    \ inline-cache-miss-tail pic-miss-tail-word set
    \ mega-cache-lookup mega-lookup-word set
    \ mega-cache-miss mega-miss-word set
    \ declare jit-declare-word set
    \ c-to-factor c-to-factor-word set
    \ lazy-jit-compile lazy-jit-compile-word set
    \ unwind-native-frames unwind-native-frames-word set
    undefined-def undefined-quot set ;

: emit-special-objects ( -- )
    special-objects get keys [ emit-special-object ] each ;

: fixup-header ( -- )
    heap-size data-heap-size-offset fixup ;

: build-generics ( -- )
    [
        all-words
        [ generic? ] filter
        [ make-generic ] each
    ] with-compilation-unit ;

: build-image ( -- image )
    800000 <vector> image set
    20000 <hashtable> objects set
    emit-image-header t, 0, 1, -1,
    "Building generic words..." print flush
    build-generics
    "Serializing words..." print flush
    emit-words
    "Serializing JIT data..." print flush
    emit-jit-data
    "Serializing global namespace..." print flush
    emit-global
    "Serializing special object table..." print flush
    emit-special-objects
    "Performing word fixups..." print flush
    fixup-words
    "Performing header fixups..." print flush
    fixup-header
    "Image length: " write image get length .
    "Object cache size: " write objects get assoc-size .
    \ word global delete-at
    image get ;

! Image output

: (write-image) ( image -- )
    bootstrap-cell big-endian get
    [ '[ _ >be write ] each ]
    [ '[ _ >le write ] each ] if ;

: write-image ( image -- )
    "Writing image to " write
    architecture get boot-image-name resource-path
    [ write "..." print flush ]
    [ binary [ (write-image) ] with-file-writer ] bi ;

PRIVATE>

: make-image ( arch -- )
    [
        architecture set
        "resource:/core/bootstrap/stage1.factor" run-file
        build-image
        write-image
    ] with-scope ;

: make-images ( -- )
    images [ make-image ] each ;
