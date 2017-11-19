#include <stdio.h>
#include <math.h>
#include <stdlib.h>
#include "fila_circular.h"
int main(){
	Fila* f;
	int dado, escolha;
	f=criar_fila();
	do{
		scanf("%d",&escolha);
		switch(escolha){
			case 1:
				/*adiciona um inteiro */
				scanf("%d",&dado);
				enfileira(f,dado);
				break;
			case 2:
				/* desenfileira um inteiro */
				dado=desenfileira(f);
				break;
		}
	} while (escolha != 0);
	destruir_fila(f);
	printf("Sistema encerrado.\n");

	return 0;
}
