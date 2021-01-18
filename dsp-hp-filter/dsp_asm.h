/*
 * dsp_asm.h
 *
 * Created: 28.12.2020 22:29:08
 *  Author: kunek
 */ 

#ifndef DSP_ASM_H_
#define DSP_ASM_H_

#include "dsp.h"

void calculate(struct FIR_filter *, uint16_t *); // second argument is the output

#endif /* DSP_ASM_H_ */