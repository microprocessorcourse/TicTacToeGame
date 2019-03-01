	#include p18f87k22.inc
	
	global XO_switcher, round_counter
	extern	UART_Setup, UART_Transmit_Message, UART_Transmit_Byte  ; external UART subroutines
	extern GLCD_init, GLCD_clear, GLCD_set_horizontal, LCD_delay_ms
	extern X_char, O_char
	extern Y_address, Page_address, Y_addressO, Page_addressO
	extern keyboard_init, test1
	
acs0	udata_acs   ; reserve data space in access ram
counter	    res 1   ; reserve one byte for a counter variable
delay_count res 1   ; reserve one byte for counter in the delay routine
XO_switcher res 1
round_counter res 1

main    code
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
        goto $		; goto current line in code
	; a delay subroutine if you need one, times around loop in delay_count
delay	decfsz	delay_count	; decrement until zero
	bra delay
	return
	
	end