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
# this file is under MIT LINCESE
#

.section .rodata
	.fatal_1_msg: .string "f64: unknown format!\n"
	.fatal_1_len: .quad   21

	.buffersz: .quad 2048

.section .bss
	.buffer: .zero 2048

.section .text

.macro SAVE_REG_N
	movq	%r8 , -64(%rbp)
	movq	%r9 , -72(%rbp)
	movq	%r10, -80(%rbp)
	movq	%r11, -88(%rbp)
	movq	%r12, -96(%rbp)
	movq	%r13, -96(%rbp)
	movq	%r14, -104(%rbp)
	movq	%r15, -112(%rbp)
.endm

.macro PUT_BACK_REG_N
	movq	-64(%rbp),  %r8 
	movq	-72(%rbp),  %r9
	movq	-80(%rbp),  %r10
	movq	-88(%rbp),  %r11
	movq	-96(%rbp),  %r12
	movq	-96(%rbp),  %r13
	movq	-104(%rbp), %r14
	movq	-112(%rbp), %r15
.endm

.macro PUTS
	movq	$1, %rax
	movq	-8(%rbp), %rdi
	movq	%r9, %rdx
	leaq	.buffer(%rip), %rsi
	syscall
.endm

.macro FATAL fnl, fnm
	movq	$1, %rax
	movq	$2, %rdi
	movq	\fnl, %rdx
	leaq	\fnm, %rsi
	syscall
	movq	$60, %rax
	movq	$-1, %rdi
	syscall
.endm

.globl f64
f64:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$120, %rsp
	# stack distribution
	# -8         : file descriptor
	# -16        : format string
	# -32        : arg1
	# -40        : arg2
	# -48        : arg3
	# -56        : arg4
	# [-64, -112]: [r8, ..., r15]
	# -120       : number of bytes written so far
	movq	%rdi, -8(%rbp)
	movq	%rsi, -16(%rbp)
	movq	%rdx, -24(%rbp)
	movq	%rcx, -32(%rbp)
	movq	%r8,  -40(%rbp)
	movq	%r9,  -56(%rbp)
	SAVE_REG_N	
	movq	$0, -120(%rbp)
	# in order to make f64 faster we're going to use
	# a register to track the buffer
	# r8: buffer itself
	# r9: position within buffer (differs from -120 since r9 can be set to zero if the buffer needs to be flushed)
	leaq	.buffer(%rip), %r8
	movq	$0, %r9
.f64_loop:
	cmpq	%r9, (.buffersz)
	je	.f64_need_to_flush
	movq	-16(%rbp), %rax
	movzbl	(%rax), %edi
	cmpb	$0, %dil
	je	.f64_fini
	cmpb	$'%', %dil
	je	.f64_format_found
	movb	%dil, (%r8)
	incq	%r8
	incq	%r9
	incq	-120(%rbp)
	jmp	.f64_resume
.f64_format_found:
	incq	-16(%rbp)
	movq	-16(%rbp), %rax
	movzbl	(%rax), %edi
	cmpb	$'%', %dil
	je	.f64_fmt_per
	# XXX: formsta go here
	jmp	.f64_fatal_unknown_format
.f64_fmt_per:
	movb	%dil, (%r8)
	incq	%r8
	incq	%r9
	incq	-120(%rbp)
	jmp	.f64_resume


.f64_resume:
	incq	-16(%rbp)
	jmp	.f64_loop
.f64_need_to_flush:
	# prints the content of the buffer at this point
	# and sets r8 and r9 back to the begining of the
	# buffer
	PUTS
	xorq	%r9, %r9
	leaq	.buffer(%rip), %r8
	jmp	.f64_loop
.f64_fini:
	PUTS
	PUT_BACK_REG_N
	movq	-120(%rbp), %rax
	leave
	ret
.f64_fatal_unknown_format:
	FATAL	.fatal_1_len(%rip), .fatal_1_msg(%rip)
