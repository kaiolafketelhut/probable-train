# Makefile - probable-train - 8 unified MAINs - KDP + eal7 QUAD 84 + BOA IANA 1460172
# make all - builds everything from 0s and 1s to R data.frame to SQL trigger

CC=clang
BISON=bison
FLEX=flex
GO=go
SQLITE=sqlite3
PSQL=psql
RSCRIPT=Rscript
PYTHON=python3
BUILD=~/.qxd-build

all: dirs lex yacc rpc go r python sql pgsql
@echo "=== ALL 8 MAINs BUILT ==="
@echo "Nickname: KDPMember:KL5UQ4f48673352 | Code: KL5UQ4f48673352 | 84 flops | 8038 | BOA IANA 1460172"

dirs:
mkdir -p $(BUILD)

lex: MAIN.l
$(FLEX) -o $(BUILD)/main.yy.c MAIN.l
$(CC) -o $(BUILD)/kdp_lex $(BUILD)/main.yy.c
$(BUILD)/kdp_lex

yacc: main.y main.h
$(BISON) -d -o $(BUILD)/main.tab.c main.y
$(CC) -I. -I$(BUILD) -o $(BUILD)/kdp_yacc $(BUILD)/main.tab.c
$(BUILD)/kdp_yacc

rpc: MAIN.x rpc/kdp_main.c
@echo "--- RPC XDR (needs Debian proot) ---"
proot-distro login debian --bind $(HOME)/probable-train:/repo -- bash -c "apt update -qq && apt install -y -qq rpcsvc-proto libtirpc-dev && mkdir -p /tmp/r && cd /tmp/r && cp /repo/MAIN.x /repo/rpc/kdp_main.c . && rpcgen -h MAIN.x -o main.h && rpcgen -c MAIN.x -o main_xdr.c && gcc -I/usr/include/tirpc -I. kdp_main.c main_xdr.c -ltirpc -o kdp_xdr && ./kdp_xdr" < /dev/null || echo "rpcgen skipped (no proot)"

go: MAIN.go
$(GO) build -o MAIN.ximg MAIN.go || $(GO) build -o MAIN.ximg ./...
./MAIN.ximg & sleep 2; curl -s http://localhost:8038/matrix || true; pkill -9 MAIN.ximg || true

r: MAIN.r
$(RSCRIPT) MAIN.r

python: MAIN.py
$(PYTHON) MAIN.py

sql: MAIN.sql
rm -f eal7.db
$(SQLITE) eal7.db < MAIN.sql
$(SQLITE) eal7.db "SELECT * FROM flop_quadruple;"
$(SQLITE) eal7.db -header -column "SELECT * FROM matrix;"

pgsql: MAIN.pgsql
@echo "--- PostgreSQL PL/pgSQL ---"
initdb -D ~/pgdata -U $$(whoami) --auth=trust > /dev/null 2>&1 || true
pg_ctl -D ~/pgdata -l ~/pgdata/logfile start > /dev/null 2>&1 || true
sleep 2
createdb eal7 2>/dev/null || true
$(PSQL) eal7 < MAIN.pgsql
$(PSQL) eal7 -c "SELECT * FROM flop_quadruple;"
$(PSQL) eal7 -c "SELECT * FROM matrix;"

clean:
rm -rf $(BUILD) eal7.db MAIN.ximg *.yy.c *.tab.c *.tab.h
pg_ctl -D ~/pgdata stop 2>/dev/null || true

.PHONY: all dirs lex yacc rpc go r python sql pgsql clean
