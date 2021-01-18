/*
 * dac.c
 *
 * Created: 11.11.2020 17:15:57
 *  Author: kunek
 */

#include "dac.h"

#include <avr/io.h>

#define SPI_DDR		DDRB	// define(slave select low or high)
#define SPI_PORT	PORTB	// define(slave select on or off)
#define SS			PINB2	// define(slave select input)
#define MOSI		PINB3	// define(master output slave input)
#define MISO		PINB4	// define(master input slave output)
#define SCK			PINB5	// define(serial clock input)

void DACInit()
{
	// set SPI parameters as output
    SPI_DDR |= (1 << SS) | (1 << MOSI) | (1 << SCK); // set SS, MOSI and SCK to output
	
	SPI_PORT |= (1 << SS); // dac off
	
	//SPCR - SPI control register
    SPCR = (1 << SPE) | (1 << MSTR) | (1 << SPI2X); // SPE enable SPI, MSTR select master SPI, SPI2X set clock rate fck/2
}

void DACOutput(uint16_t data)
{
	SPI_PORT &= ~(1 << SS); // dac on
	
    SPDR = data >> 8; // load data into register
    while(!(SPSR & (1 << SPIF))); // Wait for transmission complete
	
    SPDR = data; // load data into register
    while(!(SPSR & (1 << SPIF))); // Wait for transmission complete
	
	SPI_PORT |= (1 << SS); //dac off
}
