# Agent protocol: DPG Open Science catalog

## Mission and hard rules

Maintain an evidence-backed showcase of substantive Open Science practices in publications with at least one author of the **Dipartimento di Psicologia Generale (DPG)**, University of Padova. Sequence: **local screening -> semantic verification -> durable record -> validation -> derived site data**.

- Human decisions are authoritative: never overwrite a non-empty `human_override`; if new evidence conflicts, preserve it and report that re-review is needed.
- PDFs and extracted text stay local: never upload them to GROBID, LLM services or other external processors. Never put PDFs, local paths, hashes or evidence passages in `data/` or `docs/`.
- New records are `ready`, `published=false`, `featured=false`; publication and featuring are human choices.
- No commit, push or deployment without an explicit request. Do not store chain-of-thought.

## Commands

Run from the repository root with R (`pdftools`, `yaml`) and Quarto. `scripts/04-validate.R` is the only check (non-zero exit on failure).

```sh
Rscript scripts/01-screen.R      # inbox/ PDFs -> reports/screening.csv + reports/decisions.csv
# resolve every decision=review in reports/decisions.csv
Rscript scripts/02-finalize.R    # -> records/, ledger; deletes finalized inbox PDFs
cmd /c render.bat                # UTF-8 locale; 04 -> 05 -> quarto render -> 04
```

`render.bat` is the standard render. To update only data without rendering, run `04 -> 05-build-site-data.R -> 04` under a UTF-8 locale (a C locale writes `<c2><a0>`-style garbage into `data/`). Unchanged records must leave `git diff data/publications.csv` empty.

## Architecture

- `01-screen.R` extracts text locally and scores regex hits; the agent fills `reports/decisions.csv`; `02-finalize.R` writes `records/<id>/record.yml`, appends `ledger/screening.csv`, deletes the PDF (md5 kept for deduplication); `05-build-site-data.R` writes `data/` (incl. raw-HTML `data/listing.md`); `quarto render` builds `docs/` (GitHub Pages, committed). There is no `03`.
- Site eligibility: `screening.status` in `ready`/`published`, `final_decision == keep`, and year >= `site_min_year` (2025). The rule lives in both `05` and `04`; change both together.
- `index.qmd` is the whole showcase (filter/search/dialog JS inline); card markup is in `05-build-site-data.R`; styling in `styles.scss`. Edit those, never `data/` or `docs/`.
- Practice keys (`preregistration`, `registered_report`, `open_data`, `open_code`, `open_materials`, `open_protocol`, `open_access`, `reusable_tool`) are defined once in `config/badges.yml` (order = display order). A new practice also needs a badge image, `records/README.md`, a regex in `01` and a claim->resource case in `02`.
- `curation.why_open` ("Che cosa è aperto") is generated from the badges' fixed `short_description` phrases; never hand-write it.
- Site text is Italian; scripts, records and comments are English.

Canonical: `records/*/record.yml` (schema and lifecycle in `records/README.md`) and `ledger/screening.csv`. Generated: `reports/`, `data/`, `docs/`. `selected/` is legacy migration history only.

## Inclusion criteria

1. **Identity and scope**: verify DOI/title against the paper (an extracted DOI may belong to a reference), the official bibliographic year (2025 or later for the site; an online-first paper moved to a later issue keeps its official citation year) and at least one author affiliated with DPG at publication. "University of Padova" alone is not enough. Deduplicate by DOI and hash; equal DOIs need version comparison.
2. **Substantive practice of this paper**: prospective preregistration, Registered Report/Replication, public data, public analysis/source code, public materials/protocol, or a concrete reusable tool. Evaluate all categories; use `null` for unknown, `false` only for a confirmed absence.
3. **Not sufficient**: open access alone, "available on request", future promises, other studies' practices, generic availability headings, OSF mentions not tied to this paper, private-only repositories. Do not infer code from "analyses", or a Registered Report from a preregistration.
4. **Links**: view-only links printed in the final paper and accessible without login are valid. Resource fields hold the actual published URL, including the view-only parameter; never replace it with the article DOI. Unpublished credentials stay private. If the resource is inside the article, document its location in `curation.article_resources`.
5. **Open Access badge**: publisher-hosted access without paywall (Unpaywall `gold`, `hybrid`, `bronze`, `diamond`; not `green`/`closed`), matched by DOI. Existing records keep their documented classification in evidence.

