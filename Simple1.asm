	#include p18f87k22.inc
	; code starts at line 49, was having issues with deleting what was before it
	; simple1 allows for calling general GLCD routines and also for looping keypad presses in order to allow consecutive presses 
	; and switching between XO
	
	
	global XO_switcher, round_counter
	extern	UART_Setup, UART_Transmit_Message, UART_Transmit_Byte  ; external UART subroutines
	extern GLCD_init, GLCD_clear, GLCD_fill, GLCD_set_horizontal, LCD_delay_ms
	extern X_char, O_char
	extern Y_address, Page_address, Y_addressO, Page_addressO
	extern keyboard_init, test1

acs0	udata_acs   ; reserve data space in access ram
counter	    res 1   ; reserve one byte for a counter variable
delay_count res 1   ; reserve one byte for counter in the delay routine
XO_switcher res 1
tables	udata	0x400    ; reserve data anywhere in RAM (here at 0x400)
myArray res 0x80    ; reserve 128 bytes for message data

rst	code	0    ; reset vector
	goto	setup
	
pdata	code    ; a section of programme memory for storing data
	; ******* myTable, data in programme memory, and its length *****
myTable data	    "Hello World!\n"	; message, plus carriage return
	constant    myTable_l=.13	; length of data
	
main	code
	; ******* Programme FLASH read Setup Code ***********************
setup	bcf	EECON1, CFGS	; point to Flash program memory  
	bsf	EECON1, EEPGD 	; access Flash program memory
	call	UART_Setup	; setup UART
	goto	start 
	
	; ******* Main programme ****************************************
start 	lfsr	FSR0, myArray	; Load FSR0 with address in RAM	
	movlw	upper(myTable)	; address of data in PM
	movwf	TBLPTRU		; load upper bits to TBLPTRU
	movlw	high(myTable)	; address of data in PM
	movwf	TBLPTRH		; load high byte to TBLPTRH
	movlw	low(myTable)	; address of data in PM
	movwf	TBLPTRL		; load low byte to TBLPTRL
	movlw	myTable_l	; bytes to read
	movwf 	counter		; our counter register
loop 	tblrd*+			; one byte from PM to TABLAT, increment TBLPRT
	movff	TABLAT, POSTINC0; move data from TABLAT to (FSR0), inc FSR0	
	decfsz	counter		; count down to zero
	bra	loop		; keep going until finished
	
	
	call GLCD_init; code starts here
	call GLCD_clear
	call GLCD_set_horizontal; sets tic-tac-toe shape, horizontal and vertical
rounds	movlw 0x01; start with X character as first one 
	movwf XO_switcher
key_test
	nop
	nop
	nop
	nop
	call keyboard_init; sets up row_input, col_input and combo
	nop
	nop
	nop
	movlw 1
	call LCD_delay_ms
	nop
	call test1; checks with box has been pressed and draws characters in it
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	movlw 1000
	call LCD_delay_ms
	bra key_test; loops around to allow multiple presses
        goto $		; goto current line in code
	; a delay subroutine if you need one, times around loop in delay_count
delay	decfsz	delay_count	; decrement until zero
	bra delay
	return
	
	end
