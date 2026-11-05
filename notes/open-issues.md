# Open issues for Enrico

Running log of problematic points found during screening: decisions that need
a human, borderline judgement calls taken by agents, inconsistencies in papers
or in the inventory, and tool problems. Agents append new items here (rules in
`../AGENTS.md`); Enrico resolves them. Canonical decisions stay in
`records/*/record.yml` and `ledger/screening.csv`; this file only points to them.

Format: one bullet per item under **Open**, starting with date, record id or
DOI, the problem, and the action needed. When resolved, move the item to
**Resolved** with the date and outcome (or delete it if trivial). Never put
PDF text, local paths or private workbook fields here beyond what the records
already hold.

## Open

### Decisions needing Enrico (scope: DPG affiliation)

- 2026-11-05 `doi-10-3758-s13428-025-02743-x` (Behav Res Methods 2025):
  Cipolletta and Tomaino printed only as "University of Padua". Open data,
  code, materials and tool declared. If DPG at publication is confirmed:
  keep. Status `needs-review`.
- 2026-11-05 `doi-10-1371-journal-pone-0339975` (PLOS One 2025): all authors
  printed at DPSS, but the inventory lists Mancinelli at DPG since 2024-10-01.
  Minimum dataset public on figshare. Decide scope. Status `needs-review`.
- 2026-11-05 `doi-10-1007-s10902-026-01089-1` (J Happiness Stud 2026):
  Meneghetti printed only as "University of Padua". Study 2 stated
  pre-registered (OSF cvp9w), data and scripts on OSF ge7ms. If DPG
  confirmed: keep. Status `needs-review`.
- 2026-11-05 `doi-10-1186-s40359-026-04991-8` (BMC Psychol 2026, phubbing
  in pregnancy): Cellini, Mioni, Mancinelli, Salcuni printed only as
  "Universita degli Studi di Padova". Data "deposited into the Open Science
  Framework" (osf.io/xfszc), without explicit open wording. Decide scope and
  whether the wording qualifies. Status `needs-review`. Note: the companion
  paper `doi-10-1038-s41598-026-47775-1` (same team, 2026) prints Cellini
  and Mioni at DPG.

### Out-of-scope rejects worth a glance

- 2026-11-05 `doi-10-1016-j-schres-2024-12-005` and
  `doi-10-1016-j-neuroimage-2025-121514`: Fracasso printed only at University
  of Glasgow; rejected as no DPG author at publication. NeuroImage also
  declares data and code on OSF. Override only if you consider him DPG at
  publication.

### Agent judgement calls to confirm (records are `ready`)

- `doi-10-1017-s2045796025000095` (Miguel et al. 2025): protocol "registered
  in OSF" (osf.io/c9tbz) without date; not counted as preregistration or
  protocol.
- `doi-10-1002-pmh-70056` (Sica et al. 2026): "code file uploaded on OSF" not
  stated as openly accessible; open_code left null.
- `doi-10-1038-s41598-026-43063-0` (Di Rosa et al. 2026): PROSPERO record
  stated "pre-registered" but no registration date printed; counted as
  preregistration.
- `doi-10-1016-j-leaqua-2026-101991` (Peters et al. 2026, Feraco only DPG):
  Stage 1 in-principle acceptance; counted as both registered_report and
  preregistration (same convention as `doi-10-1371-journal-pone-0351764`).
- `doi-10-1016-j-heliyon-2026-e44660` (Khodami et al. 2026): "data and
  related materials" counted as open_materials although unspecific.
- `doi-10-3390-jintelligence13060069` (Pellegrino et al. 2025): reanalysed
  third-party dataset not counted as open data; only the R script counts.
- `doi-10-3389-fnut-2025-1622087` (Sarlo et al. 2025): food images on request
  only; open_materials false.
- `doi-10-1007-s10433-025-00903-8` (Vicentin et al. 2026): Human Connectome
  Project data restricted by licence; open_data false, only the R code counts.
