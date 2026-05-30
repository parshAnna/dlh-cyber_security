#!/usr/bin/env python3
import socket
import requests
import dns.resolver
from bs4 import BeautifulSoup

def dns_recon(domain):
    try:
        print(f"IP Address: {socket.gethostbyname(domain)}")
    except Exception as error:
        print(f"DNS error: {error}")
    try:
        print("\nMX Records:")
        for record in dns.resolver.resolve(domain, 'MX'):
            print(f"  {record}")
    except Exception as error:
        print(f"MX error: {error}")

def web_recon(domain):
    try:
        response = requests.get(f"https://{domain}", timeout=5)
        soup = BeautifulSoup(response.text, 'html.parser')
        print(f"Status Code: {response.status_code}")
        print("\nImportant Headers:")
        for header in ['Server', 'Content-Type']:
            print(f"  {header}: {response.headers.get(header, 'N/A')}")
        print(f"\nTotal Links Found: {len(soup.find_all('a'))}")
    except Exception as error:
        print(f"Web error: {error}")

def port_scan(domain):
    print(f"Scanning common ports on {domain}...\nOpen ports:")
    for port in [80, 443]:
        try:
            sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
            sock.settimeout(3)
            result = sock.connect_ex((domain, port))
            sock.close()
            if result == 0:
                print(f"  Port {port}: OPEN")
        except Exception:
            pass
