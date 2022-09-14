CC=gcc
CFLAGS=
#SYMBOLS_TABLE_DIR=symbols_table
SYNTACTIC_DIR=syntactic
ERROR_DIR=errors
#CODE_GENERATION_DIR=code_generation


# src directory structure
SRC_DIR=src
SYMBOLS_TABLE_DIR=$(SRC_DIR)/symbols_table
CODE_GENERATION_DIR=$(SRC_DIR)/code_generation
COMPILER_DIR=$(SRC_DIR)/compiler

# test directory structure
TEST_DIR=tests
BASIC_TESTS_DIR=$(TEST_DIR)/basic
EXTRA_TESTS_DIR=$(TEST_DIR)/extra
ERROR_TESTS_DIR=$(TEST_DIR)/errors

ALFA=alfa
ASM=asm
EXEC=exec
OBJ=obj

ALFA_BASIC_DIR=$(BASIC_TESTS_DIR)/$(ALFA)
ASM_BASIC_DIR=$(BASIC_TESTS_DIR)/$(ASM)
EXEC_BASIC_DIR=$(BASIC_TESTS_DIR)/$(EXEC)
OBJ_BASIC_DIR=$(BASIC_TESTS_DIR)/$(OBJ)

ALFA_EXTRA_DIR=$(EXTRA_TESTS_DIR)/$(ALFA)
ASM_EXTRA_DIR=$(EXTRA_TESTS_DIR)/$(ASM)
EXEC_EXTRA_DIR=$(EXTRA_TESTS_DIR)/$(EXEC)
OBJ_EXTRA_DIR=$(EXTRA_TESTS_DIR)/$(OBJ)

ALFA_ERROR_DIR=$(ERROR_TESTS_DIR)/$(ALFA)
ASM_ERROR_DIR=$(ERROR_TESTS_DIR)/$(ASM)
EXEC_ERROR_DIR=$(ERROR_TESTS_DIR)/$(EXEC)
OBJ_ERROR_DIR=$(ERROR_TESTS_DIR)/$(OBJ)

%.c: %.y
%.c: %.l


###########################################################
################### COMPILER GENERATION ###################
###########################################################
compiler: $(SRC_DIR)/alfa

$(SRC_DIR)/alfa: $(COMPILER_DIR)/y.tab.o $(COMPILER_DIR)/lex.yy.o $(COMPILER_DIR)/symbols_table.o $(COMPILER_DIR)/generacion.o $(COMPILER_DIR)/alfa.o
	$(CC) $(CFLAGS) $^ -o $@


$(COMPILER_DIR)/y.tab.o: $(COMPILER_DIR)/y.tab.c
	$(CC) $(CFLAGS) -c $< -o $@

$(COMPILER_DIR)/y.tab.c: $(COMPILER_DIR)/alfa.y
	bison -d -y -v --report=all $^ -o $(COMPILER_DIR)/y.tab.c

$(COMPILER_DIR)/lex.yy.o: $(COMPILER_DIR)/lex.yy.c
	$(CC) $(CFLAGS) -c $^ -o $@

$(COMPILER_DIR)/lex.yy.c: $(COMPILER_DIR)/alfa.l $(COMPILER_DIR)/y.tab.h
	flex -o $(COMPILER_DIR)/lex.yy.c $< 

$(COMPILER_DIR)/y.tab.h: $(COMPILER_DIR)/alfa.y
	bison -d -y -v --report=all $^ -o $(COMPILER_DIR)/y.tab.c

$(COMPILER_DIR)/symbols_table.o: $(SYMBOLS_TABLE_DIR)/symbols_table.c
	$(CC) $(CFLAGS) -c $^ -o $@

$(COMPILER_DIR)/generacion.o: $(CODE_GENERATION_DIR)/generacion.c
	$(CC) $(CFLAGS) -c $^ -o $@

$(COMPILER_DIR)/alfa.o: $(COMPILER_DIR)/alfa.c
	$(CC) $(CFLAGS) -c $^ -o $@
















###########################################################
######################### TESTS ###########################
###########################################################


###################### BASIC TESTS ########################

