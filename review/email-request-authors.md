# Draft email: request to the assessment authors

**From:** S.D.N. Johnson (Landmark Fisheries Research)
**Cc:** S. Cox
**To:** S.C. Anderson, Q.C. Huynh, L.N.K. Davidson, J.R. King
**Subject:** Dogfish assessment review -- request for model outputs

---

Hello,

Landmark Fisheries Research has been contracted to review the Outside
Pacific Spiny Dogfish assessment (Res. Doc. 2025/055) in support of
rebuilding planning. We have the `dogfish-assess` repository and have
refit all 21 A- and B-series configurations from the supplied inputs.

We have worked through the Research Document, so this is a short list.
Most of what we initially wanted is documented there.

## 1. The build

Was the published work run on a standard release build, or a custom
compilation? If custom, could you send the `.tpl` source, or simply a
diff against the v3.30.22.1 release source? We would rather compile
locally than depend on a platform-specific binary, and a diff would
likely answer the question without either of us building anything.

We ask because the repository is inconsistent on version: `ss3/Notes.md`
names 3.30.21.1 but links the 3.30.22.1 release, `02-outside-ss3-r4ss.R`
names 3.30.22.1, and the official 3.30.22.1 binary self-reports as
`3.30.22.beta`. The fitting script also mentions "a custom compilation
that fixes lognormal prior density function if necessary".

For what it is worth we have checked, and that particular fix cannot
affect these models: none of the 21 configurations uses a lognormal
prior. Every prior is absent, CASAL's beta, or normal. A one-line
confirmation either way would be enough.

## 2. Fitted outputs

The complete final output directory for A0 -- `Report.sso`,
`CompReport.sso`, `warning.sso`, `ss.par`, `covar.sso`, `ss_summary.sso`,
`Forecast-report.sso` -- and the equivalents for the sensitivity runs,
profiles and retrospectives where they exist.

Our A0 converges and returns 2023 S/S0 of 0.086 (SD 0.005), consistent
with the published 0.09 and CI of 0.08-0.09. But we cannot describe that
as reproducing your model without comparing likelihood components, the
parameter vector, warnings and gradients.

## 3. The MCMC output for A1 and B2, and one observation behind it

This is our most specific request, and the reason for it is the one
substantive thing we have that is not in the Research Document.

Section 3.3 states that models were assessed as converged when the
maximum absolute log-likelihood gradient was < 0.0001 and the Hessian was
invertible. We have multi-started every configuration -- 11 starts each
for the published models, 21 for our own diagnostics, jittered by 10% of
each estimated parameter's bounded range -- and we find that this
criterion does not discriminate on this likelihood surface.

Eleven of the 21 published configurations reach, from the supplied
initial values, an optimum more than 10 likelihood units above the best
we can find for the same configuration. Three are roughly 650 units
above: B2, B4 and A13. Every one of those poor optima satisfies your
stated criterion -- small gradient, invertible Hessian, no parameters at
bounds. The penalty is almost entirely in the length compositions; B2's
composition likelihood falls from 1194.0 to 537.9 at the better optimum.

We want to be clear about what this does and does not mean. Estimated
status is almost unaffected: across all 21 configurations the largest
change in 2023 S/S0 between the supplied start and the better optimum is
0.022, and most are 0.000. **This does not appear to affect the stock
status conclusions in the Research Document.** It bears on composition
fits, residual diagnostics, and any comparison between models made on
likelihood.

Which brings us to the request. B2 is both one of the three largest
penalties and one of only two models you sampled with MCMC. The
posterior samples and log-posterior traces for B2 would tell us a great
deal: if the chains explored the better mode, the trace would show it and
our concern is substantially reduced; if they stayed in the neighbourhood
of the MLE start, the posterior is centred on a mode roughly 650
likelihood units above another one. Either way that is more informative
than anything we can compute from inputs alone.

If the raw `adnuts` output or the posterior files still exist, those
would be ideal.

## 4. Biological data

We hold `survey-samples.rds` and `commercial-samples.rds`. Two items from
the reviewer's list remain outstanding:

- Joint age-length-maturity-reproductive records with sample provenance.
- Fleet documentation for discard sampling and retention, beyond the
  Courtney (2014) rates already given in Section 2.1.

We are requesting the midwater trawl commercial biological samples
separately through the Groundfish Data Unit; no action needed from you.

## One thing you may want to know

The review raised the possibility that the numeric sex codes in the
composition inputs were reversed, which would have required the
compositions and base model to be rebuilt. We have audited it and they
are not reversed. The codes are correct as used, confirmed against the
DFO groundfish data dictionary published on open.canada.ca and against
several independent lines of evidence in the data. We mention it so the
question does not reach you second-hand as an open concern.

We also reproduce your A8 finding: fitting to the HBLL Outside index
alone gives 2023 S/S0 of 0.997 with a standard deviation of 0.000 and
unfished spawning output of 1.08e7. Consistent with your note that it had
convergence issues you could not resolve.

Happy to take any of this on a call if that is easier than assembling
files.

Best regards,

Samuel Johnson
Landmark Fisheries Research
