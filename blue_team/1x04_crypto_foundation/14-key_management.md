# MedDefense Health Systems — Task 14: Hardware Security and Key Management

**Project:** 1x04 — Cryptographic Foundation

**Deliverable:** `14-key_management.md`

**Assessment date:** 5 November 2026

**Audience:** James Chen (Deputy CISO), Sarah Park (IT Director), Robert Kim (CFO), EHR clinical data owner, DPO, backup/network operations and Board

**Status:** Proposed key-management architecture and pricing/risk decision; **not an implemented MedDefense production control**.

## Executive decision

Adopt a **centralized, access-controlled KMS with hardware-protected keys where affordable**, envelope encryption for sensitive patient data and backups, **TPM-backed device encryption** on employee laptops, and a separate, tested offline recovery channel. **Do not store plaintext master keys or recovery passphrases on NAS-01 or the server holding the ciphertext.** Start with a narrowly scoped, managed multi-tenant HSM-backed KMS evaluation, not a dedicated HSM cluster. A cloud KMS key billed at ~$1/month and a dedicated HSM billed by the hour are **not the same product or assurance/cost model**.

**Evidence boundary:** Task 12 demonstrated LUKS2 on safe 500 MiB and 128 MiB Fedora *lab files*; Task 13 recommended encryption levels; Task 10 generated an internal `.local` *lab CSR*, not an issued public portal certificate. None proves that EHR, NAS-01 or the patient portal has been migrated in production. The VPN's reported AES-256/SHA-256/IKEv2/DH14 baseline is contextual and needs live configuration verification. The following is MedDefense's **target-state Key Management Plan**.

## Part 1 — Technology comparison (Security+ 1.4)

| Technology | What It Is | What It Protects / Limitations | Typical Cost (USD, indicative) | Typical Deployment | MedDefense fit |
|---|---|---|---|---|---|
| **TPM (Trusted Platform Module, TPM 2.0)** | Host-bound secure cryptographic processor for protected key material, device measurements and sealed secrets. | Protects endpoint/device-bound keys against straightforward offline extraction; an unlocked, compromised OS can still request authorized use, so TPM alone is **not** an enterprise multi-tenant key vault. | **$0 marginal** where already fitted; discrete module/replacement is vendor- and platform-specific (obtain quote). | Windows BitLocker, eligible Linux LUKS2 unlock, secure/measured boot and endpoint identity. | **Recommended** for managed employee laptops, subject to hardware inventory and recovery-key escrow. |
| **HSM (Hardware Security Module)** | Tamper-resistant hardware that generates, stores and uses protected keys; dedicated, shared cloud, or on-prem appliance. | Strong isolation for **KEKs/root keys** and high-value signing keys; does **not** automatically prevent data theft by an authorized application that obtains plaintext DEKs or database query results. | **Shared cloud HSM-backed KMS:** e.g. Google Cloud symmetric HSM key version **$1/month**, certain asymmetric versions **$2.50/month**, plus operations; **dedicated** AWS CloudHSM example **$1.60/HSM/hour**, often multiple HSMs; on-prem purchase/support needs a quote. | Central database/backup master-key protection, signing services, regulatory requirements; cloud service integration must be validated. | **Pilot managed HSM-backed keys**, defer dedicated cluster under current budget. |
| **Secure enclave / TEE** | Hardware-isolated execution/key area integrated into a supported device, e.g. Apple's Secure Enclave. | Hardware-protected device private keys, authentication, local secrets; app permissions, OS interfaces and hardware differences still matter; **not** a general replacement for enterprise database KMS. | Usually **bundled with compatible device** (no separate per-key fee); device acquisition and platform integration extra. | Mobile/Apple device biometrics, device identity and app key operations. | **Use if supported on managed endpoints**; not a universal requirement for `ehr-db-01`. |
| **KMS (Software / managed service)** | Central lifecycle service for generation, RBAC, wrapping/unwrapping, versioning, monitoring and policy; may use software protection **or HSM underneath**. | Reduces sprawl of plaintext secrets and centralizes audits; protection strength depends on backing hardware, IAM, workload identities, availability, logging and administrator controls. | Google Cloud **software** symmetric key version ~$0.06/month; AWS customer-managed KMS key **$1/month** plus requests/rotation-related charges; self-hosted licensing/operations vary. | Cloud-native storage keys, on-prem applications via authenticated APIs, backup envelope encryption, TLS key integration when supported. | **Primary operational layer**; HSM-backed KEK for highest-value workloads if justified. |

