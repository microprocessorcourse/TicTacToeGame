
#include p18f87k22.inc

    global touchpad_init, touchpad_run
    
;player1_input res 1
;player2_input res 1
acs0    udata_acs   ; named variables in access ram
LCD_cnt_l   res 1   ; reserve 1 byte for variable LCD_cnt_l
LCD_cnt_h   res 1   ; reserve 1 byte for variable LCD_cnt_h
LCD_cnt_ms  res 1   ; reserve 1 byte for ms counter
char_X      res 1   ; reserve memory address for X and O characters
char_O      res 1
  
    constant cs1=0 ; set names for control pins
    constant cs2=1
    constant RS=2
    constant RW=3
    constant EN=4
    constant RST=5
    constant DISP_ON=0x3F
    constant DISP_OFF=0x3E

  
GLCD code


touchpad_init
    clrf LATB
    clrf TRISD
    clrf TRISB
    bsf LATB, RST ; reset button required to be 1 for display on?
    bcf LATB, cs1 ; cs1 and cs2 pattern not clear both out to page 0
    bsf LATB, cs2 
    movlw 20
    call LCD_delay_ms
    call touchpad_run
    return
touchpad_run
    movlw DISP_OFF ; must turn off display to initialize and then turn on again
    call GLCD_Cmdwrite
    movlw 0x40    ; set x address 0-63 is page 1
    call GLCD_Cmdwrite
    movlw 0xB8 ; sets line   line 0 in this case with B8 up to BF and each line has 8 pixels
    call GLCD_Cmdwrite
    movlw 0xC0 ; set starting pixel of code vertically
    call GLCD_Cmdwrite
    movlw DISP_ON
    call GLCD_Cmdwrite
    movlw .10
    call LCD_delay_ms
    ;movlw  0x55 ; this and line 53-55 is a test at random parts of display shift horizontally here
    ;call GLCD_Cmdwrite
    movlw 0x7F
    call GLCD_Cmdwrite
    movlw 0xC;
    call GLCD_Datawrite
    movlw 0xD
    call GLCD_Datawrite
    return 
touchpad_test
    movlw 0x48
    movwf PORTD
    call GLCD_Cmdwrite
    movlw 0xC1
    movwf PORTD
    call GLCD_Cmdwrite
    movlw 5
    movwf PORTD
    call GLCD_Datawrite
    return
GLCD_Cmdwrite
    movwf PORTD
    bcf LATB, RS ; RS low for command write
    bcf LATB, RW ; RW low for write
    call LCD_Enable
    return
    
GLCD_Datawrite
    movwf PORTD
    bsf LATB, RS ; RS high for data write
    bcf LATB, RW ; RW low for write
    call LCD_Enable
    return

GLCD_clear
LCD_Enable	    ; pulse enable bit LCD_E for 500ns
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	bsf	    LATB, EN	    ; Take enable high
	nop
	nop
	movlw   .5
	call LCD_delay_x4us
	nop
	nop
	nop
	nop
	bcf	    LATB, EN	    ; Writes data to LCD   high to low transitions
	movlw .1
	call LCD_delay_ms
	return
    
; ** a few delay routines below here as LCD timing can be quite critical ****
LCD_delay_ms		    ; delay given in ms in W
	movwf	LCD_cnt_ms
lcdlp2	movlw	.250	    ; 1 ms delay
	call	LCD_delay_x4us	
	decfsz	LCD_cnt_ms
	bra	lcdlp2
	return
    
LCD_delay_x4us		    ; delay given in chunks of 4 microsecond in W
	movwf	LCD_cnt_l   ; now need to multiply by 16
	swapf   LCD_cnt_l,F ; swap nibbles
	movlw	0x0f	    
	andwf	LCD_cnt_l,W ; move low nibble to W
	movwf	LCD_cnt_h   ; then to LCD_cnt_h
	movlw	0xf0	    
	andwf	LCD_cnt_l,F ; keep high nibble in LCD_cnt_l
	call	LCD_delay
	return

LCD_delay			; delay routine	4 instruction loop == 250ns	    
	movlw 	0x00		; W=0
lcdlp1	decf 	LCD_cnt_l,F	; no carry when 0x00 -> 0xff
	subwfb 	LCD_cnt_h,F	; no carry when 0x00 -> 0xff
	bc 	lcdlp1		; carry, then loop again
	return			; carry reset so return


    end