# holbertonschool.com Shodan Report

## Target
Domain: holbertonschool.com

## Passive reconnaissance source
This report is based on passive reconnaissance using Shodan-style exposed-service research, DNS records, subdomains, and public IP information.

## IP ranges and exposed IPs
The domain and its subdomains resolve to several public cloud/CDN IP addresses, including:
- 75.2.70.75
- 99.83.190.102
- 63.35.51.142
- 52.85.96.82
- 52.85.96.95
- 13.36.10.99
- 13.37.98.87
- 13.38.122.220
- 18.66.196.8
- 34.203.198.145
- 44.214.9.111
- 54.157.56.129
- 54.86.136.129
- 54.89.246.137
- 104.16.53.111
- 151.139.128.10
- 192.0.78.131

## Technologies and services observed
- AWS Route 53 for DNS hosting
- AWS CloudFront / AWS-hosted infrastructure
- Google Workspace mail servers
- Cloudflare CDN on some services
- Webflow subdomains
- WordPress-related hosting
- Discourse-related staging subdomain
- Mailgun SPF configuration
- Stripe domain verification
- Dropbox domain verification
- Zapier domain verification
- Brevo domain verification
- Notion domain verification

## Notes
The infrastructure appears to rely heavily on cloud providers and CDN services. Several subdomains point to AWS-hosted services, while TXT records reveal third-party SaaS integrations used by the organization.
