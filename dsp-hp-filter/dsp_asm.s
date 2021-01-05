
/*
 * dsp_asm.s
 *
 * Created: 28.12.2020 22:28:35
 *  Author: kunek
 */
 .global calculate
 .func calculate
 calculate:
	push r16
	push r17

	movw r30, r24 ; register Z points to filter struct
	movw r26, r22 ; register X points to output
	
	;*	r18:r17:r16 = r23:r22 * r21:r20

	;----------------------------------------;

	; load node 3
	ld r23, Z
	ldd r22, Z+1

	; load coefficient 3
	ldd r21, Z+8
	ldd r20, Z+9

	call muls16x16_24

	;----------------------------------------;

	; load node 2
	ldd r23, Z+2
	ldd r22, Z+3

	; load coefficient 2
	ldd r21, Z+10
	ldd r20, Z+11

	call mac16x16_24

	;----------------------------------------;

	; load node 1
	ldd r23, Z+4
	ldd r22, Z+5

	; load coefficient 1
	ldd r21, Z+12
	ldd r20, Z+13

	call mac16x16_24

	;----------------------------------------;

	; load node 0
	ldd r23, Z+6
	ldd r22, Z+7

	; load coefficient 0
	ldd r21, Z+14
	ldd r20, Z+15

	call mac16x16_24

	;----------------------------------------;

	; output in r18, r17, r16

	; start downscaling to 10 bits
	; need to shift r18:r17 >> 6

	asr r18
	ror r17

	asr r18
	ror r17

	asr r18
	ror r17

	asr r18
	ror r17

	asr r18
	ror r17

	asr r18
	ror r17
 
	; end downscaling
	; 10 bit output in r18:r17

	st X+, r17
	st X+, r18

	clr r0
	clr r1

	pop r17
	pop r16

	ret
.endfunc

/*
 * Additional subroutines
 * Based on AVR201: Using the AVR Hardware Multiplier
 * Original info:
 *
 * Title		:	16bit multiply routines using hardware multiplier
 * Version		:	V2.0
 * Last updated	:	10 Jun, 2002
 * Target		:	Any AVR with HW multiplier
 *
 */ 
	
;******************************************************************************
;*
;* FUNCTION
;*	muls16x16_24
;* DECRIPTION
;*	Signed multiply of two 16bits numbers with 24bits result.
;* USAGE
;*	r18:r17:r16 = r23:r22 * r21:r20
;* STATISTICS
;*	Cycles :	14 + ret
;*	Words :		10 + ret
;*	Register usage: r0 to r1, r16 to r18 and r20 to r23 (9 registers)
;* NOTE
;*	The routine is non-destructive to the operands.
;*
;******************************************************************************

muls16x16_24:
	muls	r23, r21		; (signed)ah * (signed)bh
	mov		r18, r0
	mul		r22, r20		; al * bl
	movw	r16, r0
	mulsu	r23, r20		; (signed)ah * bl
	add		r17, r0
	adc		r18, r1
	mulsu	r21, r22		; (signed)bh * al
	add		r17, r0
	adc		r18, r1
	ret

;******************************************************************************
;*
;* FUNCTION
;*	mac16x16_24
;* DECRIPTION
;*	Signed multiply accumulate of two 16bits numbers with
;*	a 24bits result.
;* USAGE
;*	r18:r17:r16 += r23:r22 * r21:r20
;* STATISTICS
;*	Cycles :	16 + ret
;*	Words :		12 + ret
;*	Register usage: r0 to r1, r16 to r18 and r20 to r23 (9 registers)
;*
;******************************************************************************

mac16x16_24:
	muls	r23, r21		; (signed)ah * (signed)bh
	add	r18, r0

	mul	r22, r20		; al * bl
	add	r16, r0
	adc	r17, r1
	adc	r18, r2

	mulsu	r23, r20		; (signed)ah * bl
	add	r17, r0
	adc	r18, r1

	mulsu	r21, r22		; (signed)bh * al
	add	r17, r0
	adc	r18, r1

	ret
