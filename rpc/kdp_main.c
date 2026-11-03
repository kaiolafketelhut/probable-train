/* kdp_main.c - encode the KDP profile with the XDR routines from main.x, decode it back, print it.
   build (Debian: apt install rpcsvc-proto libtirpc-dev):
     rpcgen -h main.x -o main.h && rpcgen -c main.x -o main_xdr.c
     gcc -I/usr/include/tirpc kdp_main.c main_xdr.c -ltirpc -o kdp_xdr */
#include <stdio.h>
#include <string.h>
#include <rpc/rpc.h>
#include "main.h"

int main(void)
{
    char nick[] = "KDPMember:KL5UQ4f48673352";
    char code[] = "KL5UQ4f48673352";
    char role[] = "Member";
    kdp_profile in = { nick, code, role, 1 };
    kdp_profile out;
    char buf[256];
    XDR enc, dec;

    memset(&out, 0, sizeof out);
    xdrmem_create(&enc, buf, sizeof buf, XDR_ENCODE);
    if (!xdr_kdp_profile(&enc, &in)) { puts("encode failed"); return 1; }
    unsigned len = xdr_getpos(&enc);

    xdrmem_create(&dec, buf, len, XDR_DECODE);
    if (!xdr_kdp_profile(&dec, &out)) { puts("decode failed"); return 1; }

    puts("=== KDP Forum Profile ===");
    printf("Nickname : %s\nCode     : %s\nRole     : %s\nPoints   : %d\n",
           out.nickname, out.code, out.role, out.points);
    printf("XDR      : %u bytes on the wire\n", len);
    xdr_free((xdrproc_t)xdr_kdp_profile, (char *)&out);
    return 0;
}
