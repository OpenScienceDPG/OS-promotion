# Selezione iniziale

Questi 10 articoli provengono dal primo screening di 205 PDF. La selezione privilegia dichiarazioni esplicite su preregistrazione, dati, codice o materiali depositati in repository identificabili.

| PDF | Evidenza principale nel testo |
|---|---|
| `journal.pone.0297954.pdf` | Due esperimenti preregistrati su OSF; materiali, dati e codice di analisi pubblici (`gdr3b`, `z5esb`). |
| `henry-et-al-how-strong-is-the-rhythm-of-perception-a-registered-replication-of-hickok-et-al-(2015).pdf` | Registered Replication con Stage 1 preregistrato prima di raccolta e analisi; dati su OSF e supplementi su Figshare. |
| `MAGDA et al JRPe 2024 Agentic and Communal Collective Narcisism.pdf` | Progetto preregistrato; dataset, codici e materiali supplementari su OSF. |
| `Filippi 2025 They don t really care about us  the impact of perceived vertical pay disparity on employee well-being.pdf` | Due esperimenti preregistrati e dati aperti su OSF (`9vtcd`). |
| `Sica et al 2024_JPD.pdf` | Dati de-identificati elaborati e codici analitici su OSF (`pfgwa`). |
| `s41598-018-20462-6.pdf` | Dati, codice del task e codice R/procedura ML in un repository GitHub. |
| `2024_JSLHR-24-00227.pdf` | Dati e script principali su OSF, con ulteriori repository per stimoli e dati collegati. |
| `journal.pone.0315654.pdf` | Dataset, script e stimoli su OSF (`hr8sz`). |
| `Locher et al - 2022 - Publication by association- how the COVID-19 pandemic.pdf` | Codice R per riprodurre estrazione PubMed e analisi su OSF (`dqvea`). |
| `FurlanBabcockVallesiPlosOne2018.pdf` | Tutti i dati rilevanti dichiarati disponibili su OSF (`xjngr`). |

Il dettaglio strutturato è in `manifest.csv`; `initial_selection.csv` conserva la tabella originale della prima selezione.

Lo screening iniziale e la pipeline corrente usano estrazione locale con `pdftools`. Non è stato usato il GROBID pubblico di `metacheck`, perché comporterebbe il caricamento esterno dei PDF.
