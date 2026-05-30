#!/usr/bin/env python3
import requests
from bs4 import BeautifulSoup
from urllib.parse import urljoin, urlparse, urldefrag

def crawl_website(start_url, max_depth=2):
    visited = set()
    base_domain = urlparse(start_url).netloc

    def crawl(url, depth):
        if depth > max_depth or url in visited:
            return
        if urlparse(url).netloc != base_domain:
            return
        try:
            response = requests.get(url, timeout=5)
            response.raise_for_status()
        except requests.exceptions.RequestException:
            return
        visited.add(url)
        soup = BeautifulSoup(response.text, 'html.parser')
        for link in soup.find_all('a', href=True):
            next_url = urljoin(url, link['href'])
            next_url = urldefrag(next_url)[0]
            if urlparse(next_url).netloc == base_domain:
                crawl(next_url, depth + 1)

    crawl(start_url, 0)
    return visited
