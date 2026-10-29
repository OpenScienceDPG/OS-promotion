library(yaml)

allowed_states = c("new", "candidate", "needs-review", "screened-reject",
                   "ready", "published")
# Controlled practice keys and their badges, defined once in config/badges.yml
badges = yaml.load_file("config/badges.yml")
claims = names(badges)
allowed_verification = c("agent-verified", "human-verified", "legacy-reviewed",
                         "unverified")

blank = function(x){
  is.null(x) || length(x) == 0 || all(is.na(x)) || !nzchar(trimws(as.character(x)[1]))
}

private_source = function(txt){
  # Public publisher supplements may be PDFs; local PDF sources stay private.
  without_urls = gsub("https?://[^[:space:]<>\"']+", "", txt, ignore.case=TRUE)
  grepl("selected/|archive/|inbox/|md5", txt, ignore.case=TRUE) ||
    grepl("\\.pdf", without_urls, ignore.case=TRUE)
}

errors = character()

# Every badge needs a label, an existing image, its pop-up text, and a web link
for(key in claims){
  b = badges[[key]]
  if(blank(b$label) || blank(b$short_description) || blank(b$badge) || blank(b$description) || blank(b$link) ||
     blank(b$link_text)){
    errors = c(errors, paste("config/badges.yml:", key,
                             "needs label, short_description, badge, description, link and link_text"))
    next
  }
  if(!file.exists(file.path("assets/badges", b$badge))){
    errors = c(errors, paste("config/badges.yml:", key, "badge file not found in assets/badges/:",
                             b$badge))
  }
  if(!grepl("^https?://", b$link)){
    errors = c(errors, paste("config/badges.yml:", key, "link is not a web address:", b$link))
  }
}

files = list.files("records", pattern="record\\.yml$", recursive=TRUE,
                   full.names=TRUE)
files = files[basename(dirname(files)) != "records"]

if(length(files) == 0) errors = c(errors, "No canonical records found.")

records = vector("list", length(files))
ids = dois = character(length(files))

for(i in seq_along(files)){
  x = yaml.load_file(files[i])
  records[[i]] = x
  label = gsub("\\\\", "/", files[i])

  if(blank(x$id)){
    errors = c(errors, paste(label, "has no stable id"))
    next
  }
  ids[i] = x$id
  if(x$id != basename(dirname(files[i]))){
    errors = c(errors, paste(label, "id does not match its directory"))
  }
  if(is.null(x$schema_version) || x$schema_version != 1){
    errors = c(errors, paste(label, "has unsupported schema_version"))
  }
  if(blank(x$screening$status) || !x$screening$status %in% allowed_states){
    errors = c(errors, paste(label, "has an invalid lifecycle state"))
  }
  if(!blank(x$doi)){
    dois[i] = tolower(x$doi)
    if(x$doi != tolower(x$doi) || !grepl("^10\\.", x$doi)){
      errors = c(errors, paste(label, "has a non-normalized DOI"))
    }
  }

  missing_claims = claims[!claims %in% names(x$open_science)]
  if(length(missing_claims) > 0){
    errors = c(errors, paste(label, "is missing claims:",
                             paste(missing_claims, collapse=", ")))
  }

  for(key in claims){
    if(isTRUE(x$open_science[[key]])){
      found = FALSE
      for(ev in x$evidence){
        ev_claims = unlist(ev$claims)
        valid_passage = !blank(ev$passage)
        valid_verification = !blank(ev$verification) &&
          ev$verification %in% allowed_verification
        if(key %in% ev_claims && valid_passage && valid_verification) found = TRUE
      }
      if(!found){
        errors = c(errors, paste(label, "has", key,
                                 "= true without matching auditable evidence"))
      }
    }
  }

  override = x$human_override
  if(x$screening$status %in% c("ready", "published")){
    open = claims[vapply(claims, function(key) isTRUE(x$open_science[[key]]), logical(1))]
    expected = paste(vapply(badges[open], function(b) b$short_description, ""), collapse="; ")
    if(blank(x$curation$why_open) || x$curation$why_open != expected){
      errors = c(errors, paste(label, "why_open does not match the fixed badge descriptions"))
    }
    if(!blank(x$bibliography$year) && as.numeric(x$bibliography$year) >= 2025){
      article_urls = tolower(sub("/+$", "", unlist(x$resources$article)))
      article_urls = unique(c(article_urls, paste0("https://doi.org/", x$doi)))
      for(field in setdiff(names(x$resources), "article")){
        urls = unlist(x$resources[[field]])
        if(any(tolower(sub("/+$", "", urls)) %in% article_urls) &&
           blank(x$curation$article_resources[[field]])){
          errors = c(errors, paste(label, field,
            "reuses the article URL: supply the resource link or document its location in curation.article_resources"))
        }
      }
    }
  }
  if(!blank(override$decision)){
    if(!override$decision %in% c("keep", "reject") || blank(override$by) ||
       blank(override$at) || blank(override$note)){
      errors = c(errors, paste(label, "has an incomplete human override"))
    }
    if(!blank(x$screening$final_decision) &&
       x$screening$final_decision != override$decision){
      errors = c(errors, paste(label, "does not respect its human override"))
    }
  }

  if(x$screening$status %in% c("ready", "published") &&
     x$screening$final_decision != "keep"){
    errors = c(errors, paste(label, "is eligible but final_decision is not keep"))
  }
  if(x$screening$status == "screened-reject" &&
     x$screening$final_decision != "reject"){
    errors = c(errors, paste(label, "is screened-reject without a reject decision"))
  }
  if(x$screening$status == "published" && !isTRUE(x$publication$published)){
    errors = c(errors, paste(label, "has published state without publication approval"))
  }
  if(isTRUE(x$publication$published) && x$screening$status != "published"){
    errors = c(errors, paste(label, "has publication approval but is not published"))
  }
}

