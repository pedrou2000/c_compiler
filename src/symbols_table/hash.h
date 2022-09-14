#ifndef _HASH_H
#define _HASH_H


#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define MAX_TABLE_SIZE 	1024*1024		// Longitud máxima de la tabla
#define TRUE			1
#define FLASE			0
#define _HASH_C 		0

typedef struct hash_node
{
	struct hash_node *next;	// Si el hash (clave) es el mismo, siga el relevo
	char *key;				//Palabra clave
	void *value;			//valor
	char is_occupyed;	// ¿Está ocupado?
} Hash_node;

typedef struct hash_table
{
	Hash_node **table;	//Tabla de picadillo
}Hash_Table;

static unsigned int JSHash(char* key, unsigned int key_len);
static void init_hs_node(Hash_node *node);
static Hash_Table *creat_hash_table(void);
int add_node2HashTable(Hash_Table *Hs_table, char *key, unsigned int key_len, void *value);
void *get_value_from_hstable(Hash_Table *Hs_table, char *key, unsigned int key_len);
void hash_table_delete(Hash_Table *Hs_Table);


#endif
