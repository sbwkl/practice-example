%option noyywrap

%{
#define FLOAT 0xFFFFFFFF

int floataction();
%}


%%
float        { floataction(); return(FLOAT);}
%%

#include <stdio.h>

int floataction() {
    printf("double");
}

int main() {
    while(yylex());
}
