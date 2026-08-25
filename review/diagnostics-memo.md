# Section 10 diagnostics: first results

**To:** Sean Cox
**From:** S.D.N. Johnson, Landmark Fisheries Research
**Date:** 25 August 2026
**Re:** Outside Pacific Spiny Dogfish -- bounded diagnostic programme,
first three diagnostics, and a methodological problem that conditions
all of them

---

## Summary

Three of your seven S.10 diagnostics are run. Before any of them: this
likelihood surface is strongly multi-modal, and single-start fits of
perturbed configurations are not trustworthy. Everything below is the
best of 21 starts.

The headline result is that **A0's depletion estimate is not robust to
allowing recruitment variation**. Estimated 2023 depletion moves from
0.086 to 0.185 when recruitment deviations are switched on, and the fit
to *both* data components improves substantially. That is close to what
your B-series counterparts produce by a different route (B1 0.172, B4
0.179), so two independent relaxations of A0's deterministic structure
land in the same place.

## 0. The surface is multi-modal

Configurations started from the supplied control values converge cleanly
-- small maximum gradient components, no parameters at bounds -- to
optima far from the best we can find for the same configuration.

| Configuration | Supplied start | Best of 21 | Penalty |
|---|---|---|---|
| A0 | 1646.38 | 1646.38 | 0 |
| D1_commonsel | 1852.16 | 1852.16 | 0 |
| S1_sexswap | 2016.86 | 2014.13 | 2.7 |
| D3_recdev | 2147.14 | 1513.81 | 633.3 |
| D2_nodiscardlen | 2071.55 | 1434.23 | 637.3 |
| S2_mwswap | 2309.14 | 1664.04 | 645.1 |

A0 is robust, so the supplied initial values are well tuned for the base
configuration. Nothing else can be assumed to be. The alternative modes
are interpretable rather than numerical noise: at the poor SYN optimum
the male apex selectivity scale falls from 0.934 to 0.446, so the model
explains the same sex composition by deciding the survey barely catches
males. That the data admit both readings supports your S.5 concern that
sex-specific selectivity is weakly identified.

We are currently multi-starting all 21 published configurations to see
whether any of them sits at a poor optimum. The first two checked, A0 and
A1, are both clean.

## 1. Common sex selectivity (S.10 row 2)

`D1_commonsel` fixes the four estimated male-offset parameters on each of
the six pattern-24 fleets, taking the model from 46 to 22 estimated
parameters. Verified: female and male selectivity are then identical to
machine precision in all twelve fleets.

| | A0 | D1_commonsel |
|---|---|---|
| Estimated parameters | 46 | 22 |
| Total objective | 1646.4 | 1852.2 |
| Length composition | 671.1 | 842.5 |
| Survey | 922.5 | 955.1 |
| Unfished spawning output | 39,194 | 29,588 |
| Depletion 2023 | 0.086 | 0.104 |
| F 2023 | 0.0092 | 0.0120 |

**The data reject common selectivity decisively.** D1 is nested in A0:
the likelihood ratio is 411.6 on 24 degrees of freedom, p of order
1e-72; AIC 3384.8 against 3748.4.

The more useful finding is what the structure carries. Imposing common
selectivity cuts unfished spawning output by a quarter and *raises*
both depletion and fishing mortality. So sex-specific selectivity is not
inflating female F -- removing it makes F higher, not lower -- but it is
carrying about 25% of the estimated stock scale, which is the part that
matters for rebuilding. Answering your question directly: the curves are
necessary in the statistical sense, and the parsimonious baseline you
proposed is not supported by these data. Whether the curves represent
gear behaviour or absorbed availability is not resolved by a fit test,
and the multi-modality above is a reason to keep that question open.

## 2. Discard length compositions (S.10 row 6)

`D2_nodiscardlen` drops the ten fleet-2 length-composition rows, keeping
catch and dead removals. Comparison is on retained components only, since
the data differ.

| | A0 | D2_nodiscardlen |
|---|---|---|
| Unfished spawning output | 39,194 | 46,918 |
| Depletion 2023 | 0.086 | 0.094 |
| F 2023 (total) | 0.0092 | 0.0047 |
| Apical F, Bottom Trawl Discards | 0.0107 | **0.0838** |
| Apical F, Midwater Trawl | 0.0125 | 0.0101 |

Removing those ten rows changes removal-at-length drastically. Total F
halves while apical F on bottom trawl discards rises roughly eightfold,
and unfished spawning output rises 20%. Those compositions are what pin
down that fleet's selectivity -- and through the mirroring structure,
fleets 5, 9, 10 and 12 inherit it, so ten rows of data are load-bearing
for five fleets. This is concrete support for your S.9 position that the
direction of the removal-at-length allocation must be recalculated.

## 3. Recruitment process (S.10 row 4)

`D3_recdev` switches the recruitment deviation phase from -3 to 3,
estimating 63 main deviations over 1960-2022 with sigmaR fixed at 0.4 as
supplied.

| | A0 | D3_recdev |
|---|---|---|
| Estimated parameters | 46 | 109 |
| Survey likelihood | 922.5 | **768.3** |
| Length composition | 671.1 | **643.9** |
| Data components combined | 1593.6 | **1412.2** |
| Recruitment penalty | 0.0 | 51.3 |
| Unfished spawning output | 39,194 | 36,825 |
| Depletion 2023 | 0.086 | **0.185** |
| Depletion SD | 0.005 | 0.019 |

**Both** data components improve, by 181.4 units combined, at a
recruitment penalty of 51.3. And estimated depletion more than doubles.

On identifiability, which we checked before believing any of it: the
estimated deviations have a standard deviation of 0.515, larger than the
0.4 the prior assumes, so the model wants more recruitment variation than
it is being allowed. Splitting at 1977, the first year with length
compositions: of the 17 deviations before 1977, 12 have parameter
standard deviations at or above the prior and are effectively
unidentified, functioning as a block adjustment to the initial condition.
Of the 46 from 1977 onward, 41 are genuinely estimated.

We would not lean on the AIC comparison here, because penalised
deviations are not free parameters and the count is not meaningful. The
result that matters is the direction and the size: relaxing the
deterministic recruitment assumption improves the fit to every data
component and doubles estimated depletion. This is the concrete form of
your S.4 point that failure to estimate recruitment deviations is not
evidence of deterministic pup survival.

A variant restricting the deviation window to 1970-2015, where the data
can actually inform it, is built and queued.

## What this adds up to

A0's depletion of about 0.09 is conditional on two structural
assumptions that the data do not obviously support. Allowing recruitment
variation moves it to 0.185. Your B-series counterparts, which relax
constant natural mortality instead, reach 0.172 and 0.179. Three
different relaxations of A0's deterministic structure converge on
roughly twice the base depletion.

That does not overturn the low-abundance conclusion, which is robust
across everything we have run. It does bear on the reconstructed unfished
scale and therefore on the removal advice, which is the separation you
drew in your fourth immediate priority.

## Still open

- Lorenzen M (S.10 row 3), build pending.
- Old-age biology and trawl removals (rows 5, 7), deferred until the
  baseline is validated against the authors' outputs.
- A0 verification proper (row 1), blocked on those outputs. See the
  separate request.
