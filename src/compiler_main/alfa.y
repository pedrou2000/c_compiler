%{
#include <stdio.h>
#include "../symbols_table/symbols_table.h"
#include "../code_generation/generacion.h"
#include "alfa.h"
#include "y.tab.h"

extern FILE * yyout;
extern int yline;
extern int ycol;
extern int err_morf;
extern int yyleng;

int yylex();
void yyerror(const char *s);
void semantic_error(char * message);


/** GLOBAL VARIABLES **/
symbols_table *table;

int tipo_actual = ERROR; /* INT or BOOLEAN */
int clase_actual = ERROR; /* ESCALAR or VECTOR */
int tamanio_vector_actual = ERROR;
int funcion_retorno = 0;
int funcion_tipo;
int num_total_parametros = 0;
int num_total_var_locales = 0;
int etiqueta = 0;
int dentro_fun = 0; /* 1 si estamos dentro de la llamada de una funcion */
int pos_parametro = 0; /* solo para elementos de tipo parametro */ 
int pos_var_local = 0; /* solo para variables locales */
int num_arg_funcion = 0;
int cuantos_no = 0;

// para las funciones
int en_explist = 0; /* 1 si la actual llamada a funcion es parametro de llamada a funcion*/
int num_parametros_llamada_actual = 0; 


%}


%union {
    tipo_atributos atributos;
}

%token <atributos> TOK_IDENTIFICADOR
%token <atributos> TOK_CONSTANTE_ENTERA
%token <atributos> TOK_CONSTANTE_REAL


/* Tokens sin valor semantico */
%token TOK_MAIN
%token TOK_INT
%token TOK_BOOLEAN
%token <atributos> TOK_ARRAY
%token TOK_FUNCTION
%token TOK_IF
%token TOK_ELSE
%token TOK_WHILE
%token TOK_SCANF
%token TOK_PRINTF
%token TOK_RETURN

%token TOK_PUNTOYCOMA
%token TOK_COMA
%token TOK_PARENTESISIZQUIERDO
%token TOK_PARENTESISDERECHO
%token TOK_CORCHETEIZQUIERDO
%token TOK_CORCHETEDERECHO
%token TOK_LLAVEIZQUIERDA
%token TOK_LLAVEDERECHA
%token TOK_ASIGNACION
%token TOK_MAS
%token TOK_MENOS
%token TOK_DIVISION
%token TOK_ASTERISCO
%token TOK_AND
%token TOK_OR
%token TOK_NOT
%token TOK_IGUAL
%token TOK_DISTINTO
%token TOK_MENORIGUAL
%token TOK_MAYORIGUAL
%token TOK_MENOR
%token TOK_MAYOR

%token TOK_TRUE
%token TOK_FALSE

%token TOK_ERROR

/* No terminales con atributos semanticos */
%type <atributos> condicional
%type <atributos> comparacion
%type <atributos> elemento_vector
%type <atributos> exp
%type <atributos> constante
%type <atributos> constante_entera
%type <atributos> constante_logica
%type <atributos> identificador
%type <atributos> funcion
%type <atributos> fn_declaration
%type <atributos> fn_name
%type <atributos> if_exp
%type <atributos> if_else_exp
%type <atributos> bucle_exp
%type <atributos> while
%type <atributos> idf_llamada_funcion


%left TOK_IGUAL TOK_MENORIGUAL TOK_MENOR TOK_MAYORIGUAL TOK_MAYOR TOK_DISTINTO
%left TOK_MAS TOK_MENOS TOK_OR
%left TOK_ASTERISCO TOK_DIVISION TOK_AND
%right TOK_NOT

%%

programa: inicioTabla TOK_MAIN TOK_LLAVEIZQUIERDA declaraciones write_before_main funciones  write_inicio_main sentencias TOK_LLAVEDERECHA  {
    fprintf(yyout,";R1:\t<programa> ::= main { <declaraciones> <funciones> <sentencias> }\n");
    escribir_fin(yyout);
    delete_table(table);
};

inicioTabla: {
    table = create_table();
    if (table == NULL) {
        printf("ERRROR: Error when creating the table.\n");
        return ERROR;
    }
    escribir_subseccion_data(yyout);
    escribir_cabecera_bss(yyout);
};

