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

# f64 main function
# args  : file descriptor (rdi)
#         format          (rsi)
#         arg1            (rdx)
#         arg2            (rcx)
#         arg3            (r8 )
#         arg4            (r9 )
# return: total number of bytes written (into rax)
.globl f64
f64:
	pushq	%rbp
	movq	%rsp, %rbp


	leave
	ret
