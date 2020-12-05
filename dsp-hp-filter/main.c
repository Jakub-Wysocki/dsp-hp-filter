/*
 * dsp-hp-filter.c
 *
 * Created: 11.11.2020 17:14:38
 * Author : kunek
 */ 

#include "adc.h"
#include "dac.h"
#include "dsp.h"

#include <avr/io.h>
#include <avr/interrupt.h>

#define N 3

int main(void)
{
	struct FIR_filter myfilter;
	
	ADCInit();
	
    /* Replace with your application code */
    while (1) 
    {
		asm volatile ("nop");
		
    }
}

ISR(ADC_vect)
{
	
}