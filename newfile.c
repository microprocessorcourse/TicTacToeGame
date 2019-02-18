
void Glcd_CmdWrite(char cmd)
{
    GlcdDataBus = cmd;           //Send the Command nibble
    GlcdControlBus &= ~(1<<RS);  // Send LOW pulse on RS pin for selecting Command register
    GlcdControlBus &= ~(1<<RW);  // Send LOW pulse on RW pin for Write operation
    GlcdControlBus |= (1<<EN);   // Generate a High-to-low pulse on EN pin
    delay(100);
    GlcdControlBus &= ~(1<<EN);

    delay(1000);
}