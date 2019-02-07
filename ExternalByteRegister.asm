#include p18f87k22.inc
	
	code
	org 0x0
	goto	start
	
	org 0x100		    ; Main code starts here at address 0x100

banksel PADCFG1
bsf     PADCFG1, REPU, BANKED
movlb   0x00
setf    TRISE

start movlw 0x00
      movwf PORTD, ACCESS ; sets PORTD as output
      movwf PORTE, ACCESS ; sets PORTE as output
      bsf   0, PORTD, ACCESS
      bsf   1, PORTD, ACCESS
      bsf   2, PORTD, ACCESS
      bsf   3, PORTD, ACCESS ; sets pins 0-3 on PORTD high
end      