global sleep_for

extern update_display

section .data
	timeval:
		tv_sec	dd 0
		tv_usec	dd 0

; expects eax stores hours, ebx stores minutes, ecx stores seconds
sleep_for:
	; NOTE: edx is also modified by mul and div instructions, storing higher half of result of mul, and remainder of div
	mov edx, 3600
	mul edx		; eax *= 3600
	add ecx, eax

	mov eax, ebx
	mov edx, 60
	mul edx			; eax is storing value of ebx here, edx is 60
	add ecx, eax

	mov edx, ecx	; NOTE: eax, ebx, and ecx will be overwritten by sleep_for_1_sec_linux call

waiting_loop:
	dec edx		; decrement ecx

	call update_display
	;call sleep_for_1_sec	; seg fault at int 15G
	call sleep_for_1_sec_linux

	cmp edx, 0
	jg waiting_loop	; if num_seconds > 0, loop again

	ret

sleep_for_1_sec_linux:
	; https://stackoverflow.com/a/19580595/12339402 ->  sys_nanosleep : eax = 162, ebx = struct timespec *, ecx = struct timespec *

	mov eax, 162	; nanosleep system call
	mov dword [tv_sec], 1	; 1 second
	mov ebx, timeval
	mov ecx, 0	; nullptr
	int 0x80
	ret

sleep_for_1_sec:
	mov cx, 0FH
	mov dx, 4240H
	mov ax, 86H
	int 15H
	ret
