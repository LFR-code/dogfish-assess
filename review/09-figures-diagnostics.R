# Figures for the diagnostics summary page.
# Base graphics throughout, white ground (the page frames them on a light
# surface so they read the same in either theme).
suppressMessages(library(r4ss))

dir.create("review/figs", showWarnings = FALSE, recursive = TRUE)

get <- function(m) SS_output(file.path("review/fits", m), verbose = FALSE,
                             printstats = FALSE, hidewarn = TRUE, covar = TRUE)
A0  <- get("A0")
D3  <- get("D3_recdev")
D3b <- get("D3b_recdev_window")
D4  <- get("D4_lorenzenM")

col_a0  <- "#5A6B6A"
col_d4  <- "#0D6B62"
col_d3  <- "#A34A1C"
col_d3b <- "#C2185B"
col_f   <- "#C2185B"
col_m   <- "#1976D2"

ssb <- function(r) {
  d <- r$derived_quants
  i <- grep("^SSB_[0-9]{4}$", d$Label)
  y <- as.numeric(sub("^SSB_", "", d$Label[i]))
  o <- order(y)
  data.frame(yr = y[o], ssb = as.numeric(d$Value[i])[o])
}
depl <- function(r, lab = "Bratio_2023") {
  d <- r$derived_quants; i <- match(lab, d$Label)
  c(as.numeric(d$Value[i]), as.numeric(d$StdDev[i]))
}

# ---------------------------------------------------------------- figure 1
# D4: natural mortality at age, and what it does to the trajectory
png("review/figs/fig1-D4-lorenzen.png", width = 2200, height = 1000, res = 200)
op <- par(mfrow = c(1, 2), mar = c(4.2, 4.4, 3, 1), oma = c(0, 0, 0, 0))

eg <- D4$endgrowth
fem <- eg[eg$Sex == 1, ]; mal <- eg[eg$Sex == 2, ]
plot(NA, xlim = c(0, 70), ylim = c(0, 0.20), xlab = "Age (years)",
     ylab = "Natural mortality M", main = "Natural mortality at age")
abline(h = 0.065, col = col_a0, lwd = 3, lty = 2)
lines(fem$Age_Beg, fem$M, col = col_f, lwd = 3)
if (nrow(mal)) lines(mal$Age_Beg, mal$M, col = col_m, lwd = 3, lty = 3)
abline(v = 40, col = "grey75", lty = 3)
text(40, 0.004, " reference age", cex = 0.72, col = "grey45", adj = 0)
legend("topright", bty = "n", cex = 0.85, lwd = 3,
       lty = c(2, 1, 3), col = c(col_a0, col_f, col_m),
       legend = c("A0: constant 0.065", "D4 female (Lorenzen)", "D4 male"))

sa <- ssb(A0); s4 <- ssb(D4)
plot(NA, xlim = c(1937, 2023), ylim = c(0, max(sa$ssb, s4$ssb) * 1.05),
     xlab = "Year", ylab = "Spawning output", main = "Spawning output")
lines(sa$yr, sa$ssb, col = col_a0, lwd = 3)
lines(s4$yr, s4$ssb, col = col_d4, lwd = 3)
da <- depl(A0); d4v <- depl(D4)
legend("topright", bty = "n", cex = 0.85, lwd = 3, col = c(col_a0, col_d4),
       legend = c(sprintf("A0        depl %.3f", da[1]),
                  sprintf("D4        depl %.3f", d4v[1])))
par(op); dev.off()

# ---------------------------------------------------------------- figure 2
# D3b: the recruitment deviations, and the trajectory they imply
png("review/figs/fig2-D3b-recdev.png", width = 2200, height = 1000, res = 200)
op <- par(mfrow = c(1, 2), mar = c(4.2, 4.4, 3, 1))

p <- D3b$parameters
rec <- p[!is.na(p$Active_Cnt) & grepl("^Main_RecrDev_", p$Label), ]
yr <- as.numeric(sub("^Main_RecrDev_", "", rec$Label))
v <- rec$Value; sd <- rec$Parm_StDev
o <- order(yr); yr <- yr[o]; v <- v[o]; sd <- sd[o]
plot(NA, xlim = range(yr), ylim = range(c(v - sd, v + sd), na.rm = TRUE),
     xlab = "Year", ylab = "log recruitment deviation",
     main = "D3b recruitment deviations")
abline(h = 0, col = "grey70")
abline(h = c(-0.4, 0.4), col = "grey85", lty = 3)
segments(yr, v - sd, yr, v + sd, col = adjustcolor(col_d3b, 0.45), lwd = 2)
points(yr, v, pch = 16, col = col_d3b, cex = 0.8)
lines(yr, v, col = adjustcolor(col_d3b, 0.6))
legend("topleft", bty = "n", cex = 0.75, text.col = "grey30",
       legend = c("dotted grey = assumed sigmaR 0.4",
                  sprintf("estimated sd = %.2f", sd(v))))

sb <- ssb(D3b); s3 <- ssb(D3)
plot(NA, xlim = c(1937, 2023), ylim = c(0, max(sa$ssb, sb$ssb, s3$ssb) * 1.05),
     xlab = "Year", ylab = "Spawning output", main = "Spawning output")