write_before_main: {
    escribir_segmento_codigo(yyout);
};

write_inicio_main: {
    escribir_inicio_main(yyout);
};

declaraciones:  declaracion {
    fprintf(yyout, ";R2:\t<declaraciones> ::= <declaracion>\n");
}
                | declaracion declaraciones {
    fprintf(yyout, ";R3:\t<declaraciones> ::= <declaracion> <declaraciones>\n");
};

declaracion: clase identificadores TOK_PUNTOYCOMA {
    fprintf(yyout, ";R4:\t<declaracion> ::= <clase> <identificadores> ;\n");
};

clase:  clase_escalar {
    fprintf(yyout, ";R5:\t<clase> ::= <clase_escalar>\n");
    clase_actual = ESCALAR;
}
        | clase_vector {
    fprintf(yyout, ";R7:\t<clase> ::= <clase_vector>\n");
    clase_actual = VECTOR;
};

clase_escalar:  tipo {
    fprintf(yyout, ";R9:\t<clase_escalar> ::= <tipo>\n");
};

tipo:   TOK_INT {
    fprintf(yyout, ";R10:\t<tipo> ::= int\n");
    tipo_actual = INT;
}
        | TOK_BOOLEAN {
    fprintf(yyout, ";R11:\t<tipo> ::= boolean\n");
    tipo_actual = BOOLEAN;
};

clase_vector:   TOK_ARRAY tipo TOK_CORCHETEIZQUIERDO TOK_CONSTANTE_ENTERA TOK_CORCHETEDERECHO {
    fprintf(yyout, ";R15:\t<clase_vector> ::= array <tipo> [ <constante_entera> ]\n");
    tamanio_vector_actual = $4.valor_entero;
    if ((tamanio_vector_actual < 1 ) || (tamanio_vector_actual > MAX_TAMANIO_VECTOR)) {
        char err[MAX_ERROR];
        sprintf(err, "El tamanyo del vector %s excede los limites permitidos (1,64).\n", $1.lexema);
        semantic_error(err);
        return ERROR;
    }
};

identificadores:    identificador {
    fprintf(yyout, ";R18:\t<identificadores> ::= <identificador>\n");
}
                    | identificador TOK_COMA identificadores {
    fprintf(yyout, ";R19:\t<identificadores> ::= <identificador> , <identificadores>\n");
};

funciones:  funcion funciones {
    fprintf(yyout, ";R20:\t<funciones> ::= <funcion> <funciones>\n");
}
            | /* EMPTY */ {
    fprintf(yyout, ";R21:\t<funciones> ::= \n");
};

funcion: fn_declaration sentencias TOK_LLAVEDERECHA {
    fprintf(yyout, ";R22:\t<funcion> ::= function <tipo> <identificador> ( <parametros_funcion> ) { <declaraciones_funcion> <sentencias> }\n");
    if (funcion_retorno < 1){
        char err[MAX_ERROR];
        sprintf(err, "Funcion %s sin sentencia de retorno.\n", $1.lexema);
        semantic_error(err);
        return ERROR;
    }
    close_scope(table);
    symbol *sym;
    sym = search_global(table, $1.lexema);
    if (sym == NULL){
        printf("****Error en la tabla de simbolos.\n");
        delete_table(table);
        return ERROR;
    }
    sym->num_params = num_total_parametros;
    sym->type = funcion_tipo;
    num_total_parametros = 0;
    num_total_var_locales = 0;
    pos_parametro = 0;
};

fn_declaration: fn_name TOK_PARENTESISIZQUIERDO parametros_funcion TOK_PARENTESISDERECHO TOK_LLAVEIZQUIERDA declaraciones_funcion {
    symbol *sym;
    sym = search_local(table, $1.lexema);
    if (sym == NULL){
        printf("****Error en la tabla de simbolos.\n");
        delete_table(table);
        return ERROR;
    }
    sym->num_params = num_total_parametros;
    sym->num_locals = num_total_var_locales;
    sym->type = funcion_tipo;
    strcpy($$.lexema, $1.lexema);
    declararFuncion(yyout, $1.lexema, num_total_var_locales);

};

