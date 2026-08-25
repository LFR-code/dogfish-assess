# Sex-code audit: results for Interim Review Report 1 (S.5, S.11)

**To:** Sean Cox
**From:** S.D.N. Johnson, Landmark Fisheries Research
**Date:** 25 August 2026
**Re:** Outside Pacific Spiny Dogfish -- verification of the numeric
sex-code dictionary, and disposition of the S.11 run gate

---

## Bottom line

The numeric sex codes are correct as used. Code 1 is male and code 2 is
female, confirmed against the authoritative DFO data dictionary published
on the Government of Canada open data portal. The composition inputs to
A0 are not reversed, and the run gate in S.11 can be lifted.

The anomaly you identified is real, but it is not a coding artifact. It is
confined to the midwater trawl fleet, where it has a straightforward
reading as size-selective availability. The separate structural concern
raised in the first paragraph of S.5 -- whether strongly sex-specific
selectivity is necessary -- is unaffected by this result and in our view
remains the more consequential question.

## What was tested

Your S.5 required audit asked for the sex codes to be traced from raw
records through to the SS3 inputs, and for sex-specific means and
quantiles to be compared by dataset. The two files you were missing,
`survey-samples.rds` and `commercial-samples.rds`, are present in the
repository we hold, so the trace could be completed. We also refit the
model under the reversal hypothesis to bound its consequence.

## Evidence

### 1. The authoritative dictionary

The DFO "Groundfish Synoptic Bottom Trawl Surveys" record on
open.canada.ca (dataset `a278d1af-d567-4964-a109-ae1e84cbd24a`) publishes a
data dictionary that defines the field directly:

> **Sex** -- Sex of the fish: 0 = not examined; 1 = male; 2 = female,
> 3 = unknown

This is the item listed as outstanding in your S.15. It matches the
assumption in `ss3/01-outside-stock-synthesis-data.R` line 323
(`sex = ifelse(sex == 1, "M", "F")`) exactly. It is also consistent with
the code frequencies in the raw file, which include the rare 0 and 3
categories the dictionary describes (0: 525; 1: 86,783; 2: 62,914; 3: 25;
missing: 706).

### 2. The published data reproduce the repository extraction

The portal also publishes specimen-level biology. Queen Charlotte Sound
dogfish records, compared against the same survey in the repository copy:

| source | sex 1: n, mean, q95, max | sex 2: n, mean, q95, max |
|---|---|---|
| Open data portal | 2920, 70.1, 85, 99 | 1531, 64.4, 82, 118 |
| `survey-samples.rds` | 3156, 69.9, 85, 99 | 1681, 63.9, 81, 118 |

Lengths in cm. Small count differences reflect usability-code filtering.
The two sources agree, so the GFBio extraction is faithful.

### 3. Cross-check against unambiguous character codes

The IPHC length file carries character codes (`"F"`, `"M"`) and so does
not depend on the numeric dictionary at all. Numeric code 2 tracks IPHC
"F" and code 1 tracks "M" in every gear:

| source | F mean | F q95 | F max | M mean | M q95 | M max |
|---|---|---|---|---|---|---|
| IPHC (character codes) | 91.5 | 108 | 122 | 78.1 | 88 | 115 |
| Bottom trawl (code 2 / 1) | 94.1 | 110 | 124 | 78.2 | 91 | 112 |
| Longline (code 2 / 1) | 95.4 | 110 | 128 | 82.3 | 90 | 114 |

### 4. The maxima never invert

Code 2 reaches 116-128 cm in every gear and survey; code 1 tops out at
99-115 cm. A label reversal flips an entire distribution, maximum
included. Here the maximum stays with code 2 even in the fleets where its
*median* is smaller. That signature is not consistent with a swap. It is
consistent with females spanning a wider size range than males, which
mature small and stop growing.

### 5. Maturity staging

