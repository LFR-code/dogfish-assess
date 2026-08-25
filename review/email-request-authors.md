# Draft email: data and output request to the assessment authors

**From:** S.D.N. Johnson (Landmark Fisheries Research)
**Cc:** S. Cox
**To:** Assessment authors, Outside Pacific Spiny Dogfish
**Subject:** Dogfish assessment review -- request for model outputs and
executable

---

Hello,

Landmark Fisheries Research has been contracted to review the Outside
Pacific Spiny Dogfish assessment (Res. Doc. 2025/055) in support of
rebuilding planning. We have the `dogfish-assess` repository and have
refit all 21 A- and B-series configurations from the supplied inputs.

Before we go further we need a small number of items that are not in the
repository. I have grouped them by why we need them rather than by file
type, since a couple of the questions may be quicker to answer than to
assemble.

## 1. The executable, and how convergence was established

Which SS3 binary produced the published results -- exact version,
platform, and whether it was a standard release or a custom build?

We ask because the repository is internally inconsistent on this point.
`ss3/Notes.md` names version 3.30.21.1 but links to the 3.30.22.1
release; `ss3/02-outside-ss3-r4ss.R` names 3.30.22.1; and the official
3.30.22.1 macOS binary self-reports as `3.30.22.beta: not an official
version of SS`. A comment in the fitting script also mentions "a custom
compilation that fixes lognormal prior density function if necessary",
which we would want to know about if it was used.

Relatedly, and this is our most important question: **what convergence
protocol was used?** Specifically, were jittered or multiple starts run,
and if so how many and with what dispersion?

We ask because we are finding this likelihood surface to be strongly
multi-modal. Perturbed configurations started from the supplied control
files converge, with small maximum gradient components, to optima several
hundred likelihood units worse than the same configuration started from a
different point. Any comparison between configurations is meaningless
unless each is at its own best optimum, so we need to know whether the
published runs were multi-started before we can interpret differences
among them.

## 2. Final fitted outputs

The complete final output directory for A0: `Report.sso`,
`CompReport.sso`, `warning.sso`, `ss.par`, `covar.sso`, `ss_summary.sso`,
and `Forecast-report.sso`.

Our A0 converges and returns 2023 depletion of 0.086 (SD 0.005), which is
consistent with the published 0.09 and CI of 0.08 to 0.09. But we cannot
confirm we have reproduced your model without comparing likelihood
components, the parameter vector, warnings, and gradients, and we are not
willing to describe our fit as a reproduction until we can.

Where they exist, we would also like the final output directories for the
reported sensitivities, likelihood profiles, retrospectives, and the MCMC
runs including posterior files.

## 3. Two specific questions about the model

**Catch multipliers.** The control file fixes these at phase -50 with
values including 2.702703 for bottom trawl discards, 3.703704 for hook
and line discards, IPHC and HBLL, and 10 for iRec. Could you point us to
the source for each, and confirm what they represent? They encode the
discard mortality assumptions and their provenance is not documented in
the repository.

**A8 (HBLL only).** Our refit returns 2023 depletion of 0.997 with a
standard deviation of 0.000 and unfished spawning output of 1.08e7. It
appears to carry no information on absolute scale. Did you see the same
behaviour, and was A8 given any weight in an ensemble or in the
derivation of reference points?

More generally, which configuration underpins the published reference
points, and if an ensemble was used, how were the models weighted?

## 4. Biological data

We hold `survey-samples.rds` and `commercial-samples.rds`. Two gaps:

- Joint age-length-maturity-reproductive records with sample provenance.
- Fleet documentation for discard sampling, retention, and the mortality
  conversions behind the catch multipliers above.

We are requesting the midwater trawl commercial biological samples
separately through the Groundfish Data Unit, since those are commercial
records; no action needed from you on that.

## One thing you may want to know

The review raised the possibility that the numeric sex codes in the
composition inputs were reversed, which would have required the
compositions and the base model to be rebuilt. We have audited it and
they are not reversed. The codes are correct as used, confirmed against
the DFO groundfish data dictionary published on open.canada.ca and
against several independent lines of evidence in the data themselves. We
mention it so the question does not reach you second-hand as an open
concern.

Happy to take any of this on a call if that is easier than assembling
files.

Best regards,

Samuel Johnson
Landmark Fisheries Research
