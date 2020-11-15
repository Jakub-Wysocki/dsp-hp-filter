/*
 * dsp.h
 *
 * Created: 11.11.2020 17:18:27
 *  Author: kunek
 */ 


#ifndef DSP_H_
#define DSP_H_

struct FIR_filter {
	int16_t filterNodes[N]; // kolejne dane wejsciowe
	int16_t filterCoefficients[N+1]; // wspolczynniki policzone
};

void filterInit(struct FIR_filter);


#endif /* DSP_H_ */