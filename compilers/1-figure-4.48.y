%{
#include <ctype.h>
#include <stdio.h>

int yylex();
void yyerror(char *s);
%}

%token DIGIT

%%
lines   : lines expr '\n'   {printf("%d\n", $2);}
        | lines '\n'
        | 
        ;
expr    : expr '+' term     {$$ = $1 + $3;}
        | term
        ;
term    : term '*' factor   {$$ = $1 * $3;}
        | factor
        ;
factor  : '(' expr ')'      {$$ = $2;}
        | DIGIT
        ;
%%
int yylex(){
    int c;
    c = getchar();
    if (isdigit(c)) {
        yylval = c - '0';
        return DIGIT;
    }
    return c;
}

int main() {
    return yyparse();
}

void yyerror(char *s) {
    printf("error: %s\n", s);
}
