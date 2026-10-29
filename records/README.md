# Canonical publication records

Each processed publication has one `records/<stable-id>/record.yml`. A DOI-derived ID is preferred (`doi-...`); otherwise use `local-` plus the first 12 MD5 characters. File hashes support deduplication but are not the publication identity.

## Lifecycle

- `new`: ingested but not screened.
- `candidate`: algorithmically promising, awaiting semantic review.
- `needs-review`: ambiguous, changed, or conflicting evidence.
- `screened-reject`: processed with no qualifying substantive practice.
- `ready`: at least one qualifying claim has auditable evidence; eligible for the local site preview.
- `published`: explicitly approved for the public showcase.

Directory location never determines state. `screening.status` does.

## Compact schema

Every record has:

- `schema_version`, `id`, and normalized `doi` (or null);
- `bibliography` and `dpg` metadata, with null/empty values when not verified;
- private `source` file metadata for provenance and deduplication (`md5`; the PDF itself is deleted after finalization, so `pdf_path` is null or historical);
- `screening`, including state, version, suggestion, final decision, and reviewer status;
- `human_override`, null unless a named human has corrected the decision;
- controlled `open_science` claims (`true`, `false`, or null/unknown);
- direct `resources` links;
- `evidence`, where each item names supported claims, observable source/location, a concise passage or summary, URL when present, and verification status;
- `curation` and `publication` fields for the presentation layer; `curation.public_summary` is an engaging, promotional plain-language Italian paragraph (about 100-140 words) shown on the public site, without Open Science notes, criticism or caveats (rules in `../AGENTS.md`).

`curation.why_open` is the public "Che cosa è aperto" text: join the fixed
`short_description` phrases in `config/badges.yml` for the record's true badges,
in configuration order, separated by `; ` (the site shows one list item per
phrase, so the phrases themselves contain no semicolons). Keep review notes in the screening,
evidence or resource-review fields. Finalization sets this text; validation
checks it for all ready/published records.

Controlled Open Science keys are `preregistration`, `registered_report`, `open_data`, `open_code`, `open_materials`, `open_protocol`, `open_access`, and `reusable_tool`; they are defined once in `config/badges.yml`, which the scripts read. Positive claims require a matching evidence item. Use `verification: unverified` rather than filling a gap by inference.

## Rapid-mode evidence and pending manual checks

When Enrico explicitly requests "modalità rapida", a paper's explicit statement
that it performed/shared a practice publicly, accompanied by its resource link
(including view-only), is accepted provisionally. Set the declared claim to
`true`; the normal `ready` eligibility, badges and public summary apply (the summary does not mention the resources).
Do not open the resource. Ordinary identity/scope and scientific-summary checks
remain necessary. See `../AGENTS.md` for the full rule.

Distinguish the checked paper declaration from the unchecked external resource:

```yaml
screening:
  review_mode: rapid
evidence:
  - claims: [open_data]
    source: pdf
    location: "PDF page 9, Data availability"
    passage: "Paper explicitly declares public study data and supplies a link. Declaration and link read; resource not opened. Manual check pending."
    url: "<actual published resource URL, including any view-only parameter printed in the final PDF>"
    verification: unverified
curation:
  resource_review:
    status: pending
    assigned_to: Enrico
    practices: [open_data]
```

This is a partial schema example, not a record to copy verbatim. Preserve all
other fields. `unverified` refers to external access/content, not an inferred
declaration. Only practices expressly declared with links qualify. The current
validator already accepts this evidence status; no validator bypass is needed.
The ledger reason and corpus queue note must identify rapid-mode acceptance.
Use these canonical fields to recover Enrico's manual-check backlog without
creating a second catalog. Pending manual checks do not block eligibility or
completion of the corpus queue and must not be reported as already performed.
After an actual manual check, record its outcome and dated evidence; preserve
human decisions and append the appropriate ledger event when decisions change.

Resource links must point to the actual data/code/materials/registration destination,
including published view-only links (Enrico's corrective request, 2026-10-20).
Never substitute the article DOI to hide a published view-only parameter.
For resources embedded in the article itself, `curation.article_resources` maps
each resource field (for example `materials` or `protocol`) to its specific
section/table/appendix. This is a documented exception to the validator's
article-placeholder check. Cards show one button per distinct destination,
combining labels when several categories share the same URL.

## Open Access badge criterion

For the showcase, `open_science.open_access` refers to publisher-hosted access
without a paywall, following Enrico's instruction of 2026-10-20. The Unpaywall
OA type supports the badge for `gold`, `hybrid`, `bronze`, or `diamond`;
`green` and `closed` do not. For the 2025–2026 corpus it came from the workbook
`list.xlsx` (column `unpaywall: Tipologia Open Access (OA)`), kept outside the
repository; the classification is retained in each record's evidence. For new
papers, check Unpaywall by DOI.
Green access remains an important sharing route, but repository access alone
does not meet this badge's publisher-access criterion. An available local PDF
or its licence statement alone must not override this classification.
Match by normalized DOI, resolve conflicts explicitly, and retain the source
and classification in evidence when correcting a claim.
Missing classifications require separate evidence, not an inferred positive.
The 2026-10-20 audit covers all 95 current showcase records; earlier hidden
records and rejected records were inventoried but left unchanged.

## Human overrides

A human correction requires all four fields:

```yaml
human_override:
  decision: keep          # keep or reject
  by: "Name"
  at: "YYYY-MM-DD"
  note: "Concise reason"
```

Also append a `human-override` event to `ledger/screening.csv`. Automated scripts may flag changed evidence but must preserve this block and use its decision as authoritative.

