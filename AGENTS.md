# Agent protocol: DPG Open Science catalog

## Scope and safeguards

Showcase publications with official citation year **2025 onward**, at least one author affiliated with **DPG, University of Padova, at publication**, and **at least one substantive Open Science practice other than Open Access**. Open Access is recorded separately: neither necessary nor sufficient for inclusion.

- Preserve every non-empty `human_override`; report conflicting evidence for re-review.
- PDFs and extracted text stay local: no uploads to GROBID, LLM services or external processors. Keep source workbooks private too. Never put PDFs, raw workbooks/private workbook fields, local paths, hashes or evidence passages in `data/` or `docs/`.
- New accepted records: `ready`, `published=false`, `featured=false`. Publication and featuring are human choices.
- No commit, push or deployment without an explicit request. Do not store chain-of-thought.
- Site text is Italian; scripts, records and comments are English.

## Sources and durable tracking

**Inventory:** use the latest dated `inbox/list-YYYY-MM-DD.xlsx` (currently `list-2026-11-04.xlsx`); keep it intact, never delete it during PDF finalization. It covers DPG's whole publication history: filter `Anno di pubblicazione >= 2025`. Inspect headers on updates; use title, DOI, IRIS identifiers/handle and bibliography to identify candidates and merge repeated rows. Workbook membership/current affiliation does not replace checking DPG affiliation at publication. It provides **no evidence of substantive Open Science practices**.

**Open Access:** match the workbook's `unpaywall: Tipologia Open Access (OA)` by normalized DOI. Accept **gold, bronze, hybrid** for the badge; green/closed do not qualify, missing/other values require clarification. Record classification, source/version and date in private evidence. If absent, consult Unpaywall by DOI. Preserve existing documented classifications unless explicitly reassessed. Never filter the search corpus by OA.

**Canonical history:** `records/*/record.yml` plus append-only `ledger/screening.csv`, for **keeps, rejects and unresolved attempts**. Schema/lifecycle: `records/README.md`. Before retrieving or screening, compare against both, including rejected records: normalized DOI first; otherwise IRIS ID/handle and normalized title/authors/year. Reuse an existing record rather than creating another catalog.

- Same known PDF hash: automatic skip. Same DOI with a different hash: scripts flag `source-changed`; compare versions and prior evidence before deciding whether reassessment is needed.
- Do not repeat completed screening without new evidence, a materially different version or an explicit request. A new inventory version alone is not new practice evidence.
- Every exclusion needs an identifiable record (`screened-reject`, `final_decision: reject`), bibliography, a specific reason and reviewer/date, plus a ledger event. Use `reviewer=agent` for semantic rejects in decisions; out-of-scope exclusions are tracked too.
- Missing full text, failed access or ambiguous evidence means `needs-review`, **not rejection or a confirmed absence**. Record URLs tried, date, reason and next step in the existing record and ledger; avoid retrying the same failed route without a reason. These cases do not count as fully screened.
- Historical screening before durable tracking is incomplete; do not claim the catalog contains all past exclusions.

## Inclusion and evidence

1. Verify title/DOI against the paper (an extracted DOI may belong to a reference), official citation year and DPG affiliation. Online-first papers moved to a later issue use the official citation year; “University of Padova” alone is insufficient.
2. Evaluate all practices: prospective preregistration, Registered Report/Replication, public data, public analysis/source code, public materials/protocol, concrete reusable tool. Use `null` for unknown, `false` only for confirmed absence. Do not infer code from “analyses” or a Registered Report from preregistration.
3. Exclude OA alone, “available on request”, future promises, other papers' practices, generic headings, unrelated OSF mentions and private-only resources.
4. Every positive claim needs source, location, short passage, actual supporting URL and `verification`. Keep the published URL, including view-only parameters; never replace it with the article DOI. Unpublished credentials stay private. For resources inside the article, document the exact location in `curation.article_resources`; an article URL alone is not evidence of an open resource.

