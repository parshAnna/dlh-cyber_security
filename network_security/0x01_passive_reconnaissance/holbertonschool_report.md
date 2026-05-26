# holbertonschool.com Shodan Report

## Target
Domain: holbertonschool.com

## Methodology
I used passive reconnaissance with DNS lookups and Shodan host lookups. No exploitation, scanning attack, or direct system access was performed.

## Shodan findings

### 75.2.70.75
Organization: Amazon.com, Inc.
Hostname: aacb0a264e514dd48.awsglobalaccelerator.com
Open ports: 80/tcp, 443/tcp
Technology: AWS Global Accelerator, nginx, HTTPS

### 99.83.190.102
Organization: Amazon.com, Inc.
Hostname: aacb0a264e514dd48.awsglobalaccelerator.com
Open ports: 80/tcp, 443/tcp
Technology: AWS Global Accelerator, nginx, HTTPS

### 192.0.78.131
Organization: Automattic, Inc.
Open ports: 80/tcp, 443/tcp
Technology: nginx, HTTPS, WordPress/Automattic shared infrastructure
Certificate issuer: Google Trust Services

### 198.202.211.1
Organization: Webflow, Inc.
Open ports: 80, 443, 2052, 2053, 2082, 2083, 2086, 2087, 2095, 6443, 8080, 8443, 8880
Technology: Webflow infrastructure, HTTPS, Google Trust Services certificate

### 104.16.53.111
Organization: Cloudflare, Inc.
Open ports: 80, 443, 2052, 2053, 2082, 2083, 2086, 2087, 2095, 6443, 8080, 8443, 8880
Technology: Cloudflare CDN and reverse proxy services

### 34.203.198.145
Shodan result: Access denied / 403 Forbidden
No detailed service information was available.

## Technologies identified
AWS Global Accelerator, Amazon AWS, Cloudflare, Webflow, Automattic, WordPress, nginx, HTTPS/TLS, Google Trust Services, Google Workspace, Mailgun, Stripe, Dropbox, Zapier, Brevo, and Notion verification records.

## Security observations
The domain uses several third-party cloud and SaaS providers. Some IP addresses are shared infrastructure, so unrelated hostnames may appear in Shodan results. The exposed services are mainly web-facing services such as 80/tcp and 443/tcp.

## Conclusion
holbertonschool.com appears to use distributed cloud infrastructure with AWS, Cloudflare, Webflow, and Automattic. The public exposure is mostly CDN-based and web-facing.
