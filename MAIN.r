# MAIN.r - the KDP profile as an R data frame + eal7 FLOP QUADRUPLE
# run: Rscript MAIN.r  or  R --slave -f MAIN.r

kdp_profile <- list(
  nickname = "KDPMember:KL5UQ4f48673352",
  code = "KL5UQ4f48673352",
  role = "Member",
  points = 1L,
  page = "main.ximg",
  event = "ximg_view",
  flops = 64,
  boa = "application/vnd.x-mosfetq-dos-image",
  port = 8038L,
  iana = 1460172L
)

# Parse like Yacc/Lex would
parse_kdp <- function(text) {
  lines <- strsplit(text, "\n")[[1]]
  rec <- list()
  for (ln in lines) {
    if (!grepl(":", ln)) next
    kv <- strsplit(ln, ":", fixed=TRUE)[[1]]
    k <- trimws(kv[1]); v <- trimws(paste(kv[-1], collapse=":"))
    rec[[tolower(k)]] <- v
  }
  rec
}

# FLOP QUADRUPLE logic from FEMoeneye main.ximg
flop_quadruple <- function(event) {
  switch(event,
    page_view = 4,
    fem_run = 16,
    ximg_view = 64,
    4)
}

# Simulate the BOA XIMG header
boa_header <- sprintf(
"BOA: %s\nIANA: %d\nPORT: %d flop quadruple\nFLOP: %.0f + %.0f + %.0f = %d",
  kdp_profile$boa, kdp_profile$iana, kdp_profile$port, 4, 16, 64, 84
)

cat("=== KDP Forum Profile + eal7 QUAD (R) ===\n")
cat(sprintf("Nickname : %s\nCode     : %s\nRole     : %s\nPoints   : %d\n",
            kdp_profile$nickname, kdp_profile$code, kdp_profile$role, kdp_profile$points))
cat(sprintf("Page     : %s\nEvent    : %s\nFlops    : %.0f\nBOA      : %s\nPort     : %d\n",
            kdp_profile$page, kdp_profile$event, kdp_profile$flops, kdp_profile$boa, kdp_profile$port))
cat(boa_header, "\n")
cat(sprintf("=== FLOP QUADRUPLE 4+16+64=%d on %d ===\n", 84, kdp_profile$port))

# Create data.frame like FEMoeneye matrix
df <- data.frame(
  page = c("main.ximg", "eal7.x", "eal7.html"),
  event = c("fem_run", "ximg_view", "page_view"),
  flops = c(16, 64, 4),
  stringsAsFactors = FALSE
)
df$total_flops <- cumsum(df$flops)
print(df)

# If plumber installed, serve on 8038
# plumber::pr() %>% pr_run(port=8038)
