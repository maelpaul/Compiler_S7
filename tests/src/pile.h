#ifndef PILE_H
#define PILE_H

#include <stdio.h>

/* linked element def */
typedef struct element {
    int value;
	struct element * next;
} element;

/* linked chain def */
typedef struct pile {
    element * head;
} pile;

/* remove and return the value of head */
int remove_head_value(pile * storage);

/* add the value at head */
void add_value(pile * storage, int value);

/* return head value */
int read_head_value(pile * storage);

#endif
