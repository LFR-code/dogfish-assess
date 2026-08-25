# Compare the base model (A0) with a variant in which the female and male
# blocks of every length-composition row are swapped (S1_sexswap).
# This tests the sex-code reversal hypothesis of Interim Review Report 1.

library(r4ss)

get <- function(d) SS_output(dir = file.path("ss3", d), verbose = FALSE,
                             printstats = FALSE, hidewarn = TRUE, covar = TRUE)
a0 <- get("A0")
sw <- get("S1_sexswap")

fl <- a0$FleetNames
col_f <- "#C2185B"; col_m <- "#1976D2"

# ---- aggregate observed / expected comps by fleet and sex ------------------
agg <- function(rep) {
  lb <- rep$lendbase
  w <- lb$Nsamp_adj
  o <- tapply(X = lb$Obs * w, INDEX = list(lb$Bin, lb$Fleet, lb$Sex), FUN = sum)
  e <- tapply(X = lb$Exp * w, INDEX = list(lb$Bin, lb$Fleet, lb$Sex), FUN = sum)
  list(obs = o, exp = e, bins = as.numeric(dimnames(o)[[1]]),
       fleets = as.numeric(dimnames(o)[[2]]))
}
A <- agg(a0); S <- agg(sw)

png("review/figs/02-sexswap-comp-fits.png", width = 2400, height = 2300, res = 190)
op <- par(mfrow = c(4, 4), mar = c(4, 4, 3, 1), oma = c(0, 0, 4, 0))
for (f in A$fleets) {
  for (nm in c("A0 (as coded)", "S1 (sexes swapped)")) {
    X <- if (nm == "A0 (as coded)") A else S
    fi <- as.character(f)
    ok <- fi %in% dimnames(X$obs)[[2]]
    if (!ok) { plot.new(); next }
    of <- X$obs[, fi, "1"]; om <- X$obs[, fi, "2"]
    ef <- X$exp[, fi, "1"]; em <- X$exp[, fi, "2"]
    of[is.na(of)] <- 0; om[is.na(om)] <- 0
    ef[is.na(ef)] <- 0; em[is.na(em)] <- 0
    tot <- sum(of, om)
    of <- of / tot; om <- om / tot; ef <- ef / tot; em <- em / tot
    ylim <- c(0, max(of, om, ef, em) * 1.15)
    plot(NA, xlim = range(X$bins), ylim = ylim, xlab = "Length (cm)",
         ylab = "Proportion", main = sprintf("%s\n%s", fl[f], nm),
         cex.main = 0.95)
    points(X$bins, of, col = col_f, pch = 16, cex = 0.8)
    points(X$bins, om, col = col_m, pch = 16, cex = 0.8)
    lines(X$bins, ef, col = col_f, lwd = 2.5)
    lines(X$bins, em, col = col_m, lwd = 2.5)
  }
}
plot.new()
legend("center", bty = "n", cex = 1.15,
       legend = c("Female obs", "Male obs", "Female fit", "Male fit"),
       col = c(col_f, col_m, col_f, col_m), pch = c(16, 16, NA, NA),
       lwd = c(NA, NA, 2.5, 2.5))
mtext("Aggregate length-composition fits: base vs sex-swapped input",
      outer = TRUE, cex = 1.2, font = 2)
par(op); dev.off()

# ---- likelihood comparison ------------------------------------------------
lik <- function(rep, nm) {
  l <- rep$likelihoods_used
  data.frame(model = nm,
             TOTAL = round(l["TOTAL", "values"], 1),
             Survey = round(l["Survey", "values"], 1),
             Length_comp = round(l["Length_comp", "values"], 1),
             Parm_priors = round(l["Parm_priors", "values"], 1))
}
L <- rbind(lik(a0, "A0 (as coded)"), lik(sw, "S1 (sexes swapped)"))
L$dTOTAL <- L$TOTAL - L$TOTAL[1]
print(L, row.names = FALSE)

dq <- function(rep, nm) {
  d <- rep$derived_quants
  g <- function(x) as.numeric(d$Value[match(x, d$Label)])
  data.frame(model = nm, SSB0 = round(g("SSB_Virgin")),
             SSB2023 = round(g("SSB_2023")),
             depl2023 = round(g("Bratio_2023"), 3))
}
D <- rbind(dq(a0, "A0 (as coded)"), dq(sw, "S1 (sexes swapped)"))
print(D, row.names = FALSE)
write.csv(cbind(L, D[, -1]), "review/figs/02-sexswap-summary.csv",
          row.names = FALSE)

# ---- length-based selectivity by sex --------------------------------------
sel <- function(rep) {
  s <- rep$sizeselex
  s[s$Factor == "Lsel" & s$Yr == max(s$Yr), , drop = FALSE]
}
sa <- sel(a0); ss <- sel(sw)
bins <- as.numeric(names(sa)[grep("^[0-9.]+$", names(sa))])

png("review/figs/03-sexswap-selectivity.png", width = 2400, height = 2300,
    res = 190)
op <- par(mfrow = c(4, 4), mar = c(4, 4, 3, 1), oma = c(0, 0, 4, 0))
for (f in sort(unique(sa$Fleet))) {
  plot(NA, xlim = range(bins), ylim = c(0, 1.05), xlab = "Length (cm)",
       ylab = "Selectivity", main = fl[f], cex.main = 1)
  for (pair in list(list(d = sa, lty = 1), list(d = ss, lty = 2))) {
    dd <- pair$d[pair$d$Fleet == f, , drop = FALSE]
    for (sx in c(1, 2)) {
      r <- dd[dd$Sex == sx, , drop = FALSE]
      if (!nrow(r)) next
      lines(bins, as.numeric(r[1, as.character(bins)]),
            col = if (sx == 1) col_f else col_m, lwd = 2.5, lty = pair$lty)
    }
  }
}
plot.new()
legend("center", bty = "n", cex = 1.05, lwd = 2.5,
       col = c(col_f, col_m, "grey30", "grey30"), lty = c(1, 1, 1, 2),
       legend = c("Female", "Male", "A0 (as coded)", "S1 (swapped)"))
mtext("Length-based selectivity by sex: base vs sex-swapped input",
      outer = TRUE, cex = 1.2, font = 2)
par(op); dev.off()
cat("\nwrote review/figs/02-sexswap-comp-fits.png and 03-sexswap-selectivity.png\n")
