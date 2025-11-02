#!/bin/bash

BACKENDS=("http://10.94.1.21:8001" "http://10.94.1.22:8002" "http://10.94.1.23:8003")
cat > /root/elros_proxy.py <<'PY'
from http.server import BaseHTTPRequestHandler,HTTPServer
import urllib.request, itertools
servers = itertools.cycle(%s)
class H(BaseHTTPRequestHandler):
    def do_GET(self):
        target = next(servers)
        try:
            with urllib.request.urlopen(target+self.path) as r:
                data=r.read()
            self.send_response(200); self.end_headers()
            self.wfile.write(data)
        except Exception as e:
            self.send_response(502); self.end_headers()
            self.wfile.write(str(e).encode())
HTTPServer(('',80),H).serve_forever()
PY
python3 - <<'PY'
from pathlib import Path
BACKENDS=("http://10.94.1.21:8001","http://10.94.1.22:8002","http://10.94.1.23:8003")
s=Path('/root/elros_proxy.py').read_text()
s=s % (BACKENDS,)
Path('/root/elros_proxy.py').write_text(s)
PY
nohup python3 /root/elros_proxy.py >/root/elros.log 2>&1 &
echo "✅ Elros reverse proxy aktif (port 80, RR ke 3 Laravel)"
