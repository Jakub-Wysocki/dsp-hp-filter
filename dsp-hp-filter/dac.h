/*
 * dac.h
 *
 * Created: 11.11.2020 17:18:20
 *  Author: kunek
 */ 

#include <avr/io.h>

#ifndef DAC_H_
#define DAC_H_

// #define SDA_PIN 

void DACInit();
void DACOutput(uint16_t output);


#endif /* DAC_H_ */