fn_name: TOK_FUNCTION tipo TOK_IDENTIFICADOR {
    /* la funcion no existe, por lo que la insertamos en la tabla */
    if (search_local_global(table, $3.lexema) == NULL){
        strcpy($$.lexema, $3.lexema);
        declare_function(table, $3.lexema, $3.valor_entero, FUNCION, ERROR, tipo_actual, ERROR, 0, 0, 0, ERROR);
        tamanio_vector_actual = 1;
        num_total_var_locales = 0;
        pos_parametro = 0;
        num_total_parametros = 0;
        funcion_retorno = 0;
        funcion_tipo = tipo_actual;
    }
    /* la funcion ya existe, error */
    else{
        semantic_error("Declaracion duplicada.\n");
        return ERROR;
    }

};

parametros_funcion: parametro_funcion resto_parametros_funcion {
    fprintf(yyout, ";R23:\t<parametros_funcion> ::= <parametro_funcion> <resto_parametros_funcion>\n");
}
                    | /* EMPTY */ {
    fprintf(yyout, ";R24:\t<parametros_funcion> ::= \n");
};

resto_parametros_funcion:   TOK_PUNTOYCOMA parametro_funcion resto_parametros_funcion {
    fprintf(yyout, ";R25:\t<resto_parametros_funcion> ::= ; <parametro_funcion> <resto_parametros_funcion>\n");
}
                            | /* EMPTY */ {
    fprintf(yyout, ";R26:\t<resto_parametros_funcion> ::= \n");
};

parametro_funcion:  tipo idpf {
    fprintf(yyout, ";R27:\t<parametro_funcion> ::= <tipo> <identificador>\n");
    num_total_parametros++;
    pos_parametro++;
};

idpf: TOK_IDENTIFICADOR {
    if (search_current_scope(table, $1.lexema) == NULL){
        clase_actual = ESCALAR;
        declare_local(table, $1.lexema, $1.valor_entero, PARAMETRO, clase_actual, tipo_actual, ERROR, ERROR, pos_var_local, ERROR, pos_parametro);
        pos_var_local++;
        num_total_var_locales++;
    }
    else{
        semantic_error("Declaracion duplicada.\n");
        return ERROR;
    }
};

declaraciones_funcion:  declaraciones {
    fprintf(yyout, ";R28:\t<declaraciones_funcion> ::= <declaraciones>\n");
}
                        | /* EMPTY */ {  
    fprintf(yyout, ";R29:\t<declaraciones_funcion> ::= \n");
};

sentencias: sentencia {
    fprintf(yyout, ";R30:\t<sentencias> ::= <sentencia>\n");
}
            | sentencia sentencias {
    fprintf(yyout, ";R31:\t<sentencias> ::= <sentencia> <sentencias>\n");
};

sentencia:  sentencia_simple TOK_PUNTOYCOMA {
    fprintf(yyout, ";R32:\t<sentencia> ::= <sentencia_simple> ;\n");
}
            | bloque {
    fprintf(yyout, ";R33:\t<sentencia> ::= <bloque>\n");
};

sentencia_simple:   asignacion {
    fprintf(yyout, ";R34:\t<sentencia_simple> ::= <asignacion>\n");
}
                    | lectura {
    fprintf(yyout, ";R35:\t<sentencia_simple> ::= <lectura>\n");
}
                    | escritura {
    fprintf(yyout, ";R36:\t<sentencia_simple> ::= <escritura>\n");
}
                    | retorno_funcion {
    fprintf(yyout, ";R38:\t<sentencia_simple> ::= <retorno_funcion>\n");
};

bloque: condicional {
    fprintf(yyout, ";R40:\t<bloque> ::= <condicional>\n");
}
        | bucle {
    fprintf(yyout, ";R41:\t<bloque> ::= <bucle>\n");
};

