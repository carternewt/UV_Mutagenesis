setwd("C:/Users/cnewt/vscode/UV_Mutagenesis")

library(ggplot2)
library(plyr)
library(dplyr)
library(ggh4x)

data <- read.csv('survival_curve_data.csv')
data[data == '#VALUE!'] <- NA
na.omit(data)
data <- na.omit(data)
str(data)
data$UV <- as.factor(data$UV)
data$Plate <- as.factor(data$Plate)
data$CFU.ml <- as.numeric(data$CFU.ml)
data_sum <- ddply(data, c('UV', 'Plate'), summarize, CFU_ml = mean(CFU.ml), CFU_ml_sd = sd(CFU.ml))

data_sum <- data_sum %>% group_by(Plate) %>% mutate(Percent = CFU_ml / CFU_ml[UV == 0][1]*100) %>% mutate(Percent = 100 - Percent) %>% ungroup()
data_sum$Percent <- round(data_sum$Percent, digits = 2)

fig_control <- ggplot(filter(data_sum, UV == '0'), aes(x = Plate, y = CFU_ml)) + 
  geom_point(size = 2) + theme_classic() + 
  ylab('CFU/ml') + xlab('Culture Dilution UV Treated') + 
  ggtitle('F7-5 with no UV Treatment') +
  scale_y_log10(guide = 'axis_logticks', breaks = c(10000, 100000, 1000000, 10000000), limits = c(10000, 10000000), expand = c(0,0)) +
  theme(axis.ticks.length.y = unit(0.5, 'cm'), ggh4x.axis.ticks.length.minor = rel(0.55), ggh4x.axis.ticks.length.mini = rel(0.25))
fig_control

 fig_15s <- ggplot(filter(data_sum, UV == '15'), aes(x = Plate, y = CFU_ml)) + 
  geom_point(size = 2) + theme_classic() + 
  ylab('CFU/ml') + xlab('Culture Dilution UV Treated') + 
  ggtitle('F7-5 with 15s UV Treatment') +
  scale_y_log10(guide = 'axis_logticks', breaks = c(100, 1000, 10000, 100000, 1000000, 10000000), limits = c(100, 10000000), expand = c(0,0)) +
  theme(axis.ticks.length.y = unit(0.5, 'cm'), ggh4x.axis.ticks.length.minor = rel(0.55), ggh4x.axis.ticks.length.mini = rel(0.25))
fig_15s

fig_30s <- ggplot(filter(data_sum, UV == '15'), aes(x = Plate, y = CFU_ml)) + 
  geom_point(size = 2) + theme_classic() + 
  ylab('CFU/ml') + xlab('Culture Dilution UV Treated') + 
  ggtitle('F7-5 with 15s UV Treatment') +
  scale_y_log10(guide = 'axis_logticks', breaks = c(100, 1000, 10000, 100000, 1000000, 10000000), limits = c(100, 10000000), expand = c(0,0)) +
  theme(axis.ticks.length.y = unit(0.5, 'cm'), ggh4x.axis.ticks.length.minor = rel(0.55), ggh4x.axis.ticks.length.mini = rel(0.25))

Compile <- ggplot(data_sum, aes(x = Plate, y = CFU_ml, label = Percent)) + 
  geom_point(size = 2) + theme_classic() + 
  ylab('CFU/ml') + xlab('Culture Dilution UV Treated') + 
  ggtitle('F7-5 Survival Curve Under UV Treatment', subtitle = 'Undiluted = ~5e + 7 CFU/ml\n10 = ~5e + 6 CFU/ml\n100 = ~5e + 5 CFU/ml\n1000 = ~5e + 4 CFU/ml') +
  scale_y_log10(guide = 'axis_logticks', breaks = c(100, 1000, 10000, 100000, 1000000, 10000000), limits = c(100, 10000000), expand = c(0,0)) +
  theme(axis.ticks.length.y = unit(0.5, 'cm'), ggh4x.axis.ticks.length.minor = rel(0.55), ggh4x.axis.ticks.length.mini = rel(0.25)) + facet_grid(~UV, space = 'free_x', scales = 'free_x') +
  geom_text(nudge_y = 0.2)
Compile
ggsave('Compiled_survival.jpeg', device = 'jpeg', scale = 1, width = 6, height = 6, units = 'in', dpi = 'print')

fig_plate_10 <- ggplot(filter(data_sum, Plate == '10'), aes(x = UV, y = CFU_ml, label = Percent)) + 
  geom_point(size = 2) + theme_classic() + 
  ylab('CFU/ml') + xlab('UV Treatment (seconds)') +
  scale_y_log10(guide = 'axis_logticks', breaks = c(100, 1000, 10000, 100000, 1000000, 10000000), limits = c(100, 10000000), expand = c(0,0)) +
  theme(axis.ticks.length.y = unit(0.5, 'cm'), ggh4x.axis.ticks.length.minor = rel(0.55), ggh4x.axis.ticks.length.mini = rel(0.25)) +
  geom_text(nudge_y = 0.2)
fig_plate_10
ggsave('Plate_10_survival.jpeg', device = 'jpeg', scale = 1, width = 6, height = 6, units = 'in', dpi = 'print')
