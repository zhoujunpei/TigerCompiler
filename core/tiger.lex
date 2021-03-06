%{
#include <string.h>
#include "util.h"
#include "symbol.h"
#include "absyn.h"
#include "y.tab.h"
#include "errormsg.h"

#define MAX_STR 1024

int current_pos = 1;

int yywrap(void) {
    current_pos = 1;
    return 1;
}

void adjust(void) {
    EM_tokPos = current_pos;
    current_pos += yyleng;
}

int comment_nest_layer = 0;
char str_buf[MAX_STR];
char *str_buf_ptr;
int str_buf_len = 0;

/* Append a string into str buf */
void str_buf_push(char *s) {
    str_buf_len += strlen(s);
    if (str_buf_len > MAX_STR) {
        EM_LexError(EM_tokPos, "String buffer overflow!");
    }
    else
        strcpy(str_buf_ptr, s);
    str_buf_ptr += strlen(s);
}

%}

id [A-Za-z][A-Za-z0-9_]*
digit 0|[1-9][0-9]* 
octal \\[0-2][0-9]{2}|3[0-6][0-9]|37[0-7]
hex \\x[0-9]{2}
invalid_ch [!@#$%^&~`?<>']
%x string
%x comment
%x replus
%x reminus

%%
[ \t]+ { 
    adjust(); 
    continue; 
}
\n  { 
    adjust(); 
    EM_newline(); 
    continue; 
}
\r { 
    adjust(); 
    EM_newline(); 
    continue; 
}
\n\r { 
    adjust(); 
    EM_newline(); 
    continue; 
}
\r\n { 
    adjust(); 
    EM_newline(); 
    continue; 
}

"," { 
    adjust(); 
    return COMMA; 
}
":" { 
    adjust(); 
    return COLON; 
}
";" { 
    adjust(); 
    return SEMICOLON; 
}
"(" { 
    adjust(); 
    return LPAREN; 
}
")" { 
    adjust(); 
    return RPAREN; 
}
"[" { 
    adjust(); 
    return LBRACK; 
}
"]" { 
    adjust(); 
    return RBRACK; 
}
"{" { 
    adjust(); 
    return LBRACE; 
}
"}" { 
    adjust(); 
    return RBRACE; 
}
"." { 
    adjust(); 
    return DOT; 
}

"++" {
    adjust();
    return DOUBLEPLUS;
}

"+" { 
    adjust();
    BEGIN(replus);
    return PLUS;
}
<replus>[ \t] {
    adjust();
}
<replus>"+" {
    adjust();
    EM_LexWarning(EM_tokPos, "series of '+', ignore it");
}
<replus>. {
    adjust();
    unput(yytext[0]);
    BEGIN(INITIAL);
}

"--" {
    adjust();
    return DOUBLEMINUS;
}

"-" { 
    adjust(); 
    BEGIN(reminus);
    return MINUS; 
}
<reminus>[ \t] {
    adjust();
}
<reminus>"-" {
    adjust();
    EM_LexWarning(EM_tokPos, "series of '-', ignore it");
}
<reminus>. {
    adjust();
    unput(yytext[0]);
    BEGIN(INITIAL);
}

"*" { 
    adjust(); 
    return TIMES; 
}
"/" { 
    adjust(); 
    return DIVIDE; 
}
"=" { 
    adjust(); 
    return EQ;
}
"<>" { 
    adjust(); 
    return NEQ; 
}
"<=" { 
    adjust(); 
    return LE; 
}
"<"  { 
    adjust(); 
    return LT; 
}
">=" { 
    adjust(); 
    return GE; 
}
">" { 
    adjust(); 
    return GT; 
}
"&&" { 
    adjust(); 
    return LOGIC_AND; 
}
"||" { 
    adjust(); 
    return LOGIC_OR; 
}

"&" {
    adjust();
    return ARITH_AND;
}

"|" {
    adjust();
    return ARITH_OR;
}

":=" { 
    adjust(); 
    return ASSIGN; 
}

array{invalid_ch} {
    adjust();
    EM_LexWarning(EM_tokPos, "maybe you mean 'array'");
    return ARRAY;
}

array { 
    adjust(); 
    return ARRAY; 
}

if{invalid_ch} {
    adjust();
    EM_LexWarning(EM_tokPos, "maybe you mean 'if'");
    return IF;
}

if { 
    adjust(); 
    return IF; 
}

then{invalid_ch} {
    adjust();
    EM_LexWarning(EM_tokPos, "maybe you mean 'then'");
    return THEN;
}

then { 
    adjust(); 
    return THEN; 
}

else{invalid_ch} {
    adjust();
    EM_LexWarning(EM_tokPos, "maybe you mean 'else'");
    return ELSE;
}

else {
    adjust(); 
    return ELSE; 
}

while{invalid_ch} {
    adjust();
    EM_LexWarning(EM_tokPos, "maybe you mean 'while'");
    return WHILE;
}

while { 
    adjust(); 
    return WHILE; 
}

for{invalid_ch} {
    adjust();
    EM_LexWarning(EM_tokPos, "maybe you mean 'for'");
    return FOR;
}

for { 
    adjust(); 
    return FOR; 
}

to{invalid_ch} {
    adjust();
    EM_LexWarning(EM_tokPos, "maybe you mean 'to'");
    return TO;
}

to { 
    adjust(); 
    return TO; 
}

do{invalid_ch} {
    adjust();
    EM_LexWarning(EM_tokPos, "maybe you mean 'do'");
    return DO;
}

do { 
    adjust(); 
    return DO; 
}

let{invalid_ch} {
    adjust();
    EM_LexWarning(EM_tokPos, "maybe you mean 'let'");
    return LET;
}

let { 
    adjust(); 
    return LET; 
}

in{invalid_ch} {
    adjust();
    EM_LexWarning(EM_tokPos, "maybe you mean 'in'");
    return IN;
}

in { 
    adjust(); 
    return IN; 
}

end{invalid_ch} {
    adjust();
    EM_LexWarning(EM_tokPos, "maybe you mean 'end'");
    return END;
}

end { 
    adjust(); 
    return END; 
}

of{invalid_ch} {
    adjust();
    EM_LexWarning(EM_tokPos, "maybe you mean 'of'");
    return OF;
}

of { 
    adjust(); 
    return OF; 
}

break{invalid_ch} {
    adjust();
    EM_LexWarning(EM_tokPos, "maybe you mean 'break'");
    return BREAK;
}

break { 
    adjust(); 
    return BREAK; 
}

nil{invalid_ch} {
    adjust();
    EM_LexWarning(EM_tokPos, "maybe you mean 'nil'");
    return NIL;
}

nil { 
    adjust(); 
    return NIL; 
}

function{invalid_ch} {
    adjust();
    EM_LexWarning(EM_tokPos, "maybe you mean 'function'");
    return FUNCTION;
}

function { 
    adjust(); 
    return FUNCTION; 
}

var{invalid_ch} {
    adjust();
    EM_LexWarning(EM_tokPos, "maybe you mean 'var'");
    return VAR;
}

var {
    adjust(); 
    return VAR; 
}

type{invalid_ch} {
    adjust();
    EM_LexWarning(EM_tokPos, "maybe you mean 'type'");
    return TYPE;
}

type { 
    adjust(); 
    return TYPE; 
}
import { 
    adjust(); 
    return IMPORT; 
}
primitive { 
    adjust(); 
    return PRIMITIVE; 
}

class { 
    adjust(); 
    return CLASS; 
}
extends { 
    adjust(); 
    return EXTENDS; 
}
method { 
    adjust(); 
    return METHOD; 
}
new { 
    adjust(); 
    return NEW; 
}

{id} { 
    adjust(); 
    yylval.sval = yytext; 
    return ID; 
}
{digit} { 
    adjust(); 
    yylval.ival = atoi(yytext); 
    return INT; 
}

"/*" {
    /* Comment start */
    adjust();
    comment_nest_layer++;
    BEGIN(comment);
    // printf("begin comment\n");
}
<comment>"/*" {
    adjust();
    comment_nest_layer++;
    BEGIN(comment);
}
<comment>"*/" {
    /* Comment end */
    adjust();
    comment_nest_layer--;
    if (comment_nest_layer == 0)
        BEGIN(INITIAL);
    // printf("end comment\n");
}
<comment>\n {
    adjust();
    EM_newline(); 
}
<comment>. {
    adjust();
    continue;
}

\" { 
    /* String start */
    adjust();
    str_buf_ptr = str_buf;
    str_buf_len = 0;
    BEGIN(string);
}
<string>\" {
    /* when seeing closed quote */
    adjust();
    BEGIN(INITIAL);
    *str_buf_ptr = '\0';
    yylval.sval = str_buf;
    //printf("%s\n", str_buf);
    return STRING;
}
<string>{octal}|{hex} {
    adjust();
    char ch[1];
    ch[0] = (char)atoi(yytext);
    str_buf_push(ch);
}
<string>\\n {
    adjust();
    str_buf_push("\n");
}
<string>\\t {
    adjust();
    str_buf_push("\t");
}
<string>\\r {
    adjust();
    str_buf_push("\r");
}
<string>"\\\"" {
    adjust();
    str_buf_push("\"");
}
<string>[^\\" \t\n]+ {
    adjust();
    str_buf_push(yytext);
}

. {
    adjust();
    EM_LexError(EM_tokPos, "illegal token");
}
%%

