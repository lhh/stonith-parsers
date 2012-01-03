%{
#include <stdio.h>
#include <malloc.h>
#include <string.h>
#include <assert.h>

extern int yylex (void);
int yyerror(const char *foo);

%}

%token <sval> T_VAL
%token T_DEVICE T_CONNECT T_MAP
%token T_EQ T_ENDL T_UNFENCE
%left T_VAL

%start stuff

%union {
	char *sval;
	int ival;
}

%%

devline:
	T_DEVICE T_VAL T_VAL T_ENDL {
		printf("Device\n");
	} |
	T_DEVICE T_VAL T_VAL assigns T_ENDL {
		printf("Device\n");
	}
	;

conline:
	T_CONNECT T_VAL T_VAL assigns T_ENDL {
		printf("Connect\n");
	}
	;

unfline:
	T_UNFENCE T_VAL T_VAL T_ENDL {
		printf("unfence\n");
	}

mapinfo:
	assign mapinfo |
	T_VAL mapinfo |
	assign |
	T_VAL
	;

mapline:
	T_MAP T_VAL mapinfo T_ENDL {
		printf("map\n");
	}
	;


stuff:
	T_ENDL stuff |
	unfline stuff |
	devline stuff |
	conline stuff |
	mapline stuff |
	unfline |
	conline |
	mapline |
	devline |
	T_ENDL
	;

assign:
	T_VAL T_EQ T_VAL
	;

assigns:
	assigns assign |
	assign 
	;
%%

extern int _line_count;

int
yyerror(const char *foo)
{
	printf("%s on line %d\n", foo, _line_count);
	return 0;
}
