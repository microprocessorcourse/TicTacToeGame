#include p18f87k22.inc
; sets up keyboard pins
; allows for input from keys 1-9 and key 'A' for play again
; allows for pressing a number to draw a character (X/O) in a designated box
 
    global keyboard_init, test1
    extern X_char, O_char, Y_address, Page_address, Y_addressO, Page_addressO
    extern LCD_delay_ms
    extern GLCD_set_horizontal, GLCD_clear
    extern XO_switcher, round_counter
	constant left=0
	constant right=1
 
acs0    udata_acs  
row0       res 1
row1       res 1
row2       res 1
row3       res 1
row_input  res 1
column0    res 1
column1    res 1
column2    res 1
column3    res 1
col_input  res 1
combo      res 1

    
    code
keyboard_init
    banksel PADCFG1; set pull up resistor on for PORTE
    bsf PADCFG1, REPU, BANKED
    clrf LATE
    setf TRISE; sets TRISTATE mode
    movlw .5; delay required after setting TRISTATE
    call LCD_delay_ms
    call row_init
    return
row_init
    movlw 0x0F; turn on row inputs
    movwf TRISE
    movlw 1
    call LCD_delay_ms; need delay between tristate and port
    movff PORTE, row_input  
    call column_init
    return
column_init
    movlw 0xF0; make column pins inputs
    movwf TRISE
    movlw 1
    call LCD_delay_ms
    movff PORTE, col_input
    return
test1; this is the correct way, registers f and W have to make sense create var. combo 
    movf row_input, W
    iorwf col_input, 1; stores inclusive OR with row_input in col_input, store in col_input
    movff col_input, combo
    movlw 0x77; value for '1' on keypad
    cpfseq combo; if input value of row and column is same as 'A' then skip next line
    goto test2; otherwise try next possible key input
    movlw 0x00
    cpfseq XO_switcher; if XO_switcher is 0 will draw on O so goes to line60, if XO_switcher=1 will draw an X
    cpfsgt XO_switcher
    bra O_check1
    bsf LATB, right; turn off right display to write in box 1 only, bug here
    movlw 0x43
    movwf Y_address; sets Y address corresponding to box 1
    movlw 0xB8
    movwf Page_address; sets page address corresponding to box 1
    call X_char; draws X
    decf XO_switcher; changes XO_switcher to 0 such that in the next loop (see simple1) an O is drawn
    bcf LATB, right; turns back on right display
    bra out1
O_check1 
    bcf LATB, left 
    bsf LATB, right 
    movlw 0x43
    movwf Y_addressO
    movlw 0xB9; O address for same box is one lower than X address based on how O_char routine is setup
    movwf Page_addressO
    call O_char; draws O
    incf XO_switcher; changes XO_switcher to 1 such that next loop (see simple1) an X is drawn
out1  return
test2; check for box 2 
    movf row_input, W
    iorwf col_input, 1; stores inclusive OR with row_input in col_input
    movff col_input, combo
    movlw 0xB7; value for '1' on keypad
    cpfseq combo; if input value of row and column is same as 'A' then skip next line
    goto test3
    movlw 0x00
    cpfseq XO_switcher
    cpfsgt XO_switcher
    bra O_check2
    bcf LATB, left
    bsf LATB, right
    movlw 0x68; address for box 2
    movwf Y_address
    movlw 0xB8
    movwf Page_address
    call X_char
    decf XO_switcher
    bcf LATB, left
    bcf LATB, right
    bra out2
O_check2 
    bcf LATB, left 
    bsf LATB, right
    movlw 0x68
    movwf Y_addressO
    movlw 0xB9; start at lower page of two
    movwf Page_addressO
    call O_char
    incf XO_switcher
    ;movlw 0x22; right disp off
    ;movwf PORTB
    ;movlw 0x21; left disp off right on, dont need to switch right disp back on
    ;movwf PORTB
    ;call GLCD_clear
    ;call GLCD_set_horizontal
out2  return
test3;
    movf row_input, W
    iorwf col_input, 1; stores inclusive OR with row_input in col_input
    movff col_input, combo
    movlw 0xD7; value for '1' on keypad
    cpfseq combo; if input value of row and column is same as 'A' then skip next line
    goto test4
    movlw 0x00
    cpfseq XO_switcher
    cpfsgt XO_switcher
    bra O_check3
    bsf LATB, left
    bcf LATB, right
    movlw 0x68
    movwf Y_address
    movlw 0xB8
    movwf Page_address
    call X_char
    decf XO_switcher
    bra out3
O_check3 
    bsf LATB, left 
    bcf LATB, right
    movlw 0x68
    movwf Y_addressO
    movlw 0xB9; start at lower page of two
    movwf Page_addressO
    call O_char
    incf XO_switcher
    ;movlw 0x22; right disp off
    ;movwf PORTB
    ;movlw 0x21; left disp off right on, dont need to switch right disp back on
    ;movwf PORTB
    ;call GLCD_clear
    ;call GLCD_set_horizontal
out3  return
test4; 
    movf row_input, W
    iorwf col_input, 1; stores inclusive OR with row_input in col_input
    movff col_input, combo
    movlw 0x7B; value for '1' on keypad
    cpfseq combo; if input value of row and column is same as 'A' then skip next line
    goto test5
    movlw 0x00
    cpfseq XO_switcher
    cpfsgt XO_switcher
    bra O_check4
    bcf LATB, left
    bsf LATB, right
    movlw 0x43
    movwf Y_address
    movlw 0xBB
    movwf Page_address
    call X_char
    bcf LATB, left
    bcf LATB, right
    decf XO_switcher
    bra out4