Sex 1 is almost entirely a single maturity code (90, n = 13,738). Sex 2
carries the full staged ladder (50-56, 70-79, 95-99), which is the
gestation and uterus-condition staging that exists only for females.

### 6. The reversal fits materially worse

We built `S1_sexswap` by exchanging the 17 female and 17 male bins in all
73 length-composition rows of A0's `data.ss`, confirmed no other part of
the file changed, and refit with the Hessian:

| component | A0 (as coded) | S1 (sexes swapped) | change |
|---|---|---|---|
| Length composition | 671.1 | 1007.8 | **+336.7** |
| Survey | 922.5 | 871.5 | -51.0 |
| Parameter priors | 52.7 | 134.8 | **+82.1** |
| **Total** | **1646.4** | **2014.1** | **+367.7** |
| Depletion 2023 | 0.086 | 0.076 | |

Both fits are the best of 21 starts; see section 8 on why that matters.

The mechanism is visible in the aggregate composition fits
(`review/figs/02-sexswap-comp-fits.png`). The swap requires large numbers
of males at 95-105 cm in the landings fleets, against a male asymptotic
length of roughly 84 cm and a female value of 97.4 cm. The model cannot
reach that, so the compositions misfit and selectivity is driven hard
against its priors -- the contortion anticipated in S.5, but appearing in
the swapped configuration rather than the base.

### 7. The direction is inconsistent across fleets

Mean observed length by sex in A0's own compositions, aggregated over
years:

| fleet | mean F | mean M | F - M | proportion female |
|---|---|---|---|---|
| Bottom Trawl Landings | 95.7 | 80.6 | **+15.1** | 0.90 |
| HookLine Landings | 96.3 | 82.2 | **+14.1** | 0.84 |
| IPHC | 88.9 | 75.6 | **+13.3** | 0.59 |
| Bottom Trawl Discards | 67.0 | 66.0 | +1.0 | 0.49 |
| SYN | 67.2 | 67.7 | -0.5 | 0.46 |
| Midwater Trawl | 56.3 | 63.6 | **-7.4** | 0.42 |

Four of six fleets run in the expected direction, three of them by 13-15
cm. Aggregated across years only midwater trawl shows the flagged pattern
materially; SYN is -0.5 cm, which is no difference. Individual Synoptic
years may still resemble Figures 7 and 9.

This distribution is itself an argument against a coding error,
independent of the raw data. A dictionary error is a property of the
source system, so it must flip every fleet drawn from that system in the
same direction. Midwater trawl and bottom-trawl landings both come from
`commercial-samples.rds` and are both numerically coded, yet they run in
opposite directions. No dictionary swap can produce that.

### 8. Midwater trawl's own data reject the swap

The obvious follow-up is whether midwater trawl, the one fleet that shows
the pattern materially, fits better when reversed. It does not. We
decomposed the length-composition likelihood by fleet, and additionally
fit `S2_mwswap`, in which only the 14 midwater trawl rows are exchanged
and every other fleet is left as coded.

Establishing this took more care than we first applied, for a reason that
matters beyond this question. **The likelihood surface is strongly
multi-modal.** Perturbed configurations started from the supplied control
values converge, with small maximum gradient components and no parameter
at a bound, to optima several hundred likelihood units worse than the
same configuration started elsewhere. Every figure below is therefore the
best of 21 starts: the supplied values, a warm start from A0's solution
where the parameter vector permits, and 19 seeded jitters. A0 itself is
robust -- all 21 starts return 1646.38.

| fleet | A0 | all swapped | MW-only swapped |
|---|---|---|---|
| Bottom Trawl Landings | 34.5 | 128.1 | 34.1 |
| Bottom Trawl Discards | 65.7 | 61.7 | 66.6 |
| **Midwater Trawl** | **108.1** | **118.5** | **119.6** |
| HookLine Landings | 35.1 | 128.9 | 34.9 |
| IPHC | 168.5 | 289.0 | 169.8 |
| SYN | 259.1 | 281.6 | 257.8 |
| **Length-comp total** | **671.1** | **1007.8** | **682.7** |
| **Total objective** | **1646.4** | **2014.1** | **1664.0** |

