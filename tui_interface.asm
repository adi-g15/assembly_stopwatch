global update_display

section .bss	; uninitialised mem
	buffer: resb 5		; reserve 5 bytes; NASM syntax

section .data
	time_left_msg db 0x0f, "Samay samapti me samay: "	; 13 (0x0d) is ASCII for '\r'
	time_left_len equ $ - time_left_msg
	;buffer_cap equ 5-0	; ERROR: Causes seg fault
	;buffer_cap dd 5		; db - byte, dw -> 2 byte, dd -> 4 byte

section .text
update_display:
	; edx contains the number of seconds left

	mov eax, edx
	call print_number

	ret

print_number:
	; Expects argument in eax

	mov esi, buffer
	call num_to_string
	
	push eax	; push pointer to string
	push ebx	; push length of string

	mov eax, 4
	mov ebx, 1
	mov ecx, time_left_msg
	mov edx, time_left_len
	int 0x80

.newline:
	; replace '\0' with '\n' to have the newline; didn't do in num_to_string to let it be generic
	mov [buffer+4], byte 0x0a ; TODO: To make it adapt to buffer size, instead of 4, use buffer_cap-1

	mov eax, 4
	mov ebx, 1
	pop edx
	pop ecx

	int 0x80
	
	mov eax, 1
	mov ebx, 0
	int 0x80

	ret

; https://stackoverflow.com/a/25065047/12339402
;
; Supporting max 5 digit number, and using 'compile time variable' buffer length
;
; Input : eax -> value
;	: esi -> pointer to start location in buffer
; Output: eax -> pointer to start of number in string
;	  ebx -> length of resulting string
num_to_string:
	;add esi, buffer_cap
	add esi, 5
	dec esi			; go to end of buffer (buff_cap-1)

	mov byte [esi], 0	; '\0'

	push ecx	; save ecx
	push edx	; save edx

	mov ebx, 10	; storing 10 for use with mul and div
.next_digit:	; LEARNT: NASM treats labels starting with '.' as local labels, ie. associated with previous non-local label
	; https://www.felixcloutier.com/x86/div -> Info on div instruction
	xor edx, edx	; edx = 0, as div will use edx:eax as dividend

	div ebx		; eax /= 10
	; print edx
	add edx, '0'	; digit -> ASCII
	dec esi
	mov [esi], edx

	test eax, eax	; sets zf (short for zero flag, a 1 bit flag) =1 (true if eax==0), else 0 (ie. eax!=0)
	jnz .next_digit	; loop again if "not zero"

	mov eax, esi	; store esi in eax, since that's the output

	; finding length of string... or simpler, do it by updating a counter in the loop, i am leaving the Complex one it reminds i tried to find some other way
	mov ebx, eax
	sub ebx, buffer	; effectively, start_ptr_of_result - ptr_to_0th_element, ie. it gives us the index
	mov ecx, 5	; TODO: replace with buffer_cap
	sub ecx, ebx	; size_of_buffer - start_index = length_of_string_returned

	mov ebx, ecx	; store length in ebx

	pop edx		; restore edx
	pop ecx		; restore ecx

	ret

__print_digit:	; obsolete and maybe wrong attempt :)
	push eax	; save eax

	mov eax, 4	; sys_write
	mov ebx, 1
	mov ecx, edx	; store the digit
	add ecx, 48
	mov edx, 1
	int 0x80

	pop eax
	ret
