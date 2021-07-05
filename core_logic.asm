global sleep_for

extern update_display

; expects eax stores hours, ebx stores minutes, ecx stores seconds
sleep_for:
	; TODO: Logic, likely a for/while loop
waiting_loop:
	dec ecx		; decrement ecx

	call update_display

	cmp ecx, 0
	jg waiting_loop	; if num_seconds > 0, loop again
	jmp done_waiting

done_waiting:
	;
