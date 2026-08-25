# Compare the Section 10 diagnostics against A0, using the canonical
# best-of-N fits produced by 06-fit-best.R.
suppressMessages(library(r4ss))

mods <- c(A0 = "A0", D1_commonsel = "D1_commonsel",
          D2_nodiscardlen = "D2_nodiscardlen", D3_recdev = "D3_recdev")
reps <- lapply(X = mods, FUN = function(m)
  SS_output(file.path("review/fits", m), verbose = FALSE,
            printstats = FALSE, hidewarn = TRUE, covar = TRUE))
fl <- reps[[1]]$FleetNames

gv <- function(r, lab, col = "Value") {
  d <- r$derived_quants
  i <- match(lab, d$Label)
  if (is.na(i)) NA_real_ else as.numeric(d[[col]][i])
}

# --- headline comparison -------------------------------------------------
hd <- do.call(rbind, lapply(X = names(mods), FUN = function(m) {
  r <- reps[[m]]; l <- r$likelihoods_used
  data.frame(model = m,
             npar = sum(!is.na(r$parameters$Active_Cnt)),
             TOTAL = round(l["TOTAL", "values"], 1),
             Survey = round(l["Survey", "values"], 1),
             Lencomp = round(l["Length_comp", "values"], 1),
             Recruit = round(l["Recruitment", "values"], 1),
             SSB0 = round(gv(r, "SSB_Virgin")),
             SSB2023 = round(gv(r, "SSB_2023")),
             depl2023 = round(gv(r, "Bratio_2023"), 3),
             depl_sd = round(gv(r, "Bratio_2023", "StdDev"), 3),
             F2023 = round(gv(r, "F_2023"), 4))
}))
cat("=== Headline comparison (best-of-N fits) ===\n")
print(hd, row.names = FALSE)

# --- likelihood ratio for the nested case (D1 nested in A0) --------------
d_nll <- hd$TOTAL[hd$model == "D1_commonsel"] - hd$TOTAL[hd$model == "A0"]
d_df  <- hd$npar[hd$model == "A0"] - hd$npar[hd$model == "D1_commonsel"]
cat(sprintf("\nD1 is nested in A0: dNLL = %.2f on %d df, LR = %.1f, p = %.3g\n",
            d_nll, d_df, 2 * d_nll, pchisq(2 * d_nll, d_df, lower.tail = FALSE)))
cat(sprintf("AIC  A0 = %.1f   D1 = %.1f\n",
            2 * hd$TOTAL[hd$model == "A0"] + 2 * hd$npar[hd$model == "A0"],
            2 * hd$TOTAL[hd$model == "D1_commonsel"] +
              2 * hd$npar[hd$model == "D1_commonsel"]))

# --- female vs male apical F, and mature female biomass ------------------
cat("\n=== 2023 apical F by fleet ===\n")
ff <- do.call(rbind, lapply(X = names(mods), FUN = function(m) {
  ts <- reps[[m]]$timeseries
  y <- ts[ts$Yr == 2023, grep("^F:_", names(ts)), drop = FALSE]
  data.frame(model = m, t(round(unlist(y), 4)))
}))
names(ff)[-1] <- fl[seq_len(ncol(ff) - 1)]
print(ff, row.names = FALSE)

write.csv(hd, "review/figs/07-diagnostics-headline.csv", row.names = FALSE)
write.csv(ff, "review/figs/07-diagnostics-apicalF.csv", row.names = FALSE)
