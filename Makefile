CROSS_COMPILE?=arm-linux-gnueabihf-
ARM_COMPILE_FLAGS?=-mtune=cortex-a8 -march=armv7-a

AM335_PRU_PACKAGE=./am335x_pru_package
PASM=$(AM335_PRU_PACKAGE)/pru_sw/utils/pasm
LIBDIR_APP_LOADER?=$(AM335_PRU_PACKAGE)/pru_sw/app_loader/lib
INCDIR_APP_LOADER?=$(AM335_PRU_PACKAGE)/pru_sw/app_loader/include

CFLAGS+= -Wall -I$(INCDIR_APP_LOADER) -D_XOPEN_SOURCE=500 $(ARM_COMPILE_FLAGS)

export CXXFLAGS+=$(CFLAGS) -std=c++03
export CXX=g++

LDFLAGS+=-lpthread  -lm
PRUSS_LIBS=$(LIBDIR_APP_LOADER)/libprussdrv.a

TARGETS=bb_blink

all: bb_blink bb_blink.bin

bb_blink: bb_blink.c
	$(CROSS_COMPILE)$(CXX) $(CFLAGS) -o $@ $^ $(PRUSS_LIBS) $(LDFLAGS)

bb_blink.bin: bb_blink.p
	$(PASM) -b $^

clean:
	rm bb_blink bb_blink.bin