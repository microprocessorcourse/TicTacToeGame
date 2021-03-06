; main GLCD code, intialises GLCD
; GLCD sending instructions via Cmdwrite and sending a byte of data via Datawrite using pulse enable/lcdenable routine
; GLCDclear routine, draw game shape, and draw X/O characters also included here, called in simple1
#include p18f87k22.inc

    global GLCD_init, GLCD_clear, GLCD_fill, GLCD_set_horizontal, X_char, O_char, GLCD_Cmdwrite, GLCD_Datawrite
    global Y_address, Page_address, Y_addressO, Page_addressO
    global LCD_delay_ms
    
;player1_input res 1
;player2_input res 1
acs0    udata_acs   ; named variables in access ram
LCD_cnt_l     res 1   ; reserve 1 byte for variable LCD_cnt_l
LCD_cnt_h     res 1   ; reserve 1 byte for variable LCD_cnt_h
LCD_cnt_ms    res 1   ; reserve 1 byte for ms counter
char_X        res 1   ; reserve memory address for X and O characters
char_O        res 1   ;
Y_counter     res 1   ; counter for Y address
Page_counter  res 1   ; counter for pages
line_setter   res 1   ; counter for lines 
y_address     res 1   ; reserve 1 byte for y_address input from keypad
Xshape_counter res 1  ;  for X character counter
Xshape_drawer res 1   ;  for writing x lines
Xshape_page res 1     ;  for switching pages while drawing lines
O_counter  res 1      ;  for O character counter
O_counter2 res 1      ;  for 2nd half of O shape on next page
Y_address res 1       ;  reserve memory for deciding which box to put an X or O, based on keypad press, coupled with page_address
Page_address res 1
Y_addressO   res 1
Page_addressO res 1
Page_address2 res 1
chip_counter res 1
chip1        res 1
chip2        res 1
    constant cs1=0 ; set names for control pins on PORTB and for certain instruction values
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

GLCD_init ; need to turn off GLCD and initialize by setting display start 0xC0 and page and Y address start then turn on again
    clrf LATB
    clrf TRISD ; sets PORTB and PORTD as output
    clrf TRISB
    bsf LATB, RST ; reset is ON when reset switch is low, so keep high to display GLCD
    bcf LATB, cs1 ; cs1 and cs2 on when low, determines left and right half of display
    bsf LATB, cs2 ; initiliazes chipsets separately
    movlw 0x01
    movwf chip_counter
    movwf chip1
    movwf chip2
chip movlw 20 ; 20ms delay after latch
    call LCD_delay_ms
    movlw DISP_OFF ; init starts here
    call GLCD_Cmdwrite
    movlw Y_start    ; set Y address starting point, horizontal
    call GLCD_Cmdwrite
    movlw Page0 ; sets line   line 0 in this case with B8 up to BF and each line has 8 pixels
    call GLCD_Cmdwrite
    movlw 0xC0 ; set starting page of display, this is not changed once set as it shifts entire display
    call GLCD_Cmdwrite
    movlw DISP_ON
    call GLCD_Cmdwrite
    decfsz chip1
    bcf LATB, cs2
    decfsz chip2
    bsf LATB, cs1
    decfsz chip_counter
    bra chip
    return 
    
GLCD_Cmdwrite ; write instructions to GLCD
    movwf PORTD ; PORTD is data bus
    bcf LATB, RS ; RS low for command write
    bcf LATB, RW ; RW low for write
    call LCD_Enable 
    return  
    
GLCD_Datawrite; write data to GLCD, 1 byte is a vertical row of 8 pixels at given Y and page
    movwf PORTD
    bsf LATB, RS ; RS high for data write
    bcf LATB, RW ; RW low for write
    call LCD_Enable
    return
    
GLCD_clear; clear entire display
              bcf LATB, cs1
	      bcf LATB, cs2
	      movlw 0x08; 8 vertical pages in total with a byte/page/Yaddress
              movwf Page_counter
Page_clear    movlw Y_start
	      call GLCD_Cmdwrite
	      movwf Y_counter
y_loop        movf Page_counter, W
	      addlw Page0; add 0xB8 to 0x08, start at last page  (0xBF) clear bottom to top
	      call GLCD_Cmdwrite
	      movlw 0x00; clear
	      call GLCD_Datawrite; Y_address increments automatically here
	      decfsz Y_counter; go through 0-63 Y addresses horizontally
              bra y_loop
              decfsz Page_counter; once cleared page via Y addresses move up to next page
	      bra Page_clear
	      return

	      
GLCD_fill; idnetical to GLCD_clear with 0xFF to fill
	      bcf LATB, cs1
	      bcf LATB, cs2
	      movlw 0x08
              movwf Page_counter
Page_fill     movlw Y_start
	      call GLCD_Cmdwrite
	      movwf Y_counter
y_loop_fill   movf Page_counter, W
	      addlw Page0
	      call GLCD_Cmdwrite
	      movlw 0xFF; fills display
	      call GLCD_Datawrite
	      decfsz Y_counter
              bra y_loop_fill
              decfsz Page_counter
	      bra Page_fill
	      return
	      
GLCD_set_horizontal; sets tic tac toe game shape
	movlw 0x40; start position of line
	call GLCD_Cmdwrite
	movlw 0xBA; set to page 2
	call GLCD_Cmdwrite
	movlw 0x40; not 3F but need 0x40 to set last y adress
	movwf Y_counter