lines(sa$yr, sa$ssb, col = col_a0, lwd = 3)
lines(s3$yr, s3$ssb, col = col_d3, lwd = 2.5, lty = 2)
lines(sb$yr, sb$ssb, col = col_d3b, lwd = 3)
d3v <- depl(D3); d3bv <- depl(D3b)
legend("topright", bty = "n", cex = 0.85, lwd = 3, lty = c(1, 2, 1),
       col = c(col_a0, col_d3, col_d3b),
       legend = c(sprintf("A0    depl %.3f", da[1]),
                  sprintf("D3    depl %.3f", d3v[1]),
                  sprintf("D3b   depl %.3f", d3bv[1])))
par(op); dev.off()

# ---------------------------------------------------------------- figure 3
# depletion across the diagnostics, with uncertainty
png("review/figs/fig3-depletion.png", width = 1700, height = 950, res = 200)
par(mar = c(4.2, 11, 2.5, 2))
mods <- c(A0 = "A0", D4_lorenzenM = "D4  Lorenzen M",
          D1_commonsel = "D1  common sex sel.",
          D2_nodiscardlen = "D2  no discard comps",
          D3_recdev = "D3  recdevs 1960-2022",
          D3b_recdev_window = "D3b recdevs 1970-2015")
vals <- t(vapply(X = names(mods), FUN.VALUE = numeric(2),
                 FUN = function(m) depl(get(m))))
n <- nrow(vals); ypos <- rev(seq_len(n))
plot(NA, xlim = c(0, 0.25), ylim = c(0.5, n + 0.5), yaxt = "n",
     xlab = "2023 depletion (SSB / SSB0)", ylab = "",
     main = "Estimated status across diagnostics")
abline(v = seq(0, 0.25, 0.05), col = "grey92")
abline(v = vals[1, 1], col = col_a0, lty = 2)
cols <- c(col_a0, col_d4, "#7A5AA0", "#2C6B40", col_d3, col_d3b)
segments(vals[, 1] - 1.96 * vals[, 2], ypos, vals[, 1] + 1.96 * vals[, 2],
         ypos, col = cols, lwd = 3)
points(vals[, 1], ypos, pch = 16, col = cols, cex = 1.5)
axis(2, at = ypos, labels = mods, las = 1, cex.axis = 0.8, tick = FALSE)
text(vals[, 1], ypos + 0.28, sprintf("%.3f", vals[, 1]), cex = 0.7, col = cols)
dev.off()

# ---------------------------------------------------------------- figure 4
# published sensitivities: paired panels avoid the label collisions of a
# scatter, and put penalty and status change on a common ordering
s <- read.csv("review/figs/08-sensitivity-multistart.csv", stringsAsFactors = FALSE)
s <- s[order(s$penalty), , drop = FALSE]
n <- nrow(s)
png("review/figs/fig4-sensitivities.png", width = 2100, height = 1500, res = 190)
op <- par(mfrow = c(1, 2), mar = c(4.4, 11.5, 3.2, 1))

bar_col <- ifelse(s$penalty > 100, "#A34A1C",
                  ifelse(s$penalty > 10, "#C08A2E", "#8C9A99"))
xp <- pmax(s$penalty, 0.03)
plot(NA, log = "x", xlim = c(0.03, 4000), ylim = c(0.5, n + 0.5), yaxt = "n",
     xlab = "Likelihood units above best optimum (log)", ylab = "",
     main = "How far the published start sits\nabove a better optimum")
abline(v = c(0.1, 1, 10, 100, 1000), col = "grey93")
abline(v = 10, col = "grey55", lty = 3)
segments(0.03, seq_len(n), xp, seq_len(n), col = bar_col, lwd = 4)
points(xp, seq_len(n), pch = 16, col = bar_col, cex = 1.1)
axis(2, at = seq_len(n), labels = s$model, las = 1, cex.axis = 0.72, tick = FALSE)
lab <- s$penalty > 10
text(xp[lab], seq_len(n)[lab], sprintf(" %.0f", s$penalty[lab]),
     pos = 4, cex = 0.68, col = bar_col[lab])

par(mar = c(4.4, 1, 3.2, 2))
plot(NA, xlim = c(-0.03, 0.03), ylim = c(0.5, n + 0.5), yaxt = "n",
     xlab = "Change in 2023 depletion at the better optimum", ylab = "",
     main = "What it changes about\nestimated status")
abline(v = seq(-0.03, 0.03, 0.01), col = "grey93")
abline(v = 0, col = "grey45")
segments(0, seq_len(n), s$depl_shift, seq_len(n), col = bar_col, lwd = 4)
points(s$depl_shift, seq_len(n), pch = 16, col = bar_col, cex = 1.1)
big <- abs(s$depl_shift) >= 0.005
text(s$depl_shift[big], seq_len(n)[big], sprintf("%+.3f", s$depl_shift[big]),
     pos = ifelse(s$depl_shift[big] > 0, 4, 2), cex = 0.68, col = bar_col[big])
mtext("largest change anywhere: 0.022", side = 3, line = -0.2, cex = 0.7,
      col = "grey45")
par(op); dev.off()

cat("wrote fig1-D4-lorenzen.png, fig2-D3b-recdev.png,",
    "fig3-depletion.png, fig4-sensitivities.png\n")
