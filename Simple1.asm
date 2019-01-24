  	#include p18f87k22.inc
	
	code
	org 0x0
	goto	start
	
	org 0x100		    ; Main code starts here at address 0x100

SPI_MasterInit ; Set Clock edge to negative
bcf SSP2STAT, CKE
; MSSP enable; CKP=1; SPI master, clock=Fosc/64 (1MHz)
movlw (1<<SSPEN)|(1<<CKP)|(0x02)
movwf SSP2CON1
; SDO2 output; SCK2 output
bcf TRISD, SDO2
bcf TRISD, SCK2
return
SPI_MasterTransmit ; Start transmission of data (held in W)
movwf SSP2BUF
Wait_Transmit ; Wait for transmission to complete
btfss PIR2, SSP2IF
bra Wait_Transmit
bcf PIR2, SSP2IF ; clear interrupt flag
return

	
start 
      banksel PADCFG1
      bsf     PADCFG1, REPU, BANKED
      movlb   0x00
      setf    TRISE
      movlw 0x00
      movwf TRISD, ACCESS ; sets PORTD as output
      bsf   PORTD, 0, ACCESS
      bsf   PORTD, 1, ACCESS
      bsf   PORTD, 2, ACCESS
      bsf   PORTD, 3, ACCESS ; sets pins 0-3 PORTD ON
      call write
      call read
write
      clrf TRISE
      movlw 0x05; DATA
      movwf PORTE, ACCESS
      bcf  PORTD, 2, ACCESS
      bsf  PORTD, 2, ACCESS
      clrf TRISE
      movlw 0x06; DATA chip 2
      movwf PORTE, ACCESS
      bcf PORTD, 3, ACCESS
      bsf PORTD, 3, ACCESS
      setf TRISE
      return
read
      bcf PORTD, 0
      clrf TRISC
      movff PORTE,PORTC
      goto $
end
      
 