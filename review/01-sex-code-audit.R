# Audit of the sex-code mapping flagged in Interim Review Report 1 (s.5, s.11).
# Question: is numeric sex code 1 = male, 2 = female (as assumed in
# ss3/01-outside-stock-synthesis-data.R), or are the codes reversed?
#
# The IPHC length file carries unambiguous character codes ("F"/"M") and so
# provides a reference distribution against which the numeric codes can be
# compared.

d <- readRDS("data/raw/survey-samples.rds")
cs <- readRDS("data/raw/commercial-samples.rds")
ip <- read.csv("data/raw/IPHC_dogfish_lengths2021.csv")

ip <- ip[ip$reg_area == "2B" & ip$sex %in% c("F", "M") & !is.na(ip$length), ,
         drop = FALSE]
ip$length <- ip$length * 1.20 # pre-caudal -> extended, as in the SS3 script

syn <- d[d$survey_abbrev %in% c("SYN WCHG", "SYN HS", "SYN QCS", "SYN WCVI") &
         d$sex %in% c(1, 2) & !is.na(d$length), , drop = FALSE]
cs <- cs[cs$sex %in% c(1, 2) & !is.na(cs$length) &
         cs$gear_desc %in% c("BOTTOM TRAWL", "MIDWATER TRAWL", "LONGLINE"), ,
         drop = FALSE]

# Assemble panels: name, female-vector, male-vector, under the mapping under test
panels <- list(
  list(nm = "IPHC (character codes)",
       f = ip$length[ip$sex == "F"], m = ip$length[ip$sex == "M"]),
  list(nm = "Synoptic surveys (code 2 / 1)",
       f = syn$length[syn$sex == 2], m = syn$length[syn$sex == 1]),
  list(nm = "Bottom trawl (code 2 / 1)",
       f = cs$length[cs$sex == 2 & cs$gear_desc == "BOTTOM TRAWL"],
       m = cs$length[cs$sex == 1 & cs$gear_desc == "BOTTOM TRAWL"]),
  list(nm = "Longline (code 2 / 1)",
       f = cs$length[cs$sex == 2 & cs$gear_desc == "LONGLINE"],
       m = cs$length[cs$sex == 1 & cs$gear_desc == "LONGLINE"]),
  list(nm = "Midwater trawl (code 2 / 1)",
       f = cs$length[cs$sex == 2 & cs$gear_desc == "MIDWATER TRAWL"],
       m = cs$length[cs$sex == 1 & cs$gear_desc == "MIDWATER TRAWL"])
)

col_f <- "#C2185B"
col_m <- "#1976D2"

png("review/figs/01-sex-code-length-distributions.png",
    width = 2400, height = 1500, res = 200)
op <- par(mfrow = c(2, 3), mar = c(4, 4, 3, 1), oma = c(0, 0, 3, 0))
for (p in panels) {
  df <- density(p$f, from = 30, to = 130)
  dm <- density(p$m, from = 30, to = 130)
  plot(NA, xlim = c(30, 130), ylim = c(0, max(df$y, dm$y) * 1.05),
       xlab = "Length (cm, extended)", ylab = "Density", main = p$nm)
  polygon(x = c(df$x, rev(df$x)), y = c(df$y, rep(0, length(df$y))),
          col = adjustcolor(col_f, 0.35), border = NA)
  polygon(x = c(dm$x, rev(dm$x)), y = c(dm$y, rep(0, length(dm$y))),
          col = adjustcolor(col_m, 0.35), border = NA)
  lines(df, col = col_f, lwd = 2)
  lines(dm, col = col_m, lwd = 2)
  abline(v = max(p$f), col = col_f, lty = 3, lwd = 2)
  abline(v = max(p$m), col = col_m, lty = 3, lwd = 2)
  legend("topleft", bty = "n", cex = 0.85,
         legend = c(sprintf("F  max %.0f  q95 %.0f", max(p$f),
                            quantile(p$f, 0.95)),
                    sprintf("M  max %.0f  q95 %.0f", max(p$m),
                            quantile(p$m, 0.95))),
         text.col = c(col_f, col_m))
}
plot.new()
legend("center", bty = "n", cex = 1.1, lwd = 3, col = c(col_f, col_m),
       legend = c("Female (code 2)", "Male (code 1)"),
       title = "Dotted lines = observed maximum")
mtext("Length-frequency by sex, BC numeric codes vs IPHC character codes",
      outer = TRUE, cex = 1.1, font = 2)
par(op)
dev.off()

# Numeric summary table
tab <- do.call(rbind, lapply(X = panels, FUN = function(p) {
  data.frame(source = p$nm,
             n_F = length(p$f), mean_F = round(mean(p$f), 1),
             q95_F = round(quantile(p$f, 0.95), 1), max_F = max(p$f),
             n_M = length(p$m), mean_M = round(mean(p$m), 1),
             q95_M = round(quantile(p$m, 0.95), 1), max_M = max(p$m),
             row.names = NULL)
}))
print(tab)
write.csv(tab, "review/figs/01-sex-code-summary.csv", row.names = FALSE)
cat("\nwrote review/figs/01-sex-code-length-distributions.png\n")
