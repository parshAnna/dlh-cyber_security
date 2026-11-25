#!/bin/bash
set -euo pipefail; cd "$(dirname "$0")"; python3 - <<'PY'
import json, collections, pathlib
profile=json.load(open('cis_profile.json')); audit=json.load(open('lynis_findings.json')); findings=audit['findings']; assert len(profile['controls'])==15 and isinstance(findings,list)
rules="""
01,02,06|SSH-7408|non_compliant|4-ssh_hardening.sh
03|AUTH-9230,AUTH-9286,DEB-0880|non_compliant|5-pam_policy.sh
04||not_assessed|12-db_exposure.sh
05,12|ACCT-9630,LOGG-2154|non_compliant|10-audit_logging.sh
07|BOOT-5264|non_compliant|6-service_minimization.sh
08|KRNL-6000|non_compliant|7-sysctl_hardening.sh
09|KRNL-6000|partially_compliant|7-sysctl_hardening.sh
10|FIRE-4512,FIRE-4513|non_compliant|8-firewall_policy.sh
11|FILE-7524|non_compliant|9-file_permissions.sh
13||compliant|9-file_permissions.sh
14|LOGG-2154|partially_compliant|11-log_retention.sh
15||compliant|13-module_hardening.sh
""".strip().splitlines()
rulemap={}; list(map(lambda r:rulemap.update(dict.fromkeys(r[0].split(','),(list(filter(None,r[1].split(','))),r[2],r[3]))),map(lambda s:s.split('|'),rules)))
def assess(c):
    keys,status,script=rulemap[c['control_id'][-2:]]; hits=list(filter(lambda f:f['test_id'] in keys,findings)); status=(hits or not keys) and status or 'not_assessed'; evidence=list(map(lambda x:dict(zip(('severity','test_id','message'),x)),dict.fromkeys(map(lambda f:(f['severity'],f['test_id'],f['message']),hits)))); score=min(100,{'critical':82,'high':62,'medium':42}[c['severity']]+min(8,len(evidence)*3)+12*int(any(map(lambda f:f['severity']=='warning',hits))))
    c=dict(c); c.update(status=status,affected_asset='billing-srv-01',matching_lynis_findings=evidence,remediation_script=script,remediation_script_planned=True,priority_score=score,operational_risk=c['justification'],expected_validation_check=c['verification_method'],assessment_basis=(evidence and 'Lynis finding: provisional control-level inference; validate exact setting' or 'No relevant Lynis finding: compliance unverified; validate on host')); return c
controls=list(map(assess,profile['controls'])); queue=list(filter(lambda c:c['status'] in ('non_compliant','partially_compliant'),controls)); queue.sort(key=lambda c:(-c['priority_score'],c['control_id'])); counts=collections.Counter(map(lambda c:c['status'],controls))
pathlib.Path('gap_analysis.json').write_text(json.dumps({'assessed_asset':'billing-srv-01','hardening_index':audit['hardening_index'],'assessment_limitations':'Lynis reports gaps, not proof of compliance; other named assets are outside this audit. Provisional compliant statuses require validation.','status_counts':dict(counts),'controls':controls},indent=2)+'\n'); pathlib.Path('remediation_queue.json').write_text(json.dumps({'assessed_asset':'billing-srv-01','sorted_by':'priority_score descending','remediation_actions':queue},indent=2)+'\n'); print(f"Controls assessed: {len(controls)}\nCompliant: {counts['compliant']}\nNon-compliant: {counts['non_compliant']}\nPartially compliant: {counts['partially_compliant']}\nNot assessed: {counts['not_assessed']}\nRemediation actions queued: {len(queue)}\nReport saved to: gap_analysis.json\nQueue saved to: remediation_queue.json")
PY
