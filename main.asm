global _start

section .data
	success_msg db "Time Up !", 0x0a	; 0x0a is the '\n' at end, ie. 10 in decimal
	error_msg db "Some error occured", 0x0a
	s_msg_len equ $ - success_msg			; TODO: Will it work ? It should not i think, since $ is current location i guess
	err_msg_len $ - error_msg

section .text
_start:		; changed label from main to _start
	; this is the start, apun ka stopwatch ka :D

	mov eax, 0	; number of hours
	mov ebx, 1	; number of minutes
	mov ecx, 5	; number of seconds


	; TODO: here there should be a while loop, for the hours, minutes, seconds
	; while ecx != 0; sub ecx, 1
	call sleep_for	; sets 'edx' as its return value
	
	; Check if sleep_for successful or not
	cmp edx, 0
	jne errored
	; else continue
	jmp success

success:
	; A "done" message
	mov eax, 4	; will do a sys_write
	mov ebx, 1	; to stdout (fd, file descriptor)
	mov ecx, success_msg	; now, the third param to interrupt is the string pointer
	mov edx, s_msg_len	; the fourth param, is the string length

	int 0x80	; interrupt handler for system call
	jmp exit

errored:
	mov eax, 4
	mov ebx, 2	; TODO: Verify if 2 is the file descriptor for std_err
	mov ecx, error_msg
	mov edx, err_msg_len

	int 0x80
	jmp exit

exit:
	mov eax, 1;	; code for sys_exit call
	mov ebx, 0
	int 0x80

