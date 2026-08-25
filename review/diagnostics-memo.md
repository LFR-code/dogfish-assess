# Section 10 diagnostics: first results

**To:** Sean Cox
**From:** S.D.N. Johnson, Landmark Fisheries Research
**Date:** 25 August 2026
**Re:** Outside Pacific Spiny Dogfish -- bounded diagnostic programme,
first four diagnostics, and a methodological problem that conditions
all of them

---

## Summary

Four of your seven S.10 diagnostics are run. Before any of them: this
likelihood surface is strongly multi-modal, single-start fits of
perturbed configurations are not trustworthy, and the source of the
problem turns out to be the sex-specific selectivity structure you
flagged in S.5. Everything below is best-of-N.

Two substantive results.

**A0's depletion is not robust to relaxing its deterministic structure.**
Estimated 2023 depletion moves from 0.086 to 0.185 when recruitment
deviations are switched on, and the fit to *both* data components
improves. Your B-series counterparts reach 0.172 and 0.179 by relaxing
constant M instead. Three independent relaxations land near twice the
base depletion.

**Constant M is a worse-fitting assumption than a standard alternative
at identical cost.** Lorenzen M, with the same 46 estimated parameters,
fits better on both data components than A0 does.

Neither disturbs the low-abundance conclusion, which is robust across
everything we have run. What moves is the reconstructed unfished scale,
and therefore the removal advice.

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

A0 reaches its best optimum from the supplied values, so those are well
tuned. But its basin is narrow. Counting how often 21 jittered starts
reach the best optimum found for each configuration:

| Configuration | Starts reaching best | Rate | Worst start |
|---|---|---|---|
| A0 | 6 of 21 | 29% | 5000 |
| S1_sexswap | 1 of 21 | 5% | 5451 |
| S2_mwswap | 4 of 21 | 19% | 5535 |
| **D1_commonsel** | **20 of 21** | **95%** | **1854** |
| D2_nodiscardlen | 6 of 21 | 29% | 3391 |
| D3_recdev | 1 of 21 | 5% | 3466 |

**The one configuration that optimises reliably is the one with
sex-specific selectivity switched off.** D1 fixes the 24 male-offset
parameters and converges to within 2 units from 20 of 21 starts. Every
configuration that retains those offsets finds its best optimum between 5
and 29% of the time, with worst starts three times the best value.

The alternative modes are interpretable rather than numerical noise, and
they are consistently in the same parameters: at the poor SYN optimum the
male apex selectivity scale falls from 0.934 to 0.446, so the model
explains the same sex composition by deciding the survey barely catches
males.

This is an independent line of evidence for your S.5 concern. The
sex-specific selectivity structure is not merely flexible enough to admit
several explanations of the same data -- it is flexible enough to make
the likelihood surface pathological, and it is the specific source of
that pathology in this model.

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
proposed is not supported by these data on fit alone.

That said, the two results are in tension and the tension is the point.
The data prefer sex-specific curves by a wide margin, and those same
curves are what make the model unreliable to fit -- D1 is the only
configuration we have that optimises dependably. A structure that
improves fit by 206 units while turning a well-behaved optimisation
problem into one that finds its own optimum 29% of the time is not
obviously the right structure for a rebuilding baseline, whatever the
likelihood ratio says. Whether those curves represent gear behaviour or
absorbed availability is not resolved by a fit test, and we would want
the profile and the retrospective before recommending either way.

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

**The result survives the obvious objection.** `D3b_recdev_window`
restricts the deviations to 1970-2015, dropping the unidentified
pre-1977 block and the terminal years that cannot yet be observed. It
uses 46 deviations instead of 63 and reaches a total of 1520.2 against
D3's 1513.8 -- essentially the same fit for 17 fewer parameters:

| | A0 | D3 (1960-2022) | D3b (1970-2015) |
|---|---|---|---|
| Survey | 922.5 | 768.3 | 772.5 |
| Length composition | 671.1 | 643.9 | 650.0 |
| Recruitment penalty | 0.0 | 51.3 | 45.9 |
| Deviations estimated | 0 | 63 | 46 |
| Depletion 2023 | 0.086 | 0.185 | **0.175** |

Both windows give a deviation standard deviation well above the assumed
sigmaR of 0.4 (0.515 and 0.571), and both roughly double estimated
depletion. The conclusion does not rest on the deviations that the data
cannot inform.

## 4. Mortality structure (S.10 row 3)

`D4_lorenzenM` switches `natM_type` from 0 to 2 with a reference age of
40, matching `Growth_Age_for_L2`. The supplied fixed M of 0.065 becomes M
*at that age*, so only the shape changes and the parameter count is
unchanged. Syntax is from the v3.30.22.1 manual, which specifies one
additional integer line for the reference age under option 2.

| | A0 | D4_lorenzenM |
|---|---|---|
| Estimated parameters | 46 | 46 |
| Total objective | 1646.4 | **1567.8** |
| Survey | 922.5 | **877.6** |
| Length composition | 671.1 | **637.3** |
| Unfished spawning output | 39,194 | 40,286 |
| Depletion 2023 | 0.086 | 0.097 |

Resulting female M-at-age: 0.184 at age 0, 0.097 at age 10, 0.069 at age
30, 0.065 at the reference age 40, and 0.061 at age 70.

At identical parameter count, Lorenzen fits better on both data
components by 78.6 units combined. There is no parsimony argument for
constant M here -- it is simply the worse of the two.

Per the agreed sequencing we are holding the phi0, S0 and
reference-point consequences until the baseline is validated against the
authors' outputs, since those are absolute rather than relative
quantities. This configuration is still being multi-started, so the
numbers above are provisional.

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

- Old-age biology and trawl removals (rows 5, 7), deferred until the
  baseline is validated against the authors' outputs.
- A0 verification proper (row 1), blocked on those outputs. See the
  separate request.