if(anyDuplicated(ids[nzchar(ids)])){
  errors = c(errors, paste("Duplicate record ids:",
                           paste(unique(ids[duplicated(ids)]), collapse=", ")))
}
if(anyDuplicated(dois[nzchar(dois)])){
  errors = c(errors, paste("Duplicate DOIs:",
                           paste(unique(dois[duplicated(dois)]), collapse=", ")))
}

ledger_file = "ledger/screening.csv"
if(!file.exists(ledger_file)){
  errors = c(errors, "Missing ledger/screening.csv")
} else {
  ledger = read.csv(ledger_file, stringsAsFactors=FALSE, check.names=FALSE,
                    fileEncoding="UTF-8-BOM")
  required = c("event_id", "event_type", "processed_at", "record_id", "doi",
               "md5", "file", "screening_version", "algorithm_score",
               "algorithm_suggestion", "final_decision", "decision_source",
               "reason", "human_override", "source_action")
  if(any(!required %in% names(ledger))){
    errors = c(errors, "The screening ledger has an invalid layout.")
  } else {
    unknown = unique(ledger$record_id[!ledger$record_id %in% ids])
    if(length(unknown) > 0){
      errors = c(errors, paste("Ledger references unknown records:",
                               paste(unknown, collapse=", ")))
    }
    if(anyDuplicated(ledger$event_id)) errors = c(errors, "Ledger event_id values are not unique.")

    for(i in seq_along(records)){
      x = records[[i]]
      if(!blank(x$human_override$decision)){
        has_event = any(ledger$record_id == x$id & ledger$event_type == "human-override")
        if(!has_event) errors = c(errors, paste(x$id, "has an override but no ledger event"))
      }
    }
  }
}

site_file = "data/publications.csv"
if(file.exists(site_file)){
  public = read.csv(site_file, stringsAsFactors=FALSE, check.names=FALSE,
                    fileEncoding="UTF-8-BOM")
  eligible = ids[vapply(records, function(x){
    x$screening$status %in% c("ready", "published") &&
      x$screening$final_decision == "keep"
  }, logical(1))]
  if(nrow(public) > 0 && any(!public$id %in% eligible)){
    errors = c(errors, "Generated site data contain an ineligible record.")
  }
  # The showcase covers publications from site_min_year on (see 05-build-site-data.R)
  site_min_year = 2025
  if(nrow(public) > 0 && any(is.na(public$year) | public$year < site_min_year)){
    errors = c(errors, paste("Generated site data contain records published before",
                             site_min_year))
  }
  txt = paste(readLines(site_file, warn=FALSE, encoding="UTF-8"), collapse="\n")
  if(private_source(txt)){
    errors = c(errors, "Generated site data contain private source information.")
  }
}

listing_file = "data/listing.md"
if(file.exists(listing_file)){
  txt = paste(readLines(listing_file, warn=FALSE, encoding="UTF-8"), collapse="\n")
  if(private_source(txt)){
    errors = c(errors, "Generated listing contains private source information.")
  }
}

docs_files = list.files("docs", pattern="\\.(html|json)$", recursive=TRUE,
                        full.names=TRUE)
docs_files = docs_files[!grepl("/site_libs/", docs_files)]
for(f in docs_files){
  txt = paste(readLines(f, warn=FALSE, encoding="UTF-8"), collapse="\n")
  if(private_source(txt)){
    errors = c(errors, paste("Rendered site file contains private source information:", f))
  }
}
if(length(list.files("docs", pattern="\\.pdf$", recursive=TRUE, ignore.case=TRUE)) > 0){
  errors = c(errors, "Rendered site contains PDF files.")
}

if(length(errors) > 0){
  cat("Validation failed:\n-", paste(errors, collapse="\n- "), "\n")
  quit(status=1, save="no")
}

cat("Validation passed:", length(files), "records and", nrow(ledger),
    "ledger events.\n")

no_summary = vapply(records, function(x){
  x$screening$status %in% c("ready", "published") && blank(x$curation$public_summary)
}, logical(1))
if(any(no_summary)){
  cat("Note: eligible records without curation.public_summary:",
      paste(ids[no_summary], collapse=", "), "\n")
}
