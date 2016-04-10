//Modified from Derek Molloy for the book Exploring BeagleBone
.origin 0
.entrypoint START

#define INS_PER_US   1000 / 5 		// 5ns per instruction
#define INS_PER_DELAY_LOOP 2		// two instructions per delay loop
#define DELAY  1000 * 1000 * (INS_PER_US / INS_PER_DELAY_LOOP)	// set up a 1s delay

#define MAX_COUNT	9

#define PRU0_R31_VEC_VALID 32    // allows notification of program completion
#define PRU_EVTOUT_0    3        // the event number that is sent back

// Memory space mapped to the GPIO registers
#define GPIO0	0x44e07000
#define GPIO1	0x4804c000
#define GPIO2	0x481ac000
#define GPIO3	0x481ae000

// GPIO Registers
#define GPIO_OE 			0x134
#define GPIO_DATAIN			0x138
#define GPIO_DATAOUT		0x13c
#define GPIO_CLEARDATAOUT	0x190
#define GPIO_SETDATAOUT		0x194

#define GPIO0_30	1<<30	//P9_11 gpio0[30] Output - bit 30

START:
	//Enable PRU write to GPIO
	LBCO	r0, C4, 4, 4
	CLR		r0, r0, 4
	SBCO	r0, C4, 4, 4

	MOV		r3, MAX_COUNT

LEDON:
	MOV		r1, GPIO0 | GPIO_SETDATAOUT // load addr for GPIO Set data r1
	MOV		r2, GPIO0_30	// write GPIO0_30 to r2
	SBBO	r2, r1, 0, 4	// write r2 to the r1 address value - LED ON
	MOV		r0, DELAY

DELAYON:
	SUB		r0, r0, 1
	QBNE	DELAYON, r0, 0

LEDOFF:
	MOV		r1, GPIO0 | GPIO_CLEARDATAOUT // load addr for GPIO Set data r1
	MOV		r2, GPIO0_30	// write GPIO0_30 to r2
	SBBO	r2, r1, 0, 4	// write r2 to the r1 address value - LED OFF
	MOV		r0, DELAY

DELAYOFF:
	SUB		r0, r0, 1
	QBNE	DELAYOFF, r0, 0
	SUB		r3, r3, 1
	QBEQ	END, r3, 0
	CALL	LEDON

END:
	MOV	R31.b0, PRU0_R31_VEC_VALID | PRU_EVTOUT_0
	HALT