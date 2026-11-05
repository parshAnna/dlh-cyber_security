# Task 4 — The Key Exchange

**Project:** 1x04 Cryptographic Foundation
**Organization:** MedDefense Health Systems
**Platform:** Fedora Linux / OpenSSL
**Scope:** Finite-field Diffie–Hellman (DH) simulation, explanation, MITM risk, and VPN authentication

## Executive Outcome

**Result: PASS.** Alice and Bob independently derived **identical 256-byte DH shared secrets** from their own private keys and the other party's public key. The observed `diff` exit code was **0**, and `diff -s` printed `Files alice_secret.bin and bob_secret.bin are identical`. This proves agreement in the local simulation; it does **not** prove peer authentication or demonstrate that an attacker can be detected.

**Evidence boundary:** The commands and observable output below were supplied from the Fedora terminal on **5 November 2026**. No raw private keys or derived secrets are reproduced in this report. The creation of `dhparams.pem` is supported by the subsequent key-generation results and the file listing; the original `openssl dhparam` console transcript and `openssl dhparam -check` result were not supplied.

## Part 1 — Diffie–Hellman Simulation

### 1. Isolate lab materials and generate shared DH parameters

The lab directory is outside the Git repository, with restrictive permissions. Run commands:

```bash
mkdir -p "$HOME/.local/share/meddefense-crypto/key_exchange"
chmod 700 "$HOME/.local/share/meddefense-crypto/key_exchange"
cd "$HOME/.local/share/meddefense-crypto/key_exchange"
umask 077
openssl dhparam -out dhparams.pem 2048
```

**Observed evidence:** `dhparams.pem` was present in the later file listing with size **428 bytes**. The DH parameter generation output itself was not included in the submitted terminal record. These shared parameters are **public**, unlike either party's private key.

### 2. Generate Alice's private and public keys

```bash
openssl genpkey -paramfile dhparams.pem -out alice_private.pem
openssl pkey -in alice_private.pem -pubout -out alice_public.pem
```

**Observed output:** No terminal output or error was displayed; both Alice key files were subsequently listed.

### 3. Generate Bob's private and public keys

```bash
openssl genpkey -paramfile dhparams.pem -out bob_private.pem
openssl pkey -in bob_private.pem -pubout -out bob_public.pem
```

**Observed output:** No terminal output or error was displayed; both Bob key files were subsequently listed.

**Observed key and parameter file listing:**

```text
-rw-------. 1 parshana parshana 806 Nov  5 13:54 alice_private.pem
-rw-------. 1 parshana parshana 804 Nov  5 13:54 alice_public.pem
-rw-------. 1 parshana parshana 806 Nov  5 13:54 bob_private.pem
-rw-------. 1 parshana parshana 804 Nov  5 13:54 bob_public.pem
-rw-------. 1 parshana parshana 428 Nov  5 13:53 dhparams.pem
```

Command used: `ls -lh dhparams.pem alice_*.pem bob_*.pem`.

### 4. Derive the secret from Alice's side

```bash
openssl pkeyutl -derive -inkey alice_private.pem \
  -peerkey bob_public.pem -out alice_secret.bin
```

**Observed output:** No terminal output or error was displayed. The command produced `alice_secret.bin`.

### 5. Derive the secret from Bob's side

```bash
openssl pkeyutl -derive -inkey bob_private.pem \
  -peerkey alice_public.pem -out bob_secret.bin
```

**Observed output:** No terminal output or error was displayed. The command produced `bob_secret.bin`.

### 6. Compare both derived secrets

```bash
diff alice_secret.bin bob_secret.bin
echo "Exit code: $?"
```

**Observed output:**

```text
Exit code: 0
```

A successful `diff` produces no difference output. The user additionally ran:

```bash
diff -s alice_secret.bin bob_secret.bin
wc -c alice_secret.bin bob_secret.bin
```

**Observed output:**

```text
Files alice_secret.bin and bob_secret.bin are identical
256 alice_secret.bin
256 bob_secret.bin
512 total
```

**Finding:** Both independently derived secrets are identical and 256 bytes (2,048 bits) long. This raw DH secret is not automatically an AES key; a real protocol derives appropriately sized session keys using a key-derivation function (KDF) and protocol context.

