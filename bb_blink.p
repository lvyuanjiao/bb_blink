//Modified from Derek Molloy for the book Exploring BeagleBone
.origin 0
.entrypoint START

#define INS_PER_US   1000 / 5 		// 5ns per instruction
#define INS_PER_DELAY_LOOP 2		// two instructions per delay loop
#define DELAY  1000 * 1000 * (INS_PER_US / INS_PER_DELAY_LOOP)	// set up a 1s delay

#define MAX_COUNT	9

#define PRU0_R31_VEC_VALID 32    // allows notification of program completion
#define PRU_EVTOUT_0    3        // the event number that is sent back

START:
	MOV		r1, MAX_COUNT

LEDON:
	SET		r30.t5
	MOV		r0, DELAY

DELAYON:
	SUB		r0, r0, 1
	QBNE	DELAYON, r0, 0

LEDOFF:
	CLR		r30.t5
	MOV		r0, DELAY

DELAYOFF:
	SUB		r0, r0, 1
	QBNE	DELAYOFF, r0, 0
	SUB		r1, r1, 1
	QBEQ	END, r1, 0
	CALL	LEDON

END:
	MOV	R31.b0, PRU0_R31_VEC_VALID | PRU_EVTOUT_0
	HALT