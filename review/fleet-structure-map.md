# Fleet structure map

Read-only map of fleet definitions, selectivity, mirroring, catch
multipliers, and catchability in `ss3/A0/`. This closes the first item of
Cox's S.12 "work while the request is pending".

## Fleet definitions

All twelve fleets are declared `fleet_type = 1`, catch fleets. The surveys
are not survey-only fleets: they remove fish and carry catch. This is
consistent with `ss3/Notes.md` ("Survey catch as fleets") but is worth
stating plainly, because it means survey selectivity is also removal
selectivity.

| # | Fleet | Catch units | Index | Length comps |
|---|---|---|---|---|
| 1 | Bottom_Trawl_Landings | biomass | -- | yes |
| 2 | Bottom_Trawl_Discards | biomass | -- | yes |
| 3 | MidwaterTrawl | biomass | -- | yes |
| 4 | HookLine_Landings | biomass | -- | yes |
| 5 | HookLine_Discards | numbers | -- | -- |
| 6 | IPHC | numbers | yes | yes |
| 7 | HBLL | numbers | yes | -- |
| 8 | SYN | biomass | yes | yes |
| 9 | iRec | numbers | -- | -- |
| 10 | Salmon_Bycatch | numbers | -- | -- |
| 11 | HS_MSA | -- | yes | -- |
| 12 | Bottom_Trawl_CPUE | -- | yes | -- |

## Selectivity and mirroring

Six fleets estimate size selectivity with pattern 24 (double normal) and
male offset option 3. Six mirror another fleet with pattern 15.

| Fleet | Pattern | Mirrors |
|---|---|---|
| 1, 2, 3, 4, 6, 8 | 24, estimated | -- |
| 5 HookLine_Discards | 15 | fleet 2 |
| 7 HBLL | 15 | fleet 6 |
| 9 iRec | 15 | fleet 2 |
| 10 Salmon_Bycatch | 15 | fleet 2 |
| 11 HS_MSA | 15 | fleet 8 |
| 12 Bottom_Trawl_CPUE | 15 | fleet 2 |

Each pattern-24 fleet carries five male-offset parameters
(`SzSel_Male_Peak`, `_Ascend`, `_Descend`, `_Final`, `_Scale`). Four are
estimated at phase 3; `_Final` is fixed at -999. That is 24 estimated
male-offset parameters out of A0's 46 active parameters -- more than half
the estimated parameter vector is devoted to letting male selectivity
differ from female.

**Consequence worth noting.** Fleet 2, Bottom_Trawl_Discards, drives the
selectivity of four other fleets (5, 9, 10, 12) as well as its own. Its
length compositions are therefore load-bearing far beyond the discard
fishery, which is why removing them (diagnostic D2) destabilises the fit
much more than the size of the removed dataset suggests.

## Catchability

Five fleets carry indices. All five have `LnQ_base` at phase -50, but
with the float flag set to 1, so q is solved analytically each iteration
rather than being genuinely fixed. No extra SD parameters and no bias
adjustment are switched on for any index.

| Fleet | link | extra_se | biasadj | float |
|---|---|---|---|---|
| 6, 7, 8, 11, 12 (all index fleets) | 1 (simple q) | 0 | 0 | 1 |

## Catch multipliers and discard mortality

All catch multipliers are fixed at phase -50. Values in A0, and how they
move across the discard-mortality sensitivities:

| Fleet | A14 low | A0 base | A5 high | A15 100% |
|---|---|---|---|---|
| 1 Bottom_Trawl_Landings | 1 | 1 | 1 | 1 |
| 2 Bottom_Trawl_Discards | 5.263158 | 2.702703 | 1.785714 | 1 |
| 3 MidwaterTrawl | 1 | 1 | 1 | 1 |
| 4 HookLine_Landings | 1 | 1 | 1 | 1 |
| 5 HookLine_Discards | 12.5 | 3.703704 | 2.777778 | 1 |
| 6 IPHC | 12.5 | 3.703704 | 2.777778 | 1 |
| 7 HBLL | 12.5 | 3.703704 | 2.777778 | 1 |
| 8 SYN | 5.263158 | 2.702703 | 1.785714 | 1 |
| 9 iRec | 20 | 10 | 6.666667 | 1 |
| 10 Salmon_Bycatch | 3.703 | 1.234568 | 1.162791 | 1 |

Every A0 value is the reciprocal of a round number: 2.702703 = 1/0.37,
3.703704 = 1/0.27, 10 = 1/0.10, 1.234568 = 1/0.81. Under A15, described
as 100% discard mortality, all multipliers become 1.

Discard mortality reaches the model by two different routes. For the
fleets above it is carried by the multiplier, with the catch series held
constant. For fleet 3, MidwaterTrawl, the multiplier stays at 1 and the
**catch series itself** changes across the scenarios -- 28 catch records
differ, rising with assumed mortality (2005: 762.6 low, 796.1 base, 831.4
high, 913.2 at 100%).

The net behaviour is correct: total dead removals over 2000-2023 rise
monotonically with assumed discard mortality (41,236 / 45,055 / 48,459 /
58,710) and 2023 depletion falls accordingly (0.088 / 0.086 / 0.082 /
0.075). The two-route implementation is not itself an error, but the
provenance of the underlying rates is undocumented in the repository and
is on the request list to the authors.

## Natural mortality

`natM_type = 0`, a single parameter, M = 0.065, shared across sexes via a
zero male offset and constant across all ages. Growth is sex-specific
von Bertalanffy with `Growth_Age_for_L2 = 40` and exponential decay above
maximum age set to -999 (replicating SS 3.24 behaviour).

## Recruitment

Spawner-recruit option 7, the elasmobranch survival function.
`SR_LN(R0)` is the only estimated stock-recruit parameter; `SR_surv_zfrac`
is fixed at 0.4 and `SR_surv_Beta` at 1. `do_recdev = 1` but the recdev
phase is -3, so main recruitment deviations are **not estimated**. Six
forecast and late recruitment deviations are active, which is where the
gap between 40 control-file parameters and SS3's reported 46 active
parameters comes from.
