# MedDefense Health Systems — The Patch Briefing

**To:** James Chen, Deputy CISO; Board of Directors  
**Decision window:** Next 24–48 hours  
**Request:** Authorize three immediate actions.

**1. Close the exposed EHR connector — Finding 031 (Critical).** The EHR exposes an unnecessarily reachable connector (AJP, port 8009). Abuse could expose patient credentials and records, disrupting care. **Action:** Confirm the installed Tomcat build and service dependency; disable AJP if unused, otherwise restrict it to approved peers, then test EHR access. Tomcat 9.0.31 already fixes Ghostcat; verify its build before attributing that CVE. **Estimate:** 4–8 staff hours; **$400–$800** in modeled labor.

**2. Restrict EHR database access — Finding 003 (Critical).** The patient-record database accepts connection attempts from the entire internal network, although passwords are still required. Stolen credentials could enable record theft or manipulation. **Action:** Allow PostgreSQL access only from verified EHR application and administration systems; test clinical workflows and rollback. **Estimate:** 6–10 staff hours; **$600–$1,000** in modeled labor.

**3. Isolate the unpatchable MRI controller — Finding 004 (Critical).** The Windows XP workstation exposes legacy network services; compromise could disrupt approximately 45 daily MRI studies. **Action:** Deploy the proposed CC-01 firewall-enforced network isolation while preserving validated PACS transfers; coordinate testing with Radiology and the vendor. **Estimate:** 16–24 staff hours; **$1,600–$2,400** labor plus equipment/vendor costs, subject to the existing **$12,000 planning allowance** and quotation. This reduces exposure; it does not patch Windows XP.

**Cost basis:** Assumed **$100/staff hour**; not an approved rate or quote. Downtime excluded.

**Three-week progress:** MedDefense progressed from asset/control assessment through threat modeling to a prioritized vulnerability remediation queue.