Each positive claim needs an evidence item (source, location, short passage, URL, `verification`). Rejects need a specific semantic reason with `reviewer=agent`.

### Rapid mode ("modalità rapida")

Only when the user explicitly asks for it, for that unit of work. An explicit statement by the paper that a practice was performed/shared publicly, **with an actual link**, suffices: set the claim `true`, include normally. **Do not open or test the link** (no browser, HTTP, API). Record evidence as `source: pdf`, `verification: unverified`, passage noting the declaration was read but the resource not checked; set `screening.review_mode: rapid` and `curation.resource_review: {status: pending, assigned_to: Enrico, practices: [...]}`; mention rapid acceptance in the ledger reason. Identity, scope, deduplication, summary checks and validation still apply. Pending review does not block `ready`.

## Public summary (`curation.public_summary`)

Rule set by Enrico on 2026-10-20. The summary **promotes** the paper to the general public: it must make the work interesting and its main idea clear to someone with no scientific training ("my mum must understand it"). It is not a technical abstract and need not be exhaustive.

- One Italian paragraph, about **100-140 words**, folded block `public_summary: >-`. The card previews the first words: the opening must hook.
- Open with a concrete question, an everyday situation or the most surprising finding; vary openings.
- Say what the authors did in plain words with two or three chosen details (who, how many, what). No jargon, acronyms or statistics unless essential, and then explained at once.
- State the main finding clearly, with at most one or two telling numbers.
- Close with a punchy, positive sentence on why it matters. Frame null results, replications, tools and methods as valuable contributions.
- **Never include**: Open Science notes (data, code, materials, OSF, GitHub, preregistration, Registered Report, open access, "on request") — badges already show them; criticism, limitations, caveats ("the sample is small", "does not prove", "remains to be verified"); internal notes or page references.
- **Positive is not false**: get accuracy from word choice, not disclaimers. Use associative wording for correlational data ("va di pari passo", "si associa", "chi... tende a..."); attribute interpretations to the authors ("per gli autori..."); never invent numbers, details, applications or promises. Everyday examples are allowed only as illustrations, not as study facts.
- Write after reading abstract, method and main results (the abstract alone is not enough). Then do a scientific check against the paper (causation vs correlation, observed vs interpreted, null vs non-significant, humans vs animals vs models) and an editorial pass reading it as a lay reader.
- Never overwrite an existing summary unless Enrico explicitly asks; propose corrections instead.

## When asked to "process inbox"

1. Run `01-screen.R`; read `reports/screening.csv` and `reports/decisions.csv`, starting with `decision=review`; inspect only relevant local PDF passages.
2. Apply the inclusion criteria; resolve every `review` to `keep`/`reject`, filling `practices`, `evidence_note`, `evidence_page`, `evidence_url`, `reviewer=agent` and a concise `note`. Check low-scoring rejects only when evidence suggests a missed practice.
3. Run `02-finalize.R`; then complete bibliography, DPG authors and the public summary for each new keep.
4. Run `render.bat` (or data-only `04 -> 05 -> 04` if a full render is not wanted; then say `docs/` is stale).
5. Report briefly: screened/new/skipped, kept/rejected, cases needing attention, validation status, link to `ledger/screening.csv`.

## Before finishing any change

Validation passes; public data contain nothing private; all records remain represented (pre-2025 ones hidden, not deleted); this file still describes what the scripts do.