**Pricing interpretation (5 November 2026):** Published cloud list prices are examples, not MedDefense quotes, local tax calculations or a guarantee of regional suitability. Google Cloud HSM-backed key-version pricing is per **active version**; AWS KMS bills per customer-managed key, while AWS CloudHSM bills per provisioned device-hour. A software KMS can itself use an HSM; these four entries describe distinct **interfaces/architectures**, not four mutually exclusive products. [S1–S6]

**Selection in one sentence each:** Use a TPM for **one device's boot/drive key**, an HSM for **high-value organization-wide master/signing keys**, a secure enclave for **supported endpoint-local non-exportable keys**, and KMS for **central enterprise policy, audit and rotation** regardless of whether its root keys are hardware protected.

### 1.1 Why hardware is not enough

- **Encryption at rest** protects stolen powered-off media; once a legitimate service mounts a volume and can decrypt records, host or application compromise may disclose plaintext.
- A **key-encryption key (KEK)** or root/master key belongs inside a restricted KMS/HSM; a **data-encryption key (DEK)** encrypts the records/files and is stored only **wrapped**, or briefly in the authorized service's memory. Do not log plaintext keys.
- Separate **production, test and recovery keys**, and separate EHR, NAS/offsite, billing, portal and VPN cryptographic domains; never reuse an arbitrary general-purpose shared AES key.
- A cloud provider's managed HSM does not automatically provide MedDefense-exclusive possession of physical hardware; understand tenant isolation, audit access, exportability and contractual/data-residency controls.

## Part 2 — MedDefense Key Management Plan

### 2.1 Governance and key inventory

The **1x03 Task 4 RACI** remains the authority: **James Chen** proposes security policy and leads incidents; **Sarah Park** owns implementation and IT change control; the **Security Analyst** validates controls and reviews alerts; the **CEO** approves funding and any exceptional high/critical residual-risk acceptance; **Robert Kim** verifies affordability and financial exposure. Clinical data owners authorize EHR uses, the DPO/Legal reviews personal-data handling, and vendor/Biomedical clearance is mandatory for medical devices. These are **proposed assignments awaiting formal approval**.

Maintain a restricted asset/key register with: `Key ID`, asset and business owner, purpose, type/algorithm, environment, protection level, KMS/HSM location/region, authorized service identities, human custodians, creation/activation/retirement dates, cryptoperiod, escrow and recovery location, backup dependency, last rotation/test, audit-log destination, and incident/change tickets. Store **references and metadata only**, never plaintext secret values or passphrases.

### 2.2 Per-system key location, access, rotation, compromise and loss

