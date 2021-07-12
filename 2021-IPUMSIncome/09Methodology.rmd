---
  title: "09Methodology"
  author: "Julie Christie | Data + Impact Editor, [Resolve Philly](https://www.resolvephilly.org)"
  date: "7/6/2021"
  output: html_document
---

## Methodology

### Get your data ready

1.  Download the 2019 5-year PUMS data for each state holding a city that will be examined. In our case, we looked at Philadelphia, PA; Pittsburgh, PA; Phoenix, AZ; Miami, FL; Atlanta, GA; Chicago, IL; Baltimore, MD; Boston, MA; Detroit, MI; Cleveland, OH; Austin, TX; Houston, TX; and Washington, DC. **Download them as .csv files into one folder.**

2.  Load your needed packages into your work environment.

    ```{r results='hide'}
    library(plyr)
    library(dplyr)
    library(pollster)
    library(readr)
    library(gtools)
    ```

3.  Make sure you've set up your work environment to have all the files you need in the right folder. As you get new data, add the files in there so you can easily bring them into your environment.

4.  Bring in the data you need to examine and then read it.

    ```{r results='hide'}
    library(readr)
      STATE_Arizona <- read_csv("STATE_Arizona.csv")
      STATE_Delaware <- read_csv("STATE_Delaware.csv")
      STATE_Florida <- read_csv("STATE_Florida.csv")
      STATE_Georgia <- read_csv("STATE_Georgia.csv")
      STATE_Illinois <- read_csv("STATE_Illinois.csv")
    	STATE_Maryland <- read_csv("STATE_Maryland.csv")
    	STATE_Massachusetts <- read_csv("STATE_Massachusetts.csv")
    	STATE_Michigan <- read_csv("STATE_Michigan.csv")
    	STATE_Ohio <- read_csv("STATE_Ohio.csv")
    	STATE_Pennsylvania <- read_csv("STATE_Pennsylvania.csv")
    	STATE_Texas <- read_csv("STATE_Texas.csv")
    	STATE_Washington <- read_csv("STATE_WashingtonDC.csv")
    ```

5.  Shorten these tables to only include the variables that you want.

    ```{r results='hide'}
    STATE_Arizona <- STATE_Arizona %>%
      select(SERIALNO, PUMA, ST, ADJINC, AGEP, PWGTP, PINCP, HISP, RAC1P, AGEP, COW, JWMNP, PAP, SEX, INDP, NAICSP, OCCP, SOCP, MIG)
    STATE_Delaware <- STATE_Delaware %>%
      select(SERIALNO, PUMA, ST, ADJINC, AGEP, PWGTP, PINCP, HISP, RAC1P, AGEP, COW, JWMNP, PAP, SEX, INDP, NAICSP, OCCP, SOCP, MIG)
    STATE_Florida <- STATE_Florida %>%
      select(SERIALNO, PUMA, ST, ADJINC, AGEP, PWGTP, PINCP, HISP, RAC1P, AGEP, COW, JWMNP, PAP, SEX, INDP, NAICSP, OCCP, SOCP, MIG)
    STATE_Georgia <- STATE_Georgia %>%
      select(SERIALNO, PUMA, ST, ADJINC, AGEP, PWGTP, PINCP, HISP, RAC1P, AGEP, COW, JWMNP, PAP, SEX, INDP, NAICSP, OCCP, SOCP, MIG)
    STATE_Illinois <- STATE_Illinois %>%
      select(SERIALNO, PUMA, ST, ADJINC, AGEP, PWGTP, PINCP, HISP, RAC1P, AGEP, COW, JWMNP, PAP, SEX, INDP, NAICSP, OCCP, SOCP, MIG)
    STATE_Maryland <- STATE_Maryland %>%
      select(SERIALNO, PUMA, ST, ADJINC, AGEP, PWGTP, PINCP, HISP, RAC1P, AGEP, COW, JWMNP, PAP, SEX, INDP, NAICSP, OCCP, SOCP, MIG)
    STATE_Massachusetts <- STATE_Massachusetts %>%
      select(SERIALNO, PUMA, ST, ADJINC, AGEP, PWGTP, PINCP, HISP, RAC1P, AGEP, COW, JWMNP, PAP, SEX, INDP, NAICSP, OCCP, SOCP, MIG)
    STATE_Michigan <- STATE_Michigan %>%
      select(SERIALNO, PUMA, ST, ADJINC, AGEP, PWGTP, PINCP, HISP, RAC1P, AGEP, COW, JWMNP, PAP, SEX, INDP, NAICSP, OCCP, SOCP, MIG)
    STATE_Ohio <- STATE_Ohio %>%
      select(SERIALNO, PUMA, ST, ADJINC, AGEP, PWGTP, PINCP, HISP, RAC1P, AGEP, COW, JWMNP, PAP, SEX, INDP, NAICSP, OCCP, SOCP, MIG)
    STATE_Pennsylvania <- STATE_Pennsylvania %>%
      select(SERIALNO, PUMA, ST, ADJINC, AGEP, PWGTP, PINCP, HISP, RAC1P, AGEP, COW, JWMNP, PAP, SEX, INDP, NAICSP, OCCP, SOCP, MIG)
    STATE_Texas <- STATE_Texas %>%
      select(SERIALNO, PUMA, ST, ADJINC, AGEP, PWGTP, PINCP, HISP, RAC1P, AGEP, COW, JWMNP, PAP, SEX, INDP, NAICSP, OCCP, SOCP, MIG)
    STATE_Washington <- STATE_Washington %>%
      select(SERIALNO, PUMA, ST, ADJINC, AGEP, PWGTP, PINCP, HISP, RAC1P, AGEP, COW, JWMNP, PAP, SEX, INDP, NAICSP, OCCP, SOCP, MIG)
    ```

