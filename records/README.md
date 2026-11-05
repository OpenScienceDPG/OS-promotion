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

## Tracking online searches and exclusions

Before retrieval, compare the latest inventory against all canonical records
and ledger events, including rejects: normalized DOI first, otherwise IRIS
ID/handle and title/authors/year. A previous exclusion is a completed decision;
reassess only with new evidence, a materially different version or an explicit
request. Same-hash PDF skips are automatic; changed hashes with the same DOI
are flagged for version comparison, not automatically skipped.

Every semantic or scope exclusion needs an identifiable `screened-reject`
record, `final_decision: reject`, bibliography, dated reviewer/reason and a
ledger event. Failed access or insufficient evidence instead uses
`needs-review`, with no final rejection. Preserve article URLs, dated attempts,
reason and next step in evidence/screening notes and append an attempt event
using the existing ledger columns. Consult these attempts before retrying.

Downloaded PDFs use the normal scripts. Full-HTML reviews and unsuccessful
retrieval attempts are curated directly into the same schema and ledger;
use the actual source URL/location and null/empty PDF-specific fields when no
PDF exists, without inventing hashes. With no DOI, retain the IRIS identifier
or handle in private provenance and use a stable record ID. Do not create a
second screening catalog. The inventory is retained intact; historical
unrecorded exclusions cannot be assumed to have been recovered.

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

## Review modes and pending resource checks

Ordinary mode is the default. Accept a practice only when the paper explicitly
declares its specific resource openly available without access conditions and
provides an actual supporting resource link. A bare link, generic declaration,
access on request, login or further authorization do not qualify. Published
view-only links qualify when presented as allowing unconditional access.
Set the qualifying claim to `true`; normal `ready` eligibility, badges and
public summary apply (the summary does not mention the resources).
Do not open or test the resource in ordinary mode. Identity/scope,
deduplication and scientific-summary checks remain necessary in both modes.
See `../AGENTS.md` for the full rule.

Distinguish the checked paper declaration from the unchecked external resource:

```yaml
screening:
  review_mode: ordinary
evidence:
  - claims: [open_data]
    source: pdf
    location: "PDF page 9, Data availability"
    passage: "Paper explicitly declares study data openly available without access conditions and supplies a supporting link. Declaration and link read; resource not opened. Manual check pending."
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
The ledger reason and any corpus queue note must identify ordinary-mode
acceptance based on the paper declaration.
Use these canonical fields to recover Enrico's manual-check backlog without
creating a second catalog. Pending manual checks do not block eligibility or
completion of the corpus queue and must not be reported as already performed.
After an actual manual check, record its outcome and dated evidence; preserve
human decisions and append the appropriate ledger event when decisions change.

In-depth mode ("modalità approfondita") is used when explicitly requested for
a unit of work. Set `screening.review_mode: in_depth`; independently open the
published links and check resource existence, correspondence to this paper,
support for each claimed practice and accessibility without login, requests
or further authorization. Record the actual outcome and dated evidence;
`verification: agent-verified` applies only to claims actually checked.
Update pending resource reviews to reflect the checks and report missing,
inaccessible or mismatched resources without overriding human decisions.
Historical `review_mode: rapid` values retain their original provenance and
are not rewritten; their declaration-based procedure is now the default.

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
without a paywall. Following Enrico's updated instruction of 2026-11-05,
the Unpaywall OA type supports the badge for `gold`, `hybrid`, or `bronze`;
`green` and `closed` do not; missing/other values need clarification.
For new work use the latest dated `inbox/list-YYYY-MM-DD.xlsx`, column
`unpaywall: Tipologia Open Access (OA)`, matched by normalized DOI. Record the
source version, classification and date in private evidence; if absent,
consult Unpaywall by DOI. Preserve existing documented classifications unless
explicitly reassessed. Historical evidence may cite the earlier `list.xlsx`.
The inventory covers all years: only papers from 2025 onward enter the current
search corpus, regardless of OA type. It provides no evidence of other Open
Science practices. Open Access is neither necessary nor sufficient for inclusion.
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

