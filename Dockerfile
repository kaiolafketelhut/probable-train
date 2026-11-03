# Dockerfile - BOA application/vnd.x-mosfetq-dos-image - KDP KL5UQ4f48673352 - 84 flops on 8038
FROM python:3.12-slim
WORKDIR /app
RUN apt-get update && apt-get install -y sqlite3 && rm -rf /var/lib/apt/lists/*
COPY Makefile MAIN.l main.y MAIN.r MAIN.py MAIN.sql MAIN.pgsql MAIN.ximg MAIN_8038.py MAIN.js MAIN.wat boa.json ./
RUN make json || true
EXPOSE 8038
CMD ["python3", "MAIN_8038.py"]
# BOA: application/vnd.x-mosfetq-dos-image IANA 1460172 PORT 8038 FLOP 4+16+64=84
