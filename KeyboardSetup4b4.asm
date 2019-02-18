#include p18f87k22.inc
 
    global keyboard_setup, rows, columns, test1

 
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

keyboard_setup
    banksel PADCFG1
    bsf PADCFG1, REPU, BANKED
    clrf LATE
    setf TRISE
    return
    
rows
    movlw 0x0F
    movwf TRISE
    ;movlw .2
    ;call LCD_delay_ms
    movff PORTE, row_input
    movlw 0x0E
    movwf row0
    movlw 0x0D
    movwf row1
    movlw 0x0B
    movwf row2
    movlw 0x07
    movwf row3
    clrf TRISD
    movff row_input, PORTD
    return
    
columns
    clrf TRISE
    movlw 0xF0
    movwf TRISE
    ;call LCD_delay_ms
    movff PORTE, col_input
    movff col_input, PORTD
    return

 

test1 ; this is the correct way, registers f and W have to make sense create var. combo 
    movf row_input, W
    iorwf col_input, W
    movlw 0xEE
    movwf combo
    movlw 0xEE
    cpfseq combo
    goto test2 
    movlw "A"
    return
test2
    cpfseq combo
    goto test3
    movlw "0"
    return
test3
    cpfseq 0b11101011
    goto test4
    movlw "B"
    return
test4
    cpfseq 0b11100111
    goto test5
    movlw "C"
    return
test5
    cpfseq 0b11101101
    goto test6
    movlw "7"
    return
test6
    cpfseq 0b11011101
    goto test7
    movlw "8"
    return
test7
    cpfseq 0b10111101
    goto test8
    movlw "9"
    return
test8
    cpfseq 0b01111101
    goto test9
    movlw "D"
    return
test9
    cpfseq 0b11101011
    goto test10
    movlw "4"
    return
test10
    cpfseq 0b11011011
    goto test11
    movlw "5"
    return
test11
    cpfseq 0b10111011
    goto test12
    movlw "6"
    return
test12
    cpfseq 0b01111011
    goto test13
    movlw "E"
    return
test13
    cpfseq 0b11100111
    goto test14
    movlw "1"
    return
test14 
    cpfseq 0b11010111
    goto test15
    movlw "2"
    return
test15
    cpfseq 0b10110111
    goto test16
    movlw "3"
    return
test16
    cpfseq 0b01110111
    goto test17
    movlw "F"
    return
test17
    movlw 0x00
    return

    end