funciones:
	$(SRC_DIR)/alfa $(ALFA_BASIC_DIR)/funciones.alfa $(ASM_BASIC_DIR)/funciones.asm
	nasm -g -o $(OBJ_BASIC_DIR)/funciones.o -f elf32 $(ASM_BASIC_DIR)/funciones.asm
	gcc -Wall -g -m32 -o $(EXEC_BASIC_DIR)/funciones $(OBJ_BASIC_DIR)/funciones.o $(OBJ_BASIC_DIR)/alfalib.o
	./$(EXEC_BASIC_DIR)/funciones

condicionales:
	$(SRC_DIR)/alfa $(ALFA_BASIC_DIR)/condicionales.alfa $(ASM_BASIC_DIR)/condicionales.asm
	nasm -g -o $(OBJ_BASIC_DIR)/condicionales.o -f elf32 $(ASM_BASIC_DIR)/condicionales.asm
	gcc -Wall -g -m32 -o $(EXEC_BASIC_DIR)/condicionales $(OBJ_BASIC_DIR)/condicionales.o $(OBJ_BASIC_DIR)/alfalib.o
	./$(EXEC_BASIC_DIR)/condicionales

fibonacci:
	$(SRC_DIR)/alfa $(ALFA_BASIC_DIR)/fibonacci.alfa $(ASM_BASIC_DIR)/fibonacci.asm
	nasm -g -o $(OBJ_BASIC_DIR)/fibonacci.o -f elf32 $(ASM_BASIC_DIR)/fibonacci.asm
	gcc -Wall -g -m32 -o $(EXEC_BASIC_DIR)/fibonacci $(OBJ_BASIC_DIR)/fibonacci.o $(OBJ_BASIC_DIR)/alfalib.o
	./$(EXEC_BASIC_DIR)/fibonacci

factorial:
	$(SRC_DIR)/alfa $(ALFA_BASIC_DIR)/factorial.alfa $(ASM_BASIC_DIR)/factorial.asm
	nasm -g -o $(OBJ_BASIC_DIR)/factorial.o -f elf32 $(ASM_BASIC_DIR)/factorial.asm
	gcc -Wall -g -m32 -o $(EXEC_BASIC_DIR)/factorial $(OBJ_BASIC_DIR)/factorial.o $(OBJ_BASIC_DIR)/alfalib.o
	./$(EXEC_BASIC_DIR)/factorial

funciones_vectores:
	$(SRC_DIR)/alfa $(ALFA_BASIC_DIR)/funciones_vectores.alfa $(ASM_BASIC_DIR)/funciones_vectores.asm
	nasm -g -o $(OBJ_BASIC_DIR)/funciones_vectores.o -f elf32 $(ASM_BASIC_DIR)/funciones_vectores.asm
	gcc -Wall -g -m32 -o $(EXEC_BASIC_DIR)/funciones_vectores $(OBJ_BASIC_DIR)/funciones_vectores.o $(OBJ_BASIC_DIR)/alfalib.o
	./$(EXEC_BASIC_DIR)/funciones_vectores

guion:
	$(SRC_DIR)/alfa $(ALFA_BASIC_DIR)/guion.alfa $(ASM_BASIC_DIR)/guion.asm
	nasm -g -o $(OBJ_BASIC_DIR)/guion.o -f elf32 $(ASM_BASIC_DIR)/guion.asm
	gcc -Wall -g -m32 -o $(EXEC_BASIC_DIR)/guion $(OBJ_BASIC_DIR)/guion.o $(OBJ_BASIC_DIR)/alfalib.o
	./$(EXEC_BASIC_DIR)/guion

arithmetic:
	$(SRC_DIR)/alfa $(ALFA_BASIC_DIR)/arithmetic.alfa $(ASM_BASIC_DIR)/arithmetic.asm
	nasm -g -o $(OBJ_BASIC_DIR)/arithmetic.o -f elf32 $(ASM_BASIC_DIR)/arithmetic.asm
	gcc -Wall -g -m32 -o $(EXEC_BASIC_DIR)/arithmetic $(OBJ_BASIC_DIR)/arithmetic.o $(OBJ_BASIC_DIR)/alfalib.o
	./$(EXEC_BASIC_DIR)/arithmetic

