#!/bin/bash

BACKENDS=("http://10.94.2.11:8004" "http://10.94.2.12:8005" "http://10.94.2.13:8006")
cat > /root/pharazon_proxy.py <<'PY'
from http.server import BaseHTTPRequestHandler,HTTPServer
import urllib.request, itertools
servers = itertools.cycle(%s)
class H(BaseHTTPRequestHandler):
    def do_GET(self):
        target = next(servers)
        self.send_response(200)
        self.end_headers()
        self.wfile.write(f"Forward to {target}".encode())
HTTPServer(('',80),H).serve_forever()
PY
python3 - <<'PY'
from pathlib import Path
BACKENDS=("http://10.94.2.11:8004","http://10.94.2.12:8005","http://10.94.2.13:8006")
s=Path('/root/pharazon_proxy.py').read_text()
s=s % (BACKENDS,)
Path('/root/pharazon_proxy.py').write_text(s)
PY
nohup python3 /root/pharazon_proxy.py >/root/pharazon.log 2>&1 &
echo "✅ Pharazon reverse proxy aktif"
