%{
#include <stdio.h>
#include <malloc.h>
#include <string.h>
#include <assert.h>

extern int yylex (void);
int yyerror(const char *foo);

%}

%token <sval> T_VAL
%token T_DEVICE T_CONNECT T_PORTMAP T_PRIO
%token T_EQ T_ENDL T_UNFENCE T_OPTIONS
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

optline:
	T_OPTIONS T_VAL assigns T_ENDL {
		printf("Options\n");
	}
	;

prioline:
	T_PRIO T_VAL assigns T_ENDL {
		printf("Priority\n");
	}
	;

unfline:
	T_UNFENCE T_VAL T_ENDL {
		printf("unfence\n");
	}

portinfo:
	assign portinfo |
	T_VAL portinfo |
	assign |
	T_VAL
	;

portline:
	T_PORTMAP T_VAL portinfo T_ENDL {
		printf("port\n");
	}
	;


stuff:
	T_ENDL stuff |
	unfline stuff |
	devline stuff |
	conline stuff |
	portline stuff |
	optline stuff |
	prioline stuff |
	unfline |
	conline |
	portline |
	devline |
	optline |
	prioline |
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
