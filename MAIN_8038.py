# MAIN_8038.py - Fixed - serves /matrix on 8038 from SQLite - KDP KL5UQ4f48673352 84 flops
import sqlite3, http.server, json, os
DB='eal7.db'
class H(http.server.BaseHTTPRequestHandler):
    def do_GET(self):
        self.send_response(200)
        self.send_header('Content-Type','application/json')
        self.send_header('Access-Control-Allow-Origin','*')
        self.end_headers()
        if self.path=='/matrix':
            con=sqlite3.connect(DB)
            cur=con.cursor()
            cur.execute("SELECT * FROM flop_quadruple")
            quad=dict(zip([d[0] for d in cur.description], cur.fetchone()))
            cur.execute("SELECT * FROM matrix")
            mat=[dict(zip([d[0] for d in cur.description], r)) for r in cur.fetchall()]
            con.close()
            self.wfile.write(json.dumps({"KDP":"KDPMember:KL5UQ4f48673352","code":"KL5UQ4f48673352","BOA":"application/vnd.x-mosfetq-dos-image","IANA":1460172,"PORT":8038,"FLOP_QUADRUPLE":"4+16+64=84","quadruple":quad,"matrix":mat}, indent=2).encode())
        else:
            self.wfile.write(b'{"KDP":"KL5UQ4f48673352","PORT":8038,"FLOP_QUADRUPLE":84,"endpoints":["/matrix"]}')
    def log_message(self, *a): pass

print("Serving KDP 84 flops on http://0.0.0.0:8038/matrix")
http.server.HTTPServer(('0.0.0.0',8038), H).serve_forever()