## Review modes (apply to both workflows)

**Ordinary, default:** trust the paper only when it **explicitly declares the specific resource openly available without access conditions AND supplies an actual supporting link**. Bare links or generic availability statements do not qualify; neither do access on request, required login or author permission. Published view-only links qualify when presented as providing access without further authorization. **Do not open/test supporting resource links** (browser, HTTP or API). This restriction does not prevent finding and reading the paper itself, its availability statements or bibliographic/OA metadata.

Set qualifying claims `true`; evidence uses `source: pdf` (or the actual article source), `verification: unverified`, and notes that declaration/link were read but the resource was not checked. Set `screening.review_mode: ordinary` and `curation.resource_review: {status: pending, assigned_to: Enrico, practices: [...]}`; identify declaration-based acceptance in the ledger. Pending resource review does not block `ready`.

**In-depth, on explicit request:** add independent checks that each supporting resource exists, corresponds to this paper, supports the specific claim and is accessible without login, requests or further authorization. Set `screening.review_mode: in_depth`; record outcomes and dated evidence, using `agent-verified` only for checks actually performed. Update pending reviews accurately; report missing/inaccessible/mismatched resources and preserve human overrides.

Identity, scope, deduplication, summary checks and validation apply in both modes. Historical `review_mode: rapid` values retain their provenance; their declaration-based procedure is now ordinary mode.

## Two work requests

**“Process inbox” / supplied PDFs**

1. Run `01-screen.R`; read `reports/screening.csv` and `reports/decisions.csv`, starting with `review`. Inspect relevant local passages. Only PDFs are inputs to these scripts; the inventory workbook remains in place.
2. Resolve every `review` to `keep`/`reject`, filling `practices`, `evidence_note`, `evidence_page`, `evidence_url`, `reviewer=agent` and concise `note`. Check low-score rejects when evidence suggests a missed practice. Compare known DOI versions before reassessment.
3. Run `02-finalize.R`: it writes records/ledger **before deleting finalized PDFs**, including rejects/duplicates. Complete bibliography/identity for all new decisions, and DPG authors, per-claim evidence, review-mode fields and public summary for keeps. The finalizer initially labels agent evidence `agent-verified`: correct ordinary-mode resource evidence to `unverified` before validation.

**“Proseguire il lavoro” / autonomous online search**

