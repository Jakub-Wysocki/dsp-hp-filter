/*
 * dsp.h
 *
 * Created: 11.11.2020 17:18:27
 *  Author: kunek
 */ 

#ifndef DSP_H_
#define DSP_H_

#include <avr/io.h>

struct FIR_filter {
	int16_t filterNodes[4]; // 3 last samples and current sample
	int16_t filterCoefficients[4];
};

void filterInit(struct FIR_filter *);

#endif /* DSP_H_ */