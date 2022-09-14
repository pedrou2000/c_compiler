#ifndef _ALFA_H
#define _ALFA_H

#define MAX_ID_LENGTH 100
#define MAX_TAMANIO_VECTOR 64
#define MAX_ERROR 200

#define NOT_FOUND -1
#define ERROR -1
#define OK 0

#define TRUE 1
#define FALSE 0

/* symbol type */
#define INT 1
#define BOOLEAN 2

/* symbol category */
#define VARIABLE 1
#define PARAMETRO 2
#define FUNCION 3

/* class */ 
#define ESCALAR 1
#define VECTOR 2

/* ambitos */
#define GLOBAL 1
#define LOCAL 2


typedef struct {
	char lexema[MAX_ID_LENGTH+1]; // identifiers
	int tipo; // INT or BOOLEAN
	int valor_entero; // constants
	int es_direccion; // 0 or 1
	int etiqueta;
} tipo_atributos;


#endif
