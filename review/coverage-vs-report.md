# Coverage against Interim Review Report 1

Status as of 25 August 2026. Honest accounting: one of four immediate
priorities is substantially complete, the other three are untouched.

## Immediate priorities (report, executive summary)

| # | Priority | Status |
|---|---|---|
| 1 | Obtain missing outputs, executable, raw sex data | **Mostly done** |
| 2 | Run bounded SS3 diagnostics after A0 verification | Not started |
| 3 | Complete comparison reviews | Not started |
| 4 | Separate status evidence from removal advice | Not started |

### Priority 1, in detail

- **Raw sex-specific data** -- resolved. Both files were present in the
  repository we hold, and the authoritative code dictionary is public.
- **Audit of Figures 7 and 9** -- resolved in substance. Sex-specific
  means and quantiles computed by fleet directly from A0 inputs. The
  figures themselves were not regenerated; the numbers behind them were.
- **Executable** -- partially resolved, and this matters. We fetched the
  official v3.30.22.1 release and pinned it by SHA-256. That is *not* the
  same as the authors' build. The report correctly noted inconsistent
  version documentation, and we can confirm it: `Notes.md` names
  3.30.21.1 while linking 3.30.22.1, the fitting script names 3.30.22.1,
  and the release binary self-reports `3.30.22.beta: not an official
  version of SS`. The authors' exact binary is still required.
- **Final fitted outputs** -- still missing. No `Report.sso`, `ss.par`,
  covariance files, profiles, retrospectives, or MCMC output from the
  authors.

### A note on what "reproduction" currently means

Report S.12 instructs: search locally for a compatible executable, *but
do not claim baseline reproduction without the authors' final version and
outputs*. We are respecting that. What we can say is narrower than
reproduction:

- All 21 A- and B-series configurations converge, gradients 1e-8 to
  1.6e-3, Hessian obtained.
- A0 returns depletion 0.086 (SD 0.005), consistent with the published
  0.09 and CI 0.08-0.09 in `values/ref-pts.tex`.

We have **not** matched the authors' likelihood, parameter vector,
warnings, or gradients, because those files do not exist on our side.
Baseline validation in the S.12 sense remains open.

## Bounded diagnostic programme (report S.10)

| Diagnostic | Status |
|---|---|
| A0 verification | Partial -- blocked on the authors' outputs |
| Common sex selectivity | **Run** (`D1_commonsel`) |
| Mortality structure (M-at-length, phi0) | **Run** (`D4_lorenzenM`) |
| Recruitment process | **Run** (`D3_recdev`, `D3b_recdev_window`) |
| Old-age biology | Deferred, needs the baseline |
| Discard lengths | **Run** (`D2_nodiscardlen`) |
| Trawl removals | Deferred, needs the baseline |

Four of seven run. Two are deferred by the sequencing decision (old-age
biology, trawl removals), and A0 verification is blocked on the authors'
outputs.

### A finding that conditions all of them

**The likelihood surface is strongly multi-modal.** Configurations
started from the supplied control values converge cleanly -- small
gradients, no parameters at bounds -- to optima up to 645 units worse
than the same configuration started elsewhere:

| Configuration | Supplied start | Best of 21 | Penalty |
|---|---|---|---|
| A0 | 1646.38 | 1646.38 | 0 |
| D1_commonsel | 1852.16 | 1852.16 | 0 |
| S1_sexswap | 2016.86 | 2014.13 | 2.7 |
| D3_recdev | 2147.14 | 1513.81 | 633.3 |
| D2_nodiscardlen | 2071.55 | 1434.23 | 637.3 |
| S2_mwswap | 2309.14 | 1664.04 | 645.1 |

The source is identifiable: D1, the configuration with the 24
sex-specific selectivity offsets fixed, reaches its optimum from 20 of 21
starts. Every configuration retaining those offsets manages 5-29%.

All 21 published configurations were then multi-started. **Eleven sit
more than 10 units above a better optimum**, three by roughly 650, and
the penalty is almost entirely in the length compositions each time.
Estimated status is nearly untouched: the largest change in 2023
depletion is 0.022 and most are 0.000. So the Research Document's status
conclusions are robust, while its composition fits, residual diagnostics
and any likelihood-based model weighting are not. Full table in
`diagnostics-memo.md` section 5 and `figs/08-sensitivity-multistart.csv`.

We recommend **common sex selectivity** first. In A0, male selectivity in
both Bottom Trawl Landings and HookLine Landings is effectively zero --
the model attributes landed catch almost entirely to females. That is a
strong structural claim, it drives female fishing mortality directly, and
it is the diagnostic whose result most changes rebuilding advice.

## Work while the request is pending (report S.12)

| Task | Status |
|---|---|
| Map fleet selectivity, male offsets, mirroring, catch multipliers | **Done** |
| Compare every sensitivity input against A0 | Not started |
| Sex-specific means and quantiles from A0 | **Done** |
| Inspect code for numeric-to-character sex conversions | Partial |
| Search locally for a compatible SS3 executable | **Done** |

The fleet map is written up in `fleet-structure-map.md`: fleet
definitions, selectivity patterns and mirroring, catchability, catch
multipliers, and how discard mortality reaches the model by two different
routes. One structural point from it bears on the diagnostics -- fleet 2,
Bottom_Trawl_Discards, drives the selectivity of four other fleets, so
its length compositions are load-bearing far beyond the discard fishery.

On sex conversions, we traced the two in the construction script (line
279, IPHC characters; line 323, numeric survey and commercial codes) but
have not swept the plotting code in `03-outside-ss3-figures.R`.

## Files still required (report S.15)

| Item | Status |
|---|---|
| Exact final executable and fitted output directories | Still required |
| Sex-specific composition records and code dictionary | **Resolved** |
| Raw survey and commercial sample files | In hand |
| Joint age-length-maturity-reproductive data with provenance | Partial |
| Northwest Atlantic technical research document | Not obtained |
| Fleet documentation: discard sampling, retention, mortality | Not obtained |

Midwater trawl commercial biological records are the subject of a
separate outstanding request (`data-request-midwater-trawl.md`).

## Work completed outside the report's scope

- The R environment is pinned in `renv.lock` (230 packages, dated CRAN
  snapshot, GitHub packages pinned by commit), and the SS3 binary is
  pinned by version and checksum with a fetch script. Neither existed
  before; both are prerequisites for any claim of reproduction.
- `fit_ss3()` was hardcoded to another user's machine and could not run
  as supplied. Now resolves a repository-local binary.
- **A8 (HBLL only) is degenerate**: depletion 0.997, standard deviation
  0.000, unfished spawning output 1.08e7. It appears to carry no scale
  information. This is not raised in the report and should be checked
  before A8 is given any weight in an ensemble.
