
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

	movw r30, r24 ; register Z points to filter struct (r25:r24 [1st argument] -> r31:r30 [Z])
	movw r26, r22 ; register X points to output (r23:r22 [2nd argument] -> r27:r26 [X])
	
	;*	r18:r17:r16 = r23:r22 * r21:r20

	;----------------------------------------;

	; load node 3
	ldd r23, Z+1
	ld r22, Z

	; load coefficient 3
	ldd r21, Z+9
	ldd r20, Z+8

	call muls16x16_24

	;----------------------------------------;

	; load node 2
	ldd r23, Z+3
	ldd r22, Z+2

	; load coefficient 2
	ldd r21, Z+11
	ldd r20, Z+10

	call mac16x16_24

	;----------------------------------------;

	; load node 1
	ldd r23, Z+5
	ldd r22, Z+4

	; load coefficient 1
	ldd r21, Z+13
	ldd r20, Z+12

	call mac16x16_24

	;----------------------------------------;

	; load node 0
	ldd r23, Z+7
	ldd r22, Z+6

	; load coefficient 0
	ldd r21, Z+15
	ldd r20, Z+14

	call mac16x16_24

	;----------------------------------------;

	; 24 bit signed output in r18, r17, r16

	; start creating frame for 10 bit DAC
	; drop r16
	; add 32767: 16 bit signed -> 16 bit unsigned

	call addi16

	; start shifting data bits to correct position 
	lsr r18
	ror r17

	lsr r18
	ror r17

	lsr r18
	ror r17

	lsr r18
	ror r17
 
	; end shifting

	; bit 15 (start transmission) already cleared due to lsr
	; bit 13 (2x gain) already cleared due to lsr

	sbr r18, 0b00010000 ; set bit 12 (active mode)

	; end creating frame, outpit in r18:r17

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

/*
 * Additional subroutines
 * Based on AVR202: 16-bit Arithmetics
 * Original info:
 *
 * Title:		16-bit Arithmetics
 * Version:		1.1
 * Last updated:	97.07.04
 * Target:		AT90Sxxxx (All AVR Devices)
 *
 */

;***************************************************************************
;* 
;* "addi16" - Adding 16-bit register with immediate
;*
;* This example adds a register variable (addi1l,addi1h) with an 
;* immediate 16-bit number defined with .equ-statement.   The result is
;* placed in (addi1l, addi1h).
;*
;* Number of words	:2
;* Number of cycles	:2
;* Low registers used	:None
;* High registers used	:2
;*
;* Note: The sum and the addend share the same register.  This causes the
;* addend to be overwritten by the sum.
;*
;***************************************************************************

;***** Code
.func addi16
addi16:
	subi r17, lo8(-0x7FFF)	;Add low byte ( x -(-y)) = x + y
	sbci r18, hi8(-0x7FFF)	;Add high byte with carry
	ret