6.  Double check that all the variable types are the same so you can merge them together. In this case, `STATE_Arizona` loaded with a `chr` type for `ST` instead of `num`, so we'll need to fix that.

    ```{r}
    STATE_Arizona <- STATE_Arizona %>%
      mutate(ST = as.numeric(ST))
    ```

7.  Combine all your data sets into a single data set

    ```{r results='hide'}
    AllData <- do.call("rbind", list(STATE_Arizona, STATE_Delaware, STATE_Florida, STATE_Georgia, STATE_Illinois, STATE_Maryland, STATE_Massachusetts, STATE_Michigan, STATE_Ohio, STATE_Pennsylvania, STATE_Texas, STATE_Washington))

    #It'll also be helpful to remove all the STATE dataframes that you don't need anymore. They can easily be loaded back in if you need to start over.
    rm(STATE_Arizona, STATE_Delaware, STATE_Florida, STATE_Georgia, STATE_Illinois, STATE_Maryland, STATE_Massachusetts, STATE_Michigan, STATE_Ohio, STATE_Pennsylvania, STATE_Texas, STATE_Washington)
    ```

8.  Add columns that synthesize some of the data you'll need for analysis.\
    \
    If you're working in a file from before 2019, then you'll want to adjust income for inflation to 2019. [Here is a website you can use to figure out which values you need for inflation adjustments.](https://www.census.gov/topics/income-poverty/income/guidance/current-vs-constant-dollars.html) The formula you'll need is `=((ADJINC/1000000)*PINCP)*{2019 CPI-U-RS}/{2009 CPI-U-RS}`

    ```{r results='hide'}
    # Adjust income for inflation and put that in a new column
    AllData <- AllData %>%
    	mutate(inc_inflation = ((ADJINC/1000000)*PINCP)*376.5/315.2)

    # Add a column that indicates simply whether someone makes more than $200,000
    AllData <- AllData %>%
      mutate(AboveYN = case_when(inc_inflation >= 200000 ~ "Above",
                                 TRUE ~ "Below"))

    # Make a new column that turns the codes for Race into their definitions
    AllData <- AllData %>%
    	mutate(RACE = case_when (RAC1P == 1 ~ "White alone",
    		RAC1P == 2 ~ "Black or African American alone",
    		RAC1P == 3 ~ "American Indian alone",
    		RAC1P == 4 ~ "Alaska Native alone",
    		RAC1P == 5 ~ "American Indian and Alaska Native tribes specified; or American Indian or Alaska Native, not specified and no other races",
    		RAC1P == 6 ~ "Asian alone",
    		RAC1P == 7 ~ "Native Hawaiian and Other Pacific Islander alone",
    		RAC1P == 8 ~ "Some Other Race alone",
    		RAC1P == 9 ~ "Two or More Races"))

    # Make a new column that indicates whether a person is or isn't Hispanic/Latinx
    AllData <- AllData %>%
      mutate(HispYN = case_when(HISP == 1 ~ "NotHisp",
                                TRUE ~ "Hisp"))

    # Create a new column that combines the PUMA and State codes into one as STPUMA without spaces
    AllData <- AllData %>%
      mutate(FullPUMA = paste0(ST,PUMA))

    # Add a column for the year
    AllData <- AllData %>%
      mutate(DataYear = 2009)
    ```

### Determine PUMAs and shrink your data even more

