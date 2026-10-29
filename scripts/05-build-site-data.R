library(yaml)

# Label, image (in assets/badges/), pop-up text and description link of each
# practice's badge, in display order. Edit them in config/badges.yml, not here.
badges = yaml.load_file("config/badges.yml")
labels = vapply(badges, function(b) b$label, "")
badge_files = vapply(badges, function(b) b$badge, "")
badge_texts = vapply(badges, function(b) b$description, "")
badge_links = vapply(badges, function(b) b$link, "")
badge_link_texts = vapply(badges, function(b) b$link_text, "")

text_value = function(x){
  if(is.null(x) || length(x) == 0 || all(is.na(x))) return("")
  as.character(x)[1]
}

collapse_value = function(x){
  if(is.null(x) || length(x) == 0) return("")
  paste(unlist(x), collapse=" | ")
}

html_escape = function(x){
  x = gsub("&", "&amp;", x, fixed=TRUE)
  x = gsub("<", "&lt;", x, fixed=TRUE)
  x = gsub(">", "&gt;", x, fixed=TRUE)
  gsub("\"", "&quot;", x, fixed=TRUE)
}

# All links in the showcase point to external pages: open them in a new tab
ext = " target=\"_blank\" rel=\"noopener\""

badge_img = function(key, class="os-badge"){
  paste0("<img class=\"", class, "\" src=\"assets/badges/", badge_files[key],
         "\" alt=\"", labels[key], "\" title=\"", labels[key], "\">")
}

# Card/dialog badges are buttons opening the badge's pop-up (badge_dialog()).
# Filter chips keep the plain badge_img(): they are already filter <button>s.
badge_button = function(key){
  info = paste0("Che cosa significa il badge ", labels[key])
  paste0("<button type=\"button\" class=\"os-badge-btn\" data-dialog=\"badge-", key,
         "\" aria-haspopup=\"dialog\" title=\"", info, "\" aria-label=\"", info, "\">",
         badge_img(key), "</button>")
}

# Badge pop-up: the badge again (larger), its plain-language Italian
# explanation, and the link to the page describing it
badge_dialog = function(key){
  id = paste0("badge-", key)
  c(paste0("<dialog class=\"os-dialog os-badge-dialog\" id=\"", id,
           "\" aria-labelledby=\"", id, "-t\">"),
    "<div class=\"os-dialog-head\"><button type=\"button\" class=\"os-dialog-close\" aria-label=\"Chiudi\">&times;</button></div>",
    "<div class=\"os-dialog-body\">", badge_img(key, class="os-badge-large"),
    "<p class=\"os-dialog-label\">Che cosa significa</p>",
    paste0("<h2 class=\"os-badge-title\" id=\"", id, "-t\">", html_escape(labels[key]), "</h2>"),
    paste0("<p class=\"os-dialog-summary\">", html_escape(badge_texts[key]), "</p>"),
    "</div>",
    paste0("<div class=\"os-card-links\"><a class=\"os-link\" href=\"", html_escape(badge_links[key]),
           "\"", ext, ">", html_escape(badge_link_texts[key]), "</a></div>"),
    "</dialog>")
}

files = list.files("records", pattern="record\\.yml$", recursive=TRUE,
                   full.names=TRUE)
records = lapply(files, yaml.load_file)
eligible = vapply(records, function(x){
  x$screening$status %in% c("ready", "published") &&
    x$screening$final_decision == "keep"
}, logical(1))
# The showcase covers publications from site_min_year on; earlier eligible
# records stay canonical but are not shown. Same constant in 04-validate.R.
site_min_year = 2025
recent = vapply(records, function(x){
  year = suppressWarnings(as.numeric(text_value(x$bibliography$year)))
  !is.na(year) && year >= site_min_year
}, logical(1))
records = records[eligible & recent]

rows = vector("list", length(records))
for(i in seq_along(records)){
  x = records[[i]]
  open = names(labels)[vapply(names(labels), function(key){
    isTRUE(x$open_science[[key]])
  }, logical(1))]

  rows[[i]] = data.frame(
    id=x$id,
    title=text_value(x$bibliography$title),
    authors=text_value(x$bibliography$authors),
    year=text_value(x$bibliography$year),
    journal=text_value(x$bibliography$journal),
    doi=text_value(x$doi),
    article_url=collapse_value(x$resources$article),
    dpg_authors=collapse_value(x$dpg$authors),
    why_open=text_value(x$curation$why_open),
    public_summary=text_value(x$curation$public_summary),
    badges=paste(labels[open], collapse=" | "),
    practices=paste(open, collapse=" "),
    data_url=collapse_value(x$resources$data),
    code_url=collapse_value(x$resources$code),
    materials_url=collapse_value(x$resources$materials),
    preregistration_url=collapse_value(x$resources$preregistration),
    protocol_url=collapse_value(x$resources$protocol),
    topics=collapse_value(x$curation$topics),
    featured=isTRUE(x$publication$featured),
    status=x$screening$status,
    stringsAsFactors=FALSE
  )
}

