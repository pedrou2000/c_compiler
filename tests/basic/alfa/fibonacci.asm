; Generacion: escribir_subseccion_data
segment .data
error_div_by_zero db '****Error de ejecucion: Division por cero.', 0
error_out_of_range db '****Error de ejecucion: Indice fuera de rango.', 0
; Generacion: escribir_cabecera_bss
segment .bss
__esp resd 1
;D:	main
;D:	{
;D:	int
;R10:	<tipo> ::= int
;R9:	<clase_escalar> ::= <tipo>
;R5:	<clase> ::= <clase_escalar>
;D:	x
;R108:	<identificador> ::= TOK_IDENTIFICADOR
; Generacion: declarar_variable
_x resd 1
;D:	,
;D:	resultado
;R108:	<identificador> ::= TOK_IDENTIFICADOR
; Generacion: declarar_variable
_resultado resd 1
;D:	;
;R18:	<identificadores> ::= <identificador>
;R19:	<identificadores> ::= <identificador> , <identificadores>
;R4:	<declaracion> ::= <clase> <identificadores> ;
;D:	function
;R2:	<declaraciones> ::= <declaracion>
; Generacion: escribir_segmento_codigo
segment .txt
global main
extern print_int, scan_int, scan_boolean, print_boolean, print_blank, print_string, print_endofline
;D:	int
;R10:	<tipo> ::= int
;D:	fibonacci
;D:	(
;D:	int
;R10:	<tipo> ::= int
;D:	num1
;R27:	<parametro_funcion> ::= <tipo> <identificador>
;D:	)
;R26:	<resto_parametros_funcion> ::= 
;R23:	<parametros_funcion> ::= <parametro_funcion> <resto_parametros_funcion>
;D:	{
;D:	int
;R10:	<tipo> ::= int
;R9:	<clase_escalar> ::= <tipo>
;R5:	<clase> ::= <clase_escalar>
;D:	res1
;R108:	<identificador> ::= TOK_IDENTIFICADOR
;D:	,
;D:	res2
;R108:	<identificador> ::= TOK_IDENTIFICADOR
;D:	;
;R18:	<identificadores> ::= <identificador>
;R19:	<identificadores> ::= <identificador> , <identificadores>
;R4:	<declaracion> ::= <clase> <identificadores> ;
;D:	if
;R2:	<declaraciones> ::= <declaracion>
;R28:	<declaraciones_funcion> ::= <declaraciones>
; Generacion: declararFuncion
fibonacci:
push ebp
mov ebp, esp
sub esp, 4*3
;D:	(
;D:	(
;D:	num1
;D:	==
;R80:	<exp> ::= <identificador>
; Generacion: escribirParametro
lea eax, [ebp + 8]
push dword eax
;D:	0
;R104:	<contante_entera> ::= TOK_CONSTANTE_ENTERA
; Generacion: escribir_operando; nombre: 0, es_variable: 0
mov dword eax, 0
push dword eax
;R100:	<constante> ::= <constante_entera>
;R81:	<exp> ::= <constante>
;D:	)
;R93:	<comparacion> ::= <exp> == <exp>
; Generacion: igual
pop dword ecx
pop dword eax
mov dword ebx, [eax]
cmp ebx, ecx
je same_0
push dword 0
jmp distintos_0
same_0:
push dword 1
distintos_0:
;R83:	<exp> ::= ( <comparacion> )
;D:	)
; Generacion: ifthen_inicio
pop dword ebx
cmp ebx, 0
je near then_fin_1
;D:	{
;D:	return
;D:	0
;R104:	<contante_entera> ::= TOK_CONSTANTE_ENTERA
; Generacion: escribir_operando; nombre: 0, es_variable: 0
mov dword eax, 0
push dword eax
;R100:	<constante> ::= <constante_entera>
;R81:	<exp> ::= <constante>
;D:	;
;R61:	<retorno_funcion> ::= return <exp>
; Generacion: retornarFuncion
pop eax
mov esp, ebp
pop ebp
ret
;R38:	<sentencia_simple> ::= <retorno_funcion>
;R32:	<sentencia> ::= <sentencia_simple> ;
;D:	}
;R30:	<sentencias> ::= <sentencia>
;D:	if
;R50:	<condicional> ::= if (<exp>) {<sentencias>}
; Generacion: ifthen_fin
then_fin_1:
;R40:	<bloque> ::= <condicional>
;R33:	<sentencia> ::= <bloque>
;D:	(
;D:	(
;D:	num1
;D:	==
;R80:	<exp> ::= <identificador>
; Generacion: escribirParametro
lea eax, [ebp + 8]
push dword eax
;D:	1
;R104:	<contante_entera> ::= TOK_CONSTANTE_ENTERA
; Generacion: escribir_operando; nombre: 1, es_variable: 0
mov dword eax, 1
push dword eax
;R100:	<constante> ::= <constante_entera>
;R81:	<exp> ::= <constante>
;D:	)
;R93:	<comparacion> ::= <exp> == <exp>
; Generacion: igual
pop dword ecx
pop dword eax
mov dword ebx, [eax]
cmp ebx, ecx
je same_1
push dword 0
jmp distintos_1
same_1:
push dword 1
distintos_1:
;R83:	<exp> ::= ( <comparacion> )
;D:	)
; Generacion: ifthen_inicio
pop dword ebx
cmp ebx, 0
je near then_fin_2
;D:	{
;D:	return
;D:	1
;R104:	<contante_entera> ::= TOK_CONSTANTE_ENTERA
; Generacion: escribir_operando; nombre: 1, es_variable: 0
mov dword eax, 1
push dword eax
;R100:	<constante> ::= <constante_entera>
;R81:	<exp> ::= <constante>
;D:	;
;R61:	<retorno_funcion> ::= return <exp>
; Generacion: retornarFuncion
pop eax
mov esp, ebp
pop ebp
ret
;R38:	<sentencia_simple> ::= <retorno_funcion>
;R32:	<sentencia> ::= <sentencia_simple> ;
;D:	}
;R30:	<sentencias> ::= <sentencia>
;D:	res1
;R50:	<condicional> ::= if (<exp>) {<sentencias>}
; Generacion: ifthen_fin
then_fin_2:
;R40:	<bloque> ::= <condicional>
;R33:	<sentencia> ::= <bloque>
;D:	=
;D:	fibonacci
;D:	(
;D:	num1
;D:	-
;R80:	<exp> ::= <identificador>
; Generacion: escribirParametro
lea eax, [ebp + 8]
push dword eax
;D:	1
;R104:	<contante_entera> ::= TOK_CONSTANTE_ENTERA
; Generacion: escribir_operando; nombre: 1, es_variable: 0
mov dword eax, 1
push dword eax
;R100:	<constante> ::= <constante_entera>
;R81:	<exp> ::= <constante>
;D:	)
;R73:	<exp> ::= <exp> - <exp>
; Generacion: restar
pop dword ebx
pop dword ecx
mov dword eax, [ecx]
sub eax, ebx
push dword eax
;R92:	<resto_lista_expresiones> ::=
;R89:	<lista_expresiones> ::= <exp> <resto_lista_expresiones>
;R88:	<exp> ::= <identificador>( <lista_expresiones> )
; Generacion: llamarFuncion
call fibonacci
; Generacion: limpiarPila
add esp, 4
push dword eax
;D:	;
;R43:	<asignacion> ::= <identificador> = <exp>
; Generacion: escribirVariableLocal
lea eax, [ebp - 4]
push dword eax
; Generacion: asignarDestinoEnPila; es_variable: 0
pop dword ebx
pop dword eax
mov dword [ebx], eax
;R34:	<sentencia_simple> ::= <asignacion>
;R32:	<sentencia> ::= <sentencia_simple> ;
;D:	res2
;D:	=
;D:	fibonacci
;D:	(
;D:	num1
;D:	-
;R80:	<exp> ::= <identificador>
; Generacion: escribirParametro
lea eax, [ebp + 8]
push dword eax
;D:	2
;R104:	<contante_entera> ::= TOK_CONSTANTE_ENTERA
; Generacion: escribir_operando; nombre: 2, es_variable: 0
mov dword eax, 2
push dword eax
;R100:	<constante> ::= <constante_entera>
;R81:	<exp> ::= <constante>
;D:	)
;R73:	<exp> ::= <exp> - <exp>
; Generacion: restar
pop dword ebx
pop dword ecx
mov dword eax, [ecx]
sub eax, ebx
push dword eax
;R92:	<resto_lista_expresiones> ::=
;R89:	<lista_expresiones> ::= <exp> <resto_lista_expresiones>
;R88:	<exp> ::= <identificador>( <lista_expresiones> )
; Generacion: llamarFuncion
call fibonacci
; Generacion: limpiarPila
add esp, 4
push dword eax
;D:	;
;R43:	<asignacion> ::= <identificador> = <exp>
; Generacion: escribirVariableLocal
lea eax, [ebp - 8]
push dword eax
; Generacion: asignarDestinoEnPila; es_variable: 0
pop dword ebx
pop dword eax
mov dword [ebx], eax
;R34:	<sentencia_simple> ::= <asignacion>
;R32:	<sentencia> ::= <sentencia_simple> ;
;D:	return
;D:	res1
;D:	+
;R80:	<exp> ::= <identificador>
; Generacion: escribirVariableLocal
lea eax, [ebp - 4]
push dword eax
;D:	res2
;D:	;
;R80:	<exp> ::= <identificador>
; Generacion: escribirVariableLocal
lea eax, [ebp - 8]
push dword eax
;R72:	<exp> ::= <exp> + <exp>
; Generacion: sumar
pop dword ecx
mov dword ebx, [ecx]
pop dword ecx
mov dword eax, [ecx]
add eax, ebx
push dword eax
;R61:	<retorno_funcion> ::= return <exp>
; Generacion: retornarFuncion
pop eax
mov esp, ebp
pop ebp
ret
;R38:	<sentencia_simple> ::= <retorno_funcion>
;R32:	<sentencia> ::= <sentencia_simple> ;
;D:	}
;R30:	<sentencias> ::= <sentencia>
;R31:	<sentencias> ::= <sentencia> <sentencias>
;R31:	<sentencias> ::= <sentencia> <sentencias>
;R31:	<sentencias> ::= <sentencia> <sentencias>
;R31:	<sentencias> ::= <sentencia> <sentencias>
;R22:	<funcion> ::= function <tipo> <identificador> ( <parametros_funcion> ) { <declaraciones_funcion> <sentencias> }
;D:	scanf
;R21:	<funciones> ::= 
;R20:	<funciones> ::= <funcion> <funciones>
; Generacion: escribir_inicio_main
main:
mov dword [__esp], esp
;D:	x
;R54:	<lectura> ::= scanf <identificador>
; Generacion: leer
push dword _x
call scan_int
add esp, 4
;R35:	<sentencia_simple> ::= <lectura>
;D:	;
;R32:	<sentencia> ::= <sentencia_simple> ;
;D:	resultado
;D:	=
;D:	fibonacci
;D:	(
;D:	x
;D:	)
;R80:	<exp> ::= <identificador>
; Generacion: escribir_operando; nombre: x, es_variable: 1
push dword _x
; Generacion: operandoEnPilaAArgumento; es_variable: 1
pop eax
mov eax, [eax]
push dword eax
;R92:	<resto_lista_expresiones> ::=
;R89:	<lista_expresiones> ::= <exp> <resto_lista_expresiones>
;R88:	<exp> ::= <identificador>( <lista_expresiones> )
; Generacion: llamarFuncion
call fibonacci
; Generacion: limpiarPila
add esp, 4
push dword eax
;D:	;
;R43:	<asignacion> ::= <identificador> = <exp>
; Generacion: asignar
pop dword eax
mov dword [_resultado], eax
;R34:	<sentencia_simple> ::= <asignacion>
;R32:	<sentencia> ::= <sentencia_simple> ;
;D:	printf
;D:	resultado
;D:	;
;R80:	<exp> ::= <identificador>
; Generacion: escribir_operando; nombre: resultado, es_variable: 1
push dword _resultado
;R56:	<escritura> ::= printf <exp>
; Generacion: operandoEnPilaAArgumento; es_variable: 1
pop eax
mov eax, [eax]
push dword eax
; Generacion: escribir
call print_int
add esp, 4
call print_endofline
;R36:	<sentencia_simple> ::= <escritura>
;R32:	<sentencia> ::= <sentencia_simple> ;
;D:	}
;R30:	<sentencias> ::= <sentencia>
;R31:	<sentencias> ::= <sentencia> <sentencias>
;R31:	<sentencias> ::= <sentencia> <sentencias>
;R1:	<programa> ::= main { <declaraciones> <funciones> <sentencias> }
; Generacion: escribir_fin
end_program:
mov dword esp, [__esp]
ret
div_by_zero:
push dword error_div_by_zero
call print_string
call print_endofline
add dword esp, 4
jmp end_program
out_of_range:
push dword error_out_of_range
call print_string
call print_endofline
add dword esp, 4
jmp end_program
