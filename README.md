# Music's influence on a country's democracy level?

## Overview
- Traditional metrics for assessing democracy (such as GDP per capita) may no longer fully capture our evolving, technology-driven world.
- Following from that, this project explores an alternatively, and relatively more unserious perspective: the link between countries' music preferences and democracy level.
- It considers an initial hypothesis that more diverse music tastes is correlated with more diverse ways of thinking, which should reflect in a higher level of democracy.

## Model specification

$$
NumGenres_{it} = \alpha + \beta_1DemIndex_{it} + \beta_2GDPPC_{it} + \beta_3SecCompRate_{it} + \beta_4(DemIndex_{it} \times SecCompRate_{it}) + \delta X + \epsilon_{it}
$$

## Variables and Data Sources

- Depdendent Variable
  1. **Music Diversity:** 
     - Measured by the number of ‘popular’ genres a country listens to in a year.
     - Max Possible Genres: 10,400 per country per year (200 genres/week * 52 weeks).
     - Sourced from [Spotify’s Weekly Top 200 songs by country (2021-2022)](https://www.kaggle.com/datasets/yelexa/spotify200).

- Indepdendent Variable
  1. **Democracy Index:**
     - Ranges from 0 (least democratic) to 10 (most democratic).
     - Sourced from the [Economist Intelligence Unit (EIU)’s Democracy Index](https://ourworldindata.org/grapher/democracy-index-eiu).
 
- Control Variables
  1. **Wealth:**
     - Controls for the influence of economic status on democracy and music streaming access.
     - Sourced from the [World Bank](https://data.worldbank.org/indicator/NY.GDP.PCAP.CD).
       
  2. **Secondary School Completion Rate:**
     - Controls for educational exposure’s effect on cultural preferences.
     - Sourced from the [World Bank's Secondary School Completion Rate dataset](https://data.worldbank.org/indicator/SE.SEC.CMPT.LO.ZS).
 
- Interaction Term
  1. **(School Completion Rate * Democracy Index)**:
     - Examines whether education level moderates the relationship between music diversity and democracy.
     - Categorization: Uses the median global school completion rate as a threshold (1 = above median, 0 = at/below) to avoid skew from highly educated nations.

- Clustering
  - Regions: **Countries grouped into 7 regions** per World Bank classifications to account for shared political and cultural values.
  - Standard Errors: Clustered at the region level to correct for IID (Independent and Identically Distributed) violations in regression analysis.



## Findings

![image](https://github.com/user-attachments/assets/b618895f-2b8f-45f5-b7e2-f0ff286569f1)

![image](https://github.com/user-attachments/assets/fc0f2225-62ea-4d60-9971-b33c4ba331e1)