| System / key type | Where key is stored (target state) | Who may access/use it | Rotation frequency / process | If compromised | If lost / recovery |
|---|---|---|---|---|---|
| **EHR PostgreSQL `ehr-db-01`** — LUKS volume unlock material; selective application PHI DEKs/KEKs | **Volume:** LUKS2 header on storage, unlock secret through an authenticated central secret/KMS workflow with a **separate offline recovery escrow**, **not plaintext on DB host**. **Records:** per-scope DEKs generated inside approved app; **wrapped DEKs** with records, **non-exportable KEK in managed HSM-backed KMS** if selected. | EHR service identity can invoke narrowly scoped unwrap **only for authorized workflows**; Sarah's designated DB/backup operators can administer approved changes **without direct raw KEK export**; James approves policy, Security Analyst audits; clinical owner approves data entitlements. | **KEK yearly review/rotation target**, create fresh key version and rewrap DEKs; new DEKs per logical record/object or controlled data scope. Volume-key change requires a **tested re-encryption/migration plan**; merely changing a LUKS passphrase does **not** rotate the underlying volume master key. | Disable abused identity/grants, contain host, preserve audit evidence; issue fresh KEK/DEKs, rewrap or re-encrypt affected ciphertext, reestablish app access and evaluate GDPR/clinical exposure with DPO. | Two-person approved emergency retrieval of escrowed recovery key, isolated restoration test of encrypted EHR+WAL+backups; if **all** volume keys/escrow copies or required DEK KEKs are irrecoverably lost, ciphertext may be unrecoverable. |
| **NAS-01 and immutable offsite backups** — volume unlock + separate per-backup DEK/KEK | NAS volume LUKS-equivalent unlock outside NAS; each backup object encrypted **before** leaving the trusted backup client using per-object DEK; wrapped by **MedDefense-controlled recovery KEK in KMS/HSM**; an **offline, separately governed escrow** remains reachable during vendor outage. **NOT on the NAS itself.** | Dedicated backup service may **encrypt** new backups; only separately approved **restore** identity may unwrap for recovery; Sarah operates service, James authorizes exceptional emergency access and DPO/clinical owner consulted for PHI. No NAS admin should automatically be KMS recovery admin. | New DEK **per backup set/object**; annual KEK review/rotation with old versions retained **decrypt-only** through retention; test restores every quarter and after key changes; volume re-encryption planned separately. | Revoke tokens, isolate NAS/repository; rotate KEK, rewrap DEKs and **re-encrypt if DEK or plaintext was exposed**; preserve immutable copies, check attacker ability to access already-unlocked volume. | Two independent custodians and geographically separate encrypted recovery kit; restore in isolated environment using escrowed key versions and backup manifest; loss of the **last** KEK/DEK means permanent loss of corresponding ciphertext. |
| **Patient portal TLS** — private certificate signing key | New certificate's private key in controlled reverse-proxy secret store **or HSM-backed TLS key provider if compatible**; public CA-issued cert/chain on proxy. Task 10 `.local` lab CSR/key must **never** be used for a public portal; obtain a verified real DNS name first. | Web reverse-proxy service can use key for handshake; small named web/PKI operator group under Sarah can deploy, James audits; no app developer/private personal key copy. | Monitor **daily**; automate issuance/renewal within CA's validity rules, trigger renewal well **before expiry**, deploy+test SAN/chain/TLS and retain short rollback window; **new private key with each reissuance** by default. | Stop using compromised private key, revoke/reissue cert where supported, replace key and deployments, investigate logs and notify affected parties as appropriate; revocation alone does not repair an already compromised endpoint. | **Generate new key and CSR, reissue certificate** after ownership validation. Private signing key generally **not escrowed**; do not rely on recovering it. A failed portal renewal requires pre-tested rollback/alternate node, not unsafe TLS downgrade. |
| **FortiGate VPN tunnels** — IKEv2 auth key/certificate + negotiated SA session keys | Device-protected FortiGate keystore for identity private key (TPM/HSM-backed only **if device supports**); public cert chain via PKI. Short-lived IKE/CHILD SA keys negotiated in appliance memory; no long-term SA keys in repo. If legacy pre-shared key exists, unique high-entropy PSK in restricted enterprise vault, **not in shared config**. | Named network administrators under Sarah; separate security reviewers under James; VPN peers use cryptographic operations; no shared privileged accounts. | IKE/CHILD SAs **rekey automatically on vendor-validated lifetimes** (e.g., review 24h IKE / 1–8h CHILD as *planning targets*, not a verified current setting); identity cert annually/at expiry and after compromise; replace PSK with certificate auth where supported. | Revoke/replace peer certs or PSKs at **both ends**, terminate affected sessions, rotate credentials and inspect traffic/AD lateral movement under RISK-002; schedule failover to preserve clinical sites. | Reprovision identity cert from authorized CA or recover *escrowed network-configuration secrets* from separate vault; do not escrow ephemeral session keys; use documented secondary tunnel/failover if endpoint key lost. |
| **Billing MySQL (supporting Task 13)** — tablespace master/keyring key | MySQL-supported keyring/KMS integration or secure volume; **not plaintext in `my.cnf`**, scripts or on same disk. | Restricted MySQL service identity plus Sarah-approved DBA changes; Robert Kim owns revenue continuity risk. | Annual keyring KEK rotation according to verified engine/version support; test tablespace, redo/binlog and logical backup restore. | Revoke identity and rotate master, rewrite/re-encrypt affected data, investigate exposed billing records and reconcile backups. | Restore keyring backup from dual-controlled encrypted escrow before database restore; without correct key versions encrypted tablespaces may be unreadable. |
| **Employee endpoints (supporting)** — BitLocker/LUKS unlock keys | Device **TPM 2.0** when supported; recovery keys escrowed in restricted corporate endpoint directory/vault, never solely on device. | Individual user for daily unlock; nominated endpoint recovery operator with ticketed just-in-time access. | Key and recovery protector on reassignment, suspicion, TPM swap or exposure; periodic policy review, not forced full-drive re-encryption without risk justification. | Suspend device trust, revoke credentials, rotate protector/rekey as required and remotely contain. | Retrieve centrally escrowed recovery key with identity verification and audit; without recovery material a lost TPM/drive may render contents unavailable. |

