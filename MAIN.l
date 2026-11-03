%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
static const char PROFILE[] = "Nickname : KDPMember:KL5UQ4f48673352\nRole : Member\nPoints : 1\nPage : main.ximg\nEvent : ximg_view\nFlops : 64\nBOA : application/vnd.x-mosfetq-dos-image\nPort : 8038\n";
static char nick[64], role[32], page[64], event[32], boa[64]; static int points, port; static double flops;
%}
%option noyywrap noinput nounput
ID [A-Za-z0-9:]+
%%
^"Nickname"[ \t]*":"[^\n]* { sscanf(strchr(yytext,':')+1," %63s",nick); }
^"Role"[ \t]*":"[^\n]* { sscanf(strchr(yytext,':')+1," %31s",role); }
^"Points"[ \t]*":"[^\n]* { points=atoi(strchr(yytext,':')+1); }
^"Page"[ \t]*":"[^\n]* { sscanf(strchr(yytext,':')+1," %63s",page); }
^"Event"[ \t]*":"[^\n]* { sscanf(strchr(yytext,':')+1," %31s",event); }
^"Flops"[ \t]*":"[^\n]* { flops=atof(strchr(yytext,':')+1); }
^"BOA"[ \t]*":"[^\n]* { sscanf(strchr(yytext,':')+1," %63[^\n]",boa); }
^"Port"[ \t]*":"[^\n]* { port=atoi(strchr(yytext,':')+1); }
\n|. ;
%%
int main(void){ YY_BUFFER_STATE b=yy_scan_string(PROFILE); yylex(); yy_delete_buffer(b);
 const char *code=strncmp(nick,"KDPMember:",10)==0?nick+10:nick;
 printf("=== KDP Forum Profile + eal7 QUAD (lex) ===\nNickname : %s\nCode : %s\nRole : %s\nPoints : %d\nPage : %s\nEvent : %s\nFlops : %.0f\nBOA : %s\nPort : %d\n",nick,code,role,points,page,event,flops,boa,port);
 return 0; }
