%{
#include <stdio.h>
#include <malloc.h>
#include <string.h>
#include <assert.h>

extern int yylex (void);
int yyerror(const char *foo);

%}

%token <sval> T_VAL
%token T_OBRACE T_CBRACE T_CEQ T_SEMI
%token T_COMMA T_OBRACK T_CBRACK
%token T_OR T_XOR T_NOT T_AND T_EQ
%token T_OPAREN T_CPAREN

%start stuff

%union {
	char *sval;
	int ival;
}

%%
node:
	T_VAL T_OBRACE stuff T_CBRACE |
	T_VAL T_EQ T_VAL T_OBRACE stuff T_CBRACE |
	T_VAL T_OBRACE T_CBRACE |
	T_VAL T_EQ T_VAL T_OBRACE T_CBRACE
	;

stuff:
	node stuff |
	assign stuff |
	node |
	assign
	;

val:
	T_VAL |
	list
	;

vals:
	val T_COMMA vals |
	val
	;

list:
	T_OBRACK vals T_CBRACK
	;

assign_list:
	T_VAL T_EQ list
	;

assign_simp:
	T_VAL T_EQ T_VAL
	;

expr:
	T_OPAREN expr T_CPAREN |
	T_VAL |
	expr T_OR expr |
	expr T_NOT expr |
	expr T_AND expr |
	expr T_XOR expr
	;

assign_logic:
	T_VAL T_EQ expr
	;

assign:
	assign_list |
	assign_simp |
	assign_logic
	;
%%

extern int _line_count;

int
yyerror(const char *foo)
{
	printf("%s on line %d\n", foo, _line_count);
	return 0;
}
