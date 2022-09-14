#include "symbols_table.h"
#include "hash.c"

/* SYMBOL STRUCTURE MANIPULATION FUNCTIONS */

symbol * new_symbol(char* id, int value, int category, int classs, int type, int size, 
    int num_locals, int  pos_local, int num_params, int pos_param) {
    symbol * s = (symbol *) calloc(1, sizeof(symbol));
    if(s == NULL) {
        fprintf(stderr, "ERROR: Cannot allocate memory for new symbol with id %s", id);
        return NULL;
    }

    if(strlen(id) >= MAX_ID_LENGTH - 1) {
        fprintf(stderr, "ERROR: Symbol identifier too long: %s\n", id);
        destroy_symbol(s);
        return NULL;
    }
    strcpy(s->id, id);
    s->value = value;
    s->category = category;
    s->classs = classs;
    s->type = type;
    s->size = size;
    s->num_locals = num_locals;
    s->pos_local = pos_local;
    s->num_params = num_params;
    s->pos_param = pos_param;

    return s;
}

void destroy_symbol(symbol * s) {
    if(s) free(s);
}

void print_symbol(FILE * f, symbol * s) {
    fprintf(f, "Symbol with id %s, ", s->id);
    if(s->value != ERROR) fprintf(f, "value: %d, ", s->value);
    if(s->category != ERROR) {
        if(s->category == VARIABLE) { fprintf(f, "category: VARIABLE, "); } 
        else if(s->category == PARAMETRO) { fprintf(f, "category: PARAMETRO, "); } 
        else if(s->category == FUNCION) { fprintf(f, "category: FUNCION, "); }
    }
    if(s->classs != ERROR) {
        if(s->classs == ESCALAR) { fprintf(f, "classs: ESCALAR, "); } 
        else if(s->classs == VECTOR) { fprintf(f, "classs: VECTOR, "); }
    }
    if(s->type != ERROR) {
        if(s->type == INT) { fprintf(f, "type: INT, "); } 
        else if(s->type == BOOLEAN) { fprintf(f, "type: BOOLEAN, "); }
    }
    if(s->size != ERROR) { fprintf(f, "size: %d, ", s->size); }
    if(s->num_locals != ERROR) { fprintf(f, "num_locals: %d, ", s->num_locals); }
    if(s->pos_local != ERROR) { fprintf(f, "pos_local: %d, ", s->pos_local); }
    if(s->num_params != ERROR) { fprintf(f, "num_params: %d, ", s->num_params); }
    if(s->pos_param != ERROR) { fprintf(f, "pos_param: %d, ", s->pos_param); }
    fprintf(f, "\n");
}

void symbol_set_id(symbol * s, char * id) { strcpy(s->id, id); }
void symbol_set_value(symbol * s, int value) { s->value = value; }
void symbol_set_category(symbol * s, int category) { s->category = category; }
void symbol_set_classs(symbol * s, int classs) { s->classs = classs; }
void symbol_set_type(symbol * s, int type) { s->type = type; }
void symbol_set_size(symbol * s, int size) { s->size = size; }
void symbol_set_num_locals(symbol * s, int num_locals) { s->num_locals = num_locals; }
void symbol_set_pos_local(symbol * s, int pos_local) { s->pos_local = pos_local; }
void symbol_set_num_params(symbol * s, int num_params) { s->num_params = num_params; }
void symbol_set_pos_param(symbol * s, int pos_param) { s->pos_param = pos_param; }
void symbol_inc_num_locals(symbol * s) { (s->num_locals)++; }
void symbol_inc_num_params(symbol * s) { (s->num_params)++; }

char * symbol_get_id(symbol * s) { return s->id; }
int symbol_get_value(symbol * s) { return s->value; }
int symbol_get_category(symbol * s) { return s->category; }
int symbol_get_classs(symbol * s) { return s->classs; }
int symbol_get_type(symbol * s) { return s->type; }
int symbol_get_size(symbol * s) { return s->size; }
int symbol_get_num_locals(symbol * s) { return s->num_locals; }
int symbol_get_pos_local(symbol * s) { return s->pos_local; }
int symbol_get_num_params(symbol * s) { return s->num_params; }
int symbol_get_pos_param(symbol * s) { return s->pos_param; }




/* SYMBOL TABLE MANIPULATION FUNCTIONS */

/* Deletes a symbols table. */
void delete_table(symbols_table * table) {
    if(table) {
        if(table->local_table) {
            hash_table_delete(table->local_table);
        }
        if(table->global_table) {
            hash_table_delete(table->global_table);
        }
        free(table);
    }
}