1.  Go to MCDC 2014 Geocorr and download a complete list of the PUMAs for each state you want.

-   Source Geographies: `County, County Subdivision/Town(ship)/MCD, Place, PUMA` (under 2012 Geographies)
-   Target Geographies: same as above
-   Weighting Variable: Population `unchanged`
-   Ignore census blocks... : `checked`
-   Keep subsequent three boxes unchecked 
-   Save filename as `PUMAs_2010`
-   Generage CSV: `checked`, include both codes
-   Generate a report: `UNchecked`

> **A note about this data set:** each place within a PUMA will receive its own row in the data, meaning that there will be duplicates.

2.  Load this data into R

    ```{r results='hide'}
    library(readr)
     PUMA_References <- read_csv("PUMA_References.csv")
    ```

3.  Shrink this table down by only taking the variables that you'll need.

    ```{r}
    PUMA_References <- PUMA_References %>%
      select(county, state, puma12, stab, cntyname, placenm)
    ```

4.  Add a new column that combines the State code and PUMA code, and name it `FullPUMA`

    ```{r}
    PUMA_References <- PUMA_References %>%
      mutate(FullPUMA = paste0(STATEFP,PUMA5CE))
    ```

5.  Create a new table with this data that isolates PUMAs that may include a city that you're hoping to reference. Then, use the PUMA map references to manually double check which PUMAs you want to include.

    ```{r}

    ```

6.  Create a table called `PUMA_List` that just includes the FullPUMA column.

    ```{r}
    PUMA_List <- PUMA_References %>%
      filter(Year == 2009)

    PUMA_List <- PUMA_List %>%
        select(FullPUMA)
    ```

7.  Use this new list to filter `AllData` to a new, smaller table called `Data_Specific`

    ```{r}
    Data_Specific <- AllData %>%
      filter(FullPUMA == "400121" | FullPUMA == "400122" | FullPUMA == "400120" | FullPUMA == "400108" | FullPUMA == "400103" | FullPUMA == "400104" | FullPUMA == "400114" | FullPUMA == "400115" | FullPUMA == "400105" | FullPUMA == "400106" | FullPUMA == "400107" | FullPUMA == "400109" | FullPUMA == "400110" | FullPUMA == "400111" | FullPUMA == "400112" | FullPUMA == "400113" | FullPUMA == "400117" | FullPUMA == "400118" | FullPUMA == "400119" | FullPUMA == "400116" | FullPUMA == "400102" | FullPUMA == "400101" | FullPUMA == "1100101" | FullPUMA == "1100102" | FullPUMA == "1100103" | FullPUMA == "1100104" | FullPUMA == "1100105" | FullPUMA == "1204009" | FullPUMA == "1204010" | FullPUMA == "1204011" | FullPUMA == "1301201" | FullPUMA == "1301103" | FullPUMA == "1301104" | FullPUMA == "1301105" | FullPUMA == "1301106" | FullPUMA == "1703501" | FullPUMA == "1703502" | FullPUMA == "1703503" | FullPUMA == "1703504" | FullPUMA == "1703505" | FullPUMA == "1703506" | FullPUMA == "1703507" | FullPUMA == "1703508" | FullPUMA == "1703509" | FullPUMA == "1703510" | FullPUMA == "1703511" | FullPUMA == "1703512" | FullPUMA == "1703513" | FullPUMA == "1703514" | FullPUMA == "1703515" | FullPUMA == "1703516" | FullPUMA == "1703517" | FullPUMA == "1703518" | FullPUMA == "1703519" | FullPUMA == "2503301" | FullPUMA == "2503302" | FullPUMA == "2503303" | FullPUMA == "2503304" | FullPUMA == "2503305" | FullPUMA == "2502900" | FullPUMA == "2603701" | FullPUMA == "2603702" | FullPUMA == "2603703" | FullPUMA == "2603704" | FullPUMA == "2603705" | FullPUMA == "2603706" | FullPUMA == "2603707" | FullPUMA == "2603708" | FullPUMA == "3900603" | FullPUMA == "3900606" | FullPUMA == "3900607" | FullPUMA == "3900608" | FullPUMA == "4201806" | FullPUMA == "2400801" | FullPUMA == "2400802" | FullPUMA == "2400803" | FullPUMA == "2400804" | FullPUMA == "2400805" | FullPUMA == "2400806" | FullPUMA == "4201801" | FullPUMA == "4201805" | FullPUMA == "4201807" | FullPUMA == "4201803" | FullPUMA == "4201804" | FullPUMA == "4201802" | FullPUMA == "4201701" | FullPUMA == "4201702" | FullPUMA == "4201703" | FullPUMA == "4204101" | FullPUMA == "4204102" | FullPUMA == "4204103" | FullPUMA == "4204104" | FullPUMA == "4204105" | FullPUMA == "4204106" | FullPUMA == "4204107" | FullPUMA == "4204108" | FullPUMA == "4204109" | FullPUMA == "4204110" | FullPUMA == "4204111" | FullPUMA == "4804601" | FullPUMA == "4804602" | FullPUMA == "4804603" | FullPUMA == "4804604" | FullPUMA == "4804605" | FullPUMA == "4804606" | FullPUMA == "4804607" | FullPUMA == "4804608" | FullPUMA == "4804609" | FullPUMA == "4804610" | FullPUMA == "4804611" | FullPUMA == "4804612" | FullPUMA == "4804613" | FullPUMA == "4804615" | FullPUMA == "4804624" | FullPUMA == "4805301" | FullPUMA == "4805302" | FullPUMA == "4805303" | FullPUMA == "4805304" | FullPUMA == "1000103" | FullPUMA == "1000104" | FullPUMA == "1000101" | FullPUMA == "1000300" | FullPUMA == "1000102" | FullPUMA == "1000200")
    ```