O_check4 
    bcf LATB, left 
    bsf LATB, right
    movlw 0x43
    movwf Y_addressO
    movlw 0xBC; start at lower page of two
    movwf Page_addressO
    call O_char
    incf XO_switcher
    goto test1    
    ;movlw 0x22; right disp off
    ;movwf PORTB
    ;movlw 0x21; left disp off right on, dont need to switch right disp back on
    ;movwf PORTB
    ;call GLCD_clear
    ;call GLCD_set_horizontal
out4  return
test5;
    movf row_input, W
    iorwf col_input, 1; stores inclusive OR with row_input in col_input
    movff col_input, combo
    movlw 0xBB; value for '1' on keypad
    cpfseq combo; if input value of row and column is same as 'A' then skip next line
    goto test6
    movlw 0x00
    cpfseq XO_switcher
    cpfsgt XO_switcher
    bra O_check5
    bcf LATB, left
    bsf LATB, right
    movlw 0x68
    movwf Y_address
    movlw 0xBB
    movwf Page_address
    call X_char
    decf XO_switcher
    bcf LATB, left
    bcf LATB, right
    bra out5
O_check5 
    bcf LATB, left 
    bsf LATB, right
    movlw 0x68
    movwf Y_addressO
    movlw 0xBC; start at lower page of two
    movwf Page_addressO
    call O_char
    incf XO_switcher
    bra out5
    ;movlw 0x22; right disp off
    ;movwf PORTB
    ;movlw 0x21; left disp off right on, dont need to switch right disp back on
    ;movwf PORTB
    ;call GLCD_clear
    ;call GLCD_set_horizontal
out5  return
test6; 
    movf row_input, W
    iorwf col_input, 1; stores inclusive OR with row_input in col_input
    movff col_input, combo
    movlw 0xDB; value for '1' on keypad
    cpfseq combo; if input value of row and column is same as 'A' then skip next line
    goto test7
    movlw 0x00
    cpfseq XO_switcher
    cpfsgt XO_switcher
    bra O_check6
    bsf LATB, left
    bcf LATB, right
    movlw 0x68
    movwf Y_address
    movlw 0xBB
    movwf Page_address
    call X_char
    decf XO_switcher
    bra out6
O_check6 
    bsf LATB, left
    bcf LATB, right
    movlw 0x68
    movwf Y_addressO
    movlw 0xBC; start at lower page of two
    movwf Page_addressO
    call O_char
    incf XO_switcher
out6  return
test7; 
    movf row_input, W
    iorwf col_input, 1; stores inclusive OR with row_input in col_input
    movff col_input, combo
    movlw 0x7D; value for '1' on keypad
    cpfseq combo; if input value of row and column is same as 'A' then skip next line
    goto test8
    movlw 0x00
    cpfseq XO_switcher
    cpfsgt XO_switcher
    bra O_check7
    bcf LATB, left
    bsf LATB, right
    movlw 0x43
    movwf Y_address
    movlw 0xBE
    movwf Page_address
    call X_char
    bcf LATB, left
    bcf LATB, right
    decf XO_switcher
    bra out7
O_check7 
    bcf LATB, left 
    bsf LATB, right
    movlw 0x43
    movwf Y_addressO
    movlw 0xBF; start at lower page of two
    movwf Page_addressO
    call O_char
    bcf LATB, left 
    bsf LATB, right
    incf XO_switcher
out7  return
test8; this is the correct way, registers f and W have to make sense create var. combo 
    movf row_input, W
    iorwf col_input, 1; stores inclusive OR with row_input in col_input
    movff col_input, combo
    movlw 0xBD; value for '1' on keypad
    cpfseq combo; if input value of row and column is same as 'A' then skip next line
    goto test9
    movlw 0x00
    cpfseq XO_switcher
    cpfsgt XO_switcher
    bra O_check8
    bcf LATB, left
    bsf LATB, right
    movlw 0x68
    movwf Y_address
    movlw 0xBE
    movwf Page_address
    call X_char
    bcf LATB, left
    bcf LATB, right
    decf XO_switcher
    bra out8
O_check8 
    bcf LATB, left 
    bsf LATB, right
    movlw 0x68
    movwf Y_addressO
    movlw 0xBF; start at lower page of two
    movwf Page_addressO
    call O_char
    incf XO_switcher
out8  return
test9;  
    movf row_input, W
    iorwf col_input, 1; stores inclusive OR with row_input in col_input
    movff col_input, combo
    movlw 0xDD; value for '1' on keypad
    cpfseq combo; if input value of row and column is same as 'A' then skip next line
    goto play_again
    movlw 0x00
    cpfseq XO_switcher
    cpfsgt XO_switcher
    bra O_check9
    bsf LATB, left;
    bcf LATB, right;
    movlw 0x68
    movwf Y_address
    movlw 0xBE
    movwf Page_address
    call X_char
    decf XO_switcher
    bra out9
O_check9 
    bsf LATB, left
    bcf LATB, right
    movlw 0x68
    movwf Y_addressO
    movlw 0xBF; start at lower page of two
    movwf Page_addressO
    call O_char
    incf XO_switcher
out9 return`
play_again; allows for wiping the characters out of the boxes and playing again by pressing A
    movf row_input, W
    iorwf col_input, 1
    movff col_input, combo
    movlw 0x7E
    cpfseq combo
    goto invalid
    call GLCD_clear
    call GLCD_set_horizontal
    movlw 0x01
    movwf XO_switcher
    return
invalid; if no applicable key is pressed will return and loop again, minimises accidental key presses
    nop
    return
    end   