**Hard boundary:** HSM/KMS access is controlled by **workload identity**, mTLS/private networking where supported, shortest practical token TTL, least-privilege API rights, MFA and just-in-time access for people. Do **not** give James, Sarah or the Security Analyst default all-powerful decrypt access solely because of their job title; dual-control break-glass procedures require a ticket and independent approver.

### 2.3 Key lifecycle: create → store → use → rotate → revoke → recover → destroy

1. **Generate:** use approved CSPRNG inside HSM/KMS/TPM or an authorized app for DEKs; inventory the purpose, cryptoperiod, owner and environment, and ensure test/production isolation.
2. **Provision:** bind key operations to approved workload identities, service principals, regions and cryptographic context; use separation of duties between key administrators and decrypt users.
3. **Protect:** KEKs non-exportable when supported; encrypted/wrapped DEKs may be stored alongside ciphertext; do not put secret material in Git, NAS shares, config files, tickets or logs.
4. **Use:** require authorization and audit every unwrap/sign/change operation, monitor unusual decrypt frequency, and restrict privileged service egress to the KMS endpoint.
5. **Rotate:** create new key version, change encrypt/wrap target to new version, retain older versions for legitimate **decrypt-only** operation during data retention, rewrap/re-encrypt as required, then test downtime and restore before deletion.
6. **Revoke:** remove compromised identities/key permissions immediately; for TLS/VPN revoke and replace affected certificates/PSKs, and remember that revoking a wrapping key **alone does not make copied plaintext safe again**.
7. **Recover:** perform a documented, two-person approved break-glass from independent escrow; restore KMS permissions, wrapped DEK maps, LUKS headers/keyslots, backup manifests and snapshots in an isolated site; run clinical workflow and checksum tests.
8. **Retire and destroy:** verify retention holds and *all* encrypted copies are migrated or lawfully expired, approve deletion under dual control, log destruction, and prevent deletion of the sole readable key version.

**Emergency key compromise playbook:** (a) Security Analyst opens an incident and preserves relevant KMS/host logs; (b) James assesses severity and orders containment, DPO/Legal checks breach obligations; (c) Sarah freezes affected services/identities while coordinating clinical continuity; (d) key custodians revoke permissions and create replacement material; (e) application/backup owners rewrap or re-encrypt, restore and verify; (f) document exposure window, time to recovery, corrected access policy and risk-register change. Distinguish **key exposed**, **key merely suspected**, **ciphertext stolen**, and **plaintext exfiltrated** rather than treating them as equivalent.

