#include p18f87k22.inc
 
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
    banksel PADCFG1
    bsf PADCFG1, REPU, BANKED
    clrf LATE
    setf TRISE; sets TRISTATE mode
    movlw .5
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
    movlw 0xF0
    movwf TRISE
    movlw 1
    call LCD_delay_ms
    movff PORTE, col_input
    return
test1; this is the correct way, registers f and W have to make sense create var. combo 
    movf row_input, W
    iorwf col_input, 1; stores inclusive OR with row_input in col_input
    movff col_input, combo
    movlw 0x77; value for '1' on keypad
    cpfseq combo; if input value of row and column is same as 'A' then skip next line
    goto test2
    movlw 0x00
    cpfseq XO_switcher
    cpfsgt XO_switcher
    bra O_check1
    bcf LATB, right
    bcf LATB, left
    movlw 0x43
    movwf Y_address
    movlw 0xB8
    movwf Page_address
    call X_char
    decf XO_switcher
    bra out1
O_check1 
    bcf LATB, left 
    bsf LATB, right 
    movlw 0x43
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
out1  return
test2; this is the correct way, registers f and W have to make sense create var. combo 
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
    movlw 0x68
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
test3; this is the correct way, registers f and W have to make sense create var. combo 
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
test4; this is the correct way, registers f and W have to make sense create var. combo 
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
test5; this is the correct way, registers f and W have to make sense create var. combo 
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
test6; this is the correct way, registers f and W have to make sense create var. combo 
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
    ;movlw 0x22; right disp off
    ;movwf PORTB
    ;movlw 0x21; left disp off right on, dont need to switch right disp back on
    ;movwf PORTB
    ;call GLCD_clear
    ;call GLCD_set_horizontal
out6  return
test7; this is the correct way, registers f and W have to make sense create var. combo 
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
    ;movlw 0x22; right disp off
    ;movwf PORTB
    ;movlw 0x21; left disp off right on, dont need to switch right disp back on
    ;movwf PORTB
    ;call GLCD_clear
    ;call GLCD_set_horizontal
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
    ;movlw 0x22; right disp off
    ;movwf PORTB
    ;movlw 0x21; left disp off right on, dont need to switch right disp back on
    ;movwf PORTB
    ;call GLCD_clear
    ;call GLCD_set_horizontal
out8  return
test9; this is the correct way, registers f and W have to make sense create var. combo 
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
    ;movlw 0x22; right disp off
    ;movwf PORTB
    ;movlw 0x21; left disp off right on, dont need to switch right disp back on
    ;movwf PORTB
    ;call GLCD_clear
    ;call GLCD_set_horizontal
out9
    bsf LATB, left
    bsf LATB, right
    return
play_again
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
invalid
    nop
    return
    end   