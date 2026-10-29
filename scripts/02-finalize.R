library(yaml)

# Controlled practice keys, defined once in config/badges.yml
badges = yaml.load_file("config/badges.yml")
controlled = names(badges)
short_descriptions = vapply(badges, function(b) b$short_description, "")

blank = function(x){
  is.null(x) || length(x) == 0 || all(is.na(x)) || !nzchar(trimws(as.character(x)[1]))
}

# PDFs are not stored in the repository: once a decision is recorded (record,
# ledger event with md5 for deduplication), the inbox copy is deleted.
# Deletion happens only after the record and ledger event are written.
remove_source = function(src){
  unlink(src)
  if(file.exists(src)) stop("Could not delete: ", src)
}

screen = read.csv("reports/screening.csv", stringsAsFactors=FALSE,
                  check.names=FALSE, fileEncoding="UTF-8-BOM")
decisions = read.csv("reports/decisions.csv", stringsAsFactors=FALSE,
                     check.names=FALSE, fileEncoding="UTF-8-BOM",
                     colClasses="character")

if(nrow(decisions) == 0){
  cat("No decisions to finalize.\n")
  quit(save="no")
}

required = c("record_id", "doi", "md5", "path", "file", "processing_state",
             "suggested_decision", "decision", "practices", "evidence_page",
             "evidence_note", "evidence_url", "reviewer", "note")
if(any(!required %in% names(decisions))) stop("reports/decisions.csv has an old or invalid layout.")
if(any(!decisions$decision %in% c("keep", "reject", "skip"))){
  stop("Every decision must be keep, reject, or deterministic skip; review rows remain.")
}

dir.create("records", showWarnings=FALSE)
dir.create("ledger", showWarnings=FALSE)

ledger_file = "ledger/screening.csv"
ledger_cols = c("event_id", "event_type", "processed_at", "record_id", "doi",
                "md5", "file", "screening_version", "algorithm_score",
                "algorithm_suggestion", "final_decision", "decision_source",
                "reason", "human_override", "source_action")

if(file.exists(ledger_file)){
  ledger = read.csv(ledger_file, stringsAsFactors=FALSE, check.names=FALSE)
} else {
  ledger = as.data.frame(setNames(replicate(length(ledger_cols), character(),
                                            simplify=FALSE), ledger_cols),
                         stringsAsFactors=FALSE)
}

missing_path = !file.exists(decisions$path)
already_done = missing_path & decisions$md5 %in% ledger$md5
if(any(missing_path & !already_done)){
  stop("Some decision paths are missing and are not present in the ledger.")
}
if(any(already_done)) decisions = decisions[!already_done,]
if(nrow(decisions) == 0){
  cat("All rows were already finalized.\n")
  quit(save="no")
}

inbox = normalizePath("inbox", winslash="/", mustWork=TRUE)
paths = normalizePath(decisions$path, winslash="/", mustWork=TRUE)
inside = startsWith(tolower(paths), paste0(tolower(inbox), "/"))
if(any(!inside) || any(tolower(tools::file_ext(paths)) != "pdf")){
  stop("All targets must be PDF files inside inbox/.")
}
actual_md5 = unname(tools::md5sum(paths))
if(any(actual_md5 != decisions$md5)) stop("A PDF changed after screening; rerun 01-screen.R.")

pos = match(decisions$md5, screen$md5)
if(any(is.na(pos))) stop("Some decisions do not match reports/screening.csv.")

counts = c(keep=0L, reject=0L, skip=0L)

