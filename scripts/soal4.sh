#!/bin/bash

PREFIX=10.94
if [[ $(hostname) == "Palantir" ]]; then
  mkdir -p /root/db
  cat > /root/db/data.json <<'EOF'
{"airing":[{"id":1,"judul":"One Ring"},{"id":2,"judul":"White Tree"}]}
EOF
  cat > /root/db/server.py <<'PY'
from http.server import BaseHTTPRequestHandler,HTTPServer
import json
class H(BaseHTTPRequestHandler):
    def do_GET(self):
        if self.path == '/api/airing':
            data=open('/root/db/data.json').read()
            self.send_response(200)
            self.send_header('Content-Type','application/json')
            self.end_headers()
            self.wfile.write(data.encode())
if __name__=="__main__":
    HTTPServer(('',8000),H).serve_forever()
PY
  nohup python3 /root/db/server.py >/root/db/log.txt 2>&1 &
  echo " Palantir DB Master aktif di port 8000"
fi

if [[ $(hostname) == "Narvi" ]]; then
  cat > /root/db_sync.sh <<'EOF'
#!/bin/bash
curl -s http://10.94.3.11:8000/api/airing -o /root/db_slave.json
EOF
  chmod +x /root/db_sync.sh
  /root/db_sync.sh
  echo " Narvi DB Slave sinkron dengan Palantir"
fi
