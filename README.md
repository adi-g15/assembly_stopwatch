# Assembly StopWatch

World's fastest stopwatch... maybe not ;D. It's a stopwatch written in assembly, using sys calls for the sleeping part and printing on screen

> Note: It isn't accurate since in each loop it also calls a `update_display`, which takes a lot of time, though for this fun activity i believe it's okay to ignore this now

## Usage

First, you need `nasm`, it will be available in package managers of all major linux distros

Now, **either run `./build_n_run.sh`** or do these steps manually:

Secondly, compile the .asm files using the nasm assembler,
```sh
nasm main.asm -o main.o -f elf32
nasm tui_interface.asm -o tui.o -f elf32
nasm core_logic.asm -o core.o -f elf32
```

Third, link the object files with `ld` or `gcc`,
```sh
ld *.o -m elf_i386 -o stopwatch
```

Now your executable will be `stopwatch`... run it :D

> The number of hours, minutes, seconds are stored in eax, ebx, ecx respectively... for now you will have to change those manually if you want, then compile main.asm again, and the ld step :)

## Dhanyawaad

Unlicense License as always :heart:

