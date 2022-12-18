/*
 *  Table des symboles.h
 *
 *  Created by Janin on 12/10/10.
 *  Copyright 2010 LaBRI. All rights reserved.
 *
 *  Associative array encoded as linked list of pair (symbol_name, symbol_value).
 *  To be used only with getter get_symbol_value and setter set_symbol_value.
 *
 *  Symbol_value_type (defined in Attribut.h) can be customized.
 *
 *  Symbol names must be valid sid from Table des chaines. 
 *
 */


#ifndef TABLE_DES_SYMBOLES_H
#define TABLE_DES_SYMBOLES_H


#include "Attribut.h"


#include "Table_des_chaines.h"

#include <stdio.h>



/* type of values stored with symbols */


/* get the symbol value of symb_id from the symbol table */
symb_value_type get_symbol_value(sid symb_id);

/* set the value of symbol symb_id to value */
symb_value_type set_symbol_value(sid symb_id,symb_value_type value);

/* add symbol at head */
symb_value_type add_symbol_value(sid symb_id,symb_value_type value); 

/* remove the head symbol */
symb_value_type remove_head();

#endif