### Evidence and handling notes

- The two public keys and common parameters can be shared across an untrusted channel; the private keys must not be shared.
- The 256-byte shared secret is secret material and must not be printed, committed, or sent to third-party services.
- The local simulation used static DH key files for demonstration; real secure session protocols typically use ephemeral (EC)DHE keys to provide forward secrecy.
- No network transmission, active interception, certificate validation, or MITM exploit was executed in this task.

## Part 2 — Explanation for Robert Kim, CFO (six sentences)

Alice and Bob need to agree on a secret for secure communication, but sending the secret over an exposed network would allow an eavesdropper to copy it. They first agree on public mathematical parameters and each generates a private value that never leaves their own machine. Each person then shares a public value calculated from their private value. By combining their own private value with the other person's public value, both independently calculate the same shared secret—as the matching files in the lab confirm. Eve may see the public parameters and both public values, but computing the same secret from those alone is computationally infeasible when strong parameters and properly generated keys are used. Diffie–Hellman therefore solves the **key-agreement** problem, although it does not by itself prove that the received public value genuinely belongs to Alice or Bob.

## Part 3 — Man-in-the-Middle Risk (five sentences)

In unauthenticated Diffie–Hellman, Eve can intercept Alice's public value and replace it with her own before Bob receives it, while separately replacing Bob's public value on the way to Alice. Alice then derives one shared secret with Eve and Bob derives a different shared secret with Eve, while both may mistakenly believe they are communicating directly with one another. Eve can potentially decrypt, inspect, alter, and re-encrypt traffic passing between the two connections if the surrounding protocol lacks authenticated protection. If the MedDefense **Central–Westside VPN** used DH without authenticating its peers, a suitably positioned attacker could attempt this substitution, threatening clinical and operational traffic; **this is a conditional risk scenario, not a verified finding about the deployed VPN**. Validated certificates together with signatures or authenticated handshake mechanisms bind a trusted identity to the key exchange, causing an impersonator without the legitimate private authentication key to fail peer verification.

### Practical control for MedDefense

Require **mutual VPN endpoint authentication**, preferably certificate-based IKEv2/IPsec with trusted issuing CAs, correct peer identities, certificate validity/revocation checks, and secure private-key handling. In IKEv2, the `IKE_SA_INIT` phase performs DH, while `IKE_AUTH` authenticates the parties and the exchange; this is what blocks an unauthenticated DH substitution. Prefer supported strong DH/ECDH groups and ephemeral session keys, and verify the actual Central–Westside VPN configuration before asserting a compliance gap. A properly managed, high-entropy pre-shared key is also an IKEv2 authentication option, so certificates are not the only possible secure design.

## Verification Checklist

| Requirement | Evidence | Status |
|---|---|---|
| 2048-bit DH parameters | Parameter file observed, 428 B | Completed; console generation output unavailable |
| Alice key pair | Two PEM files observed | PASS |
| Bob key pair | Two PEM files observed | PASS |
| Alice derives using Bob's public key | `pkeyutl -derive` completed | PASS |
| Bob derives using Alice's public key | `pkeyutl -derive` completed | PASS |
| Derived secrets match | `diff` exit 0; `diff -s` identical | PASS |
| CFO-friendly explanation | Six sentences above | PASS |
| MITM and VPN analysis | Five sentences plus remediation | PASS |
| Evidence/secret separation | Key materials outside Git repository | PASS |

## References

1. OpenSSL, **pkeyutl manual** — shared-secret derivation: https://docs.openssl.org/master/man1/openssl-pkeyutl/
2. IETF, **RFC 7296 — Internet Key Exchange Protocol Version 2**, sections on `IKE_SA_INIT` and `IKE_AUTH`: https://www.rfc-editor.org/rfc/rfc7296.html
3. IETF, **RFC 8446 — TLS 1.3**, key exchange, certificate authentication, and handshake integrity: https://www.rfc-editor.org/rfc/rfc8446.html

**Repository deliverable:** `blue_team/1x04_crypto_foundation/4-key_exchange.md` — documentation only. All private keys, DH secrets, and temporary lab materials remain outside the repository.
