/* MC102 Algoritmos e Programação de Computadores
 *  Laboratório 08: Superis Vincio Grandia
 *  Arquivo auxiliar: exemplo.c
 *  Descrição:   Este arquivo contem exemplos de uso das funções fornecidas
 */

#include "svg.h"
#include <math.h>

#define MAX_POINTS      500
#define MAX_OPERATIONS  60000
#define MAX_STYLE       256

#define MY_PI 3.14159265358979323846


void operation_copy(int n[], double p[][2], char s[], int cpn[], double cpp[][2], char cps[])
{
	int i;
  cpn[0] = n[0];
	for (i = 0; i < n[0]; i++)
	{
		cpp[i][0] = p[i][0];
		cpp[i][1] = p[i][1];
	}
  for (i = 0; s[i] != '\n'; i++)
  {
    cps[i] = s[i];
  } cps[i] = s[i];
}

// Realiza a lista de operações no polígono nps
void do_operations(int n[], double p[][2], char s[], int op_n[], double op_p[][2], char op_s[])
{
	int i;
	int n_print[1];
	double p_print[MAX_POINTS][2];
	char s_print[MAX_STYLE];
	int start = 0;
	for (i = 0; i < op_n[0]; i++)
	{
		if (op_s[i] == 'C')
		{
			if (start)
      {
				print_svg(n_print, p_print, s_print);
      }
			start = 1;
			operation_copy(n, p, s, n_print, p_print, s_print);
		}
		if (op_s[i] == 'T')
		{
			int j;
			for (j = 0; j < n_print[0]; j++)
			{
				p_print[j][0] = p_print[j][0] + op_p[i][0];
				p_print[j][1] = p_print[j][1] + op_p[i][1];
			}
		}
		if (op_s[i] == 'S')
		{
			int j;
			for (j = 0; j < n_print[0]; j++)
			{
				p_print[j][0] = p_print[j][0] * op_p[i][0];
				p_print[j][1] = p_print[j][1] * op_p[i][1];
			}
		}
    if (op_s[i] == 'R')
		{
			int j;
			for (j = 0; j < n_print[0]; j++)
			{
				p_print[j][0] = (p_print[j][0] * cos(op_p[i][0])) - (p_print[j][1] * sin(op_p[i][0]));
				p_print[j][1] = (p_print[j][0] * sin(op_p[i][0])) + (p_print[j][1] * cos(op_p[i][0]));
			}
		}


	}
  print_svg(n_print, p_print, s_print);
}


/* Esta função imprime um arquivo SVG ignorando as operações */
void file_demo(){
	/* Variáveis para armazenar todas as operações */
	int    op_n[1];
	double op_p[MAX_OPERATIONS][2];
	char   op_s[MAX_OPERATIONS];
	/* Variáveis que armazenam um polígono */
	int    n[1];
	double p[MAX_POINTS][2];
	char   s[MAX_STYLE];

	/* Lendo as operações */
	scan_svg(op_n,op_p,op_s);
	/* Operações armazenadas em (op_n,op_p,op_s) */

	/* Polígonos */
	scan_svg(n,p,s);
	while(n[0]>=0){
		scan_svg(n,p,s);
    do_operations(n,p,s,op_n,op_p,op_s);
		/* Ignorando operações e copiando polígono original */
	}
	close_svg();
}

int main(){
	int escolha = 0;
// 	escolha = 1;


	if(escolha == 0){
		file_demo();
	}

	return 0;
}
