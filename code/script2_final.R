# SCRIPT 2: Analyzing newly written data

# setting up working space ------------------------------------------------

rm(list=ls())
setwd("C:/Users/Nadia/Desktop/NYUAD/Brightspace/Soph/Fall/Data Analysis/Final Project")


# libraries ---------------------------------------------------------------

library(tidyverse)
library(ggplot2)
library(stargazer)
library(readxl)
library(countrycode)
library(gridExtra)
library(lfe)


# importing data ----------------------------------------------------------

dat = read.csv('merged_data.csv') # cleaned and merged dataset


# summary stats -----------------------------------------------------------

## summary stats table ----

dat %>% as.data.frame() %>% select(num_genres, dem_index, gdppc, sec_comp) %>% 
  stargazer(type = 'text',
            covariate.labels =
              c('Number of "popular" song genres',
                'Democracy Index score',
                'GDP per capita',
                'Lower secondary completion rate'
              ),
            notes = c("GDPPC measured in current US Dollars",
                      "Completion rate measured as a percentage of relevant age group"),
            title = 'Summary Statistics',
            header = F)



## distribution ----

dat$sec_comp %>% hist(main="Histogram of lower\n secondary school completion rate")

# dat$sec_comp = dat$sec_comp %>% log()
# dat$sec_comp %>% hist(main = "Histogram of Log SC")


# scatterplot ----

scatter = dat %>% ggplot() +
  aes(x=dem_index, y=num_genres, color=as.factor(region)) +
  geom_point() +
  scale_color_manual(
    values = RColorBrewer::brewer.pal(7, 'YlOrRd'),
    name = 'Region') +
  geom_smooth(formula=y~x, method='lm', 
              fill='grey', color='black', alpha=.25,
              linetype = 2) +
  xlab('Democracy Index score') +
  ylab('Number of "popular" song genres') +
  #ggtitle("") +
  theme_dark()

scatter

## extra ----
# plots by region

# dat$region %>% unique()

EastAsia = dat %>% subset(region == 'East Asia & Pacific') %>% 
  ggplot() +
  geom_point() +
  aes(x=dem_index, y=num_genres) +
  geom_smooth(formula=y~x, method='lm', 
              fill='grey', color='maroon', alpha=.25,
              linetype = 2) +
  xlab('DI score') +
  ylab('Number of genres') +
  xlim(1, 10) +
  ylim(-200, 600) +
  theme_minimal() +
  ggtitle('East Asia & Pacific') +
  theme(plot.title = element_text(hjust = 0.5))

Europe = dat %>% subset(region == 'Europe & Central Asia') %>% 
  ggplot() +
  aes(x=dem_index, y=num_genres) +
  geom_point() +
  geom_smooth(formula=y~x, method='lm', 
              fill='grey', color='maroon', alpha=.25,
              linetype = 2) +
  xlab('DI score') +
  ylab('Number of genres') +
  xlim(1, 10) +
  ylim(-200, 600) +
  theme_minimal() +
  ggtitle('Europe & Central Asia') +
  theme(plot.title = element_text(hjust = 0.5))

LatinAmerica = dat %>% subset(region == 'Latin America & Caribbean') %>% 
  ggplot() +
  aes(x=dem_index, y=num_genres) +
  geom_point() +
  geom_smooth(formula=y~x, method='lm', 
              fill='grey', color='gold3', alpha=.25,
              linetype = 2) +
  xlab('DI score') +
  ylab('Number of genres') +
  xlim(1, 10) +
  ylim(-200, 600) +
  theme_minimal() +
  ggtitle('Latin America & Caribbean') +
  theme(plot.title = element_text(hjust = 0.5))

MiddleEast = dat %>% subset(region == 'Middle East & North Africa') %>% 
  ggplot() +
  aes(x=dem_index, y=num_genres) +
  geom_point() +
  geom_smooth(formula=y~x, method='lm', 
              fill='grey', color='gold3', alpha=.25,
              linetype = 2) +
  xlab('DI score') +
  ylab('Number of genres') +
  xlim(1, 10) +
  ylim(-200, 600) +
  theme_minimal() +
  ggtitle('Middle East & North Africa') +
  theme(plot.title = element_text(hjust = 0.5))

NorthAmerica = dat %>% subset(region == 'North America') %>% 
  ggplot() +
  aes(x=dem_index, y=num_genres) +
  geom_point() +
  geom_smooth(formula=y~x, method='lm', 
              fill='grey', color='gold3', alpha=.25,
              linetype = 2) +
  xlab('DI score') +
  ylab('Number of genres') +
  xlim(1, 10) +
  ylim(-200, 600) +
  theme_minimal() +
  ggtitle('North America') +
  theme(plot.title = element_text(hjust = 0.5))

SouthAsia = dat %>% subset(region == 'South Asia') %>% 
  ggplot() +
  aes(x=dem_index, y=num_genres) +
  geom_point() +
  geom_smooth(formula=y~x, method='lm', 
              fill='grey', color='maroon', alpha=.25,
              linetype = 2) +
  xlab('DI score') +
  ylab('Number of genres') +
  xlim(1, 10) +
  ylim(-200, 600) +
  theme_minimal() +
  ggtitle('South Asia') +
  theme(plot.title = element_text(hjust = 0.5))

SubSaharanAfrica = dat %>% subset(region == 'Sub-Saharan Africa') %>% 
  ggplot() +
  aes(x=dem_index, y=num_genres) +
  geom_point() +
  geom_smooth(formula=y~x, method='lm', 
              fill='grey', color='maroon', alpha=.25,
              linetype = 2) +
  xlab('DI score') +
  ylab('Number of genres') +
  xlim(1, 10) +
  ylim(-200, 600) +
  theme_minimal() +
  ggtitle('Sub-Saharan Africa') +
  theme(plot.title = element_text(hjust = 0.5))


