#! /bin/sh

nasm main.asm -f elf32 -o main.o
nasm core_logic.asm -f elf32 -o core.o
nasm tui_interface.asm -f elf32 -o tui.o

ld -m elf_i386 *.o -o stopwatch || exit 1

./stopwatch
