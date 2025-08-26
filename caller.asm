# ███████╗ ██████╗ ██╗  ██╗
# ██╔════╝██╔════╝ ██║  ██║
# █████╗  ███████╗ ███████║
# ██╔══╝  ██╔═══██╗╚════██║
# ██║     ╚██████╔╝     ██║
# ╚═╝      ╚═════╝      ╚═╝
#
# tiny fprintf function for x86_64 assembly language
# written in x86_64.
#
# contribuite to f64: https://github.com/melancolia20i/f64
#
# 'f64.asm' file is under MIT LINCESE
#

.section .rodata
	.msg: .string "%x\n"

.section .text

.globl _start

_start:
	movq	$1, %rdi
	leaq	.msg(%rip), %rsi
	call	f64

	movq	%rax, %rdi
	movq	$60, %rax
	syscall
