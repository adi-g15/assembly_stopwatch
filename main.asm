global _start

extern sleep_for

section .data
	done_msg db 0x0a, "Time Up !", 0x0a	; 0x0a is '\n', ie. 10 in decimal
	s_msg_len equ $ - done_msg		; Subtracting 'start of string (done_msg)' from 'location after (setting the) string'

section .text
_start:
	; this is the start, is stopwatch ka :D

	; For now, you have to change these manually :')
	mov eax, 0	; number of hours
	mov ebx, 0	; number of minutes
	mov ecx, 5	; number of seconds

	call sleep_for
	
.done:
	; A "done" message
	mov eax, 4	; will do a sys_write
	mov ebx, 1	; to stdout (fd, file descriptor)
	mov ecx, done_msg	; now, the third param to interrupt is the string pointer
	mov edx, s_msg_len	; the fourth param, is the string length

	int 0x80	; interrupt handler for system call

.exit:
	mov eax, 1	; code for sys_exit call
	mov ebx, 0
	int 0x80

