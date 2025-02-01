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
     - Quantified by the **total number of ‘popular’ genres** that a country listens to in a year.
     - Extracted from the [Weekly Top 200 songs on Spotify by country (2021-2022) dataset](https://www.kaggle.com/datasets/yelexa/spotify200).
     - Maximum possible genres for a single country in a single year = **(200 genres per week) * (52 weeks per year) = 10,400 genres**

- Indepdendent Variable
  2. **Democracy Index:**
     - Data for levels of countries' democracy were sourced from the [Economist Intelligence Unit (EIU)’s Democracy Index](https://ourworldindata.org/grapher/democracy-index-eiu). These scores range from 0 (least democratic) to 10 (most democratic).
 
- Control Variables
  3. **Wealth (GDP per capita):**
     - A country's wealth may influence both **democracy levels** and **access to music streaming services**, affecting music diversity.
     - To prevent the confounding effect of this on the main relationship that this study aims to investigate, countries’ wealth, obtained from the [World Bank Development Indicators dataset](https://data.worldbank.org/indicator/NY.GDP.PCAP.CD) will be accounted for in preceding analysis.
       
  4. **Secondary School Completion Rate:**
     - A control for educational exposure influencing cultural preferences.
     - Sourced from the [World Bank's Secondary School Completion Rate dataset](https://data.worldbank.org/indicator/SE.SEC.CMPT.LO.ZS)  
 
- Interaction Term
  5. **(Secondary School Completion Rate)*(Democracy Index):**
     - **Intuition:** Including this interaction term further dissects the relationship between music diversity and democracy by recognizing the idea that the ability for music to implicitly impart political themes may require a certain level of education.
     - **Categorizing education into "high" and "low":** The median global school completion rate is used as a benchmark since the data is left-skewed, with most values falling below the mean. Education levels vary widely, with developed countries having near-universal completion rates while others face limited access. The median, rather than the mean, prevents highly educated nations from skewing the threshold. Countries above the median = 1, at or below = 0, ensuring a balanced classification.

- Clustering
  - Countries are grouped into **7 regions** based on **World Bank Indicator data** to account for shared political and cultural values.
  - Standard errors are clustered at the **region level** to correct for potential violations of the IID (Independent and Identically Distributed) assumption in regression analysis.  



## Findings

![image](https://github.com/user-attachments/assets/b618895f-2b8f-45f5-b7e2-f0ff286569f1)

![image](https://github.com/user-attachments/assets/fc0f2225-62ea-4d60-9971-b33c4ba331e1)