if(length(rows) == 0){
  public = data.frame(
    id=character(), title=character(), authors=character(), year=character(),
    journal=character(), doi=character(), article_url=character(),
    dpg_authors=character(), why_open=character(), public_summary=character(),
    badges=character(), practices=character(), data_url=character(),
    code_url=character(), materials_url=character(), preregistration_url=character(),
    protocol_url=character(), topics=character(), featured=logical(),
    status=character(), stringsAsFactors=FALSE
  )
} else {
  public = do.call(rbind, rows)
  public = public[order(!public$featured, -suppressWarnings(as.numeric(public$year)),
                        public$title),]
}

dir.create("data", recursive=TRUE, showWarnings=FALSE)
write.csv(public, "data/publications.csv", row.names=FALSE,
          fileEncoding="UTF-8", na="")

# Showcase fragment: filter toolbar + one card per publication, as raw HTML
# included by index.qmd. Filtering/search is done by the page script.
out = c("<!-- Generated by scripts/05-build-site-data.R; do not edit. -->", "",
        "```{=html}")
if(nrow(public) == 0){
  out = c(out, "<p class=\"os-empty\">Nessuna pubblicazione &egrave; al momento inclusa nella vetrina.</p>")
} else {
  practices = strsplit(public$practices, " ")
  counts = table(factor(unlist(practices), levels=names(labels)))
  counts = counts[counts > 0]

  chips = paste0("<button type=\"button\" class=\"os-chip\" data-filter=\"",
                 names(counts), "\" aria-pressed=\"false\">",
                 vapply(names(counts), badge_img, "", class="os-chip-badge"),
                 "<span>", labels[names(counts)], "</span><span class=\"os-chip-n\">",
                 as.integer(counts), "</span></button>")
  out = c(out, "<div class=\"os-toolbar\">",
          "<div class=\"os-filters\" role=\"group\" aria-label=\"Filtra per pratica\">",
          paste0("<button type=\"button\" class=\"os-chip is-active\" data-filter=\"all\" aria-pressed=\"true\"><span>Tutte</span><span class=\"os-chip-n\">",
                 nrow(public), "</span></button>"),
          chips, "</div>",
          "<label class=\"os-search\"><span class=\"visually-hidden\">Cerca</span>",
          "<input type=\"search\" id=\"os-search\" placeholder=\"Cerca per titolo, autore, rivista&hellip;\" autocomplete=\"off\"></label>",
          "</div>",
          paste0("<p class=\"os-count\" aria-live=\"polite\"><strong id=\"os-count\">",
                 nrow(public), "</strong> pubblicazioni</p>"),
          "<div class=\"os-grid\" id=\"os-grid\">")

  link_fields = c(Dati="data_url", Codice="code_url", Materiali="materials_url",
                  Preregistrazione="preregistration_url", Protocollo="protocol_url")
  for(i in seq_len(nrow(public))){
    title = if(nzchar(public$title[i])) public$title[i] else public$id[i]
    # Long author lists (e.g. multi-lab studies): first three, then "et al."
    authors = trimws(strsplit(public$authors[i], ";")[[1]])
    authors = if(length(authors) > 8) paste0(paste(authors[1:3], collapse=", "), " et al.") else
      paste(authors, collapse=", ")
    article = strsplit(public$article_url[i], " \\| ")[[1]][1]
    keys = practices[[i]][nzchar(practices[[i]])]

    # Keep every destination; merge labels only when their URL is identical.
    urls = unlist(lapply(link_fields, function(f){
      u = public[i,f]
      if(nzchar(u)) unique(strsplit(u, " \\| ")[[1]]) else character()
    }), use.names=FALSE)
    names(urls) = rep(names(link_fields), vapply(link_fields, function(f){
      u = public[i,f]
      if(nzchar(u)) length(unique(strsplit(u, " \\| ")[[1]])) else 0L
    }, integer(1)))
    urls = urls[nzchar(urls)]
    if(!is.na(article) && nzchar(article)) urls = c(Articolo=article, urls)
    links = vapply(unique(urls), function(u){
      is_article = !is.na(article) && identical(u, article)
      paste0("<a class=\"os-link", if(is_article) " os-link-article", "\" href=\"",
             html_escape(u), "\"", ext, ">",
             paste(unique(names(urls)[urls == u]), collapse=" &middot; "), "</a>")
    }, "")

    summary = public$public_summary[i]
    # Short titles leave room for a slightly longer summary preview.
    preview_words = if(nchar(title) <= 60) 26 else 20
    preview = if(nzchar(trimws(summary))) paste0(
      paste(head(strsplit(trimws(summary), "[[:space:]]+")[[1]], preview_words),
            collapse=" "), "...") else ""
    search = tolower(paste(title, authors, public$journal[i], public$year[i],
                           public$why_open[i], summary, paste(labels[keys], collapse=" ")))
    title_html = if(!is.na(article) && nzchar(article)){
      paste0("<a href=\"", html_escape(article), "\"", ext, ">", html_escape(title), "</a>")
    } else html_escape(title)
    # Badge buttons; the same HTML is reused in the summary dialog head
    badge_keys = c(keys[keys != "open_access"], keys[keys == "open_access"])
    badges_html = paste0("<div class=\"os-card-badges\">",
                         paste(vapply(badge_keys, badge_button, ""), collapse=""), "</div>")
    meta_html = paste0("<p class=\"os-card-meta\"><span class=\"os-year\">", html_escape(public$year[i]),
                       "</span><span class=\"os-journal\">", html_escape(public$journal[i]), "</span></p>")
    authors_html = if(nzchar(authors)) paste0("<p class=\"os-card-authors\">", html_escape(authors), "</p>")
    links_html = if(length(links) > 0) paste0("<div class=\"os-card-links\">", paste(links, collapse=""), "</div>")
    dialog_id = paste0("sintesi-", public$id[i])

    # Plain-language summary: opened in a modal from the card ("Leggi la sintesi divulgativa")
    dialog = if(nzchar(summary)) c(
      paste0("<dialog class=\"os-dialog\" id=\"", dialog_id, "\" aria-labelledby=\"", dialog_id, "-t\">"),
      "<div class=\"os-dialog-head\">", badges_html,
      "<button type=\"button\" class=\"os-dialog-close\" aria-label=\"Chiudi\">&times;</button></div>",
      "<div class=\"os-dialog-body\">", meta_html,
      paste0("<h2 class=\"os-dialog-title\" id=\"", dialog_id, "-t\">", title_html, "</h2>"),
      authors_html,
      "<h3 class=\"os-dialog-label\">In breve</h3>",
      paste0("<p class=\"os-dialog-summary\">", html_escape(summary), "</p>"),
      if(nzchar(public$why_open[i])) c("<h3 class=\"os-dialog-label\">Che cosa &egrave; aperto</h3>",
        # One list item per badge phrase (why_open joins them with "; ")
        paste0("<ul class=\"os-card-why\">", paste0("<li>", html_escape(strsplit(public$why_open[i], "; ", fixed=TRUE)[[1]]),
                                                    "</li>", collapse=""), "</ul>")),
      "</div>", links_html, "</dialog>")

    out = c(out,
            paste0("<article class=\"os-card\" id=\"", public$id[i], "\" data-practices=\"",
                   paste(keys, collapse=" "), "\" data-search=\"", html_escape(search), "\">"),
            badges_html,
            "<div class=\"os-card-body\">", meta_html,
            paste0("<h3 class=\"os-card-title\">", title_html, "</h3>"),
            authors_html,
            if(nzchar(preview)) paste0("<p class=\"os-card-why\">", html_escape(preview), "</p>"),
            if(nzchar(summary)) paste0("<button type=\"button\" class=\"os-more\" data-dialog=\"",
                                       dialog_id, "\">Leggi la sintesi divulgativa</button>"),
            "</div>", links_html, dialog, "</article>")
  }
  # One pop-up per badge in use, outside the cards so filtering never hides them
  out = c(out, "</div>", unlist(lapply(names(counts), badge_dialog)),
          "<p class=\"os-empty\" id=\"os-empty\" hidden>Nessuna pubblicazione corrisponde ai filtri selezionati.</p>")
}
out = c(out, "```", "")

writeLines(enc2utf8(out), "data/listing.md", useBytes=TRUE)
cat("Built site data for", nrow(public), "eligible records from", site_min_year,
    "on;", sum(eligible & !recent), "earlier eligible records not shown.\n")
