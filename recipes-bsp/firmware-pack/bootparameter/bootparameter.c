// SPDX-License-Identifier: GPL-2.0-or-later
/*
 * bootparameter.c: Boot Parameter Program
 * 
 * 
 * This program creates a boot parameter file by writing bootloader size data 
 * (BL2 binary) and additional information into sector 1 of a bootable device,
 * converting it into a format similar to a Master Boot Record (MBR).
 * 
 * Copyright (C) 2021 Renesas Electronics Corp.
 * Author: Biju Das <biju.das.jz@bp.renesas.com>
*/

#include <stdio.h>
#include <stdlib.h>
#include <sys/stat.h>
#include <sys/types.h>

#define SECTOR_DUMMY_VALUE 0xFF
#define SECTOR_PADDING_SIZE 506
//2-bytes signature word or end of sector marker, which is always set to 0x55AA 
#define SECTOR_MARKER_END_FIRST_BYTE 0x55
#define SECTOR_MARKER_END_SECOND_BYTE 0xAA

// This function is used to check the size of a file.
off_t fsize(const char *filename)
{
	struct stat st;
	if (stat(filename, &st) == 0)
		return st.st_size;
	return -1;
}

/* 
 * Before writing, alignment 4 bytes for size of bl2-rzg2l-sbc.bin.
 * Open file bl2_bp.bin and write 512 bytes data into sector 1 similar to a Master Boot Record. 
 * It includes 4 bytes alignment,506 bytes padding,2 signature bytes for end of the sector.
 * ex: bootparameter ${RECIPE_SYSROOT}/boot/bl2-${MACHINE}.bin bl2_bp.bin 
   argv[0] This is always name of the program file. ; 
   argv[1] containing source binary. ;
   argv[2] containing file name of final padded binary. ;
*/
int main(int argc, char *argv[])
{
	int size, i = 0;
	char val = SECTOR_DUMMY_VALUE;
	if (argc <= 2) { /* argc should be 2 for correct execution */
		/* We print argv[0] assuming it is the program name */
		printf("usage: %s bl2_filename output_file_name\n", argv[0]);
		return -1;
	} else {
		// We assume argv[1] is a filename to open
		// The first argument is used to just identify the size of bl2.bin 
		FILE *fptr;
		fptr = fopen(argv[2], "wb");
		/* fopen returns 0, the NULL pointer, on failure */
		if (fptr == 0)	{
			printf("Could not open file\n");
		}
		int fd = fileno(fptr);
		// Check the size of bl2.bin 
		size = fsize(argv[1]);
		printf("size is %x\n",size);
		// 4-bytes alignment for the size and store the new 4-bytes aligned size into size 
		size = (size + 3) & (~0x3);
		printf("Aligned size is %x\n",size);

		// Write 4 bytes of size at the beginning of the sector 1 
		fwrite(&size, 4, 1, fptr);

		// Fill the middle of sector 1 with 506 bytes of 0xFF. 
		for(i = 0; i < SECTOR_PADDING_SIZE; i++)
			 fwrite(&val, 1, 1, fptr);
		// Write a 2-bytes signature word or end of sector marker, which is always set to 0x55AA 
		val = SECTOR_MARKER_END_FIRST_BYTE;
		fwrite(&val, 1, 1, fptr);
		val = SECTOR_MARKER_END_SECOND_BYTE;
		fwrite(&val, 1, 1, fptr);

		// The total written bytes is 4 + 506 + 2 = 512 bytes 
		fsync(fd);
		fclose(fptr);
	}
	return 0;
}