1. Read the latest inventory and canonical history; select **5–7 new, unprocessed papers** from 2025 onward. This is a bounded batch, not a request to finish the corpus. Do not substitute already accepted/rejected papers or silently expand the batch.
   - **Selection (since 2026-11-05):** run `Rscript scripts/00-shortlist.R` (or reuse today's `reports/candidati-keyword-YYYY-MM-DD.csv`); it drops already processed DOIs and orders the rest by `priority`. Take the next papers in that order: **2026 first** (0 = 2026 statement+link, 1 = 2026 link/prereg only), then 2025 (2, 3), then papers without open full text (4 = 2026, 5 = 2025). The keyword match only selects candidates; it is not evidence. Low-signal papers (no link, no preregistration) are omitted from the shortlist and stay unscreened, not rejected.
   - Inventory DPG names and `Anno di pubblicazione` have proved unreliable: check printed affiliations and the official year in every paper.
   - Several agents may read papers in parallel, but they write only in a scratch folder; one process writes records, ledger and `inbox/`.
2. Find and read the paper through publisher, DOI, institutional repository or other legitimate article sources. When available/useful, use Enrico's connected browser and existing university-network access. Do not claim university access unless it actually works.
3. Download accessible PDFs locally into `inbox/` and use the PDF workflow. If only full HTML is available, curate the same canonical record and ledger directly, following their schema and recording article URLs/locations; do not invent PDF hashes or pretend the PDF scripts processed HTML. Online-only attempts require the same durable tracking, including rejects and unresolved access.
4. Apply the selected review mode; access to the article through university credentials does **not** demonstrate unconditional access to its supporting resources. Stop after the selected batch, report unresolved cases, and leave the next batch for a later request.

**Finish either workflow:** validate, rebuild/render as below, and report briefly selected/new/skipped, kept/rejected/unresolved, attention needed, validation and a link to `ledger/screening.csv`.

**Open issues log:** append every problematic point to `notes/open-issues.md` before finishing: `needs-review` cases and the decision needed, borderline judgement calls taken on `ready` records, out-of-scope rejects that a human might overturn, inconsistencies in papers or inventory, script/tool failures, and stale outputs (e.g. `docs/` not rendered). One dated bullet per item with record id and action needed; move items to **Resolved** when Enrico decides, and update the records/ledger accordingly. Read the file at the start of each session. It is a pointer list, not a second catalog: no evidence passages, PDF text or local paths.

## Public summaries

Preserve existing summaries unless Enrico explicitly asks to replace them; propose corrections instead. For each new keep, read abstract, method and main results before writing `curation.public_summary: >-`:

- One Italian paragraph, **100–140 words**, engaging and understandable without scientific training (“my mum must understand it”). Hook with an everyday situation, concrete question or surprising finding; vary openings.
- Explain what the authors did with two or three selected details, then the main finding, at most one or two telling numbers, and a positive closing on why it matters. Present null results, replications, tools and methods as valuable contributions.
- No jargon/acronyms/statistics unless essential and immediately explained; no Open Science notes, internal notes/page references, criticism, limitations or caveats.
- Positive must remain accurate: associative wording for correlations, interpretations attributed to authors, no invented details/applications/promises. Everyday illustrations must not appear to be study facts.
- Check causation/correlation, observed/interpreted, null/non-significant, humans/animals/models against the paper; then read as a lay reader.

## Commands and maintenance

Run from repository root with R (`pdftools`, `yaml`) and Quarto. `04-validate.R` is the only check; non-zero means failure.

```sh
Rscript scripts/00-shortlist.R   # online-search candidates (also httr2, xml2, readxl)
Rscript scripts/01-screen.R
# Resolve decisions and review evidence.
Rscript scripts/02-finalize.R
cmd /c render.bat
```

`render.bat` sets a UTF-8 locale and runs **04 -> 05 -> quarto render -> 04**. For data only, run **04 -> 05-build-site-data.R -> 04** under UTF-8 and report `docs/` stale. Unchanged records must leave `git diff data/publications.csv` empty. Documentation-only changes need validation, not a site rebuild.

- Generated: `reports/`, `data/`, `docs/`; never edit site output manually. `selected/` is legacy history. There is no script `03`. `cache/fulltext/` is the gitignored local full-text cache of `00-shortlist.R`; never commit or upload it.
- `01-screen.R` can take a DOI cited in the paper (e.g. an OSF DOI) as the article DOI: check `record_id`/`doi` in `reports/decisions.csv` against the paper before `02-finalize.R`. `02` accepts only keep/reject/skip; `needs-review` PDF cases and HTML/XML-only reads are curated directly into a record plus an appended ledger line (see existing examples), never by rewriting the ledger.
- `notes/open-issues.md`: human-facing log of open problems (see above); documentation, not generated.
- Site eligibility: `ready`/`published`, `final_decision == keep`, year >= `site_min_year` (2025). Logic lives in both `04` and `05`; change both together. Preserve older records, hidden from the site.
- Page/JS: `index.qmd`; cards: `05-build-site-data.R`; style: `styles.scss`.
- Practice keys/order: `config/badges.yml`. New practice: also badge image, `records/README.md`, regex in `01`, claim-to-resource case in `02`. `curation.why_open` is generated from fixed badge `short_description` phrases; never hand-write it.
- Before finishing: validation passes, public output contains nothing private, all prior records remain represented, and this protocol still matches the scripts.
