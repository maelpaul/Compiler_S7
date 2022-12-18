all		: src/myml

y.tab.h y.tab.c :	src/myml.y
			bison -y  -d -v  src/myml.y
lex.yy.c	:	src/myml.l y.tab.h
			flex src/myml.l
src/myml		:	lex.yy.c y.tab.c src/Table_des_symboles.c src/Table_des_chaines.c src/Attribut.c src/pile.c
			gcc -o src/myml lex.yy.c y.tab.c src/Table_des_symboles.c src/Table_des_chaines.c src/Attribut.c src/pile.c

test: src/test.c src/PCode.c
	gcc -std=c99 -Wall -o test src/test.c src/PCode.c

clean		:	
			rm -f 	lex.yy.c *.o y.tab.h y.tab.c src/myml *~ y.output test.p test
