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

.section .text

.globl f64
f64:
	pushq	%rbp
	movq	%rsp, %rbp
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
.f64_loop:
	movq	-16(%rbp), %rax
	movzbl	(%rax), %edi
	cmpb	$0, %dil
	je	.f64_fini

.f64_resume:
	incq	-16(%rbp)
	jmp	.f64_loop
.f64_fini:
	PUT_BACK_REG_N
	movq	-120(%rbp), %rax
	leave
	ret