/* Creates an the symbols table structure only initializing the global table. */
symbols_table * create_table() {
    symbols_table * table = NULL;

    table = (symbols_table *) calloc(1, sizeof(symbols_table));
    if (table == NULL) {
        fprintf(stderr, "ERROR: Error allocating memory.\n");
        return NULL;
    }

    table->global_table = creat_hash_table();
    if(table->global_table == NULL) {
        delete_table(table);
        fprintf(stderr, "ERROR: Error when creating global hash table.\n");
        return NULL;
    }
    table->local_table = NULL;
    table->exists_local = FALSE;

    return table;
}

/* Reuturns the actual scope of the program */
int actual_scope(symbols_table * table) {
    if(table->exists_local) return LOCAL;
    return GLOBAL;
}



/* SEARCH FUNCTIONS */

/* Searches a symbol in an specific hash table by its id. */
symbol * search_hash_symbol(Hash_Table * table, char * id) {
    return get_value_from_hstable(table, id, strlen(id));
}

/* Searches a symbol in the local symbol table by its id. */
symbol * search_local(symbols_table * table, char * id) {
    /* If a local table exists, we search the element there. */
    if(table->exists_local && table->local_table != NULL) {
        return search_hash_symbol(table->local_table, id);
    } else {
        fprintf(stderr, "ERROR: Trying to search in a local table not inisialised yet\n");
        return NULL;
    }
}

/* Searches a symbol in the global symbol table by its id. */
symbol * search_global(symbols_table * table, char* id) {
    if(table->global_table != NULL) {
        return search_hash_symbol(table->global_table, id);
    } else {
        fprintf(stderr, "ERROR: Trying to search in a global table not inisialised yet\n");
        return NULL;
    }
}

/* Searches a symbol in the current scope by its id. */
symbol * search_current_scope(symbols_table * table, char* id) {
    /* If a local table exists, we search the element there. */
    if(table->exists_local) {
        return search_hash_symbol(table->local_table, id);
    }
    /* If not, we search it in the global table */
    return search_hash_symbol(table->global_table, id);
}

/* Searches a symbol in the local and if not the global symbol table by its id. */
symbol * search_local_global(symbols_table * table, char* id) {
    /* If a local table exists, we search the element there. */
    if(table -> exists_local) {
        symbol * s = search_hash_symbol(table->local_table, id);
        if(s != NULL) {
            return s;
        }
    }
    /* If not, we search it in the global table */
    return search_hash_symbol(table -> global_table, id);
}



/* INSERTION FUNCTIONS */

/* Inserts a symbol in an specific hash table. */
int insert_hash_symbol(Hash_Table * table, symbol * s) {
    /* If the symbol already exists in the table: error */
    if (search_hash_symbol(table, s->id) != NULL){ 
        //fprintf(stderr, "ERROR: The symbol to be inserted is already in the table: ");
        //print_symbol(stderr, s);
        return ERROR; 
    }

    if(add_node2HashTable(table, s->id, strlen(s->id), s) == -1)  {
        fprintf(stderr, "ERROR: Cannot insert into hashtable new symbol: ");
        print_symbol(stderr, s);
        return ERROR;
    }

    return OK;
}

/* Creates and inserts a symbol in the local symbol table. */
int declare_local(symbols_table * table, char* id, int value, int category, int classs,
    int type, int size, int num_locals, int  pos_local, int num_params, int pos_param) {
    if(!(table -> exists_local)) { 
        //fprintf(stderr, "ERROR: exists_local is False, id: %s, value: %d.\n", id, value);
        return ERROR; 
    } else if(!table->local_table) { 
        fprintf(stderr, "ERROR: local table is null.\n");
        return ERROR; 
    }

    symbol * s = new_symbol(id, value, category, classs, type, size, num_locals, pos_local, num_params, pos_param);
    if(s == NULL) {
        fprintf(stderr, "ERROR: Error when initializing symbol.\n");
        return ERROR;
    }

    return insert_hash_symbol(table->local_table, s);
}

/* Creates and inserts a symbol in the global symbol table. */
int declare_global(symbols_table * table, char* id, int value, int category, int classs,
    int type, int size, int num_locals, int  pos_local, int num_params, int pos_param) {
    if(!table->global_table) { 
        fprintf(stderr, "ERROR: global table is null.\n");
        return ERROR; 
    }

    symbol * s = new_symbol(id, value, category, classs, type, size, num_locals, pos_local, num_params, pos_param);
    if(s == NULL) {
        fprintf(stderr, "ERROR: Error when initializing symbol.\n");
        return ERROR;
    }

    return insert_hash_symbol(table->global_table, s);
}

