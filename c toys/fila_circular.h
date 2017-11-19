typedef struct Fila{
  int dados;
  struct Fila* prox;
  struct Fila* ant;
} Fila;
Fila* criar_fila(void);
void destruir_fila(Fila* f);
void enfileira(Fila*f, int x);
int desenfileira(Fila* f);
int fila_vazia(Fila* f);
void recursiva(Fila * f);
