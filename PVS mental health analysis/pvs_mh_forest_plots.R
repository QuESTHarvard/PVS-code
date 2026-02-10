# Install packages if not already installed 
if (!require("dplyr")) install.packages("dplyr")
if (!require("forestplot")) install.packages("forestplot")
if (!require("tidyverse")) install.packages("tidyverse")
if (!require("readxl")) install.packages("readxl")
if (!require("stringr")) install.packages("stringr")
if (!require("haven")) install.packages("haven")

# Set working directory 
setwd("~/Dropbox (Harvard University)/MH Analysis")

# Load in data
overall_quality <- read_excel("qual_reg.xlsx", sheet = "overall_quality")

pdf(file = "overall_quality.pdf")

# Forest plot 

overall_quality %>% 
  forestplot(labeltext = c(heading_1, heading_2),
             is.summary = c( rep(FALSE, 50)),
             hrzl_lines = list("2" = gpar(lwd = .75, columns = 1:2)),
             lwd.xaxis = gpar(lwd = 1),
             xlog = TRUE,
             xlim = c(0.25, 8),
#             clip = c(log(0.3), log(5)),  # Correct clipping on log scale
             xticks = c(log(0.25), log(0.5), log(1.00), log(1.75), log(3.0), log(5.0), log(8.0)),  # Log-scale appropriate ticks
             xticks.label = c(0.3, 0.5, 1, 2, 3, 5, 8),
             txt_gp = fpTxtGp(
               label = gpar(cex = 0.8, lineheight = 0.8),  # Adjust text size and line height for labels
               ticks = gpar(cex = 0.8, lineheight = 0.8),  # Adjust text size and line height for ticks
               xlab = gpar(cex = 0.8)),
             lwd.ci = 0.8,
             boxsize = 0.2,
             fn.ci_norm = ("fpDrawDiamondCI"),
             col = fpColors(box = "blue4",
                            line = "blue4",
                            zero = "black"),
             lineheight = unit(1, "cm"),
             colgap = unit(3,"mm"),
             graphwidth = unit(8, "cm"), 
             vertices = TRUE, 
             xlab = "Odds Ratio (95% CI)" ,
             title = "A. Overall quality less than very good")


dev.off()

# Load in data
unmet_need <- read_excel("qual_reg.xlsx", sheet = "unmet_need")

pdf(file = "unmet_need.pdf")

unmet_need %>% 
  forestplot(labeltext = c(heading_1, heading_2),
             is.summary = c( rep(FALSE, 50)),
             hrzl_lines = list("2" = gpar(lwd = .75, columns = 1:2)),
             lwd.xaxis = gpar(lwd = 1),
             xlog = TRUE,
             xlim = c(0.25, 8),
             xticks = c(log(0.25), log(0.5), log(1.00), log(1.75), log(3.0), log(5.0), log(8.0)),  # Log-scale appropriate ticks
             xticks.label = c(0.3, 0.5, 1, 2, 3, 5, 8),
             txt_gp = fpTxtGp(
               label = gpar(cex = 0.8, lineheight = 0.8),  # Adjust text size and line height for labels
               ticks = gpar(cex = 0.8, lineheight = 0.8),  # Adjust text size and line height for ticks
               xlab = gpar(cex = 0.8)),
             lwd.ci = 0.8,
             boxsize = 0.2,
             fn.ci_norm = ("fpDrawDiamondCI"),
             col = fpColors(box = "blue4",
                            line = "blue4",
                            zero = "black"),
             lineheight = unit(1, "cm"),
             colgap = unit(3,"mm"),
             graphwidth = unit(8, "cm"), 
             vertices = TRUE, 
             xlab = "Odds Ratio (95% CI)" ,
             title = "B. Unmet need")
dev.off()

discrim <- read_excel("qual_reg.xlsx", sheet = "discrim")

pdf(file = "discrim.pdf")

discrim %>% 
  forestplot(labeltext = c(heading_1, heading_2),
             is.summary = c( rep(FALSE, 50)),
             hrzl_lines = list("2" = gpar(lwd = .75, columns = 1:2)),
             lwd.xaxis = gpar(lwd = 1),
             xlog = TRUE,
             xticks = c(log(0.25), log(0.5), log(1.00), log(1.75), log(3.0), log(5.0), log(8.0)),  # Log-scale appropriate ticks
             xticks.label = c(0.3, 0.5, 1, 2, 3, 5, 8),
             txt_gp = fpTxtGp(
               label = gpar(cex = 0.8, lineheight = 0.8),  # Adjust text size and line height for labels
               ticks = gpar(cex = 0.8, lineheight = 0.8),  # Adjust text size and line height for ticks
               xlab = gpar(cex = 0.8)),
             lwd.ci = 0.8,
             boxsize = 0.2,
             fn.ci_norm = ("fpDrawDiamondCI"),
             col = fpColors(box = "blue4",
                            line = "blue4",
                            zero = "black"),
             lineheight = unit(1, "cm"),
             colgap = unit(3,"mm"),
             graphwidth = unit(8, "cm"), 
             vertices = TRUE, 
             xlab = "Odds Ratio (95% CI)" ,
             title = "C. Discriminated against")
dev.off()


# New confidence regressions

# Load in data
conf_getafford <- read_excel("conf_reg_v2.xlsx", sheet = "conf_getafford")

pdf(file = "conf_getafford.pdf")

# Forest plot 

