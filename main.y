%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "main.h"
int yylex(void); void yyerror(const char *msg);
struct kdp_profile kdp = {.points=1,.flops=64,.port=8038};
static const char *src =
"Nickname : KDPMember:KL5UQ4f48673352\n"
"Code : KL5UQ4f48673352\n"
"Role : Member\n"
"Points : 1\n"
"Page : main.ximg\n"
"Event : ximg_view\n"
"Flops : 64\n"
"BOA : application/vnd.x-mosfetq-dos-image\n"
"Port : 8038\n";
%}
%union { char *s; }
%token <s> KEY VALUE
%%
profile : fields ;
fields  : field | fields field ;
field   : KEY ':' VALUE { kdp_store($1,$3); free($1); free($3); } ;
%%
char *copy_n(const char *s,size_t n){char *p=malloc(n+1); memcpy(p,s,n); p[n]=0; return p;}
int yylex(void){
 static int state=0; const char *s; size_t n;
 while(*src==' '||*src=='\n'||*src=='='||*src=='-'||*src=='+')src++; if(*src==0)return 0;
 if(strncmp(src,"KDP Forum",9)==0||strncmp(src,"KDP Forum Profile",16)==0){while(*src&&*src!='\n')src++; return yylex();}
 if(state==0){s=src; while(*src&&*src!=' '&&*src!=':'&&*src!='\n')src++; if(src==s)return *src++; yylval.s=copy_n(s,src-s); state=1; return KEY;}
 if(state==1){if(*src==':'){src++; state=2; return ':';} return *src++;}
 s=src; while(*src&&*src!='\n')src++; n=src-s; while(n>0&&(s[n-1]==' '||s[n-1]=='\r'))n--; yylval.s=copy_n(s,n); state=0; return VALUE;
}
void yyerror(const char *msg){fprintf(stderr,"parse error: %s\n",msg);}
void kdp_store(const char *k,const char *v){
 if(strcmp(k,"Nickname")==0) snprintf(kdp.nickname,sizeof kdp.nickname,"%s",v);
 else if(strcmp(k,"Code")==0) snprintf(kdp.code,sizeof kdp.code,"%s",v);
 else if(strcmp(k,"Role")==0) snprintf(kdp.role,sizeof kdp.role,"%s",v);
 else if(strcmp(k,"Points")==0) kdp.points=atoi(v);
 else if(strcmp(k,"Page")==0) snprintf(kdp.page,sizeof kdp.page,"%s",v);
 else if(strcmp(k,"Event")==0) snprintf(kdp.event,sizeof kdp.event,"%s",v);
 else if(strcmp(k,"Flops")==0) kdp.flops=atof(v);
 else if(strcmp(k,"BOA")==0) snprintf(kdp.boa,sizeof kdp.boa,"%s",v);
 else if(strcmp(k,"Port")==0) kdp.port=atoi(v);
}
void kdp_print(void){
 printf("=== KDP Forum Profile + eal7 QUAD (yacc fixed) ===\n");
 printf("Nickname : %s\nCode     : %s\nRole     : %s\nPoints   : %d\n",kdp.nickname,kdp.code,kdp.role,kdp.points);
 printf("Page     : %s\nEvent    : %s\nFlops    : %.0f\nBOA      : %s\nPort     : %d\n",kdp.page,kdp.event,kdp.flops,kdp.boa,kdp.port);
 printf("=== FLOP QUADRUPLE 4+16+64=84 on %d ===\n",kdp.port);
}
int main(void){if(yyparse()!=0)return 1; kdp_print(); return 0;}
