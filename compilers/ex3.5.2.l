%option noyywrap

%{
#define WS 0xFFFFFFFF

int wsaction();
%}

delim   [ \t\n ]
ws      {delim}+

%%
{ws}        { wsaction(); return(WS);}
%%

#include <stdio.h>

int wsaction() {
    printf(" ");
}

int main() {
    while(yylex());
}
