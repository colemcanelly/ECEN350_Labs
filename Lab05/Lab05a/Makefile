# LAB01 Example Makefile
#
# This makefile is intended for use with GNU make
# This example is intended to be built with Linaro bare-metal GCC

TARGET=Lab05a
CC=gcc
LD=gcc

ASM=test2.S test.S
OBJS= $(ASM:%.S=%.o)

FLAGS=-g -O0

all: $(TARGET)

clean:
	rm *.o
	rm $(TARGET)

main.o: main.c
# Compile for best debug view (lowest optimization)
	$(CC) $(FLAGS) -c $^  -o $@

# Compile for best debug view (lowest optimization)
%.o: %.S
	$(CC) $(FLAGS) -c $^ -o $@

$(TARGET): main.o $(OBJS)
	$(LD) main.o $(OBJS) -o $@
