#include p18f87k22.inc
 
    global keyboard_setup, rows, columns
    extern LCD_delay_ms

    code
acs0    udata_acs  
KYB_row0   res 1
row1       res 1
row2       res 1
row3       res 1
row_input  res 1
column0    res 1
column1    res 1
column2    res 1
column3    res 1
col_input  res 1
    
keyboard_setup
    banksel PADCFG1
    bsf PADCFG1, REPU, BANKED
    clrf LATE
    setf TRISE
    return
    
rows
    movlw 0x0F
    movwf TRISE
    movlw 0.2
    call LCD_delay_ms
    movff PORTE, row_input
    movlw 0x0E
    movwf KYB_row0
    movlw 0x0D
    movwf row1
    movlw 0x0B
    movwf row2
    movlw 0x07
    movwf row3
    call test1
    clrf TRISD
    movff row_input, PORTD
    
columns
    clrf TRISE
    movlw 0xF0
    movwf TRISE
    movlw 0.2
    call LCD_delay_ms
    movff PORTE, col_input
    movlw 0b
end
    
    
testrow1    
    cpfseq  testrow1
    goto testrow2
    call rowfound1
testrow2
    cpfseq  testrow2
    goto next test
    call rowfoudn2
    
    
    

test1
    movf row_input, W
    cpfseq 0b11101110
    goto test2 
    movlw "A"
    return
test2
    cpfseq 0b11101101
    goto test3
    return "0"
test3
    cpfseq 0b11101011
    goto test4
    return "B"
test4
    cpfseq 0b11100111
    goto test5
    return "C"
test5
    