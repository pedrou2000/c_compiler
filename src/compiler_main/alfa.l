%{
#include "alfa.h"
#include "y.tab.h"

int ycol = 1;
int yline = 1;
int err_morf;

%}

%option noyywrap
%option nodefault

LETTER [a-zA-Z]
DIGIT [0-9]


%%

" " { ycol += yyleng; }
\n { yline++; ycol = 1;}
"//".*\n { yline++; ycol = 1; }
\t { ycol += yyleng; }


main { ycol += yyleng; fprintf(yyout, ";D:\t%s\n", yytext); return TOK_MAIN; }
int { ycol += yyleng; fprintf(yyout, ";D:\t%s\n", yytext); return TOK_INT; }
boolean { ycol += yyleng; fprintf(yyout, ";D:\t%s\n", yytext); return TOK_BOOLEAN; }
array { ycol += yyleng; fprintf(yyout, ";D:\t%s\n", yytext); return TOK_ARRAY; }
function { ycol += yyleng; fprintf(yyout, ";D:\t%s\n", yytext); return TOK_FUNCTION; }
if { ycol += yyleng; fprintf(yyout, ";D:\t%s\n", yytext); return TOK_IF; }
else { ycol += yyleng; fprintf(yyout, ";D:\t%s\n", yytext); return TOK_ELSE; }
while { ycol += yyleng; fprintf(yyout, ";D:\t%s\n", yytext); return TOK_WHILE; }
scanf { ycol += yyleng; fprintf(yyout, ";D:\t%s\n", yytext); return TOK_SCANF; }
printf { ycol += yyleng; fprintf(yyout, ";D:\t%s\n", yytext); return TOK_PRINTF; }
return { ycol += yyleng; fprintf(yyout, ";D:\t%s\n", yytext); return TOK_RETURN; }



";" { ycol += yyleng; fprintf(yyout, ";D:\t%s\n", yytext); return TOK_PUNTOYCOMA; }
"," { ycol += yyleng; fprintf(yyout, ";D:\t%s\n", yytext); return TOK_COMA; }
"(" { ycol += yyleng; fprintf(yyout, ";D:\t%s\n", yytext); return TOK_PARENTESISIZQUIERDO; }
")" { ycol += yyleng; fprintf(yyout, ";D:\t%s\n", yytext); return TOK_PARENTESISDERECHO; }
"[" { ycol += yyleng; fprintf(yyout, ";D:\t%s\n", yytext); return TOK_CORCHETEIZQUIERDO; }
"]" { ycol += yyleng; fprintf(yyout, ";D:\t%s\n", yytext); return TOK_CORCHETEDERECHO; }
"{" { ycol += yyleng; fprintf(yyout, ";D:\t%s\n", yytext); return TOK_LLAVEIZQUIERDA; }
"}" { ycol += yyleng; fprintf(yyout, ";D:\t%s\n", yytext); return TOK_LLAVEDERECHA; }
"=" { ycol += yyleng; fprintf(yyout, ";D:\t%s\n", yytext); return TOK_ASIGNACION; }
"+" { ycol += yyleng; fprintf(yyout, ";D:\t%s\n", yytext); return TOK_MAS; }
"-" { ycol += yyleng; fprintf(yyout, ";D:\t%s\n", yytext); return TOK_MENOS; }
"/" { ycol += yyleng; fprintf(yyout, ";D:\t%s\n", yytext); return TOK_DIVISION; }
"*" { ycol += yyleng; fprintf(yyout, ";D:\t%s\n", yytext); return TOK_ASTERISCO; }
"&&" { ycol += yyleng; fprintf(yyout, ";D:\t%s\n", yytext); return TOK_AND; }
"||" { ycol += yyleng; fprintf(yyout, ";D:\t%s\n", yytext); return TOK_OR; }
"!" { ycol += yyleng; fprintf(yyout, ";D:\t%s\n", yytext); return TOK_NOT; }
"==" { ycol += yyleng; fprintf(yyout, ";D:\t%s\n", yytext); return TOK_IGUAL; }
"!=" { ycol += yyleng; fprintf(yyout, ";D:\t%s\n", yytext); return TOK_DISTINTO; }
"<=" { ycol += yyleng; fprintf(yyout, ";D:\t%s\n", yytext); return TOK_MENORIGUAL; }
">=" { ycol += yyleng; fprintf(yyout, ";D:\t%s\n", yytext); return TOK_MAYORIGUAL; }
"<" { ycol += yyleng; fprintf(yyout, ";D:\t%s\n", yytext); return TOK_MENOR; }
">" { ycol += yyleng; fprintf(yyout, ";D:\t%s\n", yytext); return TOK_MAYOR; }

true { ycol += yyleng; fprintf(yyout, ";D:\t%s\n", yytext); return TOK_TRUE; }
false { ycol += yyleng; fprintf(yyout, ";D:\t%s\n", yytext); return TOK_FALSE; }


{LETTER}({DIGIT}|{LETTER}){100,} { printf("****Error en [lin %d, col %d]: identificador demasiado largo (%s)\n", yline, ycol, yytext); err_morf = 1; return TOK_ERROR; }

{DIGIT}+ { ycol += yyleng; yylval.atributos.valor_entero=atoi(yytext); fprintf(yyout, ";D:\t%s\n", yytext); return TOK_CONSTANTE_ENTERA; }
{LETTER}({DIGIT}|{LETTER}){0,99} { ycol += yyleng; strcpy(yylval.atributos.lexema,yytext); fprintf(yyout, ";D:\t%s\n", yytext); return TOK_IDENTIFICADOR; }



[^({LETTER}(({DIGIT}|{LETTER}){0,99}))] { printf("****Error morfologico en [lin %d, col %d]: simbolo no permitido (%s)\n", yline, ycol, yytext); err_morf = 1; return TOK_ERROR; }

%%

