#!/usr/bin/env python3
import socket
import requests
from bs4 import BeautifulSoup
try:
    import dns.resolver
except ImportError:
    dns = None

def dns_recon(domain):
    try: print(f"IP Address: {socket.gethostbyname(domain)}")
    except Exception as error: print(f"DNS error: {error}")
    print("\nMX Records:")
    try:
        for record in dns.resolver.resolve(domain, 'MX'): print(f"  {record}")
    except Exception as error: print(f"MX error: {error}")

def web_recon(domain):
    try:
        response = requests.get(f"https://{domain}", timeout=5); soup = BeautifulSoup(response.text, 'html.parser')
        print(f"Status Code: {response.status_code}\n\nImportant Headers:")
        for header in ['Server', 'Content-Type']: print(f"  {header}: {response.headers.get(header, 'N/A')}")
        print(f"\nTotal Links Found: {len(soup.find_all('a'))}")
    except Exception as error: print(f"Web error: {error}")

def port_scan(domain):
    print(f"Scanning common ports on {domain}...\nOpen ports:")
    for port in [80, 443]:
        try:
            sock = socket.create_connection((domain, port), timeout=3); sock.close(); print(f"  Port {port}: OPEN")
        except Exception: pass