conf_getafford %>% 
  forestplot(labeltext = c(heading_1, heading_2),
             is.summary = c( rep(FALSE, 50)),
             hrzl_lines = list("2" = gpar(lwd = .75, columns = 1:2)),
             lwd.xaxis = gpar(lwd = 1),
             xlog = TRUE,
             xlim = c(0.25, 8),
             #             clip = c(log(0.3), log(5)),  # Correct clipping on log scale
             xticks = c(log(0.25), log(0.5), log(1.00), log(1.75), log(3.0), log(5.0), log(8.0)),  # Log-scale appropriate ticks
             xticks.label = c(0.3, 0.5, 1, 2, 3, 5, 8),
             txt_gp = fpTxtGp(
               label = gpar(cex = 0.8, lineheight = 0.8),  # Adjust text size and line height for labels
               ticks = gpar(cex = 0.8, lineheight = 0.8),  # Adjust text size and line height for ticks
               xlab = gpar(cex = 0.8)),
             lwd.ci = 0.8,
             boxsize = 0.2,
             fn.ci_norm = ("fpDrawDiamondCI"),
             col = fpColors(box = "blue4",
                            line = "blue4",
                            zero = "black"),
             lineheight = unit(1, "cm"),
             colgap = unit(3,"mm"),
             graphwidth = unit(8, "cm"), 
             vertices = TRUE, 
             xlab = "Odds Ratio (95% CI)" ,
             title = "A. Confidence in getting and affording good care")


dev.off()

# Load in data
system_outlook_getbet <- read_excel("conf_reg_v2.xlsx", sheet = "system_outlook_getbet")

pdf(file = "system_outlook_getbet.pdf")

system_outlook_getbet %>% 
  forestplot(labeltext = c(heading_1, heading_2),
             is.summary = c( rep(FALSE, 50)),
             hrzl_lines = list("2" = gpar(lwd = .75, columns = 1:2)),
             lwd.xaxis = gpar(lwd = 1),
             xlog = TRUE,
             xlim = c(0.25, 8),
             xticks = c(log(0.25), log(0.5), log(1.00), log(1.75), log(3.0), log(5.0), log(8.0)),  # Log-scale appropriate ticks
             xticks.label = c(0.3, 0.5, 1, 2, 3, 5, 8),
             txt_gp = fpTxtGp(
               label = gpar(cex = 0.8, lineheight = 0.8),  # Adjust text size and line height for labels
               ticks = gpar(cex = 0.8, lineheight = 0.8),  # Adjust text size and line height for ticks
               xlab = gpar(cex = 0.8)),
             lwd.ci = 0.8,
             boxsize = 0.2,
             fn.ci_norm = ("fpDrawDiamondCI"),
             col = fpColors(box = "blue4",
                            line = "blue4",
                            zero = "black"),
             lineheight = unit(1, "cm"),
             colgap = unit(3,"mm"),
             graphwidth = unit(8, "cm"), 
             vertices = TRUE, 
             xlab = "Odds Ratio (95% CI)" ,
             title = "B. Health system getting better")
dev.off()

system_reform_minor <- read_excel("conf_reg_v2.xlsx", sheet = "system_reform_minor")

pdf(file = "system_reform_minor.pdf")

system_reform_minor %>% 
  forestplot(labeltext = c(heading_1, heading_2),
             is.summary = c( rep(FALSE, 50)),
             hrzl_lines = list("2" = gpar(lwd = .75, columns = 1:2)),
             lwd.xaxis = gpar(lwd = 1),
             xlog = TRUE,
             xticks = c(log(0.25), log(0.5), log(1.00), log(1.75), log(3.0), log(5.0), log(8.0)),  # Log-scale appropriate ticks
             xticks.label = c(0.3, 0.5, 1, 2, 3, 5, 8),
             txt_gp = fpTxtGp(
               label = gpar(cex = 0.8, lineheight = 0.8),  # Adjust text size and line height for labels
               ticks = gpar(cex = 0.8, lineheight = 0.8),  # Adjust text size and line height for ticks
               xlab = gpar(cex = 0.8)),
             lwd.ci = 0.8,
             boxsize = 0.2,
             fn.ci_norm = ("fpDrawDiamondCI"),
             col = fpColors(box = "blue4",
                            line = "blue4",
                            zero = "black"),
             lineheight = unit(1, "cm"),
             colgap = unit(3,"mm"),
             graphwidth = unit(8, "cm"), 
             vertices = TRUE, 
             xlab = "Odds Ratio (95% CI)" ,
             title = "C. Health system needs minor changes")
dev.off()










conf_reg <- read_excel("conf_reg.xlsx", sheet = "conf_reg")

pdf(file = "conf_reg.pdf", width = 6, height = 3) 

conf_reg %>% 
  forestplot(labeltext = c(heading_1),
             is.summary = c( rep(FALSE, 50)),
#             hrzl_lines = list("2" = gpar(lwd = .75, columns = 1:2)),
             lwd.xaxis = gpar(lwd = 1),
             xlog = TRUE,
            xticks = c(log(.6), log(0.75), log(1.00), log(1.25)),  # Log-scale appropriate ticks
#            xticks.label = c(0.3, 0.5, 1, 2, 3, 5, 8),
            txt_gp = fpTxtGp(
            label = gpar(cex = 0.8, lineheight = 0.8),  # Adjust text size and line height for labels
            ticks = gpar(cex = 0.8, lineheight = 0.8),  # Adjust text size and line height for ticks
            xlab = gpar(cex = 0.8)),
             lwd.ci = 0.8,
             boxsize = 0.2,
             fn.ci_norm = ("fpDrawDiamondCI"),
             col = fpColors(box = "blue4",
                            line = "blue4",
                            zero = "black"),
              lineheight = unit(1, "mm"),
             colgap = unit(3,"mm"),
             graphwidth = unit(6, "cm"), 
             vertices = TRUE, 
             xlab = "Odds Ratio (95% CI)" ,
             title = "Confidence in health system")
dev.off()

