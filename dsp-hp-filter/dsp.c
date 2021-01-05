/*
 * dsp.c
 *
 * Created: 11.11.2020 17:16:36
 *  Author: kunek
 */ 

#include "dsp.h"

#include <avr/io.h>

// filter coefficients scaled to 13 bits

static int16_t filterTaps[4] = {
  -1498,
  1045,
  1045,
  -1498
};

void filterInit(struct FIR_filter *myFilter)
{
	myFilter->filterNodes[0] = 0;
	myFilter->filterNodes[1] = 0;
	myFilter->filterNodes[2] = 0;
	myFilter->filterNodes[3] = 0;

	myFilter->filterCoefficients[0] = filterTaps[0];
	myFilter->filterCoefficients[1] = filterTaps[1];
	myFilter->filterCoefficients[2] = filterTaps[2];
	myFilter->filterCoefficients[3] = filterTaps[3];
}