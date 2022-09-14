#include "hash.h"


/*
	 Función: algoritmo hash, devolver valor hash
	 clave: tipo char *, valor clave
	 ken_len: longitud de la clave
	 Valor de retorno: valor hash
*/
static unsigned int JSHash(char* key, unsigned int key_len)
{
	unsigned int hash = 1315423911;
	unsigned int i = 0;

	for(i = 0; i < key_len; key++, i++)
	{
		hash ^= ((hash << 5) + (*key) + (hash >> 2));
	}

	return hash;
}

/*
	 Función: inicializar el nodo hash
	 nodo: nodo hash
	 Valor de retorno: ninguno
*/
static void init_hs_node(Hash_node *node)
{
	node->next = NULL;
	node->key = NULL;
	node->value = NULL;
	node->is_occupyed = FLASE;
}

/*
	 Función: crear una tabla hash
	 Parámetros: ninguno
	 Valor de retorno: devuelve correctamente una tabla hash creada; de lo contrario, NULL
*/
static Hash_Table *creat_hash_table(void)		// Crear una tabla hash
{
	Hash_Table *Hs_table = (Hash_Table *)malloc(sizeof(Hash_Table));	// Asigna la dirección de inicio de la tabla hash
	if (!Hs_table)
	{
		printf("no enough memory\n");
		return NULL;
	}
	
	Hs_table->table = malloc(sizeof(Hash_node) * MAX_TABLE_SIZE);	// Asigna memoria para todos los nodos de almacenamiento de la tabla hash
	if (!Hs_table->table)
	{
		printf("no enough memory for table\n");
		free(Hs_table);
		Hs_table = NULL;
		return NULL;
	}
	
	memset(Hs_table->table, 0, sizeof(Hash_node) * MAX_TABLE_SIZE);	// Todos los nodos se inicializan a 0
	
	return Hs_table;		// Devuelve la primera dirección de la tabla hash
}

/*
	 Función: agregar un nodo a la tabla hash
	 Hs_table: tabla hash, no puede estar vacía
	 clave: valor clave, no puede estar vacío
	 key_len: longitud de la clave
	 valor: valor
	 Valor de retorno: 0 éxito -1 falla
*/
int add_node2HashTable(Hash_Table *Hs_table, char *key, unsigned int key_len, void *value)
{
	if(!Hs_table || !key )
	{
		printf("something is NULL\n");
		return -1;
	}

	unsigned int i = JSHash(key, key_len) % MAX_TABLE_SIZE;		// Obtenga el subíndice de la tabla hash correspondiente a su valor clave a través de jhash

	Hash_node *p = Hs_table->table[i];
	Hash_node *pri = p;
	
	while(p)	// Ya hay un nodo hash en este punto, y debes ir al final de esta cadena
	{
		if ( strncmp(key, p->key, key_len) == 0 )	// El valor clave ya existe, actualizar el valor
		{
			if(p->is_occupyed)
			{
				p->value = value;
				p->is_occupyed = 1;		// Indicador de ocupación establecido en 1
				break;
			}
		}
		pri = p;			// pri siempre apunta a la posición anterior de p, utilizada para mantener el último nodo hash de la última tabla [i]
		p = p->next;
	}
	
	if(!p)	// Ir al final o el punto no ha sido ocupado
	{
		Hash_node *tmp = (Hash_node *)malloc(sizeof(Hash_node));
		if( !tmp )
		{
			printf("no enough memory\n");
			return -1;
		}
		init_hs_node(tmp);
		char *tmp_key = (char *)malloc(key_len+1);
		if(!tmp_key)
		{
			free(tmp);
			tmp = NULL;
			return -1;
		}
		strncpy(tmp_key, key, key_len);
		tmp->key = tmp_key;
		tmp->value = value;
		tmp->is_occupyed = TRUE;	// Actualiza la marca ocupada
		
		if(pri == NULL)		// Este punto no ha sido ocupado directamente
		{
			Hs_table->table[i] = tmp;
		}
		else		// Este punto ha sido ocupado y ha llegado al final de esta cadena
		{
			pri->next = tmp;
		}
	}
	
	return 0;
}

/*
	 Función: obtener datos de la tabla hash
	 Hs_table: tabla hash, no puede estar vacía
	 clave: valor clave, no puede estar vacío
	 key_len: longitud de la clave
	 Valor de retorno: contenido de almacenamiento, NULL si no se encuentra
*/
void *get_value_from_hstable(Hash_Table *Hs_table, char *key, unsigned int key_len)
{
	if( !Hs_table || !key)
	{
		printf("something is NULL\n");
		return NULL;
	}
	
	int i = JSHash(key,key_len) % MAX_TABLE_SIZE;
	Hash_node *tmp = Hs_table->table[i];
	
	while(tmp)
	{
		if(strncmp(tmp->key, key, key_len) == 0)
		{
			return tmp->value;
		}
		tmp = tmp->next;
	}
	
	return NULL;
}

/*
	 Función: Eliminar tabla hash
	 Hs_Table: nombre de la tabla hash
	 Valor de retorno: ninguno
*/
void hash_table_delete(Hash_Table *Hs_Table)
{
    if (Hs_Table)
	{
        if (Hs_Table->table)
		{
            int i = 0;
            for (i = 0; i<MAX_TABLE_SIZE; i++)	// Recorrer cada mesa 
			{
                Hash_node *p = Hs_Table->table[i];
                Hash_node *q = NULL;
                while (p)		// Hay contenido de almacenamiento en este momento
				{
                    q = p->next;
                    p->is_occupyed = 0;	// Marca de ocupación borrada a 0
                    if(p) free(p);
                    p = q;
                }
            }
            free(Hs_Table->table);	// Libera el uso de memoria del puntero de almacenamiento de la tabla
            Hs_Table->table = NULL;
        }
        free(Hs_Table);		// Suelta el puntero de la tabla
		Hs_Table = NULL;
    }
	return ;
}