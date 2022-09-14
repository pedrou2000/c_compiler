#include <stdio.h>
#include <stdlib.h>

#include "alfa.h"
#include "../symbols_table/symbols_table.h"
#include "../code_generation/generacion.h"

extern FILE *yyin;
extern FILE *yyout;
extern int yyparse();


// Symbols table checking
void check_symbols_table() {
    FILE * in = fopen("symbols_table/entrada.txt", "r");
    FILE * out = fopen("symbols_table/mi_salida.txt", "w");
    int ret = handle_in_out(in, out);
    fclose(in);
    fclose(out);
}

// Code generation checking
void check_code_generation() {
    FILE* salida = fopen("code_generation/ex1.asm","w");

    escribir_subseccion_data(salida);
    escribir_cabecera_bss(salida);
    declarar_variable(salida, "x", ENTERO, 1);
    declarar_variable(salida, "y", ENTERO, 1);
    declarar_variable(salida, "z", ENTERO, 1);
    escribir_segmento_codigo(salida);
    escribir_inicio_main(salida);
    
    /* x=8; */
    escribir_operando(salida,"8",0);
    asignar(salida,"x",0);
    
    /* scanf(&y); */
    leer(salida,"y",ENTERO);
    
    /* z = x + y */
    escribir_operando(salida,"x",1);
    escribir_operando(salida,"y",1);
    sumar(salida,1,1);
    asignar(salida,"z",0);
    
    /* printf(z); */
    escribir_operando(salida,"z",1);
    escribir(salida,1,ENTERO);
    
    /* z = 7 + y */
    escribir_operando(salida,"7",0);
    escribir_operando(salida,"y",1);
    sumar(salida,0,1);
    asignar(salida,"z",0);
    
    /* printf(z); */
    escribir_operando(salida,"z",1);
    escribir(salida,1,ENTERO);
    escribir_fin(salida);
    fclose(salida);
}


int main (int argc, char** argv){
    if (argc != 3){
        printf("Error, pocos argumentos.\n");
        return -1;       
    } 

    yyin = fopen(argv[1], "r");
    if (yyin == NULL) {
        printf("Error when openning the input file.\n");
        return -1;
    }
    
    yyout = fopen(argv[2], "w");
    if (yyout == NULL){
        printf("Error while opening output file.\n");
        return -1;
    }

    // check that imports are correctly working
    //check_symbols_table();
    //check_code_generation();


    yyparse();
    
    fclose(yyin);
    fclose(yyout);

    
    exit(EXIT_SUCCESS);
}