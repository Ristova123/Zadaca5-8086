S_SEG SEGMENT
DW 20 DUP(?) ;мора да се дефинира стек, заради
S_TOP LABEL WORD ;проследување на параметри
S_SEG ENDS
D_SEG SEGMENT
 ARRAY_1 DB 10 DUP(?)
 ARRAY_2 DB 5 DUP(?)
D_SEG ENDS
PROC_SEG SEGMENT ;сегмент на потпрограмата
ASSUME CS:PROC_SEG, DS:D_SEG & SS:S_SEG
EXAMPLE PROC FAR
PUSH BP ;привремено го чуваме BP на врв на стек
MOV BP,SP ;наместо SP го користиме BP, полесно е!
PUSH CX ;подолу ги користиме,затоа ја чуваме
PUSH BX ;нивната тековна вредност
PUSHF ;исто ги чуваме флеговите
MOV CX,[BP+8] ;Во CX е param1, т.е. должината
MOV BX,[BP+6] ;Во BX е param2, т.е. адресата
 POP F ;враќање на старите вредности
POP BX
 POP CX
 POP BP
RET 4 ;RET автоматски ги враќа CS и IP и останаа да се
исчистат уште 4 бајти на врвот на стекот
EXAMPLE ENDP
 PROC_SEG ENDS
CALLER_SEG SEGMENT
 ASSUME CS:CALLER_SEG, DS:D_SEG & SS:S_SEG
 ;иницијализација на сегментни регистри
 MOV AX,D_SEG
 MOV DS,AX
 MOV AX,S_SEG
 MOV SS,AX
 MOV SP,OFFSET S_TOP
 ;проследување на параметри
 MOV AX,LENGTH ARRAY_1
 PUSH AX
 MOV AX,OFFSET ARRAY_1
 PUSH AX
 CALL EXAMPLE ;повикување на потпрограмата
 MOV AX, LENGTH ARRAY_2
 PUSH AX
 MOV AX, OFFSET ARRAY_2
 PUSH AX
 CALL EXAMPLE ;повикување на потпрограмата
 CALLER_SEG ENDS
 END ;крај на главната програма
