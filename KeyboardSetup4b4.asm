#include p18f87k22.inc
 
    global keyboard_init, test1
    extern X_char, Y_address, Page_address
    extern LCD_delay_ms
    extern LCD_Send_Byte_D, LCD_Write_Hex
    extern GLCD_set_horizontal, GLCD_clear
    extern XO_switcher
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
    cpfseq O_switcher
    cpfsgt O_switch
    bra O_check
    bcf LATB, left
    bsf LATB, right
    movlw 0x43
    movwf Y_address
    movlw 0xB8
    movwf Page_address
    call X_char
    bra out
O_check 
    bcf LATB, left 
    bsf LATB, right
    movlw 0x43
    movwf Y_addressO
    movlw 0xB9; start at lower page of two
    movwf Page_addressO
    call O_char
    ;movlw 0x22; right disp off
    ;movwf PORTB
    ;movlw 0x21; left disp off right on, dont need to switch right disp back on
    ;movwf PORTB
    ;call GLCD_clear
    ;call GLCD_set_horizontal
out  return
test2; this is the correct way, registers f and W have to make sense create var. combo 
    movf row_input, W
    iorwf col_input, 1; stores inclusive OR with row_input in col_input
    movff col_input, combo
    movlw 0xB7; value for '2' on keypad
    cpfseq combo; if input value of row and column is same as 'A' then skip next line
    goto test3
    bsf LATB, right
    movlw 0x68
    movwf Y_address
    movlw 0xB8
    movwf Page_address
    call X_char
    bcf LATB, right
    return
test3; this is the correct way, registers f and W have to make sense create var. combo 
    movf row_input, W
    iorwf col_input, 1; stores inclusive OR with row_input in col_input
    movff col_input, combo
    movlw 0xD7; value for '3' on keypad
    cpfseq combo; if input value of row and column is same as 'A' then skip next line
    goto test4
    bsf LATB, left
    movlw 0x68
    movwf Y_address
    movlw 0xB8
    movwf Page_address
    call X_char
    bcf LATB, left
    return
test4; this is the correct way, registers f and W have to make sense create var. combo 
    movf row_input, W
    iorwf col_input, 1; stores inclusive OR with row_input in col_input
    movff col_input, combo
    movlw 0x7B; value for '4' on keypad
    cpfseq combo; if input value of row and column is same as 'A' then skip next line
    goto test5
    movlw 0x43
    movwf Y_address
    movlw 0xBB
    movwf Page_address
    movlw 0x22; right disp off
    movwf PORTB
    call X_char
    movlw 0x21; left disp off right on, dont need to switch right disp back on. this is only for current command
    movwf PORTB
    call GLCD_clear
    call GLCD_set_horizontal
    return
test5; this is the correct way, registers f and W have to make sense create var. combo 
    movf row_input, W
    iorwf col_input, 1; stores inclusive OR with row_input in col_input
    movff col_input, combo
    movlw 0xBB; value for '5' on keypad
    cpfseq combo; if input value of row and column is same as 'A' then skip next line
    goto test6
    movlw 0x68
    movwf Y_address
    movlw 0xBB
    movwf Page_address
    bsf LATB, right
    call X_char
    return
test6; this is the correct way, registers f and W have to make sense create var. combo 
    movf row_input, W
    iorwf col_input, 1; stores inclusive OR with row_input in col_input
    movff col_input, combo
    movlw 0xDB; value for '4' on keypad
    cpfseq combo; if input value of row and column is same as 'A' then skip next line
    goto test7
    bsf LATB, left
    movlw 0x68
    movwf Y_address
    movlw 0xBB
    movwf Page_address
    call X_char
    bcf LATB, left
    return
test7; this is the correct way, registers f and W have to make sense create var. combo 
    movf row_input, W
    iorwf col_input, 1; stores inclusive OR with row_input in col_input
    movff col_input, combo
    movlw 0x7D; value for '4' on keypad
    cpfseq combo; if input value of row and column is same as 'A' then skip next line
    goto test8
    bsf LATB, right
    movlw 0x43
    movwf Y_address
    movlw 0xBE
    movwf Page_address
    call X_char
    bcf LATB, right
    return
test8; this is the correct way, registers f and W have to make sense create var. combo 
    movf row_input, W
    iorwf col_input, 1; stores inclusive OR with row_input in col_input
    movff col_input, combo
    movlw 0xBD; value for '8' on keypad
    cpfseq combo; if input value of row and column is same as 'A' then skip next line
    goto test9
    bsf LATB, right
    movlw 0x68
    movwf Y_address
    movlw 0xBE
    movwf Page_address
    call X_char
    bcf LATB, right
    return
test9; this is the correct way, registers f and W have to make sense create var. combo 
    movf row_input, W
    iorwf col_input, 1; stores inclusive OR with row_input in col_input
    movff col_input, combo
    movlw 0xDD; value for '9' on keypad
    cpfseq combo; if input value of row and column is same as 'A' then skip next line
    goto invalid
    bsf LATB, left
    movlw 0x68
    movwf Y_address
    movlw 0xBE
    movwf Page_address
    call X_char
    bcf LATB, left
    return
invalid
    nop
    return
    
    end   