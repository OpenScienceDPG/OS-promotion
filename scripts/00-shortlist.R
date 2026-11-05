library(readxl)
library(yaml)
library(httr2)
library(xml2)
library(pdftools)

# Keyword shortlist of unprocessed inventory papers (2025 onward).
# Open full texts (Europe PMC XML, OA PDFs located via OpenAlex) are cached
# locally in cache/fulltext/ (gitignored) and scanned for repository links,
# availability statements and preregistration. Nothing is uploaded; supporting
# resource links (OSF, GitHub, ...) are only matched as text, never opened.
# Output: reports/candidati-keyword-YYYY-MM-DD.csv, ordered by priority.
# The shortlist only selects candidates: every paper is still read and decided
# under AGENTS.md.

inventory = sort(list.files("inbox", "^list-[0-9-]+[.]xlsx$", full.names=TRUE), decreasing=TRUE)[1]
cache = "cache/fulltext"
dir.create(file.path(cache, "xml"), recursive=TRUE, showWarnings=FALSE)
dir.create(file.path(cache, "pdf"), recursive=TRUE, showWarnings=FALSE)
ua = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130 Safari/537.36"
nd = function(d) tolower(trimws(sub("^https?://(dx[.])?doi[.]org/", "", d)))

# Unprocessed journal articles from 2025 onward (records and ledger, incl. rejects)
x = suppressWarnings(suppressMessages(read_excel(inventory)))
x = x[as.numeric(x[["Anno di pubblicazione"]]) >= 2025 & x[["Tipologia (collezione)"]] == "01.01 - Articolo in rivista", ]
x = data.frame(doi=nd(x$DOI), title=x$Titolo, year=as.numeric(x[["Anno di pubblicazione"]]),
               journal=x[["rivista: denominazione"]], oa=x[["unpaywall: Tipologia Open Access (OA)"]],
               dpg_inventory=x[["contributors: Autori/curatori attualmente afferenti (elenco)"]])
recs = list.files("records", "record.yml", recursive=TRUE, full.names=TRUE)
known = nd(c(unlist(lapply(recs, function(f) yaml.load_file(f)$doi)), read.csv("ledger/screening.csv")$doi))
x = x[!is.na(x$doi) & x$doi != "" & !x$doi %in% known & !duplicated(x$doi), ]
cat("Unprocessed articles with DOI:", nrow(x), "\n")

# Europe PMC: PMCID, then full-text XML (open access subset only)
x$pmcid = NA_character_
for(ch in split(x$doi, ceiling(seq_along(x$doi)/25))){
  q = paste0("DOI:\"", ch, "\"", collapse=" OR ")
  r = request("https://www.ebi.ac.uk/europepmc/webservices/rest/search") |>
    req_url_query(query=q, format="json", pageSize=100, resultType="lite") |>
    req_user_agent("dpg-os-screen/1.0") |> req_perform() |> resp_body_json()
  for(it in r$resultList$result) if(!is.null(it$pmcid)) x$pmcid[x$doi == tolower(it$doi)] = it$pmcid
  Sys.sleep(0.3)
}
xml_file = function(p) file.path(cache, "xml", paste0(p, ".xml"))
pdf_file = function(d) file.path(cache, "pdf", paste0(gsub("/", "_", d), ".pdf"))
for(p in na.omit(x$pmcid)){
  if(file.exists(xml_file(p))) next
  try(request(paste0("https://www.ebi.ac.uk/europepmc/webservices/rest/", p, "/fullTextXML")) |>
        req_user_agent("dpg-os-screen/1.0") |> req_error(is_error=function(r) FALSE) |>
        req_perform(path=xml_file(p)), silent=TRUE)
  Sys.sleep(0.2)
}
has_xml = !is.na(x$pmcid) & file.exists(xml_file(x$pmcid)) & file.size(xml_file(x$pmcid)) > 5000

# OpenAlex OA locations for the others; keep only real PDFs
need = x$doi[!has_xml & !file.exists(pdf_file(x$doi))]
for(ch in split(need, ceiling(seq_along(need)/40))){
  r = request("https://api.openalex.org/works") |>
    req_url_query(filter=paste0("doi:", paste(ch, collapse="|")), `per-page`=50, select="doi,locations") |>
    req_user_agent("dpg-os-screen/1.0") |> req_perform() |> resp_body_json()
  for(w in r$results){
    f = pdf_file(nd(w$doi))
    for(u in unique(unlist(lapply(w$locations, function(l) l$pdf_url)))){
      ok = tryCatch({
        request(u) |> req_user_agent(ua) |> req_timeout(40) |> req_error(is_error=function(r) FALSE) |> req_perform(path=f)
        con = file(f, "rb"); h = readBin(con, "raw", 4); close(con); identical(rawToChar(h), "%PDF")
      }, error=function(e) FALSE)
      if(ok) break else unlink(f)
    }
  }
}

