#!/bin/bash

PORT=${PORT:-8001}
PALANTIR=10.94.3.11
cat > /root/worker.py <<PY
from http.server import BaseHTTPRequestHandler,HTTPServer
import urllib.request
PAL='http://$PALANTIR:8000/api/airing'
class H(BaseHTTPRequestHandler):
    def do_GET(self):
        if self.path=='/api/airing':
            data=urllib.request.urlopen(PAL).read()
            self.send_response(200); self.end_headers(); self.wfile.write(data)
        else:
            self.send_response(200); self.end_headers(); self.wfile.write(b"Laravel Worker")
HTTPServer(('',${PORT}),H).serve_forever()
PY
nohup python3 /root/worker.py >/root/worker.log 2>&1 &
echo "✅ Worker Laravel port ${PORT} aktif"