asignacion: TOK_IDENTIFICADOR TOK_ASIGNACION exp {
    fprintf(yyout, ";R43:\t<asignacion> ::= <identificador> = <exp>\n");
    symbol *sym;
    if ((sym = search_local_global(table, $1.lexema)) == NULL){
        char err[MAX_ERROR];
        sprintf(err, "Acceso a variable no declarada (%s).\n", $1.lexema);
        semantic_error(err);
        return ERROR;
    }
    if (sym->classs == VECTOR){
        semantic_error("Asignacion incompatible.\n");
        return ERROR;
    }
    if (sym->category == FUNCION){
        semantic_error("Asignacion incompatible.\n");
        return ERROR;
    }
    if (sym->type != $3.tipo){
        semantic_error("Asignacion incompatible.\n");
        return ERROR;
    }
    symbol_set_value(sym, $3.valor_entero);
    if (actual_scope(table) == GLOBAL){
        asignar(yyout, $1.lexema, $3.es_direccion);
    }else{
        escribirVariableLocal(yyout, sym->pos_local);
        asignarDestinoEnPila(yyout, $3.es_direccion);
    }
}
            | elemento_vector TOK_ASIGNACION exp {
    fprintf(yyout, ";R44:\t<asignacion> ::= <elemento_vector> = <exp>\n");
    symbol *sym;
    if ((sym = search_local_global(table, $1.lexema)) == NULL){
        char err[MAX_ERROR];
        sprintf(err, "Acceso a variable no declarada (%s).\n", $1.lexema);
        semantic_error(err);
        return ERROR;
    }
    if ($1.tipo != $3.tipo){
        semantic_error("Asignacion incompatible.\n");
        return ERROR;
    }
    // in the stack we have at the top the value and below the address
    // of the vector element where we want the value to be assigned  
    asignarDestinoEnPilaInv(yyout, $3.es_direccion);
};

elemento_vector:    TOK_IDENTIFICADOR TOK_CORCHETEIZQUIERDO exp TOK_CORCHETEDERECHO {
    fprintf(yyout, ";R48:\t<elemento_vector> ::= <identificador> [ <exp> ]\n");
    // identificador existe en la tabla
    symbol *sym = NULL;
    sym = search_local_global(table, $1.lexema);
    if (sym == NULL){
        char err[MAX_ERROR];
        sprintf(err, "Acceso a variable no declarada (%s).\n", $1.lexema);
        semantic_error(err);
        return ERROR;
    }
    // identificador corresponde con la declaracion de un vector
    if (symbol_get_classs(sym) != VECTOR){
        semantic_error("Intento de indexacion de una variable que no es de tipo vector.\n");
        return ERROR;
    }
    // indice de tipo INT
    if ($3.tipo != INT){
        semantic_error("El indice en una operacion de indexacion tiene que ser de tipo entero.\n");
        return ERROR;
    }
    $$.tipo = symbol_get_type(sym);
    $$.es_direccion = 1;
    $$.valor_entero = $3.valor_entero;
    escribir_elemento_vector(yyout, $1.lexema, symbol_get_size(sym), $3.es_direccion);
    if(en_explist == 1) {
        operandoEnPilaAArgumento(yyout, 1);
    }

};

condicional:    if_exp TOK_PARENTESISDERECHO TOK_LLAVEIZQUIERDA sentencias TOK_LLAVEDERECHA {
    fprintf(yyout, ";R50:\t<condicional> ::= if (<exp>) {<sentencias>}\n");
    ifthen_fin(yyout, $1.etiqueta);
}
                | if_else_exp TOK_ELSE TOK_LLAVEIZQUIERDA sentencias TOK_LLAVEDERECHA {
    fprintf(yyout, ";R51:\t<condicional> ::= if (<exp>) {<sentencias>} else {<sentencias>}\n");
    ifthenelse_fin(yyout, $1.etiqueta);
};

if_exp: TOK_IF TOK_PARENTESISIZQUIERDO exp {
    if ($3.tipo != BOOLEAN) {
        semantic_error("Condicional con condicion de tipo int.\n");
        return ERROR;
    }
    $$.etiqueta = etiqueta;
    ifthen_inicio(yyout, $3.es_direccion, $$.etiqueta);
};

if_else_exp: if_exp TOK_PARENTESISDERECHO TOK_LLAVEIZQUIERDA sentencias TOK_LLAVEDERECHA {
    $$.etiqueta = $1.etiqueta;
    ifthenelse_fin_then(yyout, $$.etiqueta);
};

