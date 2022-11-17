%option noyywrap

%{
#define LT 0
#define LE 1
#define EQ 2
#define NE 3
#define GT 4
#define GE 5
#define IF 6
#define THEN 7
#define ELSE 8
#define ID 9
#define NUMBER 10
#define RELOP 11

int yylval = 0;
int installID();
int installNum();
%}

delim   [ \t\n ]
ws      {delim}+
letter  [A-Za-z]
digit   [0-9]
id      {letter}({letter}|{digit})*
number  {digit}+(\.{digit}+)?(E[+-]?{digit}+)?

%%
{ws}        {}
if          {return(IF);}
then        {return(THEN);}
else        {return(ELSE);}
{id}        {yylval = (int) installID(); return(ID);}
{number}    {yylval = (int) installNum(); return(NUMBER);}
"<"         {yylval = LT; return(RELOP);}
"<="        {yylval = LE; return(RELOP);}
"="         {yylval = EQ; return(RELOP);}
"<>"        {yylval = NE; return(RELOP);}
">"         {yylval = GT; return(RELOP);}
">="        {yylval = GE; return(RELOP);}
%%

int installID() {
    printf("id is %s with size %d and ", yytext, yyleng);
    return yyleng;
}

int installNum() {
    printf("num is %s with size %d and ", yytext, yyleng);
    return yyleng;
}

#include <stdio.h>

int main() {
    extern int yylval;
    while(1) {
        yylval = -1;
        int r = yylex();
        printf("token is %d\n", r);
    }
}
