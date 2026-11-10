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

### 2026-11-10 access recovery (university network + connected browser)

- 2026-11-10 `doi-10-1177-09388982261452122` (Feraco et al., LDRP 2026, SEB skills and SLD): `ready` with preregistration, data, code and materials (OSF BJ4E5, registration 8CWJ6). No registration date printed and data come from an existing MUR school project: confirm prospective timing.
- 2026-11-10 `doi-10-1016-j-jad-2026-122148` (Dell'Acqua et al., EMA suicide risk): `ready` with preregistration, data and code (OSF t3uvw); no registration date printed, confirm timing. OA badge assigned from the publisher page (Open access, Creative Commons) and Unpaywall hybrid, although the inventory says closed.
- 2026-11-10 `doi-10-1017-s1355617726102148` (Stroop short-form norms, Di Rosa DPG): borderline `ready` as reusable_tool only, for the scoring spreadsheet stated to be in Supplementary Material 1 (article resource; supplement not opened). Record form, stimuli and data on request. Reject if updated norms plus a supplement spreadsheet should not qualify.
- 2026-11-10 `doi-10-1421-119930` (Fietta et al., GIP 2026, resilience in prison): `ready` with open_materials only, for the complete Italian RMS-25 printed in Table 2 (same appendix-items convention as EAI-3, `doi-10-1007-s12144-026-09136-z`). Confirm or reject together with that precedent.
- 2026-11-10 `doi-10-1421-120866` (Ruffo, Aleotti, Priftis, SNARC): `ready` with open_materials; the OSF view-only link is line-wrapped in the PDF and was reconstructed. Confirm the token during the resource check. Only Priftis printed at DPG (correspondence address); co-authors generic Università di Padova.
- 2026-11-10 `doi-10-1177-00222194261417592` (Pellegrino et al., JLD 2026): `ready` with data/code (OSF 69q84). Sage HTML exposes only the corresponding author's affiliation, so only Pellegrino is listed as DPG; add Feraco, Meneghetti, Carretti if the PDF prints them at DPG.
- 2026-11-10 `doi-10-1111-lcrp-70074` (Preti et al., Melis and Sartori DPG): `ready` with open_data (Zenodo DOI). Inventory closed vs Unpaywall bronze; Wiley showed only institutional access, so no OA badge. Online first, no volume yet.
- 2026-11-10 `doi-10-1016-j-jad-2026-122176` (Filippi, Mancinelli): scope reject, both printed only at DPSS (inventory lists them at DPG). Override only with publication-time DPG evidence.
- 2026-11-10 session: Sage, Wiley, Cambridge, JAMA read as HTML in the connected browser; Rivisteweb PDFs downloaded by script from the university network (GARR); ScienceDirect required a human check, which Enrico passed in the browser. `data/` rebuilt and validated; `docs/` not rendered and stale. Visual check deferred.

### 2026-11-07 batch 12 (shortlist priority 4)

- 2026-11-07 `doi-10-1016-j-lindif-2026-102988` (Pellegrino et al., SEB skills and engagement): `ready` with open_data/open_code (OSF hrws7, "available on OSF"). T1/T3 data reused from two earlier papers by the team; resource check pending.
- 2026-11-07 batch 12: the remaining shortlist is all priority 4-5 (no open full text); with the browser connected and the university network available (2026-11-10) these can now be read. `data/` rebuilt and validated; `docs/` not rendered and stale.

### 2026-11-07 batch 11 (shortlist priority 4)

- 2026-11-07 `doi-10-1016-j-jad-2026-121539` (LPP meta-analysis, Dell'Acqua et al.): `ready` with data/code/materials (OSF y946c, "provided in" wording). Stated "entirely preregistered" in PROSPERO CRD420251023748 but no registry URL: preregistration left null, pending your decision on identifier-only registrations (same question as `doi-10-1121-10-0046098` and `doi-10-1186-s12877-025-06472-w`).
- 2026-11-07 `doi-10-1016-j-jad-2025-120474`: IRIS publisher PDF is image-only; read via local OCR (tesseract), superscripts partly illegible, so the DPG author list (Cainelli, Guglielmi, Devita, Patron) is approximate. Rejected as OA only.
- 2026-11-07 batch 11: connected Chrome extension not available; scripted ScienceDirect PDF download refused by the permission classifier (bot protection), so Elsevier articles without an IRIS file stay unresolved. `data/` rebuilt and validated; `docs/` not rendered and stale. Visual check deferred.

### 2026-11-07 batch 10 (shortlist priority 4)

- 2026-11-07 `doi-10-1080-1750984x-2026-2717406` (concussion meta-analysis, Masina DPG): `ready` with open_code only; Methods point to an OSF link "containing all relevant scripts" without explicit "publicly available" wording. Confirm during the resource check (compare `doi-10-1002-pmh-70056`, left null). Online first, no volume/issue; recheck when assigned.
- 2026-11-07 `doi-10-1016-j-ijlp-2025-102164`: rejected as OA only; the numbered forensic assessment steps were not counted as a reusable tool/protocol. Enrico may overturn.
- 2026-11-07 `inbox/10.1121_10.0046098.pdf` (already `needs-review`, batch 5) was left out of `decisions.csv` so the finalizer did not delete it; still retained pending Enrico's decision.
- 2026-11-07 batch 10: connected Chrome extension not available; `data/` rebuilt and validated; `docs/` not rendered and stale. Visual check deferred.

### 2026-11-06 batch 9 (shortlist priority 4)

- 2026-11-06 `doi-10-1177-21676968251390953` (ASA-27, Emerging Adulthood 2026): `needs-review`; raw data and R scripts stated to be in the Supplemental Materials of a closed article, without explicit public wording. Decide whether this qualifies (then keep with open_data/open_code and write summary) or reject. The screener requested the supplement once (403, contents not read); no further attempt.
- 2026-11-06 `doi-10-3390-forensicsci6020047`: `ready`; open_materials rests on the full item pool printed in Appendix Table A1, without a separate availability statement (EAI-3 precedent). Confirm. Bobbio printed at FISPPA; Polver DPG missing from inventory. Minor internal inconsistency in Study 1 sample size (349 vs 355).
- 2026-11-06 `doi-10-1177-08902070261467477` (Living SEB): `ready`; preregistration is a GitHub Pages document, not a time-stamped registry; confirm prospective timing. Protocol left unknown to avoid double counting; app URL recorded only in evidence (no tool resource field). Inventory closed vs Unpaywall green: no OA badge.
- 2026-11-06 `doi-10-1080-10409289-2026-2755008` (ENKS): scope reject; no author printed at DPG (inventory Sella, Porru, Lucangeli at Loughborough/DPSS). Open data/code/materials declared on OSF. Override only with publication-time DPG evidence.
- 2026-11-06 `doi-10-1080-0163853x-2026-2692885`: `ready`; volume/issue/pages from Crossref (read PDF is online first). Materials left unknown (landmark qualities in appendix, no shared descriptions declared).
- 2026-11-06 `doi-10-1016-j-exger-2026-113123`: rejected; of eight inventory DPG names only Devita is printed at DPG.
- 2026-11-06 batch 9: `data/` rebuilt and validated; `docs/` not rendered and stale. Visual check deferred.

### 2026-11-06 batch 8 (shortlist priority 4: 2026 without open full text)

- 2026-11-06 `doi-10-1016-j-chbr-2026-101183`: `ready`, open_materials based solely on stimulus lists and placement grids in the article's own Supplementary Materials (article DOI link), following the `doi-10-1016-j-jenvp-2025-102734` precedent. Confirm the interpretation and check the supplement; data on request.
- 2026-11-06 `doi-10-1016-j-cognition-2026-106633`: `ready`; OSF view-only link is line-wrapped in the PDF and was reconstructed. Confirm the exact token during the resource check.
- 2026-11-06 `doi-10-1016-j-cortex-2026-02-002`: `ready`; two OSF links printed (plain project link and view-only data link), both recorded. Resource check pending.
- 2026-11-06 `doi-10-1016-j-biopsycho-2026-109216`: rejected; the public mobile approach-avoidance task app (University of Padova site) is from Collantoni et al. 2023 and was not counted as a reusable tool of this paper. Enrico may overturn.
- 2026-11-06 `doi-10-1016-j-biopsycho-2026-109235`: rejected; Data availability says links to code and data are provided, but none is printed in final PDF, supplement or ScienceDirect HTML. Override if the authors supply the links.
- 2026-11-06 batch 8 inventory inconsistencies: DPG names wrong or incomplete for 109216 (Neurosciences authors), 109235 (Menardi, Vallesi not DPG; Özer missing), 101043 (Navarin at Mathematics), 101183 (Puccio, Franceschini missing), 106633 (Felisatti missing). Records use printed affiliations. Unpaywall labels IRIS final PDFs as submittedVersion for 101043 and 101183.
- 2026-11-06 batch 8: `data/` rebuilt and validated; `docs/` not rendered and stale until the next `render.bat`. Visual check deferred.

### 2026-11-06 summaries pass

- 2026-11-06 `doi-10-1177-10731911261469521`: public summary written from the final abstract plus the earlier record reading of the author manuscript; ResearchGate and Sage returned 403 this session, so the manuscript was not reread. Check the summary against the full text when convenient.
- 2026-11-06 placeholder `SINTESI DIVULGATIVA DA SCRIVERE` left in five `needs-review` records (`doi-10-1111-nyas-70194`, `doi-10-1121-10-0046098`, `doi-10-1186-s12877-025-06472-w`, `doi-10-1192-bjo-2025-10876`, `doi-10-3390-bs15020107`) and two rejects (`doi-10-1177-25152459261445951`, `doi-10-1186-s40337-025-01509-2`). Write the summary only if a record becomes `ready`; placeholders are not shown on the site.
- 2026-11-06 summaries pass: `data/` rebuilt and validated; `docs/` not rendered and stale until the next `render.bat`.

### 2026-11-06 batch 7

- 2026-11-06 `doi-10-3758-s13428-025-02908-8`: `ready`; TEP-Task counted as a reusable tool alongside explicitly public code/data/materials. Confirm tool interpretation if desired; Enrico resource check pending. Official 2026 citation used, with green OA classification retained.
- 2026-11-06 `doi-10-1186-s40337-025-01509-2`: rejected; original TRIANGLE trial registration not treated as preregistration of these exploratory secondary comparisons. Supplementary aggregate results not counted as shared participant data or new materials/protocol. Enrico may overturn this judgement. Official citation is 2026, volume 14:35, despite online/inventory 2025; retain corrected year.
- 2026-11-06 `doi-10-1126-sciadv-adu4098`: scope reject; Arcara printed only at San Camillo and other authors at institutions outside DPG. Override only with publication-time DPG evidence. Data/code links preserved privately, with public-access wording left unknown; no resource checked.
- 2026-11-06 `doi-10-1038-s41598-025-96784-z`: `ready` for data/materials; preregistration left unknown because the statement mentions a first experiment while the article describes one, and provides no specific registration link. Enrico to clarify registration identity and check declared resources.
- 2026-11-06 `doi-10-1177-25152459261445951`: rejected; earlier Music Ensemble practices not attributed to this commentary. Its own additional analysis supplies a bare OSF link without a specific open-resource declaration. Enrico may overturn this judgement. Grassi printed at DPG, Talamini at Innsbruck.
- 2026-11-06 `doi-10-1177-10731911261469521`: `ready` despite closed OA classification. Final publisher declarations support data/code/materials; separate preregistration link read in the author manuscript. No registration date printed; confirm timing and final-version registration wording during Enrico resource review. OnlineFirst 2026, no volume/issue; recheck when assigned.

### 2026-11-06 batch 6

- 2026-11-06 `doi-10-1186-s12877-025-06472-w`: `needs-review`; PROSPERO CRD42023407986 explicitly declared but no actual registry URL supplied. Decide whether the identifier satisfies the supporting-link rule or supply qualifying article evidence. Data only on request; supplementary search/extraction descriptions not treated as a separately declared open protocol/materials resource.
- 2026-11-06 `doi-10-1186-s12916-025-04435-x`: `ready` as an explicitly documented Registered Report. Dated registrations have no registry links; preregistration left unknown. Code and analysis plan declared shared on OSF without explicit public-access wording for the specific linked resources; code/protocol badges left unknown. Enrico to clarify these claims. YODA data require request and approval; retain open_data false.
- 2026-11-06 `doi-10-1136-bmjopen-2025-111686`: `ready`; detailed protocol in the article counted as open_protocol. Confirm this interpretation if desired. Future PROSPERO registration promise not counted as completed preregistration.
- 2026-11-06 `doi-10-1136-bmjoq-2024-003131`: `ready` based on raw-data declaration and actual linked supplement. Relative supplement target resolved without opening it; Enrico to check accessibility and contents.
- 2026-11-06 `doi-10-1109-tnsre-2025-3621769`: data on request and an earlier co-author toolbox do not establish a qualifying shared contribution; review the reusable-tool judgement if desired. The initial cache held a 2024 preprint, so screening was rerun on the institutional accepted manuscript carrying the actual article DOI. Check the final version if convenient.
- 2026-11-06 `doi-10-1016-j-invent-2025-100860`: `ready`; explicit preregistration with OSF link counted although no date/timing is printed. Enrico to confirm timing. Data and materials explicitly open; no code inferred from GitHub.
- 2026-11-06 `doi-10-2196-73896`: `ready`; detailed published protocol counted as open_protocol. Confirm this interpretation if desired. IRRID is not evidence of Registered Report status. Orso and Gamberini printed at DPG; Bassi and Salcuni at DPSS; retain corrected affiliation list.
- 2026-11-06 `doi-10-2196-73896`: Results reports initial data collection from 12 participants, while Data Availability says no datasets were generated or analysed. Clarify the inconsistency if needed; no open-data badge assigned.

### 2026-11-06 batch 5

- 2026-11-06 `doi-10-1121-10-0046098`: `needs-review`; explicit PROSPERO identifier CRD42023449606 but no supporting registration URL. Decide whether the identifier satisfies the link requirement or supply qualifying article evidence. PDF retained pending decision.
- 2026-11-06 `doi-10-1093-geronb-gbaf243`: rejected as OA only; shortlist preregistration match was a negation. Inventory includes authors printed at DIMED; only Mapelli and Devita are printed at DPG. Retain corrected affiliations.
- 2026-11-06 `doi-10-1080-13506285-2026-2711392`: `ready`; full task instructions in the article appendix counted as open materials. Confirm this interpretation if desired. Data/code view-only link preserved; Enrico resource check pending. Online first, no volume/issue; recheck when assigned.
- 2026-11-06 `doi-10-3390-bs15020107`: `needs-review`; Mondini printed at FISPPA, Arcara at San Camillo and generic University of Padua. Confirm Arcara's DPG affiliation at publication. Open data declared; inconsistent present/future test and scoring-software availability leaves materials/tool unknown. Clarify if scope confirmed.
- 2026-11-06 `doi-10-3390-ani15131936`: rejected as OA only; GitHub is an existing third-party Illustrator plugin. Stimulus figures and the experimental description were not counted as shared materials/protocol; Enrico may overturn this judgement. Miletto Petrazzini is printed at Biomedical Sciences; Gjinaj and Dadda at DPG.
- 2026-11-06 `doi-10-1016-j-bpsgos-2025-100626`: official publisher issue is January 2026 despite the 2025 inventory/online date; retain citation year correction. Prospective preregistration declared; Enrico resource check pending.
- 2026-11-06 `doi-10-1192-bjo-2025-10876`: `needs-review`; Box 1 contains a proposed methodological checklist, while preregistration mentions are recommendations. Decide whether this checklist qualifies as a concrete reusable tool/materials resource.

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
- 2026-11-06 `doi-10-33009-fsop-jpss139649` (J Postsecond Stud Success
  2026, Fietta, Gaggi, Navarin, Monaro): all authors printed only as
  "University of Padova". Questionnaire in Zenodo SI 18187015 (p.6 also says
  materials by email); data on request. Decide scope and whether the SI
  qualifies. Status `needs-review`.

### Decisions needing Enrico (wording)

- 2026-11-06 `doi-10-1016-j-jenvp-2026-102920` (Miola, Cellini, Bellini,
  Pazzaglia, J Environ Psychol 2026, all DPG): final version says data "will
  be available" on Zenodo, with dataset DOI 10.5281/zenodo.18280821 printed.
  Keep (open_data) if a printed DOI outweighs the future tense, otherwise
  reject. Status `needs-review`.

### Decisions needing Enrico (scope: preprints)

- 2026-11-06 `doi-10-64898-2026-05-04-722738` (bioRxiv 2026, Duma, Mento et
  al., ADHD brain dynamics): preprint, not peer reviewed, although the
  inventory types it as a journal article; no journal version named. Four DPG
  authors; data and materials declared on OSF fkhe9. Decide whether preprints
  are in scope (keep) or wait for the journal version. Status `needs-review`.

### Out-of-scope rejects worth a glance

- 2026-11-06 `doi-10-1016-j-neuroimage-2026-121695` (Mura et al., NeuroImage
  2026): rejected; data on request; the GitHub BHI toolbox is co-author
  Catrambone's earlier tool (2019). Override if you count it as a reusable
  tool.
- 2026-11-06 `doi-10-1186-s12984-026-01928-5` (Napoli et al., J NeuroEng
  Rehabil 2026): unregistered systematic review rejected; supplementary
  extraction tables not counted as open data.
- 2026-11-06 `doi-10-1038-s41746-026-03230-z` (D'Ascanio et al., npj Digit
  Med 2026, nine DPG authors incl. Enrico): protocol overview, data sharing
  "not applicable", MobGap GitHub is third-party; rejected.

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
- `doi-10-3389-fpsyg-2026-1813559` (Costa et al. 2026): analysis scripts
  "deposited at" OSF 9d4ca, with data declared available there; counted as
  open_code. Clepsydra stimuli not declared shared.
- `doi-10-1186-s13690-026-01903-5` (White et al. 2026, Moè and Pazzaglia
  DPG): programme protocol article; counted as open_protocol (the article
  itself, documented in `curation.article_resources`) and preregistration
  (dated trial registrations, e.g. Padua CS4 ISRCTN74582097, and OSF/
  AsPredicted analysis pre-registrations). No data yet. Confirm that a
  protocol paper fits the showcase.
- 2026-11-06 `doi-10-1186-s12877-026-07603-7` (Sabatini et al., BMC Geriatr
  2026, Borella only DPG): study protocol article counted as open_protocol;
  ClinicalTrials.gov NCT07113860 (release 03-07-2025, before planned data
  collection; ID printed without URL, card URL built from it) counted as
  preregistration. Data only promised; "Open Science Framework [101]"
  citations point to a 2020 article, no OSF link.
- 2026-11-06 `doi-10-1007-s12144-026-09136-z` (Granziol et al., Curr Psychol
  2026): only practice is the EAI-3 items printed in the article appendix
  (open_materials via `curation.article_resources`, as for
  `doi-10-1016-j-tele-2025-102262`); data on request. Reject if appendix
  items alone should not qualify.
- 2026-11-06 `doi-10-1016-j-chb-2026-109019` (Loconte et al., CHB 2026,
  Monaro DPG): AsPredicted timing not printed, counted as preregistration
  (final version checked 2026-11-10, see Resolved).
- 2026-11-06 `doi-10-3390-brainsci16090899` (Marson and Cona, Brain Sci 2026):
  read as Europe PMC XML (MDPI PDF not scriptable); code and stimulus list in
  the publisher supplement counted as open_code/open_materials; data withheld
  for privacy. Marson printed only at Padova Neuroscience Center.
- 2026-11-06 `doi-10-1080-21548455-2025-2594048` (Toniolo et al., Int J Sci
  Educ B 2026, Grassi DPG): read only in the arXiv original manuscript
  (final T&F version paywalled, green OA); OSF templates/questionnaires
  counted as open_materials. Confirm in the final version if convenient.
- 2026-11-06 `doi-10-1109-access-2026-3687097` (Orlando et al., IEEE Access
  2026): GitHub pipeline counted as open_code and reusable_tool; the paper
  also calls its cobot dataset/model "publicly available" without a specific
  link, so open_data left null.
- 2026-11-06 `doi-10-1007-s00221-025-07220-7` (Craighero et al., Exp Brain Res
  2026): data "can be found on" OSF wcsp9, stated only in the results (no
  data availability section); counted as open_data.
- 2026-11-06 `doi-10-1038-s41586-025-09844-9` (Aczel, Szaszi et al., Nature
  2026, multi100): only DPG author is Enrico Toffalini (1 of 494); read from
  the author manuscript, bibliography from Crossref. Preregistration (no
  dates printed), data, code and materials counted. You may prefer to
  decide yourself whether to showcase it.
- 2026-11-06 `doi-10-1037-xan0000433` (Dalbagno et al., JEP Anim Learn Cogn
  2026, Betti DPG): read only in the UNIGE submitted (pre-review)
  manuscript; OSF data/code/materials statement to confirm in the final
  version. Online first, no volume yet.
- 2026-11-06 `doi-10-1038-s41597-026-06654-0` (Talamini et al., Sci Data
  2026, Music Ensemble): data, code, materials counted; preregistration not
  counted here (it belongs to the companion Registered Report
  `doi-10-1177-25152459251379432`). Typeset PDF still shows "Published: xx".
- 2026-11-06 `doi-10-1111-psyp-70367` (Dell'Acqua et al., Psychophysiology
  2026): data and code "provided in" OSF sybdu without the word "publicly";
  counted as open.

### Inconsistencies inside papers (summaries avoid them)

- `doi-10-1038-s41598-026-43063-0`: abstract says no significant moderator,
  results report setting (home vs lab) as significant; abstract 16 studies /
  1,216 participants vs discussion 17 / 1,398.
- `doi-10-3390-brainsci16090899`: Highlights say stimulation increases delay
  discounting, while title, abstract and results report no reliable effect.
- `doi-10-1007-s12144-026-09136-z`: Discussion says higher extraversion and
  openness, Table 3 shows negative correlations; cut-off 33.5 vs 34.
- `doi-10-1016-j-futures-2025-103720`: scalar-invariance fit in the text
  differs from Table 4.
- `doi-10-1016-j-envint-2026-110277`: survey protocol cited as Swami et al.
  2022a, listed as 2022b in the references.
- `doi-10-1007-s00221-025-07220-7`: "F(1, 18) = 0.06, p = 0.08" (p.10),
  probably a typo.
- `doi-10-1038-s41597-026-06654-0`: abstract 678 matched pairs vs methods
  637 and data records 600.
- `doi-10-1016-j-sleep-2026-108858`: abstract lists low self-directedness
  among predictors, results show it only in an interaction.
- `doi-10-1016-j-heliyon-2026-e44660`: Experiment 3 text says low-stress
  group had higher reaction times, contradicting Table 4.

### Bibliographic follow-ups

- `doi-10-1080-15374416-2026-2660289` (J Clin Child Adolesc Psychol): online
  first, no volume/issue yet; recheck citation year when assigned.
- `doi-10-1017-s1366728926101412` (Biling Lang Cogn 2026): online first, no
  volume/issue yet.
- `doi-10-1111-bjep-70084` (Early View) and
  `doi-10-1038-s41746-026-03230-z` (article in press): no volume yet.
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
- Inventory types bioRxiv preprints as "01.01 - Articolo in rivista"
  (e.g. 10.64898/2026.05.04.722738); the shortlist cannot exclude them.

### Resource checks pending (ordinary mode)

- All records with `curation.resource_review.status: pending` need Enrico's
  manual check of the declared links (find them with
  `grep -l "status: pending" records/*/record.yml`).

## Resolved

- 2026-11-10 access recovery: full texts read through the University of Padova network/browser for 16 records previously blocked or judged from preliminary versions. Former `needs-review` now keep: `doi-10-1177-00222194261417592`, `doi-10-1177-09388982261452122`, `doi-10-1111-lcrp-70074`, `doi-10-1017-s1355617726102148`, `doi-10-1016-j-jad-2026-122148`, `doi-10-1421-120866`, `doi-10-1421-119930` (flags in Open above). Former `needs-review` now reject: `doi-10-1177-09388982261422712` (data on request), `doi-10-1016-j-jcomdis-2025-106606` (data on request), `doi-10-1016-j-jad-2026-122176` (no DPG author), `doi-10-1001-jamapsychiatry-2025-3242` (letter to the editor), `doi-10-1111-nyas-70194` (no resources declared), `doi-10-1421-120863` (narrative tribute). Earlier rejects confirmed on the final version: `doi-10-1421-120881`, `doi-10-1016-j-jad-2026-121397`, `doi-10-1016-j-dr-2026-101263`. Records and ledger updated; validation passed.
- 2026-11-10 final-version checks: `doi-10-1111-2041-210x-70411` (Zenodo data/code statement confirmed in the Wiley version), `doi-10-1016-j-chb-2026-109019` (AsPredicted and OSF 28avp statements confirmed, vol. 182), `doi-10-1016-j-sleep-2026-108858` (publisher page Open access under Creative Commons: hybrid OA badge confirmed). Evidence added to the records.

- 2026-11-06 summaries pass: public summaries written and reviewed for the ten deferred `ready` records of batches 5-7 (`doi-10-1016-j-bpsgos-2025-100626`, `doi-10-1016-j-invent-2025-100860`, `doi-10-1038-s41598-025-96784-z`, `doi-10-1080-13506285-2026-2711392`, `doi-10-1136-bmjopen-2025-111686`, `doi-10-1136-bmjoq-2024-003131`, `doi-10-1177-10731911261469521`, `doi-10-1186-s12916-025-04435-x`, `doi-10-2196-73896`, `doi-10-3758-s13428-025-02908-8`); summary_review updated, validation passed.

- 2026-11-06 `doi-10-3758-s13428-025-02908-8`: publisher preview and repository challenge did not supply the article; UNIGE provided the published PDF after approved network escalation. Article read locally; no unresolved article-access action for this decision.

- 2026-11-06 `doi-10-1177-25152459261445951`: Sage/Edinburgh article routes failed or presented challenges; coauthor lab supplied the published PDF after approved network escalation. Local screening extracted a trailing `rom` in the DOI; corrected identity before finalization. No unresolved tool action for this decision.
- 2026-11-06 `doi-10-1111-nyas-70194`: sandbox initially blocked an institutional metadata fetch; approved network escalation retrieved the page, confirming no attached files. Technical fetch failure resolved; full-text access remains open above.

- 2026-11-06 `doi-10-1109-tnsre-2025-3621769`: initial article downloads blocked by sandbox network; approved network escalation obtained the institutional accepted manuscript. Correct article DOI and hash used on rerunning screening; no remaining access/tool action needed for this decision.

- 2026-11-06 batch 5: rebuilt and rendered `docs/`, including prior data-only batches; final validation passed. Previous stale-output warning resolved.
- 2026-11-06 batch 5: Quarto initially failed opening its cache database; using a project-local cache and preserving the existing R package library allowed the full render to pass. No persistent configuration change needed.
- 2026-11-06 batch 5: seven distinct article agents ran in waves because only three child-agent slots are available. Initial agents were interrupted by a server restart before saving reviews. MiKTeX PDF tools failed; local pdftools rendering succeeded. R locale/BOM errors were corrected before canonical writes. No remaining tool action needed.