rerun	movlw 0x08; 0b00010000 on page 2 to draw horizontal line
	call GLCD_Datawrite; 
	decfsz Y_counter
	bra rerun; Y address incrementing alone after data write instruction 
	movlw Y_start; second horizontal line on pg 5
	call GLCD_Cmdwrite
	movlw 0xBD; page 5
	call GLCD_Cmdwrite
	movlw 0x40; need 0x40 not 3F to set last y adress
	movwf Y_counter
rerun2	movlw 0x20 ; 0b00100000 on page 5 incremented across Y addresses
	call GLCD_Datawrite
	decfsz Y_counter
	bra rerun2
GLCD_set_vertical
	bsf LATB, cs2; turns off right screen, write to left only
	movlw 0x65; set Y address for line1
	call GLCD_Cmdwrite
	bcf LATB, cs2
	bsf LATB, cs1; turn off left screen
	movlw 0x55; set Y address for line2
	call GLCD_Cmdwrite
	bcf LATB, cs1
	movlw Page0; page0 init 
	call GLCD_Cmdwrite
	movlw 0xFF
	call GLCD_Datawrite
	movlw 0x07; rest of pages looped
	movwf Page_counter
rerun_v	bsf LATB, cs2
	movlw 0x65; loops to keep Y_address from incrementing
	call GLCD_Cmdwrite
	bcf LATB, cs2
	bsf LATB, cs1
	movlw 0x55
	call GLCD_Cmdwrite
	bcf LATB, cs1
	movf Page_counter, W ; unlike Y, Page wont increment so must use counter
	addlw Page0; start at last page and fill up 
	call GLCD_Cmdwrite
	movlw 0xFF
	call GLCD_Datawrite
	decfsz Page_counter
	bra rerun_v
	return
X_char
line1   movf Y_address, W; input from keypad sets Y_address and Page_address
	call GLCD_Cmdwrite
	movff Page_address, Xshape_page  ; Xshape_page will inc/dec to draw X in more than one page
pagelop	movf Xshape_page, W
	call GLCD_Cmdwrite
	movlw 0x08
	movwf Xshape_counter
	movlw 0x01; this draws the positive sloped line
	movwf Xshape_drawer
	movlw 0x01; draw 0x01 and rotate left, starts at top
hello2	call GLCD_Datawrite
	movff PORTD, Xshape_drawer; calling data write moves contents from w to PORTD so must bring back
	rlncf Xshape_drawer, 0; rotate left one bit,store in w,  no carry allows for drawing of line top to bottom
	decfsz Xshape_counter
	bra hello2
	incf Xshape_page
	movlw 0x02
	addwf Page_address, 0; two pages up is limit to draw character, store in W
	cpfseq Xshape_page; once its two pages up stop drawing
	bra pagelop
	call X_char2
	return
X_char2; this draws the positively sloped line for the X character
	movf Y_address, W
	call GLCD_Cmdwrite
	movlw 0x01
	addwf Page_address, 0; other line starts a page lower, store add in Page_address2
	movwf Page_address2
        movff Page_address2, Xshape_page
pagelo 	movf Xshape_page, W
	call GLCD_Cmdwrite
	movlw 0x08
	movwf Xshape_counter; count to fill 8 bytes/a page
	movlw 0x80; 0b10000000 for this line instead of 0b00000001
	movwf Xshape_drawer
	movlw 0x80
hello22	call GLCD_Datawrite
	movff PORTD, Xshape_drawer; calling data write moves contents from w to PORTD so must bring back
	rrncf Xshape_drawer, 0; rotate right one bit, store in W, draw bottom to top
	decfsz Xshape_counter
	bra hello22
	decf Xshape_page
	movlw 0x02; once reach two pages below, stop.  Unlike for other line, now working downwards 
	subwf Page_address2, 0
	cpfseq Xshape_page
	bra pagelo
	return
O_char; draws O character
	movf Y_addressO, W; variable address Y_addressO to put O in any box
	call GLCD_Cmdwrite
	movf Page_addressO, W
	call GLCD_Cmdwrite
	movlw 0x10; makes O bigger, scaling
	movwf O_counter
	movlw 0x7F
	call GLCD_Datawrite
O_loop	movlw 0x80; draw in exact values to get an O shape
	call GLCD_Datawrite
	decfsz O_counter
	bra O_loop; use same value to draw O so loop it
	movlw 0x7F
	call GLCD_Datawrite
	movf Y_addressO, W; now top horizontal line of 'o', split O into two halves to make it larger
	call GLCD_Cmdwrite
	movlw 0x01
	subwf Page_addressO, 0; second half of 'o'
	call GLCD_Cmdwrite
	movlw 0xFE; draws a part of the O shape
	call GLCD_Datawrite
	movlw 0x10
	movwf O_counter2
O_loop2	movlw 0x01; looping again for top half
	call GLCD_Datawrite
	decfsz O_counter2
	bra O_loop2
	movlw 0xFE
	call GLCD_Datawrite
	movlw 0x00
	call GLCD_Datawrite
	return

LCD_Enable	    ; pulse enable bit EN, high to low is when write to GLCD
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
	bcf	    LATB, EN	    ; Writes data to GLCD, high to low transitions
	movlw .1; minimum required delay for EN, 1ms
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
