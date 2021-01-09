/*
 * dsp-hp-filter.c
 *
 * Created: 11.11.2020 17:14:38
 * Author : kunek
 */ 

#include "adc.h"
#include "dac.h"
#include "dsp.h"
#include "dsp_asm.h"

#include <avr/io.h>
#include <avr/interrupt.h>

#define N 3

struct FIR_filter myFilter;
volatile uint16_t sample_new;
volatile uint8_t sample_pointer;
volatile uint8_t sample_ready;
uint16_t output; // 10 bit output

int main(void)
{
	filterInit(&myFilter);	
	ADCInit();
	
	sei();
	
    /* Replace with your application code */
    while (1) 
    {
		if(sample_ready)
		{
			sample_ready = 0;
			sei();
			myFilter.filterNodes[0] = myFilter.filterNodes[1];
			myFilter.filterNodes[1] = myFilter.filterNodes[2];
			myFilter.filterNodes[2] = myFilter.filterNodes[3];
			myFilter.filterNodes[3] = (int16_t) sample_new - 512;
			
			calculate(&myFilter, &output);
		}
    }
}

ISR(ADC_vect)
{
	sample_new = ADC;
	sample_ready = 1;
}