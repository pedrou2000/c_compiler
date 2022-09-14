# TITLE OF THE PROJECT 

## 1. Description of the Project

[//]: # "What was the purpose of the project?" 
The purpose of this project is to create a compiler for a programming language called `alfa` which is a slight simplification of the `C` programming language. Newer versions of the compiler will aim to compile real `C` files. The compiler takes programs written in `alfa` and transform them into `assembly language` programs. 

[//]: # "What your application does?" 


[//]: # "What problem does it solve" 


[//]: # "What was your motivation?" 


[//]: # "Why did you build this project?" 


### Structure of the project 

The project is divided into two main directories:
- `src`: Here all the files needed to generate the compiler are stored. This directory is diveded into several subdirectories with the different parts of the compiler:
    - `code_generation`: Library created to easily write `assembly` code calling `C` functions. Whenever the compiller finds an entity to write from the `alfa` program will call these functions.
    - `symbols_table`: Files containing the definition of the srtructures and functions for the creation and use of the `symbols table` are stored here.
    - `compiler_main`: The main files for the compiler are stored here. These include `alfa.l` which has the definitions to perform the `lexical analysis`, `alfa.y` for performing the `syntactic and semantic analysis`, `alfa.h` with important definitions for the rest of the project and `alfa.c` as the main program of the compiler.
    - `compiler`: Executable file of the final compiler. Can be created and deleted using the `Makefile` but has been kept there for users to not need `bison` and `flex` to try the compiler.
- `tests`: Contains different subdirectories with tests to check the correct functioning of the compiler. Each subdirectoy contains several subdirectories: `alfa`, where the original `alfa` files are stored; `asm` where the resulting `asm` files are stored, `exec` where the assembled `asm` code is stored ready tu run and `obj` where the objects created during the compilition are stored. The subdirectories under `tests` are:
    - `basic`: Set of basic tests to test the correct performance of the compiler.
    - `extra`: Set of extra tests to test the correct performance of the compiler.
    - `errrors`: Tests to check the correct identification of errors and runtime errors.




## 2. Technologies Used

[//]: # "What technologies were used?" 
The main technologies used for creating the compiler were:
- `bison`: A general-purpose parser generator that converts an annotated context-free grammar into a deterministic LR or generalized LR (GLR) parser employing LALR(1) parser tables. It is part of the GNU project.
- `flex`: A tool for generating lexical analyzers.

[//]: # "Why you used the technologies you used?" 


[//]: # "Some of the challenges you faced and features you hope to implement in the future." 





## 3. Learning outcomes

[//]: # "What did you learn?" 
Through the proccess of building the compiler, several skills were developed, including:
- Reinforcing the knowledge of Automata and Language Theory.
- Learn how to use programs like `bison` and `flex` to make the proccess of analyzing the code of the compiler easier.
- Building completely functional `lexical`, `syntactic` and `semantic` analyzers.
- Managing subdirectories in the `Makefile`.


## 4. How to Install and Run

### Dependencies

In order to recompile the compiler, `yac` and `bison` must be installed in your computer. However, the compiled compiler is already in the project so there is no need to install `yac` and `bison`. 

In order to test the generated `asm` files,  `gcc` compiler and `nasm` assembler must be installed in order to assemble the final `asm` files and link them.

### How to use the Makefile

If you want to recompile the compiler you just need to running `make compiler` in a terminal oppened at the root directory in the project. 

After that you can use all the test files provided to test the correct functioning of the compiler. To select which test you want to perform you can have a look into the `alfa` files in each of the `test` subdirectories to choose which you want to compile and run. After that if you run `make <name_of_the_program>`, for example, `make functions`, will have the following consequences:
- First the `Makefile` will use the `compiler` executable to compile your code to assembly, saving the result under the `asm` directory in the `tests` directory
- Then the previous file will be assembled using `nasm` and `gcc`, saving the executable in the `exec` directory.
- Finally the executable will be run.






[//]: # "## 5. Extra Information"


