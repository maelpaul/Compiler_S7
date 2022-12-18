#include "pile.h"

#include <stdlib.h>
#include <stdio.h>

/* remove and return the value of head */
int remove_head_value(pile * storage) {
	if (storage == NULL) {
		return -1;
	}
	int a = storage->head->value;
	element * drop = storage->head;
	storage->head = storage->head->next;
	drop->next = NULL;
	free(drop);
	return a;
}

/* add the value at head */
void add_value(pile * storage, int value) {
	element * tracker;

	if (value < 0 ) {
		fprintf(stderr, "Error\n");
		exit(-1);
	}
	
	/* otherwise insert it at head of storage with proper value */
	tracker = malloc(sizeof(element));
	tracker->value = value;
	tracker->next = storage->head;
	storage->head = tracker;
}

/* return head value */
int read_head_value(pile * storage) {
	if (storage->head == NULL) {
		return -1;
	}
	return storage->head->value;
}
