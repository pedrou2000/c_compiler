#ifndef _SYMBOLS_TABLE_H
#define _SYMBOLS_TABLE_H

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stddef.h>
#include "hash.h"
#include "../compiler/alfa.h"


typedef struct _symbol {
    char id[MAX_ID_LENGTH+1];
    int value; /* Valor del BOOLEAN o INT */
    int category; /* VARIABLE PARAMETRO or FUNCION */
    int classs; /* ESCALAR o VECTOR */
    int type; /* INT or BOOLEAN */
    int size; /* number of elements in a vector */
    int num_locals; /* number of local variables */
    int pos_local; /* position of local variable */
    int num_params; /* number of parameters */
    int pos_param; /* position of parameter */
} symbol;

typedef struct _hash_table {
    Hash_Table *global_table;
    Hash_Table *local_table;
    int exists_local;
} symbols_table;


/* SYMBOL STRUCTURE MANIPULATION FUNCTIONS */

symbol * new_symbol(char* id, int value, int category, int classs, int type, int size, 
    int num_locals, int  pos_local, int num_params, int pos_param);
void destroy_symbol(symbol * s);
void print_symbol(FILE * f, symbol * s);

void symbol_set_id(symbol * s, char * id);
void symbol_set_value(symbol * s, int value);
void symbol_set_category(symbol * s, int category);
void symbol_set_classs(symbol * s, int classs);
void symbol_set_type(symbol * s, int type);
void symbol_set_size(symbol * s, int size);
void symbol_set_num_locals(symbol * s, int num_locals);
void symbol_set_pos_local(symbol * s, int pos_local);
void symbol_set_num_params(symbol * s, int num_params);
void symbol_set_pos_param(symbol * s, int pos_param);
void symbol_inc_num_locals(symbol * s);
void symbol_inc_num_params(symbol * s);

char * symbol_get_id(symbol * s);
int symbol_get_value(symbol * s);
int symbol_get_category(symbol * s);
int symbol_get_classs(symbol * s);
int symbol_get_type(symbol * s);
int symbol_get_size(symbol * s);
int symbol_get_num_locals(symbol * s);
int symbol_get_pos_local(symbol * s);
int symbol_get_num_params(symbol * s);
int symbol_get_pos_param(symbol * s);



/* SYMBOL TABLE MANIPULATION FUNCTIONS */

/* Creates an the symbols table structure only initializing the global table. */
symbols_table * create_table();
/* Deletes a symbols table. */
void delete_table(symbols_table * table);
/* Reuturns the actual scope of the program */
int actual_scope(symbols_table * table);


/* SEARCH FUNCTIONS */

/* Searches a symbol in an specific hash table by its id. */
symbol * search_hash_symbol(Hash_Table * table, char * id);
/* Searches a symbol in the local symbol table by its id. */
symbol * search_local(symbols_table * table, char* id);
/* Searches a symbol in the global symbol table by its id. */
symbol * search_global(symbols_table * table, char* id);
/* Searches a symbol in the current scope by its id. */
symbol * search_current_scope(symbols_table * table, char* id);
/* Searches a symbol in the local and if not the global symbol table by its id. */
symbol * search_local_global(symbols_table * table, char* id);


/* INSERTION FUNCTIONS */

/* Inserts a symbol in an specific hash table. */
int insert_hash_symbol(Hash_Table * table, symbol * s);
/* Creates and inserts a symbol in the local symbol table. */
int declare_local(symbols_table * table, char* id, int value, int category, int classs,
    int type, int size, int num_locals, int  pos_local, int num_params, int pos_param);
/* Creates and inserts a symbol in the global symbol table. */
int declare_global(symbols_table * table, char* id, int value, int category, int classs,
    int type, int size, int num_locals, int  pos_local, int num_params, int pos_param);
/* Creates and inserts a symbol in the current scope. */
int declare_current_scope(symbols_table * table, char* id, int value, int category, int classs,
    int type, int size, int num_locals, int  pos_local, int num_params, int pos_param);
/* Deletes the local hash table of the given symbol table. */
int close_scope(symbols_table * table);
/* Declares a function, creating a new local table, possibly eliminating the previous and inserting the new element. */
int declare_function(symbols_table * table, char* id, int value, int category, int classs,
    int type, int size, int num_locals, int  pos_local, int num_params, int pos_param);


int handle_in_out(FILE * fin, FILE * fout);


#endif