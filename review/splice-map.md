# Where our results go into Interim Review Report 1

Section-by-section map for revising the report. Each entry gives what the
report says now, what changes, and suggested replacement text where that
is useful. Sections not listed need no change.

Everything cited is best-of-N fits; see `diagnostics-memo.md` for why
that qualifier is necessary.

---

## Executive summary

### Priority conclusion 5 -- replace entirely

Now: *"The supplied A0 input confirms that the anomalous sex pattern in
Figures 7 and 9 is present in the fitted composition data, not only the
figure legend. The underlying numeric sex-code dictionary must be
verified before interpreting sex-specific selectivity and female fishing
mortality."*

Suggested: *"The numeric sex codes are correct as used. Code 1 is male
and code 2 is female, confirmed against the DFO groundfish data
dictionary published on open.canada.ca and against independent evidence
in the data. The anomalous pattern is real but confined to the midwater
trawl fleet, where it reads as size-selective availability; that fleet's
own compositions fit worse when its sexes are reversed."*

### Priority conclusion 3 -- upgrade from assertion to result

Now: *"Failure to estimate recruitment deviations is not evidence of
deterministic pup survival."* This is now demonstrated rather than
argued. Estimating deviations improves the fit to **both** data
components by 181.4 units combined and moves 2023 depletion from 0.086 to
0.175-0.185. Suggest adding the numbers.

### Priority conclusion 4 -- extend

Now: *"Independent likelihoods may overstate information and force
selectivity or mortality to absorb movement, availability, cohort, and
sampling effects."* True, and there is now a sharper version: the
sex-specific selectivity offsets do not merely absorb these effects, they
make the likelihood surface multi-modal. See the new material for S.7.

### Immediate priorities table

Row 1 status: raw sex-specific data obtained and the dictionary question
closed. Executable and fitted outputs still required.
Row 2 status: four of seven S.10 diagnostics run. Note that we ran them
before A0 verification by explicit decision, reporting relative
comparisons only.

---

## S.2 Assessment architecture table

**Natural mortality row.** Concern currently reads *"May confound
selectivity and reproductive survival."* Replace with the stronger,
tested statement: Lorenzen M-at-length fits better than constant M on
both data components at identical parameter count (total 1562.2 against
1646.4). There is no parsimony argument for constant M.

**Recruitment row.** Add that deterministic recruitment is rejected by
the data, not merely unsupported.

**Observation row.** Add that the composition likelihood surface is
multi-modal, so residual patterns cannot be read from single fits.

---

## S.3 Stock status, S0, and reference points

**This is the most consequential splice, and it has no home in the
current text.**

The report's reporting rule -- separate evidence of low recent abundance
from confidence in the absolute unfished baseline -- is exactly right, and
we can now put a number on why it matters:

| Configuration | 2023 depletion | SD | P(below 0.2 S0) |
|---|---|---|---|
| A0 | 0.086 | 0.005 | 1.00 |
| D4 Lorenzen M | 0.089 | 0.005 | 1.00 |
| D2 no discard comps | 0.094 | 0.005 | 1.00 |
| D1 common sex selectivity | 0.104 | 0.004 | 1.00 |
| D3 recdevs 1960-2022 | 0.185 | 0.019 | **0.79** |
| D3b recdevs 1970-2015 | 0.175 | 0.017 | **0.92** |

Under A0 the stock is below the proposed LRP with certainty. Under
recruitment variation the point estimate is still below 0.2 S0, but the
probability of being below it falls to 0.79-0.92. The qualitative
conclusion survives; the confidence attached to it does not.

Suggested addition: *"Whether the stock is unambiguously below the
proposed LRP is conditional on the recruitment assumption. Under the
published deterministic structure the probability of being below 0.2 S0
is effectively one. Allowing recruitment to vary, which improves the fit
to every data component, reduces it to between 0.79 and 0.92. This is a
statement about the reference point comparison, not about whether
abundance is low, which is robust throughout."*