bucle:  bucle_exp TOK_PARENTESISDERECHO TOK_LLAVEIZQUIERDA sentencias TOK_LLAVEDERECHA {
    fprintf(yyout, ";R52:\t<bucle> ::= while (<exp>) {<sentencias>}\n");
    while_fin(yyout, $1.etiqueta);
};

bucle_exp: while TOK_PARENTESISIZQUIERDO exp {
    if ($3.tipo != BOOLEAN){
        semantic_error("Bucle con condicion de tipo int.\n");
        return ERROR;
    }
    $$.etiqueta = $1.etiqueta;
    while_exp_pila(yyout, $3.es_direccion, $$.etiqueta);
};

while: TOK_WHILE {
    $$.etiqueta = etiqueta;
    while_inicio(yyout, $$.etiqueta);
};

lectura:    TOK_SCANF TOK_IDENTIFICADOR {
    fprintf(yyout, ";R54:\t<lectura> ::= scanf <identificador>\n");
    symbol *sym = NULL;
    sym = search_local_global(table, $2.lexema);
    if (sym == NULL) {
        char err[MAX_ERROR];
        sprintf(err, "Acceso a variable no declarada (%s).\n", $2.lexema);
        semantic_error(err);
        return ERROR;
    }
    if (symbol_get_category(sym) == FUNCION){
        semantic_error("No se permite leer funciones");
        return ERROR;
    }
    if (symbol_get_classs(sym) == VECTOR){
        semantic_error("No se permite leer vectores");
        return ERROR;
    }
    leer(yyout, $2.lexema, symbol_get_type(sym));
};

escritura:  TOK_PRINTF exp {
    fprintf(yyout, ";R56:\t<escritura> ::= printf <exp>\n");
    operandoEnPilaAArgumento(yyout, $2.es_direccion);
    escribir(yyout, 0, $2.tipo);
};

retorno_funcion:    TOK_RETURN exp {
    fprintf(yyout, ";R61:\t<retorno_funcion> ::= return <exp>\n");
    if (actual_scope(table) != LOCAL) {
        semantic_error("Sentencia de retorno fuera del cuerpo de una función.\n");
        return ERROR;
    }
    if ($2.tipo != funcion_tipo){
        semantic_error("Tipo de retorno incompatible\n");
        return ERROR;
    }

    funcion_retorno++;
    retornarFuncion(yyout, $2.es_direccion);
};