**Emergency key loss playbook:** do not destroy remaining versions; invoke documented dual-control escrow; bring up isolated recovery host and KMS access, recover correct historical KEK/keyslot and wrapped DEKs, test EHR read, NAS offsite restore, billing consistency and VPN failover; if recovery impossible, formally record unrecoverable ciphertext and clinical/business continuity consequences. **Availability and clinical safety** override arbitrary rotation deadlines; require signed exception and compensating controls.

### 2.4 Required monitoring and acceptance tests

| Control / metric | Target acceptance evidence | Owner |
|---|---|---|
| Key inventory completeness | Every production data store and encrypted backup references approved key ID, owner, cryptoperiod and escrow status | Sarah / Security Analyst |
| Key authorization | Denied decrypt/unwrap by unauthorized workload; approved service can operate without admin plaintext key access | Security Analyst validates; Sarah implements |
| Compromise monitoring | Alert on bulk decrypt spikes, key-policy edits, disabled audit, failed MFA, key deletion attempts; forward to proposed C3 SIEM once deployed | James / Security Analyst |
| Recovery evidence | Quarterly **full offsite restore** plus EHR, billing and encrypted key escrow tests; clinical sign-off for EHR/PACS | Sarah and clinical owners |
| Renewal/rekey | TLS expiry monitored daily; IKE/IPsec SA rekey checked; KMS key-version rotation and old-version retention verified | PKI/network/KMS operators |
| Vendor and GDPR gates | Evaluate cloud geography, DPA, key residency/ownership, egress, service-level commitments and independent exit/recovery | DPO/Legal / James / Procurement |
| Disaster scenario | Test KMS outage and NAS theft **separately**; demonstrate that ciphertext and offsite keys do not share one failure domain | Sarah / backup owner |

## Part 3 — HSM investment decision using 1x03 ALE and Risk Register

### 3.1 Risk and financial baseline (source-grounded)

| 1x03 risk | Recorded teaching ALE | Why it matters to keys | Important limitation |
|---|---:|---|---|
| **RISK-001: EHR patient-record exfiltration** (1x03 T10; T5/T6 R1) | **$3,025,000/year** | Exposed EHR KEK or widely accessible decrypt service could amplify patient-data disclosure. | Actual documented exposure primarily includes **overbroad PostgreSQL network access** and exports, not a confirmed key theft. Do **not** claim all $3.025m is preventable by HSM. |
| **RISK-002: VPN foothold / domain ransomware** (T5/T6 R2) | **$2,864,400/year** | Compromised VPN credentials and lateral access could reach stores or decrypting apps. | Compound campaign **overlaps EHR and billing**, and no HSM-specific protection rate is measured; never sum ALEs. |
| **RISK-008: billing ransomware** (T5/T6 R4) | **$135,143/year** | Lost backup key can block recovery; stolen key may expose financial data. | Ransomware availability loss persists despite HSM; controls C1/C4 and patches are necessary. |

**Risk register link:** [1x03 Task 10 — `10-risk_register.md`](../1x03_defense_blueprint/10-risk_register.md); quantitative source: [T5 `5-risk_equation.md`](../1x03_defense_blueprint/5-risk_equation.md) and [T6 `6-ale_workshop.md`](../1x03_defense_blueprint/6-ale_workshop.md). The baseline EHR figure is `$9,075,000 SLE × (1/3 ARO) = $3,025,000 ALE/year`, an **uncertain gross-additive classroom model** with possible breach-cost double counting. It is not a directly measured **key compromise ALE**. We have **no separately estimated probability, severity or ALE for HSM-preventable key theft**.

### 3.2 Technology and pricing options (published examples; not quotes)

