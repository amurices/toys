#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include "fila_circular.h"
Fila* criar_fila(void){
  Fila* f;
  f=(Fila*)malloc(sizeof(Fila));
  f->prox=f;
  f->ant=f;
  return f;
}
int fila_vazia(Fila* f){
  return f==f->prox;
}
void enfileira(Fila*f, int x){
  Fila* No;
  No=(Fila*)malloc(sizeof(Fila));
  No->dados=x;
  No->prox = f->prox;
  f->prox->ant=No;
  f->prox = No;
  No->ant=f;
}
int desenfileira(Fila* f){
  Fila* aux;
  int dado;
  aux=f->ant;
  f->ant=aux->ant;
  aux->ant->prox = f;
  dado=aux->dados;
  free(aux);
  printf("%d\n",dado);
  return dado;
}
void destruir_fila(Fila* f){
  while(!fila_vazia(f->prox)){
    desenfileira(f->prox);
  }
}
