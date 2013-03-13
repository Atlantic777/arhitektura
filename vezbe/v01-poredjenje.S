.section .data
.section .text
.globl main

main:
	movl	$5,	%ebx
	movl	$5,	%ecx
	subl	%ebx,	%ecx
	jz	jednako
	jnc	vece
	jc	manje

jednako:
	xor	%eax, %eax
	jmp	kraj

vece:	movl	$2,	%eax
	jmp	kraj

manje:	movl	$1,	%eax
	jmp	kraj


kraj:	movl	$1,	%eax
	int	$0x80
