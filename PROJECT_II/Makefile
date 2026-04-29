EXECUTABLE=sum_program
 
all:
	nasm -f elf64 sum_program.asm -o sum_program.o -l sum_program.lst
	gcc -m64 -no-pie sum_program.o -o $(EXECUTABLE)
	./$(EXECUTABLE)
 
test:
	nasm -f elf64 adder.asm -o adder.o
	gcc -m64 -c test_adder.c
	gcc -m64 -no-pie test_adder.o adder.o -o test_program
	./test_program
 

clean:
	rm -rf *.o *.lst $(EXECUTABLE) test_program
 