! Copyright (C) 2008 Slava Pestov.
! See http://factorcode.org/license.txt for BSD license.
USING: accessors system kernel alien.c-types cpu.architecture cpu.ppc ;
IN: cpu.ppc.linux

<<
t "longlong" c-type (>>stack-align?)
t "ulonglong" c-type (>>stack-align?)
>>

M: linux reserved-area-size 2 ;

M: linux lr-save 1 ;

M: float-regs param-regs { 1 2 3 4 5 6 7 8 } ;

M: ppc value-structs? drop f ;

M: ppc fp-shadows-int? drop f ;