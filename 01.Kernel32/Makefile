all: Kenel32.bin

Kenel32.bin: Source/EntryPoint.s
	nasm -o Kernel32.bin $<

clean:
	rm -f Kernel32.bin