logic:
	$(SRC_DIR)/alfa $(ALFA_BASIC_DIR)/logic.alfa $(ASM_BASIC_DIR)/logic.asm
	nasm -g -o $(OBJ_BASIC_DIR)/logic.o -f elf32 $(ASM_BASIC_DIR)/logic.asm
	gcc -Wall -g -m32 -o $(EXEC_BASIC_DIR)/logic $(OBJ_BASIC_DIR)/logic.o $(OBJ_BASIC_DIR)/alfalib.o
	./$(EXEC_BASIC_DIR)/logic


###################### EXTRA TESTS ########################

ex1:
	$(SRC_DIR)/alfa $(ALFA_EXTRA_DIR)/ex1.alfa $(ASM_EXTRA_DIR)/ex1.asm
	nasm -g -o $(OBJ_EXTRA_DIR)/ex1.o -f elf32 $(ASM_EXTRA_DIR)/ex1.asm
	gcc -Wall -g -m32 -o $(EXEC_EXTRA_DIR)/ex1 $(OBJ_EXTRA_DIR)/ex1.o $(OBJ_EXTRA_DIR)/alfalib.o
	./$(EXEC_EXTRA_DIR)/ex1

ex2:
	$(SRC_DIR)/alfa $(ALFA_EXTRA_DIR)/ex2.alfa $(ASM_EXTRA_DIR)/ex2.asm
	nasm -g -o $(OBJ_EXTRA_DIR)/ex2.o -f elf32 $(ASM_EXTRA_DIR)/ex2.asm
	gcc -Wall -g -m32 -o $(EXEC_EXTRA_DIR)/ex2 $(OBJ_EXTRA_DIR)/ex2.o $(OBJ_EXTRA_DIR)/alfalib.o
	./$(EXEC_EXTRA_DIR)/ex2

ex3:
	$(SRC_DIR)/alfa $(ALFA_EXTRA_DIR)/ex3.alfa $(ASM_EXTRA_DIR)/ex3.asm
	nasm -g -o $(OBJ_EXTRA_DIR)/ex3.o -f elf32 $(ASM_EXTRA_DIR)/ex3.asm
	gcc -Wall -g -m32 -o $(EXEC_EXTRA_DIR)/ex3 $(OBJ_EXTRA_DIR)/ex3.o $(OBJ_EXTRA_DIR)/alfalib.o
	./$(EXEC_EXTRA_DIR)/ex3

ex4:
	$(SRC_DIR)/alfa $(ALFA_EXTRA_DIR)/ex4.alfa $(ASM_EXTRA_DIR)/ex4.asm
	nasm -g -o $(OBJ_EXTRA_DIR)/ex4.o -f elf32 $(ASM_EXTRA_DIR)/ex4.asm
	gcc -Wall -g -m32 -o $(EXEC_EXTRA_DIR)/ex4 $(OBJ_EXTRA_DIR)/ex4.o $(OBJ_EXTRA_DIR)/alfalib.o
	./$(EXEC_EXTRA_DIR)/ex4

ex5:
	$(SRC_DIR)/alfa $(ALFA_EXTRA_DIR)/ex5.alfa $(ASM_EXTRA_DIR)/ex5.asm
	nasm -g -o $(OBJ_EXTRA_DIR)/ex5.o -f elf32 $(ASM_EXTRA_DIR)/ex5.asm
	gcc -Wall -g -m32 -o $(EXEC_EXTRA_DIR)/ex5 $(OBJ_EXTRA_DIR)/ex5.o $(OBJ_EXTRA_DIR)/alfalib.o
	./$(EXEC_EXTRA_DIR)/ex5

ex6:
	$(SRC_DIR)/alfa $(ALFA_EXTRA_DIR)/ex6.alfa $(ASM_EXTRA_DIR)/ex6.asm
	nasm -g -o $(OBJ_EXTRA_DIR)/ex6.o -f elf32 $(ASM_EXTRA_DIR)/ex6.asm
	gcc -Wall -g -m32 -o $(EXEC_EXTRA_DIR)/ex6 $(OBJ_EXTRA_DIR)/ex6.o $(OBJ_EXTRA_DIR)/alfalib.o
	./$(EXEC_EXTRA_DIR)/ex6