Normal approximation on Bratio; a posterior would be preferable and needs
the MCMC.

---

## S.4 Recruitment and productivity

**"Identifiability and alternatives"** -- the claim that A1 estimates
zfrac at its lower bound is confirmed exactly: our A1 refit gives
`SR_surv_zfrac` = 1.2e-08 against a lower bound of zero.

**"Modest recruitment variation"** -- currently speculative (*"Modest,
strongly regularized variation could explain some systematic index and
length residuals"*). Replace with the result:

- Survey likelihood 922.5 to 768.3, length composition 671.1 to 643.9,
  for a recruitment penalty of 51.3.
- Depletion 0.086 to 0.185, and 0.175 when the window is restricted to
  1970-2015 where the data can inform it.
- Estimated deviation standard deviation 0.515 to 0.571 against an
  assumed sigmaR of 0.4. The model wants more variation than the prior
  allows.
- **The deviations are a smooth multi-decadal wave, not interannual
  noise** -- roughly +0.7 in the mid-1970s, -1.0 around 2005, recovering
  since.

That last point deserves its own sentence in the report. It is the same
low-frequency signal the B-series captures by increasing natural
mortality. The recruitment and mortality diagnostics may not be
independent lines of evidence so much as two readings of one pattern,
which bears on how the structural scenarios in S.13 are set up.

---

## S.5 Sex structure and data integrity

**Delete the "Potential sex-code error" subsection** and replace with a
short statement that the audit is complete and the codes are correct.
The required-audit box and the run gate can go.

**Qualify the first paragraph.** It currently recommends *"common gear
selectivity-at-length across sexes"* as the rebuilding baseline. Our D1
result complicates this and both halves should be stated:

- The data reject common selectivity decisively: likelihood ratio 411.6
  on 24 degrees of freedom, AIC 3384.8 against 3748.4.
- But D1 is the only configuration we have that optimises reliably --
  20 of 21 jittered starts reach its optimum, against 5-29% for every
  configuration retaining the offsets.
- Imposing it cuts unfished spawning output by a quarter (39,194 to
  29,588) and *raises* F rather than lowering it. Sex-specific
  selectivity is not inflating female fishing mortality.

---

## S.6 Growth, maturity, mortality

**"Natural mortality"** -- the first recommended action (*"Recalculate
phi0 under constant M, Lorenzen-type M-at-length..."*) is partly done.
Lorenzen is built and fitted, with M declining 0.184 at age 0 to 0.065 at
the reference age 40 and 0.061 at age 70. phi0 and the replacement line
are deliberately held until the baseline is validated, since those are
absolute quantities.

---

## S.7 Observation structure and residuals

**"Length compositions and discards"** -- the recommended diagnostic
(*"remove discard length compositions while retaining dead removals"*) is
run. Report: total 2023 F halves, 0.0092 to 0.0047, while apical F on
bottom trawl discards rises roughly eightfold, 0.0107 to 0.0838.

Add the structural reason, which is not currently in the report: fleet 2
drives the selectivity of fleets 5, 9, 10 and 12 through the mirroring
structure, so ten rows of composition data are load-bearing for five
fleets.

**New subsection needed.** The multi-modality finding has no home in the
report and belongs here or in S.10:

> Twenty-one jittered starts per configuration show this likelihood
> surface is strongly multi-modal, and the source is the 24 sex-specific
> selectivity offsets. Configurations retaining them reach their own best
> optimum 5-29% of the time; the one configuration with them fixed
> reaches it from 20 of 21 starts. Eleven of the 21 published
> configurations sit more than 10 likelihood units above a better
> optimum, three by roughly 650, and in each case the penalty is almost
> entirely in the length compositions. Estimated status is nearly
> unaffected -- the largest shift in 2023 depletion is 0.022 -- so this
> is a model-selection and diagnostics problem rather than a status
> problem.

---

## S.8 Retrospective interpretation

**A new caution belongs here.** The section reads Figure 45 as showing
limited terminal-year sensitivity. Given the multi-modality, there is a
second possibility worth excluding: each retrospective peel is a separate
optimisation, and `r4ss::retro()` runs single starts from the same
initial values. Peels may therefore sit in different basins, and a smooth
retrospective could reflect peels landing consistently in the same
non-global mode as easily as it reflects stability. Any retrospective
supporting rebuilding advice should be multi-started per peel.

We have not run retrospectives, so this is a caution rather than a
finding.

---

## S.9 Removal-at-length and reference-point risk

The position that *"Direction must be recalculated"* is supported by the
D2 result above. Suggest citing it.

---

## S.10 Bounded diagnostic programme table

Status column, as of 28 August 2026:

| Diagnostic | Status |
|---|---|
| A0 verification | Blocked on the authors' outputs |
| Common sex selectivity | Run -- `D1_commonsel` |
| Mortality structure | Run -- `D4_lorenzenM`; phi0 held |
| Recruitment process | Run -- `D3_recdev`, `D3b_recdev_window` |
| Old-age biology | Deferred by sequencing decision |
| Discard lengths | Run -- `D2_nodiscardlen` |
| Trawl removals | Deferred by sequencing decision |

Add a sentence that every diagnostic must be multi-started, and that this
is now part of the programme rather than an optional refinement.

---

## S.11 Preliminary SS3 archive audit

**"Sex composition mapping"** -- replace with the audit outcome. The run
gate box can be removed.

**"Other archive findings"** -- the version inconsistency is confirmed
and can be sharpened: `Notes.md` names 3.30.21.1 while linking 3.30.22.1,
the fitting script names 3.30.22.1, and the official 3.30.22.1 macOS
binary self-reports as `3.30.22.beta: not an official version of SS`.

The remaining bullets stand. The absence of fitted outputs is still the
binding constraint.

---

## S.12 Next steps

**Decision sequence** -- the first branch (*"If raw sex codes were
reversed, rebuild compositions"*) is closed and can be struck. The second
(*"If sex codes are correct, investigate spatial availability, sampling,
and fleet behaviour"*) has a first pass: the midwater trawl pattern is
consistent with juvenile-dominated availability, female mode near 58 cm
against a male mode near 78 cm, with the female maximum still higher.

**Work while the request is pending** -- the fleet selectivity and
removals map is complete (`fleet-structure-map.md`). Sex-specific means
and quantiles are computed. Still open: comparing every sensitivity input
against A0, and sweeping the plotting code for sex conversions.

**Immediate request to the authors** -- add the convergence protocol
question. Whether the published runs were multi-started determines
whether their likelihood comparisons can be interpreted at all.

---

## S.13 Future reassessment and operating model

The design bullet *"Common gear selectivity-at-length as baseline,
separated from sex/area/time availability"* gains independent support
from an unexpected direction. It is not only a parsimony preference: the
sex-specific parameterisation is what makes the current model
ill-behaved to fit. That is an argument for the design choice even though
the current data reject common selectivity on fit.

Also worth reflecting the S.4 point above: if recruitment variation and
increasing M are two readings of one low-frequency signal, the
operating-model scenarios spanning productivity and mortality should not
be treated as independent axes.

---

## S.15 Files still required

Sex-specific composition records and the sex-code dictionary: **resolved
and can be struck**. The dictionary is public. The raw survey and
commercial sample files are in hand.

All other items stand.

---

## S.16 Interim conclusion

Replace *"The supplied SS3 inputs make the sex-coding question more
consequential because the anomalous pattern is present in the model
compositions"* with a sentence recording that the question is closed.

The rest of the paragraph holds and is if anything strengthened: our
results support the distinction between confidence in low abundance,
which is robust, and confidence in the unfished baseline and removal
reference, which is not.
