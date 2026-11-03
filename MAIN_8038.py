# MAIN_8038.py - serves /matrix on 8038 like Go main.ximg did, but from SQLite
import sqlite3, http.server, json
conn = sqlite3.connect('eal7.db')
class H(http.server.BaseHTTPRequestHandler):
    def do_GET(self):
        if self.path=='/matrix':
            cur=conn.cursor()
            cur.execute("SELECT * FROM matrix")
            rows=[dict(zip([c[0] for c in cur.description], r)) for r in cur.fetchall()]
            self.send_response(200); self.send_header('Content-Type','application/json'); self.end_headers()
            self.wfile.write(json.dumps({"KDP":"KDPMember:KL5UQ4f48673352","BOA":"application/vnd.x-mosfetq-dos-image","IANA":1460172,"PORT":8038,"FLOP_QUADRUPLE":"4+16+64=84","matrix":rows}).encode())
        else:
            self.send_response(200); self.end_headers(); self.wfile.write(b'KDP 8038 FLOP QUADRUPLE 84')
http.server.HTTPServer(('0.0.0.0',8038), H).serve_forever()
