/* mipslabwork.c

   This file written 2015 by F Lundevall
   Updated 2017-04-21 by F Lundevall

   This file should be changed by YOU! So you must
   add comment(s) here with your name(s) and date(s):

   This file modified 2017-04-31 by Ture Teknolog 

   For copyright and licensing, see file COPYING */

#include <stdint.h>   /* Declarations of uint_32 and the like */
#include <pic32mx.h>  /* Declarations of system-specific addresses etc */
#include "mipslab.h"  /* Declatations for these labs */

int mytime = 0x5957;

int prime = 1234567;

volatile int* porte = (volatile int*) 0xbf886110;
int timeoutcount = 0;


char textstring[] = "text, more text, and even more text!";

/* Interrupt Service Routine */
void user_isr( void )
{
  IFS(0) &= ~0x100; // Clear the Timer 2 interrupt flag
  timeoutcount++;
  
  if (timeoutcount >= 10)
  {
    timeoutcount = 0;
    time2string( textstring, mytime );
    display_string( 3, textstring );
    display_update();
    tick( &mytime ); 
  }
}

/* Lab-specific initialization goes here */
void labinit( void )
{
  volatile int* trise = (volatile int*) 0xbf886100;
  *trise = *trise & 0xFFFFFF00;
  *porte = 0;

  TRISD |= 0x0FE0; //Bitmask to set Port D to inputs
  
  // Initialize Timer2 for 100 ms timeout

  T2CON = 0x0; // Stop timer and clear control register
  TMR2 = 0x0;  // Clear timer2 register
  PR2 = 31249; // Set period to 0.100*(80 000 000/256)-1 = 31249
  IFS(0) &= ~0x100; // Clear the timer2 interrupt status flag
  
  IPC(2) |= 0x040; // Set interrupt priority
  IEC(0) |= 0x100; // Enable interrupts for Timer2
  T2CON |= 0x8070; // Start the timer with 1:256 prescaling

  enable_interrupt; // Enable interrupts globally
}

/* This function is called repetitively from the main program */
void labwork( void )
{
  prime = nextprime( prime );
  display_string( 0, itoaconv( prime ) );
  display_update();
}