Midwater trawl is worse under both configurations: 108.1 as coded, 118.5
when every fleet is swapped, 119.6 when it alone is swapped. Under the
single-fleet swap the penalty is almost entirely confined to the fleet
that was swapped -- 11.5 units of a total 11.6-unit change in the
length-composition likelihood -- and the other five fleets move by at
most 1.3 units either way. The fleet that generated the anomaly is the
fleet whose own data most directly reject reversing it.

The single-fleet swap costs 17.6 units in total against A0, on identical
data and an identical parameter count. That is a decisive preference in
likelihood terms without being dramatic, and it is a smaller margin than
the global reversal's 367.7.

## What the anomaly actually is

Female dogfish span roughly 40 to 120+ cm. Males compress into a narrow
adult band near 70-90 cm. In gear that catches predominantly juveniles the
female mode therefore sits *below* the male mode while the female tail
still extends far above it. Midwater trawl is the clear case: female mode
near 58 cm against a male mode near 78 cm, with female maximum 116 cm
against male 110 cm. This is size structure and availability, and it is
the branch anticipated in your S.12 ("If sex codes are correct,
investigate spatial availability, sampling, and fleet behaviour").

## Disposition

- The S.11 run gate can be lifted. Compositions do not need rebuilding.
- The S.15 request for the authoritative sex-code dictionary is closed;
  the source is cited in section 1 above and is publicly available.
- **New, and relevant to the S.10 programme: this surface is
  multi-modal.** Single-start fits of perturbed configurations landed up
  to 645 likelihood units above the best optimum we could find for the
  same configuration, converging cleanly each time. No diagnostic in
  S.10 can be interpreted from a single fit, and we would want to know
  whether the published sensitivities were multi-started before their
  likelihoods are compared with one another or combined in an ensemble.
  The alternative modes are interpretable rather than numerical noise: at
  the poor SYN optimum the male apex selectivity scale falls from 0.934 to
  0.446, so the model explains the same sex composition by deciding the
  survey barely catches males. That the data admit both readings is
  independent support for your S.5 concern that sex-specific selectivity
  is weakly identified.
- The S.5 structural question -- whether common gear selectivity-at-length
  across sexes is the better rebuilding baseline -- is untouched by this
  result. We note that in A0 male selectivity in both Bottom Trawl
  Landings and HookLine Landings is effectively zero, i.e. the model
  attributes the landed catch almost entirely to females. That is a strong
  claim resting on sex-specific selectivity and we suggest it is the
  higher-value target for the bounded diagnostic programme in S.10.

## Reproduction status

For the record, the items listed as missing in S.11 have been
reconstructed:

- SS3 v3.30.22.1 (`ss3_opt_osx_arm64`, SHA-256
  `38870aa0...f756ea5dc5`), pinned and fetched by script.
- All 21 A- and B-series configurations refit and converged, maximum
  gradient 1e-8 to 1.6e-3.
- A0 reproduces the published base depletion: 0.086 with standard
  deviation 0.005, against `\BaseDepl` 0.09 and CI 0.08-0.09.
- Note that A8 (HBLL only) returns depletion 0.997 with zero standard
  deviation and an unfished spawning output of 1.08e7. It appears to carry
  no scale information and should not be given weight in an ensemble.
- The R environment is pinned in an `renv.lock` (230 packages, dated CRAN
  snapshot, GitHub packages pinned by commit).

## Outstanding data request

The one remaining gap is the midwater trawl biological samples, which are
commercial rather than survey data and so are not on the open portal. See
the accompanying request. Coverage in the copy we hold is 27,933 dogfish
specimens with sex and length, sampling description UNSORTED, 1979-2019,
across 257 distinct samples, with 18,741 of those specimens in the 1990s.
