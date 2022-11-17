%{
#include <ctype.h>
#include <stdio.h>
#define YYSTYPE double

int yylex();
void yyerror(char *s);
%}

%token NUMBER

%%
lines   : lines expr '\n'   {printf("%lf\n", $2);}
        | lines '\n'
        | 
        ;
expr    : expr '+' term     {$$ = $1 + $3;}
        | expr '-' term     {$$ = $1 - $3;}
        | term
        ;
term    : term '*' factor   {$$ = $1 * $3;}
        | term '/' factor   {$$ = $1 / $3;}
        | factor
        ;
factor  : '(' expr ')'      {$$ = $2;}
        | NUMBER
        ;
%%
#include "lex.yy.c"

int main() {
    return yyparse();
}

void yyerror(char *s) {
    printf("error: %s\n", s);
}