for(i in seq_len(nrow(decisions))){
  d = decisions[i,]
  s = screen[pos[i],]
  record_file = file.path("records", d$record_id, "record.yml")
  old = NULL
  if(file.exists(record_file)) old = yaml.load_file(record_file)

  override = if(!is.null(old$human_override)) old$human_override else list(
    decision=NA_character_, by=NA_character_, at=NA_character_, note=NA_character_
  )
  override_active = !blank(override$decision)
  effective_decision = d$decision
  decision_source = d$reviewer
  if(override_active){
    effective_decision = override$decision
    decision_source = "human-override"
  }

  if(d$decision == "skip"){
    source_path = NA_character_
    source_action = "deleted-duplicate"
    final_decision = "skip"
    event_type = "duplicate"
  } else {
    practices = trimws(unlist(strsplit(d$practices, "[;,]")))
    practices = practices[nzchar(practices)]

    if(d$decision == "keep"){
      if(length(practices) == 0 || any(!practices %in% controlled)){
        stop("Each keep needs at least one controlled practice: ", d$file)
      }
      if(blank(d$evidence_note) || !d$reviewer %in% c("agent", "human")){
        stop("Each keep needs observable evidence and reviewer=agent or human: ", d$file)
      }
    }
    if(blank(d$note)) stop("Each keep/reject needs a concise reason: ", d$file)

    source_path = NA_character_
    source_action = if(effective_decision == "keep") "deleted-keep" else "deleted-reject"
    final_decision = effective_decision
    event_type = if(d$processing_state == "source-changed") "reassessment" else "screened"

    if(is.null(old)){
      old = list(
        schema_version=1,
        id=d$record_id,
        doi=if(blank(d$doi)) NA_character_ else tolower(d$doi),
        bibliography=list(title=NA_character_, authors=NA_character_,
                          year=NA_integer_, journal=NA_character_),
        dpg=list(authors=list(), verified=FALSE),
        source=list(), screening=list(), human_override=override,
        open_science=as.list(setNames(rep(NA, length(controlled)), controlled)),
        resources=list(article=list(), preregistration=list(), data=list(),
                       code=list(), materials=list(), protocol=list()),
        evidence=list(),
        curation=list(status="needs-curation", why_open=NA_character_,
                      public_summary=NA_character_, topics=list()),
        publication=list(published=FALSE, featured=FALSE)
      )
    }

    old$schema_version = 1
    old$id = d$record_id
    if(blank(old$doi) && !blank(d$doi)) old$doi = tolower(d$doi)
    old$source = list(pdf_file=d$file, pdf_path=source_path,
                      md5=d$md5)

    first_date = old$screening$first_screened_at
    if(blank(first_date)) first_date = format(Sys.Date(), "%Y-%m-%d")
    old$screening = list(
      status=if(effective_decision == "keep") "ready" else "screened-reject",
      first_screened_at=first_date,
      last_screened_at=format(Sys.time(), "%Y-%m-%d %H:%M:%S %z"),
      algorithm_version=s$screening_version,
      algorithm_score=if(is.na(s$score)) NA_real_ else s$score,
      algorithm_suggestion=s$suggested_decision,
      agent_reviewed=d$reviewer %in% c("agent", "human"),
      final_decision=effective_decision,
      final_note=d$note
    )
    old$human_override = override

    if(effective_decision == "keep"){
      for(key in practices) old$open_science[[key]] = TRUE

      urls = trimws(unlist(strsplit(d$evidence_url, "[;]")))
      urls = urls[nzchar(urls)]
      if(length(urls) > 0){
        for(key in practices){
          resource_key = switch(key, preregistration="preregistration",
                                registered_report="protocol", open_data="data",
                                open_code="code", open_materials="materials",
                                open_protocol="protocol", open_access="article",
                                reusable_tool="code")
          old$resources[[resource_key]] = unique(c(old$resources[[resource_key]], urls))
        }
      }
      if(!blank(old$doi)){
        old$resources$article = unique(c(old$resources$article,
                                         paste0("https://doi.org/", old$doi)))
      }

      location = if(blank(d$evidence_page)) NA_character_ else paste0("page ", d$evidence_page)
      ev = list(claims=as.list(practices), source="pdf", location=location,
                passage=d$evidence_note,
                url=if(length(urls) == 0) NA_character_ else urls[1],
                verification=paste0(d$reviewer, "-verified"))
      old$evidence = c(old$evidence, list(ev))
      open = controlled[vapply(controlled, function(key) isTRUE(old$open_science[[key]]), logical(1))]
      old$curation$why_open = paste(short_descriptions[open], collapse="; ")
    }

    dir.create(dirname(record_file), recursive=TRUE, showWarnings=FALSE)
    write_yaml(old, record_file, fileEncoding="UTF-8")
  }

  event_id = paste(format(Sys.time(), "%Y%m%dT%H%M%S"),
                   sprintf("%06d", nrow(ledger) + 1L), substr(d$md5, 1, 8),
                   sep="-")
  row = data.frame(
    event_id=event_id, event_type=event_type,
    processed_at=format(Sys.time(), "%Y-%m-%d %H:%M:%S %z"),
    record_id=d$record_id, doi=if(blank(d$doi)) NA_character_ else tolower(d$doi),
    md5=d$md5, file=d$file, screening_version=s$screening_version,
    algorithm_score=if(is.na(s$score)) NA_real_ else s$score,
    algorithm_suggestion=s$suggested_decision, final_decision=final_decision,
    decision_source=decision_source, reason=d$note,
    human_override=override_active, source_action=source_action,
    stringsAsFactors=FALSE
  )
  ledger = rbind(ledger, row[ledger_cols])
  write.csv(ledger, ledger_file, row.names=FALSE, fileEncoding="UTF-8", na="")
  remove_source(d$path)
  counts[d$decision] = counts[d$decision] + 1L
}

cat("Kept:", counts["keep"], "\n")
cat("Rejected:", counts["reject"], "\n")
cat("Known duplicates:", counts["skip"], "\n")
cat("Finalized PDFs deleted from inbox/.\n")
