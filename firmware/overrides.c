#include "config.h"
#include "statusword.h"
#include "ps2.h"
#include "keyboard.h"
#include "uart.h"
#include "interrupts.h"

#include <stdio.h>
#include <string.h>

#include "c64keys.c"

int LoadROM(const char *fn);

int UpdateKeys(int blockkeys)
{
	handlec64keys();
	return(HandlePS2RawCodes(blockkeys));
}

void cycle(int row);
void toggle(int row)
{
	cycle(row);
	if(menu_longpress)
	{
		statusword|=(1<<13); /* Assert hard-reset */
		sendstatus();
		statusword&=~(1<<13); /* Release hard-reset */
	}
	cycle(row);
}

char *autoboot()
{
	char *result=0;
	/* If a config file didn't cause a disk image to be loaded, attempt to mount a default image */

	if(!LoadROM(ROM_FILENAME))
		result="ROM loading failed";

	initc64keys();

	return(result);
}