### Get that sweet sweet summary info

This analysis is going to create a crosstab for several different combinations. Ultimately, these will be calculated alongside PUMA-level census information that then will give us general estimates of the number of people in addition to the percentages. Then, the PUMAs will be aggregated up to the target cities that they are within and this final information will be explorable and comparable.\
\
**The largest group examines different racial information:**

-   The percent of people in each PUMA who make more than and less than \$200,000.

-   The percent of Black-only people in each PUMA who make more than and less than \$200,000.

-   The percent of Asian-only people in each PUMA who make more than and less than \$200,000.

-   The percent of White-only people in each PUMA who make more than and less than \$200,000.

-   The percent of Hispanic/Latinx people in each PUMA who make more than and less than \$200,000.

**The next crosstabs examine things like category of work, industries, and migration**

-   The percent of people in each PUMA who make more than \$200,000 dis-aggregated by the category of work.

-   The percent of people in different industries (`INDP`) who make more than \$200,000 dis-aggregated by what PUMA they live in.

-   The percent of people in different industries (`NAICSP`) who make more than \$200,000 dis-aggregated by what PUMA they live in.

-   The percent of people in different occupations (`OCCP`) who make more than \$200,000 dis-aggregated by what PUMA they live in.

-   The percent of people in different occupations (`SOCP`) who make more than \$200,000 dis-aggregated by what PUMA they live in.

-   The percent of people in different PUMAS who make more than \$200,000 dis-aggregated by whether they lived there or elsewhere in the past year (`MIG`).

1.  First, we'll need to make a couple of tables that filter by race and whether someone made more than \$200,000. To easily identify that these are subsets of data that we'll need to make our crosstabs, these start with `Data_`.

    ```{r}
    # Just people who made more than $200,000
    Data_Above200k <- Data_Specific %>%
      filter(AboveYN == "Above")

    # Just Black-only people
    Data_RaceBlack <- Data_Specific %>%
      filter(RACE == "Black or African American alone")

    # Just Asian-only people
    Data_RaceAsian <- Data_Specific %>%
      filter(RACE == "Asian alone")
      
    # Just White-only people
    Data_RaceWhite <- Data_Specific %>%
      filter(RACE == "White alone")
      
    # Just Hispanic/Latinx people
    Data_EthHisp <- Data_Specific %>%
      filter(HispYN == "Hisp")
    ```

2.  Let's make this first group of crosstabs. To make it easier to identify that this is the summary data we want, all these dataframes are going to start with `SUM`.

    ```{r}
    # % of people above/below $200k
    SUMAboveYN_ByPUMA <- crosstab(Data_Specific, FullPUMA, AboveYN, w=PWGTP)

    # % of Black-only ppl above/below $200k
    SUMRace_BlackByPUMA <- crosstab(Data_RaceBlack, FullPUMA, AboveYN, w=PWGTP)

    # % of Asian-only ppl above/below $200k
    SUMRace_AsianByPUMA <- crosstab(Data_RaceAsian, FullPUMA, AboveYN, w=PWGTP)

    # % of White-only ppl above/below $200k
    SUMRace_WhiteByPUMA <- crosstab(Data_RaceWhite, FullPUMA, AboveYN, w=PWGTP)

    # % of Hisp/Latinx ppl above/below $200k
    SUMEthn_HispByPUMA <- crosstab(Data_EthHisp, FullPUMA, AboveYN, w=PWGTP)
    ```

