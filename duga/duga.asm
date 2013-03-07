		BITS 32

lines		equ	5
columns		equ	6
chars		equ	11
term_clr_size	equ	7
data_size	equ	lines * (columns*chars+6)

		org	0x08048000
ehdr:		db      0x7F, "ELF", 1, 1, 1, 0	; e_ident
		dd      0
		dd      0
		dw      2			; e_type
		dw      3			; e_machine
		dd      1			; e_version
		dd      _start			; e_entry
		dd      phdr - $$		; e_phoff
		dd      0			; e_shoff
		dd      0			; e_flags
		dw      ehdrsize		; e_ehsize
		dw      phdrsize		; e_phentsize
phdr:		dw      1			; e_phnum	; p_type
		dw      0			; e_shentsize
		dw      0			; e_shnum	; p_offset
		dw      0			; e_shstrndx
ehdrsize	equ	$ - ehdr
		dd	$$			; p_vaddr
		dd      $$			; p_paddr
		dd      filesize		; p_filesz
		dd      filesize + data_size	; p_memsz
		dd      7			; p_flags ; RW (5 = R)
		dd      0x1000			; p_align
phdrsize	equ     $ - phdr
		
_start		push	48
main_loop	mov	ebp, lines-1
		mov 	edi, datasection
		xor	ecx, ecx

next_line	mov	cx, (chars-1)*5
		mov	[edi], byte 27
		inc	edi
		mov	[edi], byte 91
		inc	edi
		mov	[edi], byte 51
		inc	edi
		pop	edx
		inc	edx
		cmp	edx, 55
		jbe	skip_reset
		mov	edx, 49
skip_reset	mov	[edi], dl
		push	edx
		inc	edi
		mov	[edi], byte 109
		inc	edi

load_line	mov	dl, columns-1
		xor	ebx, ebx
		mov	ebx, [slova+ebp+ecx]
		
x_loop		mov	al, " "
		shr	ebx, 1
		jnc	space
		mov	al, "#"
space		mov	[edi], al
		inc	edi
		sub	dl, 1
		jnc	x_loop

		sub	cx, 5
		jnc	load_line

		mov	[edi], byte 10
		inc 	edi
		sub	ebp, 1
		jnc	next_line
		
		xor	eax,eax	
		mov	al,4
		xor	ebx,ebx
		inc	ebx
		mov	ecx,term_clr

		mov	edx,data_size + term_clr_size
		int	0x80

		xor	eax,eax	
		mov	al,162
		mov	ebx,nano_t
		xor	ecx,ecx
		int	0x80
		
		jmp	main_loop


slova		db	00010001b
		db	00010001b
		db	00011111b
		db	00010001b
		db	01001110b

		db	00010001b
		db	00001001b
		db	00001111b
		db	00010001b
		db	00001111b
		
		db	00001110b
		db	00010001b
		db	00010001b
		db	00010001b
		db	00010001b

		db	00000100b
		db	00000100b
		db	00000100b
		db	00000100b
		db	00011111b

		db	00010001b
		db	00001001b
		db	00000111b
		db	00001001b
		db	00010001b

		db	00011111b
		db	00000001b
		db	00000111b
		db	00000001b
		db	00011111b

		db	00000100b
		db	00000100b
		db	00000100b
		db	00000100b
		db	00011111b

		db	00001110b
		db	00000100b
		db	00000100b
		db	00000100b
		db	00001110b

		db	00010001b
		db	00010001b
		db	00011111b
		db	00010001b
		db	00010001b

		db	00010001b
		db	00001001b
		db	00001111b
		db	00010001b
		db	00001111b

		db	00010001b
		db	00010001b
		db	00011111b
		db	00010001b
		db	00001110b

nano_t		dd	0,70000000

term_clr	db	27,91,50,74,27,91, 72

datasection:

filesize	equ     $ - $$

