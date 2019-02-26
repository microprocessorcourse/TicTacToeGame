
#include p18f87k22.inc

    global GLCD_init, GLCD_test, GLCD_clear, GLCD_fill, GLCD_set_horizontal, X_char
    
;player1_input res 1
;player2_input res 1
acs0    udata_acs   ; named variables in access ram
LCD_cnt_l     res 1   ; reserve 1 byte for variable LCD_cnt_l
LCD_cnt_h     res 1   ; reserve 1 byte for variable LCD_cnt_h
LCD_cnt_ms    res 1   ; reserve 1 byte for ms counter
char_X        res 1   ; reserve memory address for X and O characters
char_O        res 1
Y_counter     res 1
Page_counter  res 1    
line_setter   res 1 
y_address     res 1
Xshape_counter res 1
Xshape_drawer res 1
Xshape_page res 1
    constant cs1=0 ; set names for control pins
    constant cs2=1
    constant RS=2
    constant RW=3
    constant EN=4
    constant RST=5
    constant DISP_ON=0x3F
    constant DISP_OFF=0x3E
    constant Y_start=0x40
    constant Page0=0xB8

  
GLCD code


GLCD_init
    clrf LATB
    clrf TRISD
    clrf TRISB
    bsf LATB, RST ; reset button on when low
    bcf LATB, cs1 ; cs1 and cs2 on when low
    bcf LATB, cs2 
    movlw 20 ; 20ms delay after latch
    call LCD_delay_ms
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
    return 
    
GLCD_test
    movlw 0x48
    call GLCD_Cmdwrite
    movlw 0xC0
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
	      movlw 0x08
              movwf Page_counter
Page_clear    movlw 0x40
	      call GLCD_Cmdwrite
	      movlw 0x40
	      movwf Y_counter
y_loop        movf Page_counter, W
	      addlw 0xB8
	      call GLCD_Cmdwrite
	      movlw 0x00
	      call GLCD_Datawrite
	      decfsz Y_counter
              bra y_loop
              decfsz Page_counter
	      bra Page_clear
	      return

	      
GLCD_fill
	      movlw 0x08
              movwf Page_counter
Page_fill    movlw 0x40
	      call GLCD_Cmdwrite
	      movlw 0x40
	      movwf Y_counter
y_loopp       movf Page_counter, W
	      addlw 0xB8
	      call GLCD_Cmdwrite
	      movlw 0xFF; fills display
	      call GLCD_Datawrite
	      decfsz Y_counter
              bra y_loopp
              decfsz Page_counter
	      bra Page_fill
	      return
	      
GLCD_set_horizontal
	call GLCD_clear
	movlw 0x40; start position
	call GLCD_Cmdwrite
	movlw 0xBA; set to page 2
	call GLCD_Cmdwrite
	movlw 0x40; not 3F but need 0x40 or wont set last y adress
	movwf Y_counter
rerun	movlw 0x08; value for 0b00010000 on page 2
	call GLCD_Datawrite
	decfsz Y_counter
	bra rerun; rerun with Y incrementing alone after data instruction 
	movlw 0x40
	call GLCD_Cmdwrite
	movlw 0xBD; second horizontal line on page 5 now
	call GLCD_Cmdwrite
	movlw 0x40; not 3F but need 0x40 or wont set last y adress
	movwf Y_counter
rerunn	movlw 0x20 ; value for 0b00100000 on page 5
	call GLCD_Datawrite
	decfsz Y_counter
	bra rerunn
GLCD_set_vertical
	movlw 0x60; set Y address for vertical line at 0x60
	call GLCD_Cmdwrite
	movlw 0xB8
	call GLCD_Cmdwrite
	movlw 0xFF
	call GLCD_Datawrite
	movlw 0x07
	movwf Page_counter
hello	movlw 0x60; set Y address for vertical line at 0x60
	call GLCD_Cmdwrite
	movf Page_counter, W ; unlike Y page wont increment so must use counter
	addlw 0xB8; start at page 7 ie address 0xBF
	call GLCD_Cmdwrite
	movlw 0xFF
	call GLCD_Datawrite
	decfsz Page_counter
	bra hello
	return
X_char
line1	bsf LATB, cs2; turn off right scren to only draw X in first box
	movlw 0x45;  this is halfway point in 1st box to make x appear in middle of box obtained from vertical line Y address
	call GLCD_Cmdwrite
	movlw 0xB8
	call GLCD_Cmdwrite
	movlw 0xB8
        movwf Xshape_page; do this on page 0
pagelop	movf Xshape_page, W
	call GLCD_Cmdwrite
	movlw 0x08
	movwf Xshape_counter
	movlw 0x01
	movwf Xshape_drawer
	movlw 0x01
hello2	call GLCD_Datawrite
	movff PORTD, Xshape_drawer; calling data write moves contents from w to PORTD so must bring back
	rlncf Xshape_drawer, 0; rotate left one bit no carry allows for drawing of line top to bottom
	decfsz Xshape_counter
	bra hello2
	incf Xshape_page
	movlw 0xBA
	cpfseq Xshape_page
	bra pagelop
	bcf LATB, cs1; turn back on right screen
	call X_char2
	return
X_char2
line2	bsf LATB, cs2; turn off right scren to only draw X in first box
	movlw 0x45
	call GLCD_Cmdwrite
	movlw 0xB9
        movwf Xshape_page; do this on page 0
pagelo 	movf Xshape_page, W
	call GLCD_Cmdwrite
	movlw 0x08
	movwf Xshape_counter
	movlw 0x80
	movwf Xshape_drawer
	movlw 0x80
hello22	call GLCD_Datawrite
	movff PORTD, Xshape_drawer; calling data write moves contents from w to PORTD so must bring back
	rrncf Xshape_drawer, 0; rotate right one bit no carry allows for drawing of line2 bottom to top
	decfsz Xshape_counter
	bra hello22
	decf Xshape_page
	movlw 0xB7
	cpfseq Xshape_page
	bra pagelo
	bcf LATB, cs1; turn back on right screen
	return
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