3.  Before we can make group 2, we'll need to match each PUMA to its target city. This is because there are so many values for INDP, NACISP, OCCP, and SOCP -- we don't want to deal with a table that is several hundred columns, so the values here will be actually our observations. This means we need the target cities to be our Variables. If we did PUMAs, we wouldn't be able to combine them together because crosstabs present percentages, not numbers.

    ```{r}
    PUMA_Year <- PUMA_References %>%
      filter(Year == 2009)

    Data_CityForWork <- merge(Data_Specific, PUMA_Year)
    ```

4.  Now let's make the second group of crosstabs we want, also starting with `SUM` so they're easy to spot.

    ```{r}
    # % ppl above $200k by COW.
    SUMWork_COW <- crosstab(Data_Above200k, FullPUMA, COW, w=PWGTP)

    # % ppl above $200k by INDP
    SUMWork_INDP <- crosstab(Data_CityForWork, Target_City, INDP, w=PWGTP)

    # % ppl above $200k by NAICSP
    SUMWork_NAICSP <- crosstab(Data_CityForWork, Target_City, NAICSP, w=PWGTP)

    # % ppl above $200k by OCCP
    SUMWork_OCCP <- crosstab(Data_CityForWork, Target_City, OCCP, w=PWGTP)

    # % ppl above $200k by SOCP
    SUMWork_SOCP <- crosstab(Data_CityForWork, Target_City, SOCP, w=PWGTP)

        # % ppl above $200k by MIG
    SUMHous_MIG <- crosstab(Data_Above200k, FullPUMA, MIG, w=PWGTP)
    ```

5.  Now you can download all those files to use for your analysis!

    ```{r}
    write.csv(SUMAboveYN_ByPUMA, "/Volumes/Seagate/1 - REPORTING/2021/Tech.ly - Black Wealth/2010_Cities/AA_New09Data/BlackWealth09_07082021/FinalData//SUMAboveYN_ByPUMA.csv")
    write.csv(SUMEthn_HispByPUMA, "/Volumes/Seagate/1 - REPORTING/2021/Tech.ly - Black Wealth/2010_Cities/AA_New09Data/BlackWealth09_07082021/FinalData//SUMEthn_HispByPUMA.csv")
    write.csv(SUMHous_MIG, "/Volumes/Seagate/1 - REPORTING/2021/Tech.ly - Black Wealth/2010_Cities/AA_New09Data/BlackWealth09_07082021/FinalData//SUMHous_MIG.csv")
    write.csv(SUMRace_AsianByPUMA , "/Volumes/Seagate/1 - REPORTING/2021/Tech.ly - Black Wealth/2010_Cities/AA_New09Data/BlackWealth09_07082021/FinalData//SUMRace_AsianByPUMA.csv")
    write.csv(SUMRace_BlackByPUMA, "/Volumes/Seagate/1 - REPORTING/2021/Tech.ly - Black Wealth/2010_Cities/AA_New09Data/BlackWealth09_07082021/FinalData//SUMRace_BlackByPUMA.csv")
    write.csv(SUMRace_WhiteByPUMA, "/Volumes/Seagate/1 - REPORTING/2021/Tech.ly - Black Wealth/2010_Cities/AA_New09Data/BlackWealth09_07082021/FinalData//SUMRace_WhiteByPUMA.csv")
    write.csv(SUMWork_COW, "/Volumes/Seagate/1 - REPORTING/2021/Tech.ly - Black Wealth/2010_Cities/AA_New09Data/BlackWealth09_07082021/FinalData//SUMWork_COWA.csv")
    write.csv(SUMWork_INDP, "/Volumes/Seagate/1 - REPORTING/2021/Tech.ly - Black Wealth/2010_Cities/AA_New09Data/BlackWealth09_07082021/FinalData//SUMWork_INDP.csv")
    write.csv(SUMWork_NAICSP, "/Volumes/Seagate/1 - REPORTING/2021/Tech.ly - Black Wealth/2010_Cities/AA_New09Data/BlackWealth09_07082021/FinalData//SUMWork_NAICSP.csv")
    write.csv(SUMWork_OCCP, "/Volumes/Seagate/1 - REPORTING/2021/Tech.ly - Black Wealth/2010_Cities/AA_New09Data/BlackWealth09_07082021/FinalData//SUMWork_OCCP.csv")
    write.csv(SUMWork_SOCP, "/Volumes/Seagate/1 - REPORTING/2021/Tech.ly - Black Wealth/2010_Cities/AA_New09Data/BlackWealth09_07082021/FinalData//SUMWork_SOCP.csv")
    ```
