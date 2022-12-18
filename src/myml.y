
%{

  // header included in y.tab.h
#include "src/Attribut.h"  
#include "src/Table_des_symboles.h"
#include "src/pile.h"
#include <stdio.h>
#include <stdlib.h>

FILE * file_in = NULL;
FILE * file_out = NULL;
  
extern int yylex();
extern int yyparse();

void yyerror (char* s) {
   printf("\n%s\n",s);
 }

static int compteur = 0;

pile storage = {.head = NULL};

static int n = 0;

int c1() {
  return 2*n;
}

int c2() {
  return 2*n+1;
}

%}

%union {
  int val_int;
  double val_float; 
  void * val_id; 
  char * val_string;
}

%token <val_int> NUM <val_float> FLOAT <val_id> ID <val_string> STRING

%token PV LPAR RPAR LET IN VIR

%token IF THEN ELSE

%token ISLT ISGT ISLEQ ISGEQ ISEQ
%left ISEQ
%left ISLT ISGT ISLEQ ISGEQ


%token AND OR NOT TRUE FALSE
%left OR
%left AND



%token PLUS MOINS MULT DIV EQ
%left PLUS MOINS
%left MULT DIV
%left CONCAT
%nonassoc UNA    /* pseudo token pour assurer une priorite locale */

%type <val_string> let_def
%type <val_string> def_id
%type <val_string> def_fun
%type <val_string> fun_head
%type <val_string> comp

%start prog 
 


%%

 /* a program is a list of instruction */

prog : inst PV {printf("/* fin d'une instruction */\n");}

| prog inst PV {printf("/* fin d'une autre instruction */\n");}
;

/* a instruction is either a value or a definition (that indeed looks like an affectation) */

inst : let_def 
| exp {remove_head(); printf("DROP\n/* dropping useless value */\n"); compteur--;}
;



let_def : def_id {$$ = $1;}
| def_fun {$$ = $1;}
;

def_id : LET ID EQ exp {add_symbol_value($2, compteur); printf("/* valeur de %s stockée à fp + %d */\n", (char *) $2, compteur); compteur++; $$ = $2;}
;

def_fun : LET fun_head EQ exp {printf("une définition de fonction\n"); $$ = $2;}
;

fun_head : ID LPAR id_list RPAR {compteur++; $$ = $1;}
;

id_list : ID
| id_list VIR ID
;


exp : arith_exp 
| let_exp 
;

arith_exp : MOINS arith_exp %prec UNA {printf("MOINS\n");}
| arith_exp MOINS arith_exp {printf("SUBI\n");}
| arith_exp PLUS arith_exp {printf("ADDI\n");}
| arith_exp DIV arith_exp {printf("DIVI\n");}
| arith_exp MULT arith_exp {printf("MULTI\n");}
| arith_exp CONCAT arith_exp {printf("CONCAT\n");}
| atom_exp 
;

atom_exp : NUM {printf("LOADI(%d)\n", $1);}
| FLOAT {printf("LOADF(%lf)\n", $1);}
| STRING {printf("LOADS(%s)\n", $1);}
| ID {int n = get_symbol_value($1); if (n != -1) {printf("LOAD(fp + %d)\n/* lecture de %s à l'adresse fp + %d */\n", n, (char *) $1, n);} 
                                                  else {printf("/* Erreur de compilation : la variable %s n'est pas définie */\n", (char *) $1); exit(-1);}}
| control_exp
| funcall_exp
| LPAR exp RPAR
;

control_exp : if_exp
;


if_exp : if cond then atom_exp else atom_exp {printf("L%d:\n/* end if-then-else */\n", remove_head_value(&storage));}
;

if : IF
cond : LPAR bool RPAR; 
then : THEN {printf("/* case true */\n");}
else : ELSE {printf("GOTO(L%d)\n/* case false */\nL%d:\n", read_head_value(&storage), remove_head_value(&storage));}


let_exp : let_def IN exp {remove_head(); printf("DRCP\n/* replacing local symbol %s by expression result */\n", $1), compteur--;}
;

funcall_exp : ID LPAR arg_list RPAR
;

arg_list : arith_exp
| arg_list VIR  arith_exp
;

bool : TRUE {printf("TRUE\n");}
| FALSE {printf("FALSE\n");}
| bool OR bool {printf("OR\n");}
| bool AND bool {printf("AND\n");}
| NOT bool %prec UNA {printf("NOT\n");}
| exp comp exp {printf("%s\n/* condition loaded */\nIFN(L%d)\n/* negation condition tested */\n", $2, read_head_value(&storage));}
| LPAR bool RPAR
;


comp :  ISLT {$$ = "LT"; add_value(&storage, c2()); add_value(&storage, c1()); n++;}
| ISGT {$$ = "GT"; add_value(&storage, c2()); add_value(&storage, c1()); n++;}
| ISLEQ {$$ = "LEQ"; add_value(&storage, c2()); add_value(&storage, c1()); n++;}
| ISGEQ {$$ = "GEQ"; add_value(&storage, c2()); add_value(&storage, c1()); n++;}
| ISEQ {$$ = "EQ"; add_value(&storage, c2()); add_value(&storage, c1()); n++;}
;

%% 
int main (int argc, char *argv[]) {
  /* The code below is just a standard usage example.
     Of cours, it can be changed at will.

     for instance, one could grab input and ouput file names 
     in command line arguements instead of having them hard coded */

  stderr = stdin;
  
  /* opening target code file and redirecting stdout on it */
 file_out = fopen("test.p","w");
 stdout = file_out; 

 /* openng source code file and redirecting stdin from it */
 if (argc > 1) {
  file_in = fopen(argv[1], "r"); 
 }
 else {
  file_in = fopen("tests/test.ml","r");  
 }
 stdin = file_in; 

 /* As a starter, on may comment the above line for usual stdin as input */
 
 yyparse ();

 /* any open file shall be closed */
 fclose(file_out);
 fclose(file_in);
 
 return 1;
} 

