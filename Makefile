# Makefile - probable-train - 8 unified MAINs
CC=clang
BISON=bison
FLEX=flex
GO=go
SQLITE=sqlite3
PSQL=psql
RSCRIPT=Rscript
PYTHON=python3
BUILD=~/.qxd-build
all: dirs lex yacc go r python sql
@echo "=== ALL MAINs BUILT === KDPMember:KL5UQ4f48673352 84 flops 8038"
dirs:; mkdir -p $(BUILD)
lex: MAIN.l; $(FLEX) -o $(BUILD)/main.yy.c MAIN.l; $(CC) -o $(BUILD)/kdp_lex $(BUILD)/main.yy.c; $(BUILD)/kdp_lex
yacc: main.y main.h; $(BISON) -d -o $(BUILD)/main.tab.c main.y; $(CC) -I. -I$(BUILD) -o $(BUILD)/kdp_yacc $(BUILD)/main.tab.c; $(BUILD)/kdp_yacc
go: MAIN.go; $(GO) build -o MAIN.ximg MAIN.go || $(GO) build -o MAIN.ximg ./...; echo "MAIN.ximg built"
r: MAIN.r; $(RSCRIPT) MAIN.r
python: MAIN.py; $(PYTHON) MAIN.py
sql: MAIN.sql; rm -f eal7.db; $(SQLITE) eal7.db < MAIN.sql; $(SQLITE) eal7.db "SELECT * FROM flop_quadruple;"
pgsql: MAIN.pgsql; psql eal7 < MAIN.pgsql; psql eal7 -c "SELECT * FROM flop_quadruple;"
clean:; rm -rf $(BUILD) eal7.db MAIN.ximg