exp:    exp TOK_MAS exp {
    fprintf(yyout, ";R72:\t<exp> ::= <exp> + <exp>\n");
    if ($1.tipo != INT || $3.tipo != INT){
        semantic_error("Operacion aritmetica con operandos boolean.\n");
        return ERROR;
    }
    $$.tipo = INT;
    $$.es_direccion = 0;
    sumar(yyout, $1.es_direccion, $3.es_direccion);
}
        | exp TOK_MENOS exp {
    fprintf(yyout, ";R73:\t<exp> ::= <exp> - <exp>\n");
    if ($1.tipo != INT || $3.tipo != INT){
        semantic_error("Operacion aritmetica con operandos boolean.\n");
        return ERROR;
    }
    $$.tipo = INT;
    $$.es_direccion = 0;
    restar(yyout, $1.es_direccion, $3.es_direccion);
}
        | exp TOK_DIVISION exp {
    fprintf(yyout, ";R74:\t<exp> ::= <exp> / <exp>\n");
    if ($1.tipo != INT || $3.tipo != INT){
        semantic_error("Operacion aritmetica con operandos boolean.\n");
        return ERROR;
    }
    $$.tipo = INT;
    $$.es_direccion = 0;
    dividir(yyout, $1.es_direccion, $3.es_direccion);
}
        | exp TOK_ASTERISCO exp {
    fprintf(yyout, ";R75:\t<exp> ::= <exp> * <exp>\n");
    if ($1.tipo != INT || $3.tipo != INT){
        semantic_error("Operacion aritmetica con operandos boolean.\n");
        return ERROR;
    }
    $$.tipo = INT;
    $$.es_direccion = 0;
    multiplicar(yyout, $1.es_direccion, $3.es_direccion);
}
        | TOK_MENOS exp {
    fprintf(yyout, ";R76:\t<exp> ::= - <exp>\n");
    if ($2.tipo != INT){
        semantic_error("Operacion aritmetica con operandos boolean.\n");
        return ERROR;
    }
    $$.tipo = INT;
    $$.es_direccion = 0;
    cambiar_signo(yyout, $2.es_direccion);
}
        | exp TOK_AND exp {
    fprintf(yyout, ";R77:\t<exp> ::= <exp> && <exp>\n");
    if ($1.tipo != BOOLEAN || $3.tipo != BOOLEAN){
        semantic_error("Operacion logica con operandos int.\n");
        return ERROR;
    }
    $$.tipo = BOOLEAN;
    $$.es_direccion = 0;
    y(yyout, $1.es_direccion, $3.es_direccion);
    
}
        | exp TOK_OR exp {
    fprintf(yyout, ";R78:\t<exp> ::= <exp> || <exp>\n");
    if ($1.tipo != BOOLEAN || $3.tipo != BOOLEAN){
        semantic_error("Operacion logica con operandos int.\n");
        return ERROR;
    }
    $$.tipo = BOOLEAN;
    $$.es_direccion = 0;
    o(yyout, $1.es_direccion, $3.es_direccion);
}
        | TOK_NOT exp {
    fprintf(yyout, ";R79:\t<exp> ::= ! <exp>\n");
    if ($2.tipo != BOOLEAN){
        semantic_error("Operacion logica con operandos int.\n");
        return ERROR;
    }
    $$.tipo = BOOLEAN;
    $$.es_direccion = 0;
    no(yyout, $2.es_direccion, cuantos_no);
    cuantos_no++;
}
        | TOK_IDENTIFICADOR {
    fprintf(yyout, ";R80:\t<exp> ::= <identificador>\n");
    symbol *sym;
    if ((sym = search_local_global(table, $1.lexema)) == NULL){
        char err[MAX_ERROR];
        sprintf(err, "Acceso a variable no declarada (%s).\n", $1.lexema);
        semantic_error(err);
        return ERROR;
    }

    if (symbol_get_category(sym) == FUNCION){
        semantic_error("Identificador incompatible\n");
        return ERROR;
    }
    if (symbol_get_classs(sym) == VECTOR){
        semantic_error("Identificador incompatible\n");
        return ERROR;
    }
    $$.tipo = symbol_get_type(sym);
    $$.es_direccion = 1;
    $$.valor_entero = symbol_get_value(sym);

    if (sym->category == VARIABLE) {
        if(actual_scope(table) == LOCAL) {
            // if inside function don't push a local identifier
            escribirVariableLocal(yyout, sym->pos_local);
        } else {
            escribir_operando(yyout, $1.lexema, 1);


            if(en_explist == 1) {
                operandoEnPilaAArgumento(yyout, 1);
            }
        }
    } else if (sym->category == PARAMETRO) {
        escribirParametro(yyout, sym->pos_param, num_total_parametros);
    } else {
        semantic_error("Identificador incompatible\n");
        return ERROR;
    }
}
        | constante {
    fprintf(yyout, ";R81:\t<exp> ::= <constante>\n");
    $$.tipo = $1.tipo;
    $$.es_direccion = $1.es_direccion;
    $$.valor_entero = $1.valor_entero;
}
        | TOK_PARENTESISIZQUIERDO exp TOK_PARENTESISDERECHO {
    fprintf(yyout, ";R82:\t<exp> ::= ( <exp> )\n");
    $$.tipo = $2.tipo;
    $$.es_direccion = $2.es_direccion;
}
        | TOK_PARENTESISIZQUIERDO comparacion TOK_PARENTESISDERECHO {
    fprintf(yyout, ";R83:\t<exp> ::= ( <comparacion> )\n");
    $$.tipo = $2.tipo;
    $$.es_direccion = $2.es_direccion;
}
        | elemento_vector {
    fprintf(yyout, ";R85:\t<exp> ::= <elemento_vector>\n");
    $$.tipo = $1.tipo;
    $$.es_direccion = $1.es_direccion;
}
        | idf_llamada_funcion TOK_PARENTESISIZQUIERDO lista_expresiones TOK_PARENTESISDERECHO {
    fprintf(yyout, ";R88:\t<exp> ::= <identificador>( <lista_expresiones> )\n");
    symbol *sym;
    if ((sym = search_local_global(table, $1.lexema)) == NULL){
        char err[MAX_ERROR];
        sprintf(err, "Acceso a variable no declarada (%s).\n", $1.lexema);
        semantic_error(err);
        return ERROR;
    }
    if (num_parametros_llamada_actual != symbol_get_num_params(sym)){
        semantic_error("Numero incorrecto de parametros en llamada a funcion.\n");
        return ERROR;
    }
    en_explist = 0;
    $$.tipo = symbol_get_type(sym);
    $$.es_direccion = 0;
    
    llamarFuncion(yyout, symbol_get_id(sym), symbol_get_num_params(sym));
};

