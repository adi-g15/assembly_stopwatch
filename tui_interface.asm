global update_display

section .bss	; uninitialised mem
	buffer: resb 5		; reserve 5 bytes; NASM syntax

section .data
	time_left_msg db 0x0d, "Samay samapti me samay: "	; 13 (0x0d) is ASCII for '\r'
	time_left_len equ $ - time_left_msg
	newline_str db 0x0a	; '\n' in ASCII is 10 (0x0a)
	hr_msg db " hr "
	hr_msg_len equ $ - hr_msg
	min_msg db " min "
	min_msg_len equ $ - min_msg
	sec_msg db " sec "
	sec_msg_len equ $ - sec_msg
	;buffer_cap equ 5-0	; ERROR: Causes seg fault
	;buffer_cap dd 5		; db - byte, dw -> 2 byte, dd -> 4 byte

section .text
; Input -> eax - Number of seconds
update_display:
	push eax	; store eax's old value on stack
	push eax	; push number of seconds on stack

	mov eax, time_left_msg
	mov ebx, time_left_len
	call print_string

	xor edx, edx	; ensure edx = 0
	pop eax
	mov ebx, 3600	; NOTE: @BLUNDER - Saving constant into edx then passing edx to div, causes Arithmetic Exception
	div ebx		; eax / 3600 gives number of hours
	push edx	; push remainder onto stack
	call print_number

	mov eax, hr_msg
	mov ebx, hr_msg_len
	call print_string

	xor edx, edx
	pop eax
	mov ebx, 60
	div ebx		; eax / 60 gives number of minutes left
	push edx
	call print_number

	mov eax, min_msg
	mov ebx, min_msg_len
	call print_string

	pop eax		; has number of seconds left
	call print_number

	mov eax, sec_msg
	mov ebx, sec_msg_len
	call print_string

	jmp .prologue

.print_newline:
	mov eax, 4
	mov ebx, 1
	mov ecx, newline_str
	mov edx, 1
	int 0x80

.prologue:
	pop eax		; Restore eax

	ret

; Input -> eax - Pointer to string
;	-> ebx - Length of string
print_string:
	push eax	; Push string to stack
	push ebx	; the length

	mov eax, 4
	mov ebx, 1
	pop edx		; top of stack is length
	pop ecx

	int 0x80	; perform the system call

	ret

; Input -> eax - Number
print_number:
	; Expects argument in eax

	push eax	; TODO: REMOVE
	mov esi, buffer

	call num_to_string

	mov ecx, buffer	; TODO: REMOVE
	sub ecx, eax	; TODO: REMOVE

	call print_string

	pop eax	; TODO: REMOVE

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
	; NOTE: @Mistake - I tried to not just copy, and according to my knowledge, edx me remainder hota tha, but this will give wrong output for multi-digit number, maybe because it's 4 bit, so using 'dl' register instead (i checked in gdb, it's same value, though maybe in 1 byte)
	add dl, '0'
	;add edx, '0'	; digit -> ASCII
	dec esi
	mov [esi], dl
	;mov [esi], edx

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
