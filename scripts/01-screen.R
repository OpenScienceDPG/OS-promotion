library(pdftools)

screen_version = "screen-2.0"

dir.create("inbox", showWarnings=FALSE)
dir.create("reports", showWarnings=FALSE)

pdfs = list.files("inbox", pattern="\\.pdf$", recursive=TRUE,
                  full.names=TRUE, ignore.case=TRUE)

patterns = list(
  preregistration=paste(c(
    "preregistered", "pre-registered", "preregistration", "pre-registration",
    "registered report", "registered replication", "aspredicted\\.org",
    "osf\\.io/[a-z0-9]+/registrations"
  ), collapse="|"),
  open_data=paste(c(
    "open data", "data (are|is|were) publicly available",
    "data (are|is|were) openly available", "raw data (are|is|were) available",
    "datasets? (are|is|was|were) (publicly |openly )?available",
    "data have been deposited", "data can be (accessed|downloaded|retrieved)",
    "(materials,? )?data (and|,) (analysis )?code.{0,80}(publicly |openly )?available"
  ), collapse="|"),
  open_code=paste(c(
    "open code", "code (is|are|was|were) publicly available",
    "code (is|are|was|were) openly available",
    "analysis (code|script|scripts) (is|are|was|were) available",
    "source code (is|are|was|were) available",
    "code to reproduce .* (is|are) available",
    "data (and|,) (analysis )?code.{0,80}(publicly |openly )?available"
  ), collapse="|"),
  open_materials=paste(c(
    "open materials", "materials (are|were) publicly available",
    "materials (are|were) openly available",
    "materials (can be|may be) (accessed|downloaded|retrieved)",
    "stimuli (are|were) publicly available", "protocol (is|was) publicly available",
    "materials,? data (and|,) (analysis )?code.{0,80}(publicly |openly )?available"
  ), collapse="|"),
  repository=paste(c(
    "osf\\.io/[a-z0-9]+", "github\\.com/[a-z0-9_.-]+/[a-z0-9_.-]+",
    "gitlab\\.com/[a-z0-9_.-]+/[a-z0-9_.-]+",
    "zenodo\\.org/(record|records)/[0-9]+", "figshare\\.com",
    "doi\\.org/10\\.17605/OSF\\.IO/[A-Z0-9]+", "datadryad\\.org",
    "openneuro\\.org", "psycharchives\\.org"
  ), collapse="|")
)

get_hits = function(text, pattern){
  loc = gregexpr(pattern, text, ignore.case=TRUE, perl=TRUE)[[1]]
  if(loc[1] == -1) return(character())
  start = pmax(1, loc - 180)
  end = pmin(nchar(text), loc + attr(loc, "match.length") + 260)
  out = substring(text, start, end)
  out = gsub("[[:space:]]+", " ", out)
  unique(out)
}

get_doi = function(pages){
  if(length(pages) == 0) return(NA_character_)
  text = paste(head(pages, 2), collapse=" ")
  pattern = "10\\.[0-9]{4,9}/[-._;()/:A-Z0-9]+"
  hits = regmatches(text, gregexpr(pattern, text, ignore.case=TRUE,
                                  perl=TRUE))[[1]]
  if(length(hits) == 0) return(NA_character_)
  hits = tolower(hits)
  hits = sub("[.,;:]+$", "", hits)
  hits = hits[!grepl("/(journal|article)$", hits)]
  if(length(hits) == 0) return(NA_character_)
  doi = hits[1]
  if(lengths(regmatches(doi, gregexpr("\\(", doi))) <
     lengths(regmatches(doi, gregexpr("\\)", doi)))) doi = sub("\\)$", "", doi)
  doi
}

make_id = function(doi, md5){
  if(!is.na(doi) && nzchar(doi)){
    id = gsub("[^a-z0-9]+", "-", tolower(doi))
    id = gsub("(^-|-$)", "", id)
    return(paste0("doi-", id))
  }
  paste0("local-", substr(md5, 1, 12))
}

ledger = NULL
if(file.exists("ledger/screening.csv")){
  ledger = read.csv("ledger/screening.csv", stringsAsFactors=FALSE,
                    check.names=FALSE, fileEncoding="UTF-8-BOM")
}

results = vector("list", length(pdfs))

