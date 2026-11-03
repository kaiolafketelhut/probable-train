/* main.x - the KDP profile as an XDR / ONC RPC interface (for rpcgen).
   rpcgen -h main.x -o main.h   header with the types
   rpcgen -c main.x -o main_xdr.c   XDR encode/decode routines
   rpcgen main.x                also writes client and server stubs */

const KDP_STR_MAX = 64;

struct kdp_profile {
    string nickname<KDP_STR_MAX>;
    string code<KDP_STR_MAX>;
    string role<KDP_STR_MAX>;
    int    points;
};

program KDP_PROG {
    version KDP_VERS {
        kdp_profile KDP_GET(void) = 1;
    } = 1;
} = 0x20000001;
