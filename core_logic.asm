global sleep_for

extern update_display

section .data
	timeval:
		tv_sec	dd 0
		tv_usec	dd 0

; Input -> eax - stores hours
;	-> ebx - stores minutes
;	-> ecx - stores seconds
section .text
sleep_for:
	; NOTE: edx is also modified by mul and div instructions, storing higher half of result of mul, and remainder of div
	push ecx	; Push seconds onto stack for now
	mov ecx, 3600
	mul ecx		; eax *= 3600
	; eax has hours * 3600

	pop ecx
	add ecx, eax
	push ecx	; Push again, since i am using that to store the constant

	mov eax, ebx
	mov ecx, 60
	mul ecx		; eax is storing value of ebx here, edx is 60
	; eax has minutes * 60

	pop ecx
	add eax, ecx	; add eax and earlier stored ecx

.waiting_loop:
	call update_display

	dec eax		; decrement eax

	;call sleep_for_1_sec	; seg fault at int 15G
	call sleep_for_1_sec_linux

	cmp eax, 0
	jg .waiting_loop	; if num_seconds > 0, loop again

	ret

sleep_for_1_sec_linux:
	; https://stackoverflow.com/a/19580595/12339402 ->  sys_nanosleep : eax = 162, ebx = struct timespec *, ecx = struct timespec *

	push eax	; Store eax

	mov eax, 162	; nanosleep system call
	mov dword [tv_sec], 1	; 1 second
	mov ebx, timeval
	mov ecx, 0	; nullptr
	int 0x80

	pop eax		; Restore eax

	ret

sleep_for_1_sec:
	mov cx, 0FH
	mov dx, 4240H
	mov ax, 86H
	int 15H
	ret
