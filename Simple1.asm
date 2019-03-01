	#include p18f87k22.inc
	
	global XO_switcher
	extern	UART_Setup, UART_Transmit_Message, UART_Transmit_Byte  ; external UART subroutines
	extern GLCD_init, GLCD_clear, GLCD_set_horizontal
	extern X_char, O_char
	extern Y_address, Page_address, Y_addressO, Page_addressO
	extern keyboard_init, test1
	extern LCD_Setup
	
acs0	udata_acs   ; reserve data space in access ram
counter	    res 1   ; reserve one byte for a counter variable
delay_count res 1   ; reserve one byte for counter in the delay routine

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
	

	call GLCD_init
	call GLCD_set_horizontal
	movlw 0x09
	movwf round_counter
rounds	movlw 0x01 
	movwf XO_switcher
key_test
	nop
	nop
	nop
	nop
	call keyboard_init
	nop
	nop
	nop
	nop
	call test1
	nop
	nop
	nop
	nop
	nop
	nop
	movlw 1
	call LCD_delay_ms
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
	decfsz XO_switcher
	bra key_test 
	decfsz round_counter
	bra rounds
	;movlw 0xB8
	;lmovwf Page_address
	;call O_char
	;call   LCD_Send_Byte_D
	;call   UART_Transmit_Byte
        goto $		; goto current line in code
	; a delay subroutine if you need one, times around loop in delay_count
delay	decfsz	delay_count	; decrement until zero
	bra delay
	return
	
	end