for(i in seq_along(pdfs)){
  cat(i, "/", length(pdfs), basename(pdfs[i]), "\n")
  md5 = unname(tools::md5sum(pdfs[i]))

  old_hash = integer()
  if(!is.null(ledger) && nrow(ledger) > 0) old_hash = which(ledger$md5 == md5)

  if(length(old_hash) > 0){
    j = tail(old_hash, 1)
    results[[i]] = data.frame(
      record_id=ledger$record_id[j], doi=ledger$doi[j],
      path=gsub("\\\\", "/", pdfs[i]), file=basename(pdfs[i]), md5=md5,
      pages=NA_integer_, score=NA_integer_, preregistration=FALSE,
      open_data=FALSE, open_code=FALSE, open_materials=FALSE,
      repository=FALSE, negative_claim=FALSE, evidence="",
      processing_state="known-md5", suggested_decision="skip",
      screening_version=screen_version, stringsAsFactors=FALSE
    )
    next
  }

  pages = tryCatch(pdf_text(pdfs[i]), error=function(e) character())
  text = paste(pages, collapse="\n")
  doi = get_doi(pages)
  record_id = make_id(doi, md5)
  processing_state = "new"

  if(!is.null(ledger) && nrow(ledger) > 0 && !is.na(doi)){
    old_doi = which(!is.na(ledger$doi) & ledger$doi == doi)
    if(length(old_doi) > 0){
      j = tail(old_doi, 1)
      record_id = ledger$record_id[j]
      processing_state = "source-changed"
    }
  }

  prereg_text = gsub(paste(c(
    "not (pre-?registered|preregistered)", "was not preregistered",
    "were not preregistered"
  ), collapse="|"), "", text, ignore.case=TRUE, perl=TRUE)

  hits = lapply(patterns, function(pattern) get_hits(text, pattern))
  hits$preregistration = get_hits(prereg_text, patterns$preregistration)
  present = vapply(hits, length, integer(1)) > 0

  negative = grepl(paste(c(
    "not (pre-?registered|preregistered)", "was not preregistered",
    "were not preregistered", "available (only )?(from|upon request)",
    "not publicly available", "cannot be made (publicly )?available"
  ), collapse="|"), text, ignore.case=TRUE, perl=TRUE)

  evidence = unique(unlist(hits))
  evidence = paste(head(evidence, 12), collapse=" || ")
  score = 4 * present["preregistration"] + 4 * present["open_data"] +
    4 * present["open_code"] + 3 * present["open_materials"] +
    2 * present["repository"] - negative

  suggested = ifelse(
    length(pages) == 0 || processing_state == "source-changed" ||
      (score >= 5 && (present["preregistration"] | present["open_data"] |
                       present["open_code"] | present["open_materials"])),
    "review", "reject"
  )

  results[[i]] = data.frame(
    record_id=record_id, doi=doi, path=gsub("\\\\", "/", pdfs[i]),
    file=basename(pdfs[i]), md5=md5, pages=length(pages), score=score,
    preregistration=present["preregistration"], open_data=present["open_data"],
    open_code=present["open_code"], open_materials=present["open_materials"],
    repository=present["repository"], negative_claim=negative,
    evidence=evidence, processing_state=processing_state,
    suggested_decision=suggested, screening_version=screen_version,
    stringsAsFactors=FALSE
  )
}

if(length(results) == 0){
  df = data.frame(
    record_id=character(), doi=character(), path=character(), file=character(),
    md5=character(), pages=integer(), score=integer(), preregistration=logical(),
    open_data=logical(), open_code=logical(), open_materials=logical(),
    repository=logical(), negative_claim=logical(), evidence=character(),
    processing_state=character(), suggested_decision=character(),
    screening_version=character(), stringsAsFactors=FALSE
  )
} else {
  df = do.call(rbind, results)
  df = df[order(df$suggested_decision, -df$score, df$file),]
}

write.csv(df, "reports/screening.csv", row.names=FALSE, fileEncoding="UTF-8")

decisions = df[c("record_id", "doi", "md5", "path", "file",
                 "processing_state", "suggested_decision")]
decisions$decision = decisions$suggested_decision
decisions$practices = rep("", nrow(decisions))
decisions$evidence_page = rep("", nrow(decisions))
decisions$evidence_note = rep("", nrow(decisions))
decisions$evidence_url = rep("", nrow(decisions))
decisions$reviewer = ifelse(decisions$decision %in% c("reject", "skip"),
                            "algorithm", "")
decisions$note = ifelse(
  decisions$decision == "reject",
  "No substantive practice detected by the local screen; no contrary evidence identified.",
  ifelse(decisions$decision == "skip", "Exact file hash already present in the ledger.", "")
)

if(file.exists("reports/decisions.csv")){
  old = read.csv("reports/decisions.csv", stringsAsFactors=FALSE,
                 check.names=FALSE, fileEncoding="UTF-8-BOM")
  pos = match(decisions$md5, old$md5)
  use = !is.na(pos)
  keep_cols = intersect(names(decisions), names(old))
  for(nm in keep_cols) decisions[use,nm] = old[pos[use],nm]
}

write.csv(decisions, "reports/decisions.csv", row.names=FALSE,
          fileEncoding="UTF-8")

cat("\nInbox PDFs:", nrow(df), "\n")
cat("New or changed:", sum(df$processing_state != "known-md5"), "\n")
cat("Semantic review:", sum(decisions$decision == "review"), "\n")
cat("Known hashes skipped:", sum(decisions$decision == "skip"), "\n")