/* Creates and inserts a symbol in the current scope. */
int declare_current_scope(symbols_table * table, char* id, int value, int category, int classs,
    int type, int size, int num_locals, int  pos_local, int num_params, int pos_param) {
    if (table->exists_local) {
        return declare_local(table, id, value, category, classs, type, size, num_locals,  pos_local, num_params, pos_param);
    } else {
        return declare_global(table, id, value, category, classs, type, size, num_locals,  pos_local, num_params, pos_param);
    }
}


/* Deletes the local hash table of the given symbol table. */
int close_scope(symbols_table * table) {
    if(table->exists_local == FALSE || table->local_table == NULL) {
        return ERROR;
    } else {
        hash_table_delete(table->local_table);
    }
    table->exists_local = FALSE;
    table->local_table = NULL;
    return OK;
}

/* Declares a function, creating a new local table, possibly eliminating the previous and inserting the new element. */
int declare_function(symbols_table * table, char* id, int value, int category, int classs,
    int type, int size, int num_locals, int  pos_local, int num_params, int pos_param) {

    symbol * s = new_symbol(id, value, category, classs, type, size, num_locals, pos_local, num_params, pos_param);
    if(s == NULL) {
        fprintf(stderr, "ERROR: Error when initializing new symbol.\n");
        return ERROR;
    }

    /* Search for the element in the global table, if it exists, error. */
    if (search_hash_symbol(table -> global_table, id) != NULL){
        fprintf(stderr, "ERROR: function %s already exists.\n", id);
        return ERROR;
    }

    /* Insert the element in the global table. */
    if (insert_hash_symbol(table -> global_table, s) == ERROR) {
        fprintf(stderr, "ERROR: error while opening scope for function %s: insertion in global table failed.\n", id);
        return ERROR;
    }

    /* Initialize local table. */
    close_scope(table);
    table->local_table = creat_hash_table();
    if(table->local_table == NULL) {
        fprintf(stderr, "ERROR: Error while opening scope for function %s: Error when creating local hash table.\n", id);
        return ERROR;
    }
    table->exists_local = TRUE;
    if (insert_hash_symbol(table -> local_table, s) == ERROR) {
        printf("ERROR: Error while opening scope for function %s: insertion in local table failed.\n", id);
        return ERROR;
    }

    return OK;
}




/* Auxiliary function for handle_in_out. */
void insert_print_file(symbols_table * table, FILE * fout, char * id, int type){
    if (type == -999) {
        if (close_scope(table) == ERROR) {
            fprintf(fout, "-1\t%s\n", id);
        }
        else {
            fprintf(fout, "%s\n", id);
        }
    }
    else if (type < -1) {
        if (declare_function(table, id, type, -1, -1, -1, -1, -1, -1, -1, -1) == ERROR) {
            fprintf(fout, "-1\t%s\n", id);
        }
        else {
            fprintf(fout, "%s\n", id);
        }
    }
    else {
        if (declare_local(table, id, type, -1, -1, -1, -1, -1, -1, -1, -1) == ERROR) {
            if (declare_global(table, id, type, -1, -1, -1, -1, -1, -1, -1, -1) == ERROR) {
                fprintf(fout, "-1\t%s\n", id);
            } else {
                fprintf(fout, "%s\n", id);
            }
        }
        else {
            fprintf(fout, "%s\n", id);
        }
    }
}

/* Auxiliary function for handle_in_out. */
void search_print_file(symbols_table * table, FILE * fout, char * id){
    symbol * s = search_local_global(table, id);
    if(s == NULL) {
        fprintf(fout, "%s\t-1\n", id);
        return;
    }
    fprintf(fout, "%s\t%d\n", id, symbol_get_value(s));
}

/* Given two oppened files, reads the input inserting and searching in a new symbols 
table while writing in the output file the information of each operation. */
int handle_in_out(FILE * fin, FILE * fout){
    if(fin == NULL || fout == NULL) return ERROR;

    symbols_table *table = create_table();
    if (table == NULL) {
        fprintf(stderr, "ERRROR: Error when creating the table.\n");
        return ERROR;
    }

    char* line = NULL, *token1 = NULL, *token2 = NULL;
    size_t len = 0;
    size_t read;
    int type; 

    /* walk through all tokens */
    while ((read = getline(&line, &len, fin)) != -1) {
        token1 = strtok(line, "\t");
        token1[strcspn(token1, "\n")] = 0;
        token2 = strtok(NULL, "\t");
        if (token2) {
            type = atoi(token2);
            insert_print_file(table, fout, token1, type);
        } else {
            search_print_file(table, fout, token1);
        }
    }

    delete_table(table);

    return OK;
}