ex7:
	$(SRC_DIR)/alfa $(ALFA_EXTRA_DIR)/ex7.alfa $(ASM_EXTRA_DIR)/ex7.asm
	nasm -g -o $(OBJ_EXTRA_DIR)/ex7.o -f elf32 $(ASM_EXTRA_DIR)/ex7.asm
	gcc -Wall -g -m32 -o $(EXEC_EXTRA_DIR)/ex7 $(OBJ_EXTRA_DIR)/ex7.o $(OBJ_EXTRA_DIR)/alfalib.o
	./$(EXEC_EXTRA_DIR)/ex7


ex8:
	$(SRC_DIR)/alfa $(ALFA_EXTRA_DIR)/ex8.alfa $(ASM_EXTRA_DIR)/ex8.asm
	nasm -g -o $(OBJ_EXTRA_DIR)/ex8.o -f elf32 $(ASM_EXTRA_DIR)/ex8.asm
	gcc -Wall -g -m32 -o $(EXEC_EXTRA_DIR)/ex8 $(OBJ_EXTRA_DIR)/ex8.o $(OBJ_EXTRA_DIR)/alfalib.o
	./$(EXEC_EXTRA_DIR)/ex8

ex9:
	$(SRC_DIR)/alfa $(ALFA_EXTRA_DIR)/ex9.alfa $(ASM_EXTRA_DIR)/ex9.asm
	nasm -g -o $(OBJ_EXTRA_DIR)/ex9.o -f elf32 $(ASM_EXTRA_DIR)/ex9.asm
	gcc -Wall -g -m32 -o $(EXEC_EXTRA_DIR)/ex9 $(OBJ_EXTRA_DIR)/ex9.o $(OBJ_EXTRA_DIR)/alfalib.o
	./$(EXEC_EXTRA_DIR)/ex9

ex10:
	$(SRC_DIR)/alfa $(ALFA_EXTRA_DIR)/ex10.alfa $(ASM_EXTRA_DIR)/ex10.asm
	nasm -g -o $(OBJ_EXTRA_DIR)/ex10.o -f elf32 $(ASM_EXTRA_DIR)/ex10.asm
	gcc -Wall -g -m32 -o $(EXEC_EXTRA_DIR)/ex10 $(OBJ_EXTRA_DIR)/ex10.o $(OBJ_EXTRA_DIR)/alfalib.o
	./$(EXEC_EXTRA_DIR)/ex10

ex11:
	$(SRC_DIR)/alfa $(ALFA_EXTRA_DIR)/ex11.alfa $(ASM_EXTRA_DIR)/ex11.asm
	nasm -g -o $(OBJ_EXTRA_DIR)/ex11.o -f elf32 $(ASM_EXTRA_DIR)/ex11.asm
	gcc -Wall -g -m32 -o $(EXEC_EXTRA_DIR)/ex11 $(OBJ_EXTRA_DIR)/ex11.o $(OBJ_EXTRA_DIR)/alfalib.o
	./$(EXEC_EXTRA_DIR)/ex11


################# ERROR MESSAGE TESTS #####################

semantic_error1:
	$(SRC_DIR)/alfa $(ALFA_ERROR_DIR)/semantic_error1.alfa $(ASM_ERROR_DIR)/semantic_error1.asm

semantic_error2:
	$(SRC_DIR)/alfa $(ALFA_ERROR_DIR)/semantic_error2.alfa $(ASM_ERROR_DIR)/semantic_error2.asm

semantic_error3:
	$(SRC_DIR)/alfa $(ALFA_ERROR_DIR)/semantic_error3.alfa $(ASM_ERROR_DIR)/semantic_error3.asm

semantic_error4:
	$(SRC_DIR)/alfa $(ALFA_ERROR_DIR)/semantic_error4.alfa $(ASM_ERROR_DIR)/semantic_error4.asm

