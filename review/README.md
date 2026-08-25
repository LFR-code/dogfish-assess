# Review working directory

LFR review of the Outside Pacific Spiny Dogfish assessment (Anderson et
al. 2026, DFO CSAS Res. Doc. 2025/055), against Interim Review Report 1
(S. Cox, 25 August 2026).

## Investigation 1: sex-code dictionary (Report S.5, S.11)

**Question.** Report S.11 raised the possibility that numeric sex codes
are reversed, and placed a run gate on all sex-selectivity work until the
dictionary was verified. The audit could not be completed in the report
because `survey-samples.rds` and `commercial-samples.rds` were not in the
archive supplied to the reviewer. Both are present here.

**Finding.** The codes are correct: 1 = male, 2 = female. The run gate can
be lifted. The anomaly is real but confined to midwater trawl, where it
reads as size-selective availability, and that fleet's own compositions
fit worse when its sexes are reversed.

**Evidence, in order of strength.**

1. The authoritative DFO data dictionary, published on open.canada.ca
   with the Groundfish Synoptic Bottom Trawl Surveys record
   (`a278d1af-d567-4964-a109-ae1e84cbd24a`), defines the field as
   `0 = not examined; 1 = male; 2 = female; 3 = unknown`.
2. Specimen-level biology from the same portal reproduces the repository
   extraction for Queen Charlotte Sound.
3. The IPHC length file uses character codes and so is independent of the
   numeric dictionary; code 2 tracks "F" and code 1 tracks "M" in every
   gear.
4. Code 2 always carries the larger maximum length, even where its median
   is smaller. A reversal would flip the whole distribution.
5. Maturity staging: sex 1 is one code (90); sex 2 carries the female
   gestation and uterus-condition ladder.
6. Refitting with sexes swapped costs 370.5 total likelihood units.
7. The direction of the sex-length difference is inconsistent across
   fleets, which no source-system dictionary error can produce.
8. Midwater trawl alone, swapped alone, fits worse than as coded.

## Files

| File | Purpose |
|---|---|
| `01-sex-code-audit.R` | Raw-data audit; produces figure 01 and its CSV |
| `02-sexswap-fits.R` | Fits comparison; produces figures 02, 03 and CSV |
| `sex-code-audit-memo.md` | Memo to S. Cox; `.docx` rendered via pandoc |
| `data-request-midwater-trawl.md` | Request for commercial MW trawl samples |
| `sex-code-audit.html` | Published page version, figures embedded |
| `figs/` | Figures and numeric summaries |

The `.docx` files are rendered with
`pandoc -f markdown -t docx FILE.md -o FILE.docx`. The `.html` page was
authored from the memo and is committed as published; it embeds the
figures as data URIs so it is self-contained.

## Model configurations added

| Directory | Description |
|---|---|
| `../ss3/S1_sexswap/` | Female and male bins exchanged, all 73 rows |
| `../ss3/S2_mwswap/` | Exchanged in the 14 midwater trawl rows only |

Both derive from `ss3/A0/` and differ from it only in the length
composition block of `data.ss`.

## Reproducing

```sh
bash ss3/bin/get-ss3.sh          # fetch pinned SS3 v3.30.22.1
Rscript -e 'renv::restore()'     # restore the pinned R library
Rscript review/01-sex-code-audit.R
Rscript review/02-sexswap-fits.R # requires A0 and S1 to have been run
```

To fit a model: `ss3/bin/ss3_opt modelname ss -maxfn 500` from within the
model directory, or `fit_ss3()` from `ss3/fit_ss3.R`.

## Status against the report

See `../review/coverage-vs-report.md`.
