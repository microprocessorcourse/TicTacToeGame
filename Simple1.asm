  	#include p18f87k22.inc
	
	code
	org 0x0
	goto	start
	
	org 0x100		    ; Main code starts here at address 0x100

start
	movlw 	0x0
	movwf	TRISC, ACCESS	    ; Port B all outputs
	bra 	test
loop	movff 	0x06, PORTC
	incf 	0x06, W, ACCESS
	movwf   0x06, ACCESS
test	movlw 	0x
	movwf	0x07, ACCESS	    ; Test for end of loop condition
	call    delay
	movlw   0xFF
	cpfsgt 	0x06, ACCESS
	bra 	loop		    ; Not yet finished goto start of loop again
	goto 	0x0		    ; Re-run program from start

delay   decfsz  0x07
	bra delay
	return
	
	end
	

myTable data "hello"
        constant myArray=0x30
        constant counter=0x10
start   lfsr     FSR0, myArray