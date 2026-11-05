# MedDefense Health Systems — Task 11: The TLS Audit

**Project:** 1x04 — Cryptographic Foundation
**Deliverable:** `11-tls_audit.md`
**Assessment baseline:** 5 November 2026
**Status:** Public SSL Labs comparison completed from user-supplied screenshots and detailed reports (5 November 2026); proposed MedDefense hardening not deployed. No production change was performed.
**Audience:** James Chen (Deputy CISO), Sarah Park (IT Director), Web Operations, Clinical stakeholders, DPO

## 1. SSL Labs Analysis — Two Real Public Hosts (Part 1)

**Evidence method and scope.** Public hostnames were assessed through [Qualys SSL Labs SSL Server Test](https://www.ssllabs.com/ssltest/) on **5 November 2026**. The grade screenshots and detailed certificate/protocol/cipher tables were supplied from the user's completed scans. The preferred **A+** example is `www.overleaf.com`; the **B** legacy example is `tls-v1-0.badssl.com`. The originally considered `cloudflare.com` was observed with **B** grades across four endpoints and was not used as the required A/A+ comparison. Results reflect the scanned endpoints and time, not a perpetual site-wide guarantee; multiple IPs or no-SNI configurations may differ. The tables below preserve reported results even when a high aggregate grade coexists with some weak suites.

**Direct SSL Labs report links:** [Overleaf](https://www.ssllabs.com/ssltest/analyze.html?d=www.overleaf.com) · [BadSSL TLS 1.0](https://www.ssllabs.com/ssltest/analyze.html?d=tls-v1-0.badssl.com). These links may initiate a new scan or display a newer result later.

### 1.1 Measured side-by-side comparison

| Required field | Strong example: `www.overleaf.com` | Weak example: `tls-v1-0.badssl.com` |
|---|---|---|
| Overall SSL Labs grade | **A+** (provided grade screenshot) | **B** (provided grade screenshot) |
| Report/test timestamp | **2026-11-05 05:04:50 UTC**; 83.836 s test | **2026-11-05 19:31:03 UTC**; 135.720 s test |
| Protocols accepted | **TLS 1.3 Yes**, TLS 1.2 Yes*; TLS 1.1/1.0/SSL 3/SSL 2 **No** | TLS 1.3 **No**; TLS 1.2 Yes*, TLS 1.1 Yes, TLS 1.0 Yes*; SSL 3/SSL 2 No |
| Key exchange / Forward Secrecy | TLS 1.3 advertises **X25519MLKEM768** hybrid post-quantum key exchange; TLS 1.2 ECDHE x25519; robust FS for most browsers | ECDHE **secp256r1**, DHE **2048-bit** with FS available; **static RSA** fallback suites lack FS; robust FS for most browsers |
| Strong cipher examples | TLS 1.3 **AES-128-GCM**, **AES-256-GCM**, **ChaCha20-Poly1305**; TLS 1.2 ECDHE_RSA with AES-GCM/ChaCha20 | TLS 1.2 ECDHE_RSA/DHE_RSA with **AES-128/256-GCM** |
| Weak offered cipher examples | Despite **A+**, supplied TLS 1.2 list includes **ECDHE_RSA_AES_CBC**, static **RSA_AES_GCM/CBC** and **RSA_3DES_CBC** (flagged **WEAK**) | TLS 1.2 list includes **ECDHE/DHE AES-CBC**, static **RSA AES-GCM/CBC**, **3DES-EDE-CBC**, and **Camellia-CBC** (flagged **WEAK**) |
| Leaf certificate / key | `CN=overleaf.com`; **RSA 2048-bit**, `SHA256withRSA`; issuer **WR3 (Google Trust Services)** | `CN=*.badssl.com`; **RSA 2048-bit**, `SHA256withRSA`; issuer **YR1 (Let's Encrypt)** |
| SAN and expiration | Includes `www.overleaf.com`, `overleaf.com` and multiple language/support domains; valid **21 Oct 2026–19 Jan 2027 UTC** | `*.badssl.com`, `badssl.com`; valid **29 Sep–28 Dec 2026 UTC** |
| Chain/trust and revocation | Three supplied certificates; chain issues **None**; trusted **Yes**; CRL status **Good (not revoked)**; Certificate Transparency **Yes** | Three supplied certificates; chain issues **None**; trusted **Yes**; CRL status **Good (not revoked)**; Certificate Transparency **Yes** |
| HSTS | **Yes:** `max-age=31536000; includeSubDomains`; not reported as browser-preloaded | **No**; not browser-preloaded |
| Main warnings/observations | Some TLS 1.2 suites still labeled **WEAK**; static RSA and 3DES offered in pasted data; OCSP stapling **No**; 0-RTT **No**; PQC key exchange **Supported** | Legacy TLS 1.0/1.1 caps grade **B**; TLS 1.3 absent; **BEAST not mitigated server-side** for TLS 1.0; legacy CBC/3DES/static RSA; HSTS **No**; OCSP stapling **No** |
| Other result | HTTP 302 to `/unsupported-browser` followed by HTTP 200; server software shown as nginx | HTTP redirect loop: repeated HTTP 301, **Too many Redirections**; server software shown as nginx/1.10.3 (Ubuntu) |

*`Yes*` = SSL Labs marked the protocol result as experimentally negotiated using **No-SNI**; do not overlook endpoint/SNI variation. The 3DES and static RSA entries are listed as **offered/flagged suites**, not evidence that every patient-style browser negotiates them. TLS 1.3 is not synonymous with AES-256-only: Overleaf supports secure 128-bit AES-GCM as well.

### 1.2 Overleaf certificate and chain evidence (A+ example)

- **Leaf:** `overleaf.com`, RSA 2048 / `SHA256withRSA`; serial `0698d003098c49f4126b2eea9cf1c026`; issuer `WR3`; SHA-256 fingerprint `226cbf414b68f6b5e4816094a65fc12c1341af117d15ca3d577990036ca3b584`.
- **Validity:** 21 October 2026 10:33:57 UTC to 19 January 2027 11:27:49 UTC; **trusted** by the tested common client stores. CRL-based revocation check says **Good** and CT says **Yes**; OCSP stapling was **No**.
- **Intermediates:** `WR3` (issued by `GTS Root R1`, RSA 2048, expires 20 Feb 2029) and a supplied `GTS Root R1` certificate (issued by `GlobalSign Root CA`, RSA 4096, expires 28 Jan 2028). The third supplied certificate is not assumed to be a self-signed trust anchor simply because its subject contains “Root”; SSL Labs reported **Chain issues: None**.
- **TLS suites and key exchange:** TLS 1.3 `TLS_AES_128_GCM_SHA256`, `TLS_AES_256_GCM_SHA384` and `TLS_CHACHA20_POLY1305_SHA256`; reported `X25519MLKEM768` hybrid group. TLS 1.2 prefers `TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256`, then ChaCha20-Poly1305 and AES-256-GCM, with **x25519** key agreement and FS. The report also lists weaker legacy TLS 1.2 alternatives (including 3DES and static RSA); **A+ is not proof that every offered suite is ideal**.
- **Additional controls:** HSTS present (`max-age=31536000; includeSubDomains`), TLS_FALLBACK_SCSV present, TLS compression off, RC4 off, robust FS for most clients, hybrid PQC key exchange supported. Reported 0-RTT disabled. SSL Labs' `PQC Key Exchange: Supported` describes supported handshake groups, **not a claim of post-quantum certificate signatures**.

### 1.3 BadSSL certificate and weak TLS evidence (B example)

- **Leaf:** wildcard `*.badssl.com`, RSA 2048 / `SHA256withRSA`; serial `065c62c1d5361bd7e6951263a67064063934`; issuer `YR1`; valid 29 September–28 December 2026 UTC; **trusted**, not revoked, CT present.
- **Chain:** three supplied certificates; `YR1` issued by `Root YR` (RSA 2048, expires 2 Sep 2028); the supplied `Root YR` is issued by `ISRG Root X1` (RSA 4096, expires 2 Sep 2032). SSL Labs reported **no chain issues**; the issuer names establish the certificate relationships.
- **Protocol support:** TLS 1.0, 1.1 and 1.2 offered, TLS 1.3 absent. SSL Labs 2025 rules cap TLS 1.0/1.1 hosts at **B**, independently of the leaf certificate being trusted.
- **Encryption/key exchange:** four AEAD suites include ECDHE/DHE RSA with AES-128/256-GCM (secp256r1 / 2048-bit DH, forward secrecy); numerous fallback **CBC**, **3DES**, **Camellia-CBC** and **static RSA** suites are marked weak. A static-RSA handshake does not provide forward secrecy, even when its symmetric cipher is AES-GCM.
- **Additional warnings:** server-side BEAST mitigation absent on the reported TLS 1.0 CBC suite (`0xc013`); HSTS off, OCSP stapling off, TLS_FALLBACK_SCSV present, RC4 off and SSLv3 off; no Heartbleed, ROBOT or POODLE vulnerability was reported. The HTTP test encountered repeated **301 redirects** and ultimately **Too many Redirections**, which is an HTTP routing issue rather than proof of invalid certificate cryptography.

### 1.4 Interpretation and lessons for MedDefense

1. **A+ vs B:** The essential difference for the assignment is modern TLS versions plus HSTS, versus acceptance of deprecated TLS 1.0/1.1; cipher choice and key-exchange fallback still deserve independent review even on an A+ host.
2. **Certificate trust is necessary but insufficient:** Both hosts have valid, trusted RSA-2048 certificates, yet one is rated B due to protocol weaknesses.
3. **No false inference:** BadSSL's confirmed 3DES/CBC/static-RSA exposure is **not evidence** that MedDefense offers those suites. The MedDefense baseline confirms TLS 1.0, not the entire BadSSL cipher list.
4. **Endpoint caveat:** The Overleaf grade screenshot and copied detailed report are preserved as user observations; without endpoint-identical full screenshots, do not assert every endpoint has exactly the same suite selection or grade.

## 2. MedDefense Patient Portal Assessment (Part 2)

### 2.1 Evidence from earlier projects

| Source | Established baseline | Interpretation |
|---|---|---|
| 1x02 **Finding 005**; 1x04 Task 0 | `web-srv-01` offers **TLS 1.0 and TLS 1.2**. | Legacy protocol supported; protocol downgrade and legacy-client exposure. |
| 1x04 Task 0 | TLS 1.3 not enabled; HSTS not configured; exact cipher suite inventory **not supplied**. | Modern protocol/HSTS hardening gaps are evidenced; weak cipher deployment is **not** established. |
| 1x02 **Finding 013**; 1x04 Task 0 | Let's Encrypt certificate was due to expire in **18 days relative to the original audit**; no automatic renewal. | Availability/trust continuity risk. Do **not** interpret “18 days” as a live countdown on 5 November 2026. |
| 1x04 Task 0 | OCSP stapling not configured. | Not proof of a certificate validation defect; issuing CA capabilities and client revocation behavior must be assessed. |

### 2.2 Predicted SSL Labs grade (hypothetical, not measured)

**Conditional prediction: at most B while TLS 1.0 is enabled**, and potentially lower due to additional as-yet-unknown issues. This **is not an SSL Labs grade**: the private name `portal.meddefense.local` cannot be tested from the public service, and the actual certificate trust/expiry, cipher suites, DH groups, server behavior, IPv4/IPv6 endpoints and vulnerability checks remain unverified. An expired or untrusted certificate could instead produce a trust-related failure grade. Absent TLS 1.3 and HSTS add documented warnings/grade limitations, but the strict TLS 1.0 cap already governs a hypothetical otherwise-good configuration.

**Factors lowering the rating or security posture:**

1. **Confirmed:** TLS 1.0 supported (2025 SSL Labs B cap).
2. **Confirmed:** TLS 1.3 absent (warning and protocol-grade cap under current methodology).
3. **Confirmed:** HSTS absent (warning and grade impact; HTTP-to-HTTPS downgrade protection unavailable to first-time HTTP users without preload).
4. **Confirmed operational risk:** no automated certificate renewal; impending expiry at original audit date. Imminent expiry alone is not an observed current failure or necessarily a grade penalty before expiry.
5. **Unverified:** legacy CBC, 3DES, RC4, RSA static key exchange, weak ECDHE/DHE parameters, missing forward secrecy, or weak signature algorithms. Scan before making any claim that they are enabled.
6. **Unverified:** chain completeness, hostname/SAN correctness, revocation status, secure renegotiation, software vulnerabilities and redirect behavior.

**Acceptance target:** no TLS 1.0/1.1, verified TLS 1.2 and TLS 1.3, AEAD-only strong suites, ECDHE forward secrecy, trusted valid certificate/full chain, enforced HTTPS, tested HSTS, automated renewal and alerts, clinical/client acceptance testing. A grade target of A/A+ is desirable but does not replace functional/security acceptance evidence.

### 2.3 Prioritized remediation and rollout

| Priority | Change | Owner / required evidence |
|---|---|---|
| P0 | Inventory server/load balancer/CDN TLS termination and every patient login URL; document which clients use TLS 1.0. | Sarah + web team + Clinical; config, client telemetry, exception register. |
| P0 | Confirm live certificate SAN, `notAfter`, trusted chain and key custody; create automatic ACME renewal for the **real public DNS name** (not `.local`). | Web team; renewal dry-run, post-renewal chain/hostname check and alerts. |
| P0 | Stage TLS 1.2+1.3 and strong ECDHE/AEAD cipher suites; disable TLS 1.0/1.1. | Web + IT; positive TLS 1.2/1.3 and **negative** TLS 1.0/1.1 checks. |
| P1 | Deploy HSTS with a short pilot max-age, then increase after validating all portal hostnames/redirects. | Web + DPO/Clinical; observed header on success and error responses. |
| P1 | Disable/review session tickets and 0-RTT; verify secure renegotiation behavior and software patch levels. | Web; config review, server tests and protocol checks. |
| P1 | Test on staging with supported browsers and medical workflows; define maintenance window, rollback and emergency patient access. | Clinical + Web; signed test matrix, restore point, rollback drill. |
| P1 | Rescan public **authorized** portal FQDN after go-live and monitor certificate renewal, expiry and TLS posture. | James + Sarah; report with endpoint grades and alert ownership. |

## 3. Recommended Hardened TLS Configuration — Nginx (Part 3)

**Template only:** The block below belongs inside an *existing* HTTPS `server {}` configuration on a supported Nginx/OpenSSL build. Replace hostname and certificate paths after verifying the real public FQDN and private-key custody. Do **not** deploy untested on production; TLS may actually terminate on a load balancer/CDN rather than this Nginx instance. The application proxy/routing and HTTP redirect live elsewhere in the existing configuration.

```nginx
# Stage-only Nginx HTTPS virtual-host excerpt; not a complete server.
server_name portal.example.org;  # placeholder, not MedDefense DNS
ssl_certificate /etc/nginx/tls/portal/fullchain.pem;
ssl_certificate_key /etc/nginx/tls/portal/privkey.pem;
ssl_protocols TLSv1.2 TLSv1.3;
ssl_ciphers ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256;
ssl_prefer_server_ciphers on;
ssl_conf_command Ciphersuites TLS_AES_256_GCM_SHA384:TLS_CHACHA20_POLY1305_SHA256:TLS_AES_128_GCM_SHA256;
ssl_ecdh_curve X25519:secp256r1;
ssl_session_cache shared:SSL:10m;
ssl_session_timeout 10m;
ssl_session_tickets off;
ssl_early_data off;
add_header Strict-Transport-Security "max-age=300" always;
server_tokens off;
```

**TLS 1.3 versus TLS 1.2:** `ssl_ciphers` sets the TLS 1.2-and-earlier suite list; `ssl_conf_command Ciphersuites` sets the TLS 1.3 preference where supported (Nginx 1.19.4+ with compatible OpenSSL). Verify with `nginx -V`, `nginx -t` and actual handshakes. The ECDSA entries require an appropriate EC certificate; the RSA entries are only usable if a separate RSA certificate is configured for compatibility after testing.

### 3.1 Justification of each setting

| Control / preference | One-sentence justification |
|---|---|
| TLS 1.2 and 1.3 only | Removes obsolete protocol negotiation while allowing currently supported TLS 1.2 clients. |
| TLS 1.3 `AES_256_GCM_SHA384` first | Uses authenticated encryption with a high-strength AES key; actual relative throughput is hardware-dependent. |
| TLS 1.3 `CHACHA20_POLY1305_SHA256` second | Offers authenticated encryption with strong performance on devices without AES acceleration. |
| TLS 1.3 `AES_128_GCM_SHA256` third | Provides a widely supported, efficient authenticated-encryption alternative with adequate modern strength. |
| TLS 1.2 ECDHE + AES-GCM or ChaCha20-Poly1305 only | Requires ephemeral key agreement and AEAD; excludes static RSA key exchange, 3DES, RC4 and legacy CBC suites. |
| `ssl_prefer_server_ciphers on` | Requests server-side preference for TLS 1.2 cipher selection; TLS 1.3 negotiation is a separate matter. |
| X25519 and P-256 | Provides modern, broadly interoperable ephemeral key-exchange groups. |
| Trusted full certificate chain | Lets the client build a trust path without assuming it has server intermediate certificates cached. |
| Session cache and timeout | Improves repeat-connection performance while bounding reuse of cached session parameters. |
| Session tickets off | Avoids additional ticket-key lifecycle and shared-key complexity in the initial hardened rollout. |
| Early data off | Avoids 0-RTT request replay exposure for authentication and state-changing portal endpoints. |
| HSTS `max-age=300` **pilot** | Allows safe initial verification of HTTPS-only behavior before committing patients to a long-lived policy. |
| HSTS production `max-age=31536000` | After full hostname/redirect validation, protects returning browsers against HTTP downgrade for a year; **do not** set `includeSubDomains` or `preload` without a scoped domain review. |
| `server_tokens off` | Avoids exposing detailed Nginx version in default error responses; it is minor information reduction, not a TLS fix. |
| Secure renegotiation | Do not invent an `ssl_renegotiation off` Nginx directive; verify current OpenSSL/Nginx behavior and reject obsolete/insecure protocol features through versions and patching. |

**HSTS after approved pilot:** update only the HSTS line to `add_header Strict-Transport-Security "max-age=31536000" always;` once every patient hostname and HTTPS workflow is confirmed. HTTP port 80 should redirect to HTTPS in the existing virtual-host config, with no sensitive data handled over plaintext. HSTS does **not** itself stop TLS protocol version downgrade; restricting the accepted TLS versions does.

### 3.2 Validation commands / acceptance tests (planned, NOT run on MedDefense)

Substitute the actual publicly trusted portal FQDN for `<FQDN>` and use the approved staging/public server only. The `-brief` commands should confirm negotiated protocols; rejected legacy handshakes can exit with an SSL/protocol error (no successful TLS session).

```bash
openssl s_client -connect '<FQDN>:443' -servername '<FQDN>' -tls1_3 -brief </dev/null
openssl s_client -connect '<FQDN>:443' -servername '<FQDN>' -tls1_2 -brief </dev/null
openssl s_client -connect '<FQDN>:443' -servername '<FQDN>' -tls1 -brief </dev/null
openssl s_client -connect '<FQDN>:443' -servername '<FQDN>' -tls1_1 -brief </dev/null
openssl s_client -connect '<FQDN>:443' -servername '<FQDN>' -verify_hostname '<FQDN>' -verify_return_error </dev/null
curl -I 'https://<FQDN>/'
```

Review both IPv4 and IPv6 addresses, OCSP/revocation behavior as supported by the issuing CA, the redirect and security headers, app functionality, mobile support, backend TLS (if TLS is terminated at a reverse proxy), expiry alarms and the full chain. These are **procedural tests**, not observed output.

## 4. TLS Downgrade Attack (Part 4, Four Sentences)

A TLS downgrade attack occurs when an active network adversary manipulates or disrupts connection negotiation to make endpoints use a weaker protocol than they would otherwise select. When both TLS 1.0 and TLS 1.2 are supported by a server, a **legacy or badly implemented client with insecure retry/fallback** could be induced to connect using TLS 1.0, exposing the session to weaker cryptography. This is **not automatic** against correctly implemented modern clients because TLS handshake integrity and downgrade protections can block such interference. MedDefense's simplest definitive server-side mitigation is to **disable TLS 1.0 and 1.1**, retaining only TLS 1.2/1.3 with authenticated modern cipher suites after compatibility testing.

## 5. Evidence Ledger / Completion Checklist

- [x] **A+** SSL Labs result for `www.overleaf.com`: grade screenshot and detailed certificate, protocol, key-exchange, cipher, HSTS and warning evidence (5 Nov 2026).
- [x] **B** SSL Labs result for `tls-v1-0.badssl.com`: grade screenshot and detailed certificate, protocol, key-exchange, cipher and warning evidence (5 Nov 2026).
- [x] MedDefense evidence: Finding 005 / Finding 013 and Task 0 inventory (historical, not live portal scan).
- [x] Conditional grade assessment and explicit unresolved cipher/certificate unknowns.
- [x] Hardened Nginx configuration and rationale, staging/rollback considerations.
- [x] Four-sentence TLS downgrade analysis with accurate limitations.
- [x] Replace all Part 1 live-scan placeholders with observed data; note endpoint/SNI uncertainties and the offered weak TLS 1.2 suites even on an A+ host.

## Sources and Traceability

1. [SSL Labs SSL Server Rating Guide, revision 2009r (May 2025)](https://github.com/ssllabs/research/wiki/SSL-Server-Rating-Guide) — rating methodology, B cap for TLS 1.0/1.1, TLS 1.3 and HSTS changes.
2. [Qualys grading changes, February 2025](https://notifications.qualys.com/product/2025/02/26/key-changes-in-ssl-labs-grading-and-qualys-certview) — policy context.
3. [Nginx `ngx_http_ssl_module` documentation](https://nginx.org/en/docs/http/ngx_http_ssl_module.html) — valid directives, TLS 1.3 cipher configuration, session ticket and early-data behavior.
4. [Nginx HTTPS server configuration](https://nginx.org/en/docs/http/configuring_https_servers.html) — certificate chains and secure private-key handling.
5. [Mozilla Web Security Guidelines](https://infosec.mozilla.org/guidelines/web_security.html) — compatibility-oriented TLS hardening.
6. [badssl.com](https://badssl.com/) — controlled legacy TLS endpoint examples.
7. [RFC 8996: Deprecating TLS 1.0 and TLS 1.1](https://www.rfc-editor.org/rfc/rfc8996.html) — protocol deprecation and downgrade-related risk reduction.
8. [MedDefense 1x04 Task 0](0-crypto_inventory.md); [1x02 Vulnerability Triage](../1x02_the_weak_links/16-triage.md) — historical site-specific risk evidence.

**Final reviewer warning:** Both SSL Labs grades and all public-host metrics are based on user-supplied scan evidence dated 5 November 2026; no grade or live MedDefense portal scan is invented. The Nginx configuration and risk treatments are proposed and untested on MedDefense production. Verify target Nginx/OpenSSL support, actual certificate paths, clinical compatibility and change approvals before deployment.