idf_llamada_funcion: TOK_IDENTIFICADOR {
    symbol *sym;
    if ((sym = search_local_global(table, $1.lexema)) == NULL){
        char err[MAX_ERROR];
        sprintf(err, "Acceso a variable no declarada (%s).\n", $1.lexema);
        semantic_error(err);
        return ERROR;
    }
    if (symbol_get_category(sym) != FUNCION) {
        semantic_error("Solo esta permitido llamar a funciones\n");
        return ERROR;
    }
    if (en_explist == 1){
        semantic_error("No esta permitido el uso de llamadas a funciones como parametros de otras funciones.\n");
        return ERROR;
    }
    num_parametros_llamada_actual = 0;
    en_explist = 1;
    strcpy($$.lexema, $1.lexema);
};

lista_expresiones:  exp resto_lista_expresiones {
    fprintf(yyout, ";R89:\t<lista_expresiones> ::= <exp> <resto_lista_expresiones>\n");
    num_parametros_llamada_actual++;
}
                    | /* EMPTY */ {
    fprintf(yyout, ";R90:\t<lista_expresiones> ::=\n");
};

resto_lista_expresiones:    TOK_COMA exp resto_lista_expresiones {
    fprintf(yyout, ";R91:\t<resto_lista_expresiones> ::= , <exp> <resto_lista_expresiones>\n");
    num_parametros_llamada_actual++;
}
                            | /* EMPTY */ { 
    fprintf(yyout, ";R92:\t<resto_lista_expresiones> ::=\n");
};

comparacion:    exp TOK_IGUAL exp {
    fprintf(yyout, ";R93:\t<comparacion> ::= <exp> == <exp>\n");
    if ($1.tipo != INT || $3.tipo != INT) {
        semantic_error("Comparacion con operandos boolean.\n");
        return ERROR;
    }
    $$.tipo = BOOLEAN;
    $$.es_direccion = 0;
    igual(yyout, $1.es_direccion, $3.es_direccion, etiqueta);
    etiqueta++;
}
                | exp TOK_DISTINTO exp {
    fprintf(yyout, ";R94:\t<comparacion> ::= <exp> != <exp>\n");
    if ($1.tipo != INT || $3.tipo != INT) {
        semantic_error("Comparacion con operandos boolean.\n");
        return ERROR;
    }
    $$.tipo = BOOLEAN;
    $$.es_direccion = 0;
    distinto(yyout, $1.es_direccion, $3.es_direccion, etiqueta);
    etiqueta++;
}
                | exp TOK_MENORIGUAL exp {
    fprintf(yyout, ";R95:\t<comparacion> ::= <exp> <= <exp>\n");
    if ($1.tipo != INT || $3.tipo != INT) {
        semantic_error("Comparacion con operandos boolean.\n");
        return ERROR;
    }
    $$.tipo = BOOLEAN;
    $$.es_direccion = 0;
    menor_igual(yyout, $1.es_direccion, $3.es_direccion, etiqueta);
    etiqueta++;
}
                | exp TOK_MAYORIGUAL exp {
    fprintf(yyout, ";R96:\t<comparacion> ::= <exp> >= <exp>\n");
    if ($1.tipo != INT || $3.tipo != INT) {
        semantic_error("Comparacion con operandos boolean.\n");
        return ERROR;
    }
    $$.tipo = BOOLEAN;
    $$.es_direccion = 0;
    mayor_igual(yyout, $1.es_direccion, $3.es_direccion, etiqueta);
    etiqueta++;
}
                | exp TOK_MENOR exp {
    fprintf(yyout, ";R97:\t<comparacion> ::= <exp> < <exp>\n");
    if ($1.tipo != INT || $3.tipo != INT) {
        semantic_error("Comparacion con operandos boolean.\n");
        return ERROR;
    }
    $$.tipo = BOOLEAN;
    $$.es_direccion = 0;
    menor(yyout, $1.es_direccion, $3.es_direccion, etiqueta);
    etiqueta++;
}
                | exp TOK_MAYOR exp {
    fprintf(yyout, ";R98:\t<comparacion> ::= <exp> > <exp>\n");
    if ($1.tipo != INT || $3.tipo != INT) {
        semantic_error("Comparacion con operandos boolean.\n");
        return ERROR;
    }
    $$.tipo = BOOLEAN;
    $$.es_direccion = 0;
    mayor(yyout, $1.es_direccion, $3.es_direccion, etiqueta);
    etiqueta++;
};