semantic_error5:
	$(SRC_DIR)/alfa $(ALFA_ERROR_DIR)/semantic_error5.alfa $(ASM_ERROR_DIR)/semantic_error5.asm

semantic_error6:
	$(SRC_DIR)/alfa $(ALFA_ERROR_DIR)/semantic_error6.alfa $(ASM_ERROR_DIR)/semantic_error6.asm

semantic_error7:
	$(SRC_DIR)/alfa $(ALFA_ERROR_DIR)/semantic_error7.alfa $(ASM_ERROR_DIR)/semantic_error7.asm

semantic_error8:
	$(SRC_DIR)/alfa $(ALFA_ERROR_DIR)/semantic_error8.alfa $(ASM_ERROR_DIR)/semantic_error8.asm

semantic_error9:
	$(SRC_DIR)/alfa $(ALFA_ERROR_DIR)/semantic_error9.alfa $(ASM_ERROR_DIR)/semantic_error9.asm

semantic_error10:
	$(SRC_DIR)/alfa $(ALFA_ERROR_DIR)/semantic_error10.alfa $(ASM_ERROR_DIR)/semantic_error10.asm

semantic_error11:
	$(SRC_DIR)/alfa $(ALFA_ERROR_DIR)/semantic_error11.alfa $(ASM_ERROR_DIR)/semantic_error11.asm

semantic_error12:
	$(SRC_DIR)/alfa $(ALFA_ERROR_DIR)/semantic_error12.alfa $(ASM_ERROR_DIR)/semantic_error12.asm

semantic_error13:
	$(SRC_DIR)/alfa $(ALFA_ERROR_DIR)/semantic_error13.alfa $(ASM_ERROR_DIR)/semantic_error13.asm

semantic_error14:
	$(SRC_DIR)/alfa $(ALFA_ERROR_DIR)/semantic_error14.alfa $(ASM_ERROR_DIR)/semantic_error14.asm

semantic_error15:
	$(SRC_DIR)/alfa $(ALFA_ERROR_DIR)/semantic_error15.alfa $(ASM_ERROR_DIR)/semantic_error15.asm

semantic_error16:
	$(SRC_DIR)/alfa $(ALFA_ERROR_DIR)/semantic_error16.alfa $(ASM_ERROR_DIR)/semantic_error16.asm

runtime_error_div_by_0:
	$(SRC_DIR)/alfa $(ALFA_ERROR_DIR)/runtime_error_div_by_0.alfa $(ASM_ERROR_DIR)/runtime_error_div_by_0.asm

runtime_error_out_of_index_vector:
	$(SRC_DIR)/alfa $(ALFA_ERROR_DIR)/runtime_error_out_of_index_vector.alfa $(ASM_ERROR_DIR)/runtime_error_out_of_index_vector.asm


runtime_error_div_by_0:
	$(SRC_DIR)/alfa $(ALFA_ERROR_DIR)/runtime_error_div_by_0.alfa $(ASM_ERROR_DIR)/runtime_error_div_by_0.asm
	nasm -g -o $(OBJ_ERROR_DIR)/runtime_error_div_by_0.o -f elf32 $(ASM_ERROR_DIR)/runtime_error_div_by_0.asm
	gcc -Wall -g -m32 -o $(EXEC_ERROR_DIR)/runtime_error_div_by_0 $(OBJ_ERROR_DIR)/runtime_error_div_by_0.o $(OBJ_ERROR_DIR)/alfalib.o
	./$(EXEC_ERROR_DIR)/runtime_error_div_by_0	

runtime_error_out_of_index_vector:
	$(SRC_DIR)/alfa $(ALFA_ERROR_DIR)/runtime_error_out_of_index_vector.alfa $(ASM_ERROR_DIR)/runtime_error_out_of_index_vector.asm
	nasm -g -o $(OBJ_ERROR_DIR)/runtime_error_out_of_index_vector.o -f elf32 $(ASM_ERROR_DIR)/runtime_error_out_of_index_vector.asm
	gcc -Wall -g -m32 -o $(EXEC_ERROR_DIR)/runtime_error_out_of_index_vector $(OBJ_ERROR_DIR)/runtime_error_out_of_index_vector.o $(OBJ_ERROR_DIR)/alfalib.o
	./$(EXEC_ERROR_DIR)/runtime_error_out_of_index_vector	



