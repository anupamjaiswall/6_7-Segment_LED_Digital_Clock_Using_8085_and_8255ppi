;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Author Name : ANUPAM JAISWAL  ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Problem: Write an assembly language program (for 8085) to display a digital clock using 6 seven segment LEDs and PPI 8255.      ;
; Use port A for hour displays,                                                                                                   ;
; port B for minute displays and                                                                                                  ;
; port C for second displays.                                                                                                     ;
;                                                                                                                                 ;
; Here I'm using B, C, D, E, H, and L registers for counter.                                                                      ;
; counter B for : Left part of Hour                                                                                               ;
; counter C for : Right part of Hour                                                                                              ;
; counter D for : Left part of Minute                                                                                             ;
; counter E for : Right part of Minute                                                                                            ;
; counter H for : Left part of Second                                                                                             ;
; counter L for : Right part of Second                                                                                            ;
;                                                                                                                                 ;
;       Port-A               Port-B               Port-C                                                                          ;
;       0   0      :         0   0        :       0   0                                                                           ;
;       B   C                D   E                H   L  (These are 8085's register which I'm using for counter)                  ;
;                                                                                                                                 ;
; Port A   : 20H                                                                                                                  ;
; Port B   : 21H                                                                                                                  ;
; Port C   : 22H                                                                                                                  ;
; Port CWR : 23H                                                                                                                  ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

MVI A, 80H
OUT 23H; setting up ppi 8255 to work in i/o mode
JMP LOOP

; Loop to blink the LEDs for lifetime
LOOP:

  ; Initializing every register with 0 so that if there any data exist in the register will be overwritten with 0
  MVI A, 00H
  MOV B,A
  MOV C,A
  MOV D,A
  MOV E,A
  MOV H,A
  MOV L,A


  ; To blink LEDs as 00:00:00
  MVI A, 00H
  OUT 20H
  OUT 21H
  OUT 22H
  
  JMP SECL; This function is responsible for both seconds LED segment
  
SECR: 
  INR L
  JMP DELAY1SECOND; it will call a DELAY1SEOND subroutine that will create a delay for a second
  
SECL:
  SECR; SECR function is incrementing values in L register and calling Delay function.
  
  ;H rigister is containg only values in multiples of 10.
  
  MOV A, H
  ADD L; for example:10H + 01H = 01H, now accumulator has 11H
  
  CPI L, 09H; on equal zero flag will be set and carry flag will reset.
  JZ ADDITION10SECL; to increment the left part of second
  
  OUT 22H; seconds will be printed.
  JMP SECL; to continue in seonds.
  
ADDITION10SECL:
  MOV A, H
  ADI 10H
  MOV H, A
  MVI L, 00H; setting up L register to 00
  CPI A, 60H
  JZ INRMINUTE; a function to increment minute
  OUT 22H
  JMP SECL
  
INRMINUTE:
  INR E
  MVI H, 00H
  MVI L, 00H
  JMP MINUTEL; 
  RET
  
MINUTEL:
  MOV A, D
  ADD E
  
  CPI E, 09H
  JZ ADD10MINUTEL
  
  OUT 21H; to lightup minute LED
  RET
  
ADD10MINUTEL:
  MOV A, D
  ADI 10H
  MOV D, A
  MVI E 00H
  CPI D, 60H
  OUT 21H
  JZ INRHOUR
  
INRHOUR: 
  INR C
  MVI D, 00H
  MVI E, 00H
  JMP HOURL
  RET
  
HOURL:
  MOV A, B
  ADD C
  CPI A, 24H
  JZ LOOP
  CPI C, 09H
  JZ ADD10HOURL
  OUT 20H
  
ADD10HOURL:
  MOV A, B
  ADI 10H
  MOV B, A
  MVI C, 00H
  OUT 20H
  JMP SECL
