.section .data
.section .text
.globl main

main:
	movl	$10,	%ecx
	xor 	%eax,	%eax
ponovi: addl	%ecx,	%eax
	decl	%ecx
	jnz ponovi
kraj:	movl	1,	%eax
	int	$0x80