###########################################################
################### CLEANING PROJECT ######################
###########################################################

clean:
	rm -rf $(COMPILER_DIR)/*.o
	rm -rf $(SRC_DIR)/alfa *.gch
	rm -rf output_sin_1.txt output_sin_2.txt output_sin_3.txt output_sin_4.txt output_sin_5.txt
	rm -rf $(COMPILER_DIR)/y.output $(COMPILER_DIR)/y.tab.c $(COMPILER_DIR)/y.tab.h $(COMPILER_DIR)/lex.yy.c

clean_output:
	rm -rf $(SYMBOLS_TABLE_DIR)/mi_salida.txt $(CODE_GENERATION_DIR)/ex1.asm
	rm -rf $(ASM_BASIC_DIR)/condicionales.asm $(EXEC_BASIC_DIR)/condicionales $(OBJ_BASIC_DIR)/condicionales.o
	rm -rf $(ASM_BASIC_DIR)/funciones.asm $(EXEC_BASIC_DIR)/funciones $(OBJ_BASIC_DIR)/funciones.o
	rm -rf $(ASM_BASIC_DIR)/fibonacci.asm $(EXEC_BASIC_DIR)/fibonacci $(OBJ_BASIC_DIR)/fibonacci.o
	rm -rf $(ASM_BASIC_DIR)/factorial.asm $(EXEC_BASIC_DIR)/factorial $(OBJ_BASIC_DIR)/factorial.o
	rm -rf $(ASM_BASIC_DIR)/funciones_vectores.asm $(EXEC_BASIC_DIR)/funciones_vectores $(OBJ_BASIC_DIR)/funciones_vectores.o
	rm -rf $(ASM_BASIC_DIR)/guion.asm $(EXEC_BASIC_DIR)/guion $(OBJ_BASIC_DIR)/guion.o
	rm -rf $(ASM_BASIC_DIR)/arithmetic.asm $(EXEC_BASIC_DIR)/arithmetic $(OBJ_BASIC_DIR)/arithmetic.o
	rm -rf $(ASM_BASIC_DIR)/logic.asm $(EXEC_BASIC_DIR)/logic $(OBJ_BASIC_DIR)/logic.o
	rm -rf $(ASM_EXTRA_DIR)/ex1.asm $(EXEC_EXTRA_DIR)/ex1 $(OBJ_EXTRA_DIR)/ex1.o
	rm -rf $(ASM_EXTRA_DIR)/ex2.asm $(EXEC_EXTRA_DIR)/ex2 $(OBJ_EXTRA_DIR)/ex2.o
	rm -rf $(ASM_EXTRA_DIR)/ex3.asm $(EXEC_EXTRA_DIR)/ex3 $(OBJ_EXTRA_DIR)/ex3.o
	rm -rf $(ASM_EXTRA_DIR)/ex4.asm $(EXEC_EXTRA_DIR)/ex4 $(OBJ_EXTRA_DIR)/ex4.o
	rm -rf $(ASM_EXTRA_DIR)/ex5.asm $(EXEC_EXTRA_DIR)/ex5 $(OBJ_EXTRA_DIR)/ex5.o
	rm -rf $(ASM_EXTRA_DIR)/ex6.asm $(EXEC_EXTRA_DIR)/ex6 $(OBJ_EXTRA_DIR)/ex6.o
	rm -rf $(ASM_EXTRA_DIR)/ex7.asm $(EXEC_EXTRA_DIR)/ex7 $(OBJ_EXTRA_DIR)/ex7.o
	rm -rf $(ASM_EXTRA_DIR)/ex9.asm $(EXEC_EXTRA_DIR)/ex9 $(OBJ_EXTRA_DIR)/ex9.o
	rm -rf $(ASM_EXTRA_DIR)/ex10.asm $(EXEC_EXTRA_DIR)/ex10 $(OBJ_EXTRA_DIR)/ex10.o
	rm -rf $(ASM_EXTRA_DIR)/ex11.asm $(EXEC_EXTRA_DIR)/ex11 $(OBJ_EXTRA_DIR)/ex11.o
	rm -rf $(ASM_ERROR_DIR)/semantic_error1.asm $(EXEC_ERROR_DIR)/semantic_error1 $(OBJ_ERROR_DIR)/semantic_error1.o
	rm -rf $(ASM_ERROR_DIR)/semantic_error2.asm $(EXEC_ERROR_DIR)/semantic_error2 $(OBJ_ERROR_DIR)/semantic_error2.o
	rm -rf $(ASM_ERROR_DIR)/semantic_error3.asm $(EXEC_ERROR_DIR)/semantic_error3 $(OBJ_ERROR_DIR)/semantic_error3.o
	rm -rf $(ASM_ERROR_DIR)/semantic_error4.asm $(EXEC_ERROR_DIR)/semantic_error4 $(OBJ_ERROR_DIR)/semantic_error4.o
	rm -rf $(ASM_ERROR_DIR)/semantic_error5.asm $(EXEC_ERROR_DIR)/semantic_error5 $(OBJ_ERROR_DIR)/semantic_error5.o
	rm -rf $(ASM_ERROR_DIR)/semantic_error6.asm $(EXEC_ERROR_DIR)/semantic_error6 $(OBJ_ERROR_DIR)/semantic_error6.o
	rm -rf $(ASM_ERROR_DIR)/semantic_error7.asm $(EXEC_ERROR_DIR)/semantic_error7 $(OBJ_ERROR_DIR)/semantic_error7.o
	rm -rf $(ASM_ERROR_DIR)/semantic_error8.asm $(EXEC_ERROR_DIR)/semantic_error8 $(OBJ_ERROR_DIR)/semantic_error8.o
	rm -rf $(ASM_ERROR_DIR)/semantic_error9.asm $(EXEC_ERROR_DIR)/semantic_error9 $(OBJ_ERROR_DIR)/semantic_error9.o
	rm -rf $(ASM_ERROR_DIR)/semantic_error10.asm $(EXEC_ERROR_DIR)/semantic_error10 $(OBJ_ERROR_DIR)/semantic_error10.o
	rm -rf $(ASM_ERROR_DIR)/semantic_error11.asm $(EXEC_ERROR_DIR)/semantic_error11 $(OBJ_ERROR_DIR)/semantic_error11.o
	rm -rf $(ASM_ERROR_DIR)/semantic_error12.asm $(EXEC_ERROR_DIR)/semantic_error12 $(OBJ_ERROR_DIR)/semantic_error12.o
	rm -rf $(ASM_ERROR_DIR)/semantic_error13.asm $(EXEC_ERROR_DIR)/semantic_error13 $(OBJ_ERROR_DIR)/semantic_error13.o
	rm -rf $(ASM_ERROR_DIR)/semantic_error14.asm $(EXEC_ERROR_DIR)/semantic_error14 $(OBJ_ERROR_DIR)/semantic_error14.o
	rm -rf $(ASM_ERROR_DIR)/semantic_error15.asm $(EXEC_ERROR_DIR)/semantic_error15 $(OBJ_ERROR_DIR)/semantic_error15.o
	rm -rf $(ASM_ERROR_DIR)/semantic_error16.asm $(EXEC_ERROR_DIR)/semantic_error16 $(OBJ_ERROR_DIR)/semantic_error16.o
	rm -rf $(ASM_ERROR_DIR)/runtime_error_div_by_0.asm $(EXEC_ERROR_DIR)/runtime_error_div_by_0.asm $(OBJ_ERROR_DIR)/runtime_error_div_by_0 $(ERROR_DIR)/runtime_error_div_by_0.o
	rm -rf $(ASM_ERROR_DIR)/runtime_error_out_of_index_vector.asm $(EXEC_ERROR_DIR)/runtime_error_out_of_index_vector.asm $(OBJ_ERROR_DIR)/runtime_error_out_of_index_vector $(ERROR_DIR)/runtime_error_out_of_index_vector.o


clean_all: clean clean_output
