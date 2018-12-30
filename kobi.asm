extern printf
global GoToXY:function, ClearScreen:function
global WriteString:function, StrLength:function

segment .data
ESC				equ 27
sys_write		equ 4
sys_stdout		equ 1

;--------------------------------------------------------
GoToXY:
;
; Put the cursor at X, Y.
; Receives: DH = screen row, DL = screen column
;--------------------------------------------------------
segment .data
locateStr db ESC, "[%d;%dH", 0

segment .text
	push eax

	movzx eax,dl
	push eax
	movzx eax,dh
	push eax
	push DWORD locateStr
	call printf          ; call the libc function printf
	add esp, 12          ; align the stack after printf

	pop eax
	ret

;-----------------------------------------------------
ClearScreen:
;
; First, write the control characters to stdout to clear the screen.
; Then move the cursor to 0,0 on the screen.
;-----------------------------------------------------
segment .data
clrStr	db ESC, "[2J", 0

segment .text
	push edx
	mov edx, clrStr
	call WriteString	; clear the screen by escape code sequance
	
	xor edx, edx
	call GoToXY
	pop edx

	ret

;--------------------------------------------------------
WriteString:
; Writes a null-terminated string to standard output. 
; Receives: An offset to the string.
;--------------------------------------------------------
	push ebp
	mov ebp, esp
	pushad

	mov edx, [ebp + 8] ; offset of string in memory

	push edx
	call StrLength

	mov ecx, edx
	mov edx, eax
	mov ebx, sys_stdout 
	mov eax, sys_write 
	int 80h

	popad
	pop ebp
	ret 4

;---------------------------------------------------------
StrLength:
;
; Return the length of a null-terminated string.
; Receives: pointer to a string
; Returns: EAX = string length
;---------------------------------------------------------
	push ebp
	mov ebp, esp
	push edi

	mov edi, [ebp + 8]
	mov eax, 0     	    ; character count
.L1:
	cmp byte [edi], 0	; end of string?
	je  .L2	; yes: quit
	inc edi	; no: point to next
	inc eax	; add 1 to count
	jmp .L1
.L2:	
	pop edi
	pop ebp

	ret 4