# Keyword scan, excluding reference lists where possible
repo = paste0("(osf[.]io/[a-z0-9]{4,}|github[.]com/[A-Za-z0-9_.-]+/?[A-Za-z0-9_.-]*|zenodo[.]org/[a-z/0-9.]+|",
              "10[.]5281/zenodo[.][0-9]+|figshare[.]com/[^ )]+|10[.]6084/m9[.]figshare[.][0-9.]+|dataverse[^ )]*|",
              "aspredicted[.]org/[^ )]+|openneuro[.]org/[^ )]+|psycharchives[^ )]*|gitlab[.]com/[^ )]+|",
              "pavlovia[.]org/[^ )]+|researchbox[.]org/[0-9]+|researchdata[.]cab[.]unipd[.]it[^ )]*|",
              "clinicaltrials[.]gov/[^ )]+|NCT0[0-9]{7}|CRD420[0-9]+)")
open_stmt = paste0("(openly|publicly|freely) (available|accessible)|available (at|on|in|from|via) (https?|the open science|osf|github|zenodo|figshare|a public)|",
                   "can be (found|retrieved|accessed|downloaded)|deposited|are available at|is available at|available in (a|the) (public|online|osf)|online repositor")
x$src = "none"; x$links = ""; x$prereg = FALSE; x$onreq = FALSE; x$open_stmt = FALSE
for(i in seq_len(nrow(x))){
  t = ""
  if(has_xml[i]){
    d = read_xml(xml_file(x$pmcid[i])); xml_remove(xml_find_all(d, "//ref-list")); t = xml_text(d); x$src[i] = "epmc"
  } else if(file.exists(pdf_file(x$doi[i]))){
    t = tryCatch(paste(suppressMessages(pdf_text(pdf_file(x$doi[i]))), collapse="\n"), error=function(e) "")
    t = sub("(?s)\n\\s*(References|REFERENCES|Bibliography)\\s*\n.*$", "", t, perl=TRUE); x$src[i] = "pdf"
  }
  t = gsub("[​­]", "", gsub("\\s+", " ", t))
  x$links[i] = paste(unique(regmatches(t, gregexpr(repo, t, ignore.case=TRUE, perl=TRUE))[[1]]), collapse=" ; ")
  x$prereg[i] = grepl("preregist|pre-regist|registered report|in-principle accept", t, ignore.case=TRUE)
  x$onreq[i] = grepl("upon request|on request|reasonable request", t, ignore.case=TRUE)
  m = regexpr("data (availability|accessibility|sharing)|availability of data|open practices", t, ignore.case=TRUE)
  das = if(m > 0) substr(t, m, m + 400) else ""
  x$open_stmt[i] = grepl(open_stmt, das, ignore.case=TRUE)
}

# Tiers and priority: 2026 first, then 2025; A before B; no full text last
link = grepl("osf|github|zenodo|figshare|dataverse|aspredicted|openneuro|psycharchives|gitlab|pavlovia|researchbox|researchdata", x$links, ignore.case=TRUE)
x$tier = ifelse(x$src == "none", "D-no-fulltext",
         ifelse(link & x$open_stmt, "A-statement+link",
         ifelse(link | x$prereg, "B-link-or-prereg", "C-no-signal")))
x = x[x$tier != "C-no-signal", ]
x$priority = ifelse(x$tier == "D-no-fulltext", 4 + (x$year < 2026), (x$year < 2026) * 2 + (x$tier == "B-link-or-prereg") + 0)
x = x[order(x$priority, x$journal, x$doi), ]
out = file.path("reports", paste0("candidati-keyword-", format(Sys.Date(), "%Y-%m-%d"), ".csv"))
write.csv(x[, c("priority", "tier", "year", "doi", "title", "journal", "oa", "src", "pmcid", "links", "prereg", "onreq", "dpg_inventory")],
          out, row.names=FALSE, fileEncoding="UTF-8")
print(table(x$tier, x$year))
cat("Written:", out, "\n")