grid.arrange(EastAsia, Europe, MiddleEast, LatinAmerica,
             NorthAmerica, SouthAsia, SubSaharanAfrica,
             nrow = 4)


# dichotomization ---------------------------------------------------------

dat = dat %>%
  group_by(year) %>%
  mutate(
    sec_comp = case_when(
      sec_comp > median(sec_comp, na.rm = TRUE) ~ 1,
      sec_comp <= median(sec_comp, na.rm = TRUE) ~ 0,
      is.na(sec_comp) ~ 0
    )
  )



# regression models -------------------------------------------------------

## lm models ----
# simple cause-effect linear regression
model1 = lm(num_genres ~ dem_index, 
            data = dat)
# interaction
model2 = lm(num_genres ~ dem_index + sec_comp + dem_index*sec_comp,
            dat)
# controlled interaction
model3 = lm(num_genres ~ dem_index + gdppc + sec_comp + dem_index*sec_comp,
            dat)

## felm models ----
# region fixed effects
model4 = felm(num_genres ~ dem_index + gdppc + sec_comp + dem_index*sec_comp | region,
              dat)
# with region clustered standard errors
model5 = felm(num_genres ~ dem_index + gdppc + sec_comp + dem_index*sec_comp | region | 0 | region,
              dat)


# regression table --------------------------------------------------------

stargazer(model1, model2, model3, model4, model5,
          type = 'text',
          title = 'Core results',
          dep.var.labels = c('Number of song genres'),
          covariate.labels = c('Democracy Index score',
                               # 'GDP per capita',
                               'Lower secondary completion rate',
                               'Genres * Completion rate'),
          omit.stat = c('rsq', 'ser', 'f'),
          omit = c('gdppc'),
          style = 'ajps',
          model.numbers = F,
          #model.names = F,
          add.lines = list(
            c('Controlled for confounders', 'No', 'No', 'Yes', 'Yes', 'Yes'),
            c('Region Fixed Effects', 'No', 'No', 'No', 'Yes', 'Yes'),
            c('Region-level clustered S.E.', 'No', 'No', 'No', 'No', 'Yes')
          ),
          header = F)


# regression plots --------------------------------------------------------

## prediction plot ----

N = 50 # makes 50 predictions for each condition (i.e. 50 for young, 50 for not young)

predictions = data.frame(
  
  dem_index = 
    c(seq(min(dat$num_genres), max(dat$num_genres), length.out=N),
      seq(min(dat$num_genres), max(dat$num_genres), length.out=N)),
  
  sec_comp = c(rep(0,N), rep(1,N)),
  
  gdppc = mean(dat$gdppc, na.rm=T)
  
)

fits = predict(model3,
               newdata = predictions,
               interval = "confidence") 

predictions = cbind(predictions, fits)

pred_plot = predictions %>% ggplot() +
  aes(x=dem_index, y=fit, 
      ymin = lwr, ymax = upr,
      color = factor(sec_comp),
      linetype = factor(sec_comp)
  ) + 
  geom_line() +
  geom_ribbon(alpha = 0.1) + 
  scale_color_manual(name = "",
                     values = c("tomato4", 
                                "aquamarine4"), 
                     labels = c('Below or average \n secondary completion rate',
                                'Above average \n secondary completion rate')) +
  scale_linetype_manual(name = "",
                        values = c(2, 1), 
                        labels = c('Below or average \n secondary completion rate',
                                   'Above average \n secondary completion rate')) +
  theme_light() +
  xlab("Democracy Index score") +
  ylab('Predicted number of "popular" song genres') +
  theme_light() +
  ggtitle("Prediction Plot\n(regular linear regression)") +
  theme(plot.title = element_text(hjust = 0.5),
        legend.position='bottom', legend.direction='horizontal')

#pred_plot


## marginal effect plot ----

# simple vector containing binary indicators for conditional value
sec_comp = c(0, 1)

# b1 = coefficient of effect DI
# b4 = coefficient of effect (DI given SC)

# ME of DI on MD = b1 + (b4*SC)
effect = model5$coefficients[1] + (sec_comp*model5$coefficients[4])

# SE of DI on MV = sqrt( var(b1) + (SC)^2var(b4) + (2)(SC)*cov(b1,b4) )
margin_se = sqrt( 
  vcov(model5)[1,1] +
    (sec_comp^2) * (vcov(model5)[4,4]) +
    2 * (sec_comp*vcov(model5)[1,4]) 
)

me_plot = cbind(sec_comp, effect, margin_se) %>% 
  as.data.frame() %>% 
  mutate(
    CI_L = effect - (1.96*margin_se),
    CI_H = effect + (1.96*margin_se)
  ) %>% 
  ggplot() +
  aes(x=sec_comp, y=effect,
      ymin=CI_L, ymax=CI_H) +
  geom_point() +
  geom_errorbar(width = 0.2) +
  scale_x_continuous(breaks = c(0,1),
                     labels = c('Below or average \n Secondary completion rate',
                                'Above average \nSecondary completion \nrate')) +
  ggtitle('Marginal effect of democracy index on\n music diversity\n(with both FE & clustered S.E.)') +
  xlab("") +
  ylab("") +
  geom_hline(yintercept=0, linetype=2, color='cornflowerblue', linewidth=1) +
  theme_light() +
  theme(plot.title = element_text(hjust = 0.5))

# me_plot


# panel ----

grid.arrange(
  pred_plot, me_plot,
  nrow = 1
)

