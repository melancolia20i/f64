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

objs = f64.o caller.o
final = f64

all: $(final)

$(final): $(objs)
	ld	-o $(final) $(objs)
%.o: %.asm
	as	-c $< -o $@
clean:
	rm	-rf $(objs) $(final)
