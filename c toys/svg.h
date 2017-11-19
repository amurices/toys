/* MC102 Algoritmos e Programação de Computadores
 *  Laboratório 08: Superis Vincio Grandia
 *  Arquivo auxiliar: lab08.h
 *  Descrição:   Este arquivo contém as funções para ler e escrever elementos de SVG utilizados na tarefa.
 *               Cada função contém uma breve descrição sobre o seu objetivo, a saída esperada e uma pequena explicação dos parâmetros de entrada.
 *  Funcoes a serem utilizadas:
 *               scan_svg
 *               print_svg
 *               close_svg
 */

#include <stdio.h>

/* Funções auxiliares de uso interno. */

int cmp3(const char* f,char s[]){
	return s[0]==f[0]&&s[1]==f[1]&&s[2]==f[2];
}
int move_until(const char* f,char sop[],FILE*fop){
	int ret=0;
	char s[3]={0};
	while(!cmp3(f,s)){
		if(s[0]){
			if(sop) *sop++=s[0];
			if(fop) putc(s[0],fop);
			++ret;
		}
		s[0]=s[1];s[1]=s[2];s[2]=getchar();
	}
	return ret;
}

/* Funções fornecida para o laboratório. */

/*  Objetivo: função que lê atributos do arquivo SVG.
 *
 *  Entrada:  parâmetros que serão preenchidos com dados do SVG
 *  Saida:    a saída estara contida nos parametros
 */
void scan_svg(int n[],double p[][2], char s[]){
	int i;
	scanf("%c%c%c",&s[0],&s[1],&s[2]);
	if(cmp3("<?x",s)){
		printf("<?x");
		move_until("<!-",0,stdout);
		scanf("%*c ");
		i=0;
		do{
			scanf(" %c",&s[i]);
			if(s[i]=='S'||s[i]=='T')
				scanf(" %lf %lf ",&p[i][0],&p[i][1]);
			else if(s[i]=='R')
				scanf(" %lf ",&p[i][0]);
			else
				scanf(" ");
		}while(s[i++]!='-');
		move_until(">\n<",0,0);
		n[0] = i-1;
	}
	else if(cmp3("/sv",s)){
		move_until("g>\n",0,0);
		s[0] = '\0';
		n[0] = -1;
	}
	else if(cmp3("pol",s)){
		move_until("s='",0,0);
		for(i=0;scanf(" %lf%*c%lf ",&p[i][0],&p[i][1])==2;++i);
		n[0]=i;
		sprintf(s+move_until(">\n<",s,0),">\n");
	}
	else{
		sprintf(s+3+move_until(">\n<",s,0),">\n");
		n[0] = 0;
	}
}

/*  Objetivo: função que imprime um polígono no para um arquivo SVG.
 *
 *  Entrada: -  vetor n[] contem o numero de pontos
 *           -  vetor p[][2] contem as coordenadas dos pontos
 *           -  string s contem os atributos visuais
 *  Saida:    nenhuma
 */
void print_svg(int n[],double p[][2],char s[]){
	int i;
	if(n[0]>0){
		printf("<polygon points='");
		for(i=0;i<n[0];++i)
			printf("%.3f,%.3f ",p[i][0]+0.0f,p[i][1]+0.0f);
	}
	printf("%s",s);
}

/*  Objetivo: imprime o final de um arquivo SVG.
 *
 *  Entrada:  nenhuma
 *  Saida:    nenhuma
 */
void close_svg(){
	printf("</svg>\n");
}