| Option | Published cost basis | Illustrative cost | Fit under the proposed budget |
|---|---|---:|---|
| **Software KMS / existing vault** | Google software symmetric version ~$0.06/key-version/month; AWS KMS customer-managed key $1/key/month plus API/rotation charges. | Six software versions at $0.06 ≈ **$4.32/year** (Google list-price example, excluding use/integration). | **Low-cost baseline** for lifecycle and IAM, but not the highest hardware assurance. |
| **Managed multi-tenant HSM-backed KMS** | Google HSM-protected symmetric key version **$1/month** (certain ECC/RSA 3072+ versions **$2.50/month**), plus use/API and integration costs. | **Six AES KEK versions = $6/month = $72/year**; ten AES versions **$120/year** before requests, audit integration, regional/cloud network and staff work. | **Preferred proof of concept**, after vendor integration and data residency/security review. |
| **Dedicated HSM cluster** | AWS KMS price example: **$1.60 per HSM-hour** in example region; **two HSMs** for the illustrative cluster; KMS key and API costs additional. | `2 × $1.60 × 730 h/month = $2,336/month`, or **$28,032/year**, excluding other costs. | **Not affordable in the existing plan**; no implied purchase authorization. |
| **On-prem hardware HSM** | Separate appliance, redundancy, vendor support, secure room and backup/export controls. | **Request formal quotations; no verified MedDefense price supplied.** | Defer unless mandatory by contract/regulation or cloud residency impossible. |

**Budget reconciliation:** 1x03 Task 8/T10 proposes **$97,000 annualized** and **$115,000 estimated first-year cash** across C1/C2/C3/C4/C6, against the **single $120,000 six-month program cash cap**. This suggests at most **$5,000 apparent headroom before reconciliation**, not a separate HSM budget and not a guarantee funds are uncommitted. A $28,032/year dedicated cluster would exceed that headroom even before onboarding and integration. The $72/year managed-HSM example is **only key-version storage**, not a deployable six-month solution at that price. CFO Robert Kim must validate *all-in* first-year integration/licensing and renewal costs; CEO must approve any portfolio substitution. [S2–S4]

### 3.3 Incremental HSM risk-reduction test — avoid false ROI

**Correct formula:** `HSM-attributable annual risk reduction = baseline EHR ALE × s × e`, where `s` is the *unknown proportion* of that modeled breach loss driven by key-compromise pathways and `e` is the *unknown fraction* of those pathways actually blocked by HSM-backed controls. Both are **illustrative parameters**, not measured reductions. The prior 1x03 ALE stays unchanged in the risk register until validated evidence supports revision.

| Purely illustrative scenario | s = key-attributable fraction | e = effectiveness within that fraction | Hypothetical ARR/year on $3.025m | Interpretation |
|---|---:|---:|---:|---|
| Narrow key-specific benefit | **0.1%** | **50%** | **$1,512.50** | Can justify small recurring key-management costs *if* integration affordable; still unverified. |
| Broader key-specific benefit | **1%** | **50%** | **$15,125** | Illustrates potential value; **not a forecast, contract or proven efficacy**. |
| Pure availability/SQL attack | **0%** | Any | **$0** | HSM does not stop a compromised authorized query or restore backups whose credentials/keys remain unavailable. |

Compare **only incremental attributable ARR** to **incremental total cost** (setup, egress, staff, recovery, audit, key versions, operation and dependency risk); do not add EHR and VPN ALEs. Before procurement, simulate stolen encrypted media vs compromised authorized DB account, verify HSM can isolate KEKs and log unwraps, collect service uptime/latency and restore evidence, and get a defensible `s`/`e` range from security engineering, EHR owners and Finance.

### 3.4 Decision and phased implementation

**Decision: CONDITIONAL YES for a small managed HSM-backed KMS pilot protecting EHR master/wrapping keys; NO for a dedicated HSM purchase or cluster in the current approved/assumed six-month envelope.** The managed approach is attractive on marginal key pricing, but only if it integrates with MedDefense's *on-prem* PostgreSQL/LUKS data path, provides suitable regional security/contract terms and can be operated and restored without a single cloud outage preventing clinical care. No claim of production HSM deployment is made.

