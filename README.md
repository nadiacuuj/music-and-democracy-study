# Music's influence on a country's democracy level?

## Overview
- Traditional metrics for assessing democracy (such as GDP per capita) may no longer fully capture our evolving, technology-driven world.
- Following from that, this project explores an alternatively, and relatively more unserious perspective: the link between countries' music preferences and democracy level.
- I consider an initial hypothesis that more diverse music tastes is correlated with more diverse ways of thinking, which should reflect in a higher level of democracy.

## Model specification

$$
NumGenres_{it} = \alpha + \beta_1DemIndex_{it} + \beta_2GDPPC_{it} + \beta_3SecCompRate_{it} + \beta_4(DemIndex_{it} \times SecCompRate_{it}) + \delta X + \epsilon_{it}
$$

## Variables and Data Sources

- Indepdendent Variable
  1. **Democracy Index:**
    
     Data for levels of countries' democracy were sourced from the [Economist Intelligence Unit (EIU)’s Democracy Index](https://ourworldindata.org/grapher/democracy-index-eiu). These scores range from 0 (least democratic) to 10 (most democratic).

- Indepdendent Variable
  1. Democracy Index
   Data for levels of countries' democracy were sourced from the Economist Intelligence Unit (EIU)’s Democracy Index. These scores range from 0 (least democratic) to 10 (most democratic).







https://www.kaggle.com/datasets/yelexa/spotify200

https://data.worldbank.org/indicator/NY.GDP.PCAP.CD

https://data.worldbank.org/indicator/SE.SEC.CMPT.LO.ZS





as well as beng a control - also included as an interaction. intuition is that ...
