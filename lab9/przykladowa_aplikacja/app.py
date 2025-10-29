from http.server import BaseHTTPRequestHandler, HTTPServer
import os

class Handler(BaseHTTPRequestHandler):
    def do_GET(self):
        msg = os.environ.get("MESSAGE", "Hello from ACA sample app")
        body = (msg + "\n").encode("utf-8")
        self.send_response(200)
        self.send_header("Content-Type", "text/plain; charset=utf-8")
        self.send_header("Content-Length", str(len(body)))
        self.end_headers()
        self.wfile.write(body)

def run():
    port = int(os.environ.get("PORT", "80"))
    with HTTPServer(("0.0.0.0", port), Handler) as httpd:
        httpd.serve_forever()

if __name__ == "__main__":
    run()