1. **Gate A — Inventory (week 1–2):** Sarah inventories actual encryption and host/KMS support; Security Analyst traces EHR and backup key access; clinical owner, DPO and James confirm PHI workflows and separation of roles.
2. **Gate B — Threat/finance (week 2):** Revalidate RISK-001 and the unique subset of key compromise; Robert Kim estimates first-year/all-in cost and remaining C1–C6 budget; obtain CEO approval for any added commitment.
3. **Gate C — Isolated pilot (weeks 3–4):** Create test-only KEK, generate/wrap synthetic DEKs, restrict operations to workload identity, test wrong-role denial, key rotation, failure mode and latency; use no real PHI.
4. **Gate D — Recovery and privacy (week 4–5):** Test decrypt-only old versions, disconnected offline escrow, KMS outage, NAS loss, controlled restore, IAM audit evidence and cloud exit; clinical/DPO approval needed for any real EHR change.
5. **Gate E — Production change (only after approvals):** Stage canary rollout and rollback, perform backup consistency/recovery tests, monitor KMS failures/decrypt spikes, document acceptance and adjust Risk Register only with measured evidence.

**If managed HSM is incompatible or unaffordable:** retain audited least-privilege software KMS + offline encrypted dual-controlled escrow as an interim control; prioritize **C1 segmentation, C2 MFA, C3 monitoring and C4 immutable offsite recovery**. Do not defer access control and recovery while waiting for specialized hardware.

## Sources and evidence boundaries

**MedDefense internal (primary project sources):**

- [1x03 T4 — Governance Architecture](../1x03_defense_blueprint/4-governance_architecture.md): role authority, clinical approval gates and shared budget ceiling.
- [1x03 T5 — Risk Equation](../1x03_defense_blueprint/5-risk_equation.md): SLE, ARO, ALE, assumptions and overlaps.
- [1x03 T6 — ALE Workshop](../1x03_defense_blueprint/6-ale_workshop.md): EHR, VPN, billing after-control **hypotheses** and non-additivity.
- [1x03 T8 — Budget Allocation](../1x03_defense_blueprint/8-budget_allocation.md): proposed C1/C2/C3/C4/C6 cost plan.
- [1x03 T10 — Risk Register](../1x03_defense_blueprint/10-risk_register.md): RISK-001, RISK-002, RISK-008 and source limitations.
- [1x04 T10 — CSR Workshop](10-csr_workshop.md), [T12 — Disk Encryption](12-disk_encryption.md), [T13 — Encryption Levels](13-encryption_levels.md): laboratory verification and **recommendations**, not actual production deployment.

**Official technical and commercial references (accessed 5 November 2026):**

- [S1 — NIST SP 800-57 Part 1 Rev. 5, Recommendation for Key Management](https://csrc.nist.gov/pubs/sp/800/57/pt1/r5/final): cryptoperiods, key lifecycle, compromise and recovery guidance.
- [S2 — Google Cloud KMS pricing](https://cloud.google.com/kms/pricing): software vs HSM key-version and operation pricing.
- [S3 — AWS KMS pricing](https://aws.amazon.com/kms/pricing/): customer-managed key monthly charges, requests and key rotation cost qualifiers.
- [S4 — AWS CloudHSM pricing and AWS KMS example](https://aws.amazon.com/cloudhsm/pricing/): hourly dedicated HSM billing; the **$1.60/HSM-hour** is a quoted AWS pricing example (see S3), not a universal regional tariff.
- [S5 — Apple Secure Enclave key protection](https://developer.apple.com/documentation/Security/protecting-keys-with-the-secure-enclave): hardware isolation and endpoint-local private keys.
- [S6 — NIST SP 800-63B: non-exportable hardware-authenticator keys](https://pages.nist.gov/800-63-4/sp800-63b.html): TPM/secure-element protection boundary.
- [S7 — Google Cloud KMS envelope encryption](https://docs.cloud.google.com/kms/docs/envelope-encryption): KEKs/DEKs and key wrapping.
- [S8 — AWS KMS envelope encryption model](https://docs.aws.amazon.com/kms/latest/developerguide/kms-cryptography.html): HSM-protected root keys and application data keys.

**Final assurance statement:** Pricing is indicative; HSM integration, key compromise frequency, residual ALE and key-loss recovery **are not experimentally validated in the MedDefense production environment**. The proposed architecture must undergo procurement, clinical, privacy and restore gates before deployment.