constante:  constante_logica {
    fprintf(yyout, ";R99:\t<constante> ::= <constante_logica>\n");
    $$.tipo = $1.tipo;
    $$.es_direccion = $1.es_direccion;
    $$.valor_entero = $1.valor_entero;
}
            | constante_entera {
    fprintf(yyout, ";R100:\t<constante> ::= <constante_entera>\n");
    $$.tipo = $1.tipo;
    $$.es_direccion = $1.es_direccion;
    $$.valor_entero = $1.valor_entero;
};

constante_logica:   TOK_TRUE {
    fprintf(yyout, ";R102:\t<constante_logica> ::= true\n");
    $$.tipo = BOOLEAN;
    $$.es_direccion = 0;
    $$.valor_entero = 1;
    escribir_operando(yyout, "1", 0);
}
                    | TOK_FALSE {
    fprintf(yyout, ";R103:\t<constante_logica> ::= false\n");
    $$.tipo = BOOLEAN;
    $$.es_direccion = 0;
    $$.valor_entero = 0;
    escribir_operando(yyout, "0", 0);
};

constante_entera:   TOK_CONSTANTE_ENTERA {
    fprintf(yyout, ";R104:\t<contante_entera> ::= TOK_CONSTANTE_ENTERA\n");
    $$.tipo = INT;
    $$.es_direccion = 0;
    $$.valor_entero = $1.valor_entero;
    char buf[MAX_ERROR];
    sprintf(buf, "%d", $1.valor_entero);
    escribir_operando(yyout, buf, 0);
};

identificador:  TOK_IDENTIFICADOR {
    fprintf(yyout, ";R108:\t<identificador> ::= TOK_IDENTIFICADOR\n");
    symbol * s = search_current_scope(table, $1.lexema);
    if (s != NULL) {
        semantic_error("Declaracion duplicada.");
        return ERROR;
    } 

    if(actual_scope(table) == GLOBAL) {
        if (clase_actual == VECTOR) {
            declare_global(table, $1.lexema, $1.valor_entero, VARIABLE, clase_actual, tipo_actual, tamanio_vector_actual, ERROR, pos_var_local, ERROR, ERROR);
        } else {
            tamanio_vector_actual = 1;
            declare_global(table, $1.lexema, $1.valor_entero, VARIABLE, clase_actual, tipo_actual, ERROR, ERROR, pos_var_local, ERROR, ERROR);
        }
        declarar_variable(yyout, $1.lexema, tipo_actual, tamanio_vector_actual);
    } else { // local scope
        if (clase_actual != ESCALAR) {
            semantic_error("Variable local de tipo no escalar.");
            return ERROR;
        }
        declare_local(table, $1.lexema, $1.valor_entero, VARIABLE, clase_actual, tipo_actual, ERROR, ERROR, pos_var_local, ERROR, ERROR);
        pos_var_local++;
        num_total_var_locales++;
    }
};

%%

void yyerror(const char *s){

    if(!err_morf){
        printf("****Error sintactico en [lin %d, col %d]\n", yline, ycol);
        delete_table(table);
        return;
    }

    err_morf = 0;
    delete_table(table);
    return;
}

void semantic_error(char * message) {
    printf("****Error semantico en lin %d: %s\n", yline, message);
    delete_table(table);
}
