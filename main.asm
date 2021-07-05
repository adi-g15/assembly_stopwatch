global .main

.main:
	; this is the start, apun ka stopwatch ka :D

	mov eax, 0	; number of hours
	mov ebx, 1	; number of minutes
	mov ecx, 5	; number of seconds


	; TODO: here there should be a while loop, for the hours, minutes, seconds
	call sleep_for


	mov ebx, 0
	mov eax, 1;	; TODO: Put in the code for sys_exit call
	int 080		; TODO: Verify system call interrupt code

