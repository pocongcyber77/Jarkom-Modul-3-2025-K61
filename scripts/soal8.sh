#!/bin/bash

PORT=${PORT:-8004}
USER=noldor; PASS=silvan
cat > /root/php_worker.py <<PY
from http.server import BaseHTTPRequestHandler,HTTPServer
import base64
class H(BaseHTTPRequestHandler):
    def do_GET(self):
        auth=self.headers.get('Authorization','')
        if not auth.startswith('Basic '):
            self.send_response(401)
            self.send_header('WWW-Authenticate','Basic realm="Taman"')
            self.end_headers()
            return
        creds=base64.b64decode(auth.split()[1]).decode()
        if creds!="${USER}:${PASS}":
            self.send_response(403);self.end_headers();return
        self.send_response(200);self.end_headers()
        self.wfile.write(b"Host: "+bytes(__import__('socket').gethostname(),'utf-8')+b"\\n")
        self.wfile.write(b"X-Real-IP: "+bytes(self.headers.get('X-Real-IP','?'),'utf-8'))
HTTPServer(('',${PORT}),H).serve_forever()
PY
nohup python3 /root/php_worker.py >/root/php_worker.log 2>&1 &
echo " PHP Worker aktif port ${PORT}"
