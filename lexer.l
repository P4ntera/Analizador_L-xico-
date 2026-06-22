%{
#include <stdio.h>
#include <string.h>
#include "parser.tab.h"

FILE *salida;
int token_id = 1;

void escribir_token(const char *tipo, const char *valor)
{
    fprintf(salida,
            "%-6d %-12s %-22s %s\n",
            token_id++,
            "global",
            tipo,
            valor);
}
%}

%option noyywrap
%option never-interactive

DIGITO         [0-9]
LETRA          [a-zA-Z_]
ENTERO         {DIGITO}+
NUM_DECIMAL    {DIGITO}+"."{DIGITO}+
ID             {LETRA}({LETRA}|{DIGITO})*

%%

"int" {
    escribir_token("PALABRA_CLAVE", yytext);
    return INT;
}

"float" {
    escribir_token("PALABRA_CLAVE", yytext);
    return FLOAT;
}

"char" {
    escribir_token("PALABRA_CLAVE", yytext);
    return CHAR;
}

"void" {
    escribir_token("PALABRA_CLAVE", yytext);
    return VOID;
}

"if" {
    escribir_token("PALABRA_CLAVE", yytext);
    return IF;
}

"else" {
    escribir_token("PALABRA_CLAVE", yytext);
    return ELSE;
}

"while" {
    escribir_token("PALABRA_CLAVE", yytext);
    return WHILE;
}

"for" {
    escribir_token("PALABRA_CLAVE", yytext);
    return FOR;
}

"return" {
    escribir_token("PALABRA_CLAVE", yytext);
    return RETURN;
}


"long" {
    escribir_token("PALABRA_CLAVE", yytext);
    return LONG;
}

"short" {
    escribir_token("PALABRA_CLAVE", yytext);
}

"unsigned" {
    escribir_token("PALABRA_CLAVE", yytext);
}

"struct" {
    escribir_token("PALABRA_CLAVE", yytext);
}

"break" {
    escribir_token("PALABRA_CLAVE", yytext);
}

"continue" {
    escribir_token("PALABRA_CLAVE", yytext);
}

"switch" {
    escribir_token("PALABRA_CLAVE", yytext);
}

"do" {
    escribir_token("PALABRA_CLAVE", yytext);
}

"case" {
    escribir_token("PALABRA_CLAVE", yytext);
}

"default" {
    escribir_token("PALABRA_CLAVE", yytext);
}

"printf" {
    escribir_token("FUNC_BIBLIOTECA", yytext);
}

"scanf" {
    escribir_token("FUNC_BIBLIOTECA", yytext);
}


{ID} {
    strcpy(yylval.texto, yytext);

    escribir_token("IDENTIFICADOR", yytext);

    return ID;
}

{NUM_DECIMAL} {
    escribir_token("NUMERO_DECIMAL", yytext);
    return DECIMAL;
}

{ENTERO} {
    escribir_token("NUMERO_ENTERO", yytext);
    return NUMERO;
}


"<=" {
    escribir_token("OPERADOR_REL", yytext);
    return MENORIGUAL;
}

">=" {
    escribir_token("OPERADOR_REL", yytext);
    return MAYORIGUAL;
}

"==" {
    escribir_token("OPERADOR_REL", yytext);
    return IGUALIGUAL;
}

"!=" {
    escribir_token("OPERADOR_REL", yytext);
    return DIFERENTE;
}

"=" {
    escribir_token("OPERADOR_ASIG", yytext);
    return IGUAL;
}

"+" {
    escribir_token("OPERADOR_ARIT", yytext);
    return SUMA;
}

"-" {
    escribir_token("OPERADOR_ARIT", yytext);
    return RESTA;
}

"*" {
    escribir_token("OPERADOR_ARIT", yytext);
    return MULT;
}

"/" {
    escribir_token("OPERADOR_ARIT", yytext);
    return DIV;
}

"<" {
    escribir_token("OPERADOR_REL", yytext);
    return MENOR;
}

">" {
    escribir_token("OPERADOR_REL", yytext);
    return MAYOR;
}


"++" {
    escribir_token("OP_INCREMENTO", yytext);
}

"--" {
    escribir_token("OP_DECREMENTO", yytext);
}

"&&" {
    escribir_token("OP_LOGICO_AND", yytext);
}

"||" {
    escribir_token("OP_LOGICO_OR", yytext);
}

"!" {
    escribir_token("OP_LOGICO_NOT", yytext);
}

";" {
    escribir_token("SIMBOLO", yytext);
    return PYC;
}

"," {
    escribir_token("SIMBOLO", yytext);
    return COMA;
}

"(" {
    escribir_token("SIMBOLO", yytext);
    return PARI;
}

")" {
    escribir_token("SIMBOLO", yytext);
    return PARD;
}

"{" {
    escribir_token("SIMBOLO", yytext);
    return LLAVEA;
}

"}" {
    escribir_token("SIMBOLO", yytext);
    return LLAVEC;
}

"[" {
    escribir_token("SIMBOLO", yytext);
}

"]" {
    escribir_token("SIMBOLO", yytext);
}

[ \t\r\n]   { }


. {
    escribir_token("DESCONOCIDO", yytext);
}

%%