%{
#include <stdio.h>
#include <string.h>

FILE *salida;
int token_id = 1;

void escribir_token(const char *tipo, const char *valor) {
    fprintf(salida, "%-6d %-12s %-22s %s\n",
            token_id++, "global", tipo, valor);
}
%}

%option noyywrap
%option never-interactive

DIGITO      [0-9]
LETRA       [a-zA-Z_]
ENTERO      {DIGITO}+
DECIMAL     {DIGITO}+"."{DIGITO}+
ID          {LETRA}({LETRA}|{DIGITO})*

%%

"int"       { escribir_token("PALABRA_CLAVE",  yytext); }
"float"     { escribir_token("PALABRA_CLAVE",  yytext); }
"char"      { escribir_token("PALABRA_CLAVE",  yytext); }
"void"      { escribir_token("PALABRA_CLAVE",  yytext); }
"if"        { escribir_token("PALABRA_CLAVE",  yytext); }
"else"      { escribir_token("PALABRA_CLAVE",  yytext); }
"while"     { escribir_token("PALABRA_CLAVE",  yytext); }
"for"       { escribir_token("PALABRA_CLAVE",  yytext); }
"double"    { escribir_token("PALABRA_CLAVE",  yytext); }
"return"    { escribir_token("PALABRA_CLAVE",  yytext); }
"long"      { escribir_token("PALABRA_CLAVE", yytext); }
"short"     { escribir_token("PALABRA_CLAVE", yytext); }
"unsigned"  { escribir_token("PALABRA_CLAVE", yytext); }
"struct"    { escribir_token("PALABRA_CLAVE", yytext); }
"break"     { escribir_token("PALABRA_CLAVE", yytext); }
"continue"  { escribir_token("PALABRA_CLAVE", yytext); }
"switch"    { escribir_token("PALABRA_CLAVE", yytext); }
"do"        { escribir_token("PALABRA_CLAVE", yytext); }
"case"      { escribir_token("PALABRA_CLAVE", yytext); }
"default"   { escribir_token("PALABRA_CLAVE", yytext); }
"printf"    { escribir_token("FUNC_BIBLIOTECA",yytext); }
"scanf"     { escribir_token("FUNC_BIBLIOTECA",yytext); }

{ID}        { escribir_token("IDENTIFICADOR",  yytext); }
{DECIMAL}   { escribir_token("NUMERO_DECIMAL", yytext); }
{ENTERO}    { escribir_token("NUMERO_ENTERO",  yytext); }

"="         { escribir_token("OPERADOR_ASIG",  yytext); }
"+"         { escribir_token("OPERADOR_ARIT",  yytext); }
"-"         { escribir_token("OPERADOR_ARIT",  yytext); }
"*"         { escribir_token("OPERADOR_ARIT",  yytext); }
"/"         { escribir_token("OPERADOR_ARIT",  yytext); }
"=="        { escribir_token("OPERADOR_REL",   yytext); }
"!="        { escribir_token("OPERADOR_REL",   yytext); }
"<"         { escribir_token("OPERADOR_REL",   yytext); }
">"         { escribir_token("OPERADOR_REL",   yytext); }
"<="        { escribir_token("OPERADOR_REL",   yytext); }
">="        { escribir_token("OPERADOR_REL",   yytext); }

"++"   { escribir_token("OP_INCREMENTO", yytext); }
"--"   { escribir_token("OP_DECREMENTO", yytext); }
"&&"   { escribir_token("OP_LOGICO_AND", yytext); }
"||"   { escribir_token("OP_LOGICO_OR",  yytext); }
"!"    { escribir_token("OP_LOGICO_NOT", yytext); }

";"         { escribir_token("SIMBOLO",        yytext); }
","         { escribir_token("SIMBOLO",        yytext); }
"("         { escribir_token("SIMBOLO",        yytext); }
")"         { escribir_token("SIMBOLO",        yytext); }
"{"         { escribir_token("SIMBOLO",        yytext); }
"}"         { escribir_token("SIMBOLO",        yytext); }
"["         { escribir_token("SIMBOLO",        yytext); }
"]"         { escribir_token("SIMBOLO",        yytext); }

[ \t\n\r]   { /* ignorar espacios */ }
.           { escribir_token("DESCONOCIDO",    yytext); }

%%