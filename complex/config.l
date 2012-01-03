%{
#include <stdio.h>
#include <string.h>
#include <errno.h>
#include <assert.h>
#include "config.tab.h"

/* Some distributions can't use the output from flex without help */
#define ECHO if(fwrite( yytext, yyleng, 1, yyout ))

int _line_count = 1;

static void
_unescape(char *val)
{
	size_t x,y;
	int e = 0;

	y = strlen(val);
	for (x = 0; x < y; x++) {
		if (e == 1) {
			if (val[x] == '"') {
				memmove(&val[x-1], &val[x], y-x);
				--y;
				--x;
			}
			e = 0;
		}
		if (val[x] == '\\') {
			e = 1;
		}
	}
	val[y] = 0;
}

%}
%%
[\n] {
	++_line_count;
}

[ \t]* {}

\#[^\n]* {}

"{" {
	return T_OBRACE;
}

"}" {
	return T_CBRACE;
}

"(" {
	return T_OPAREN;
}

")" {
	return T_CPAREN;
}

"&" {
	return T_AND;
}

"!" {
	return T_NOT;
}

"|" {
	return T_OR;
}


"^" {
	return T_XOR;
}


"," {
	return T_COMMA;
}

"=" {
	return T_EQ;
}

"[" {
	return T_OBRACK;
}

"]" {
	return T_CBRACK;
}

[^ &\|!\t\(\){},;=\"\n\[\]]+ {
	yylval.sval = strdup(yytext);
	return T_VAL;
}

\"(\\\"|[^\"])+\" {
	yylval.sval = strdup(yytext+1);
	yylval.sval[strlen(yytext)-2] = 0;
	/* unescape backslash-quote to be quotes */
	_unescape(yylval.sval);
	return T_VAL;
}

\"\" {
	yylval.sval = NULL;
	return T_VAL;
}

%%
void
reset_vars(void)
{
	_line_count = 1;
}


int
yywrap(void)
{
	return 1;
}


#ifdef STANDALONE
int
main(int argc, char *argv[])
{
	yyparse();
	return 0;
}
#endif
