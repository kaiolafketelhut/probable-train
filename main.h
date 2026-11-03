/* main.h - shared by lex/main.l, main.y, rpc - KDP + eal7 QUAD */
#ifndef KDP_MAIN_H
#define KDP_MAIN_H
struct kdp_profile {
    char nickname[64];
    char code[64];
    char role[32];
    int points;
    // eal7 extension from FEMoeneye
    char page[64];
    char event[32];
    double flops;
    char boa[64];
    int port;
};
extern struct kdp_profile kdp;
void kdp_store(const char *key, const char *value);
void kdp_print(void);
#endif