- `doi-10-3389-fpsyg-2025-1657531` (Contemori et al. 2026): Frontiers
  template "datasets can be found in online repositories" + OSF DOI counted
  as an explicit open-data declaration (same convention for the five
  2026 Frontiers keeps 1670292, 1740985, 1765058, 1769309, 1795190).
- `doi-10-3389-fpsyg-2026-1770212` (Dalla Bona et al. 2026): original study
  "preregistered prior to data analysis" (OSF RXK6V), not explicitly before
  data collection; counted as preregistration. Confirm or set to null.
- `doi-10-3389-fpsyg-2026-1769309` (Freuli et al. 2026, Noventa only DPG):
  simulation paper; "datasets generated" on GitHub counted as open_data;
  code not explicitly declared, open_code left null.
- `doi-10-1111-2041-210x-70411` (Simonetti et al., Methods Ecol Evol 2026):
  read from the Europe PMC funder author manuscript (Wiley final PDF blocked
  to scripted download); data and code on Zenodo. Check the final version's
  data statement if convenient.
- `doi-10-3389-fpsyg-2026-1813559` (Costa et al. 2026): analysis scripts
  "deposited at" OSF 9d4ca, with data declared available there; counted as
  open_code. Clepsydra stimuli not declared shared.
- `doi-10-1186-s13690-026-01903-5` (White et al. 2026, Moè and Pazzaglia
  DPG): programme protocol article; counted as open_protocol (the article
  itself, documented in `curation.article_resources`) and preregistration
  (dated trial registrations, e.g. Padua CS4 ISRCTN74582097, and OSF/
  AsPredicted analysis pre-registrations). No data yet. Confirm that a
  protocol paper fits the showcase.

### Inconsistencies inside papers (summaries avoid them)

- `doi-10-1038-s41598-026-43063-0`: abstract says no significant moderator,
  results report setting (home vs lab) as significant; abstract 16 studies /
  1,216 participants vs discussion 17 / 1,398.
- `doi-10-1016-j-heliyon-2026-e44660`: Experiment 3 text says low-stress
  group had higher reaction times, contradicting Table 4.

### Bibliographic follow-ups

- `doi-10-1080-15374416-2026-2660289` (J Clin Child Adolesc Psychol): online
  first, no volume/issue yet; recheck citation year when assigned.
- `doi-10-1038-s41598-026-51912-1` and `doi-10-1111-jcpp-70162` (Toffoli et
  al.): typically developing sample probably shared (same schools and ethics
  protocol); distinct articles, both kept.
- `doi-10-3389-fpsyg-2025-1657531`: printed citation "(2026)" with volume 16
  (the 2025 Frontiers volume); recorded as 2026, vol. 16. Admissible either way.

### Inventory and tool problems

- Inventory "Anno di pubblicazione" can lag the official citation year
  (e.g. both Br J Psychol papers and J Sleep Res listed 2025, officially
  2026). Always use the year printed in the final version.
- Inventory DPG names are unreliable: Dalmaso, Pastore, Ronconi, Leonardi,
  Mancinelli, Bassi, Dalla Rosa, Montefinese, Navarrete, Suitner, Vianello and
  Fracasso appeared as DPG but were printed elsewhere; DPG co-authors missing
  from the inventory were found in several papers. Always use printed
  affiliations.
- `scripts/01-screen.R` suggested reject for most papers later kept from the
  keyword shortlist, and once took an OSF DOI as the article DOI
  (`10.17605/osf.io/825c6` for `10.1017/s2045796025000095`). Check record id
  and DOI in `reports/decisions.csv` before finalizing; consider improving the
  DOI extraction and patterns.
- 148 unprocessed inventory papers had no retrievable open full text (mostly
  Elsevier/closed): tier `D-no-fulltext` in the shortlist, still unscreened.
- `docs/` not rendered since the 2026-11-05 batches (data only rebuilt).

### Resource checks pending (ordinary mode)

- All records with `curation.resource_review.status: pending` need Enrico's
  manual check of the declared links (find them with
  `grep -l "status: pending" records/*/record.yml`).

## Resolved

(none yet)
