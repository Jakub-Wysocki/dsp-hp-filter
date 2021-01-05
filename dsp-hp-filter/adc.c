/*
 * adc.c
 *
 * Created: 11.11.2020 17:15:39
 *  Author: kunek
 */ 

#include <avr/io.h>

#include "adc.h"

void ADCInit()
{
	// Turn off digital inputs on pins ADC0-ADC5
	DIDR0 = 0;
	
	// Use ADC0 input, AVcc with capacitor at AREF voltage reference
	ADMUX = _BV(REFS0);
	
	// Set 8x prescaler - 2 MHz ADC frequency - around 153,846 kHz sampling frequency
	ADCSRA = _BV(ADPS1) | _BV(ADPS0);
	
	// Set auto trigger enable
	ADCSRA |= _BV(ADATE);
	
	// Set free running mode
	ADCSRB = 0;
	
	// Enable ADC & interrupts
	ADCSRA |= _BV(ADEN) | _BV(ADIE);
	
	// Start first conversion
	ADCSRA |= _BV(ADSC);
}