global .sleep_for

.sleep_for:
	mov ebp, esp	; Save esp


	; TODO: Logic, likely a for/while loop
	call update_display
	

	mov esp, ebp
	ret

