# Methodology for analyzing income by racial demographics
Created by Julie Christie, Data & Impact Editor at [Resolve Philly](https://www.resolvephilly.org).

## Goal of analysis
This project came about becasue we were unable to easily find hyperlocal figures that could answer the question: 
>*"How many Black people have an income more than $200,000 in different cities around the United States?"*

Sadly, the U.S. Census data tools could give us either race or income, but wouldn't allow us to combine the two for an estimat of how many people earn a specific amount within a racial group. The following is a detailed analysis of the process by which we created this analysis and the decisions we made along the way.

### Glossary

* **ACS** — American Community Survey; An annual survey the U.S. Census bureau conducts to collect an annual snapshot of demographic, housing and other information on United States residents. The presentation of this area is always aggregated by a geographic location.
* **PUMS** — Public Use Microdata Sample; A sample of the ACS that contains individual-level data and far more details than usually found in ACS exploration tools.
* **PUMAs** — Public Use Microdata Areas; A gegographic area defined by the number of residents within them and adhering to county and state borders. A single PUMA can encompass multiple towns, or many PUMAs can make up a single city. [Learn more about them here.](https://www.census.gov/programs-surveys/geography/guidance/geo-areas/pumas.html)



## Resources used
### Data
* [2019 and 2009 ACS 5-year Public Use Microdata Sample (PUMS) person files](http://www2.census.gov/programs-surveys/acs/data/pums/) — Individual-level data that provided income, race, and location.
* [Missouri Census Data Center Geocorr App 2014 and 2000 5%](https://mcdc.missouri.edu/applications/geocorr.html) — A list of Public Use Microdata Areas (PUMAs) that would match up with the PUMAs listed in the PUMS files that included names of the areas. PUMAs are the most specific geographies available in a PUMS file. These were not Super-PUMAs.
* [2010 PUMA Name reference file 5%](https://www2.census.gov/geo/docs/reference/puma/2010_PUMA_Names.txt) — A cleaned, simplified list of PUMA codes and their names.
* [ACS 5-year estimate 2019 DP05](https://data.census.gov/cedsci/table?q=dp05&tid=ACSDP5Y2019.DP05) — ACS information for the 2019 PUMA geographies I was specifically looking into.
* [ACS 1-year estimate 2010 DP05](https://data.census.gov/cedsci/table?q=dp05&tid=ACSDP1Y2010.DP05) — ACS information for the 2009 PUMA geographics I was specifically looking into.[^1]

### Tools
* [DB Browser for SQLite](https://sqlitebrowser.org/) — To match PUMS with PUMAs and narrow down very large data files
* [Sublime Text](https://www.sublimetext.com/) — Text editor
* [Excel](https://www.microsoft.com/en-us/microsoft-365/excel) — To  calculate inflation, determine income brackets, and create PivotTables.
* [Airtable](https://airtable.com/) — To de-duplicate the 2000 PUMAs files from MCDC Geocorr
* [Google Sheets](https://www.google.com/sheets/about/) — To share final data results with editors
* [Flourish](https://flourish.studio/) — To visualize the results of the data.

## Methodology
###Get your data ready
1. Download the 2019 5-year PUMS data for each state holding a city that will be examined. In our case, we looked at Philadelphia, PA; Pittsburgh, PA; Phoenix, AZ; Miami, FL; Atlanta, GA; Chicago, IL; Baltimore, MD; Boston, MA; Detroit, MI; Cleveland, OH; Austin, TX; Houston, TX; and Washington, DC. **Download them as .csv files.**
2. Go to MCDC 2014 Geocorr and download a complete list of the PUMAs for each state you want. 
	* Source Geographies: `County, County Subdivision/Town(ship)/MCD, Place, PUMA` (under 2012 Geographies)
	* Target Geographies: same as above
	* Weighting Variable: Population `unchanged`
	* Ignore census blocks... : `checked`
	* Keep subsequent three boxes unchecked 
	* Save filename as `PUMAs_2010`
	* Generage CSV: `checked`, include both codes
	* Generate a report: `UNchecked`
	
	 > **A note about this data set:** each place within a PUMA will receive its own row in the data, meaning that there will be duplicates. This gets addressed in the next section.
11. Create a new database in DB Browser and import the .csv files. If you're working with more than one state, the PUMS files are very large and I recommend that you create one database for each state so that you can save your progress as you go and reduce your risk of having to start completely over.
	* When uploading the PUMS file, rename it to `StateName2019`

### Match PUMS to PUMAs
This step will combine your PUMS and PUMA files so that you can sort through your files by the name of the city or place you're examining, rather than having to manually figure out which PUMA references you want to use.

[Download a full copy of the code here.](https://juliechristiedata.github.io/resolve-misc/2021-IncomeByRace-Methodology/TemplateCode.sql) 

1. Get a list of the PUMAs that make up the area you want to look at, and make a new table of PUMAs that are just the ones you want

	~~~sql
	CREATE TABLE smPUMAs_2010 AS 
		SELECT * From PUMAs_2010 WHERE placenm like "%cityname%";
	~~~

2. Copy the list of PUMA codes into a text editor like Sublime. Each PUMA will appear on its own line. Select the line indentation and then copy it into the search bar. Select `Find All` and your cursor will appear on every instance of a line indentation. Use the left arrow key to tab over to the very beginning of the line, and then type `PUMA =`. Then tab to the very end and type `OR`. This creates a list you will use in SQLite in the next step.
3. Create a new table of PUMS data that only includes the PUMAs you are looking for.

	~~~sql
	CREATE TABLE ST_2019StateName AS
		SELECT * From StateName2019 WHERE	
		PUMA = 123 OR
		PUMA = 4567 OR
		PUMA = 890;
	~~~

4. Match this new, narrowed down table to the smaller PUMAs table. This connects the name of the PUMAs to other information like county name, town name, etc. 

	This selection of columns was specific to what I wanted to look at. There may be additional columns or fewer columns that you want to include. If you choose to include all the columns from the PUMS file, it this will take even longer to run and will be very slow when you open it in Excel later. The essential columns you must include are `SERIALNO` and `ADJINC` if you pull in any monetary info like I did, with `PINCP`.
	
	You can find a detailed list of the fields in the [PUMS metadata for 2019](https://www2.census.gov/programs-surveys/acs/tech_docs/pums/data_dict/PUMS_Data_Dictionary_2015-2019.pdf) and the [metadata for 2009](https://www2.census.gov/programs-surveys/acs/tech_docs/pums/data_dict/PUMSDataDict05_09.pdf).

	~~~sql
	CREATE TABLE MTCHST_2019 AS
		SELECT ST_2019StateName.SERIALNO, ST_2019StateName.PINCP, ST_2019StateName.HISP, ST_2019StateName.RAC1P, ST_2019AStateName.PUMA, ST_2019StateName.AGEP, ST_2019StateName.COW, ST_2019StateName.JWMNP, ST_2019StateName.JWTRNS, ST_2019StateName.PAP, ST_2019StateName.SEX, ST_2019StateName.ST, ST_2019StateName.ADJINC,
			smPUMAs_2010.county, smPUMAs_2010.state, smPUMAs_2010.puma12, smPUMAs_2010.stab, smPUMAs_2010.cntyname, smPUMAs_2010.placenm
		FROM ST_2019StateName
		LEFT JOIN smPUMAs_2010 ON ST_2019StateName.PUMA = smPUMAs_2010.puma12 AND ST_2019StateName.ST = smPUMAs_2010.state;
	~~~

5. Filter out any records in the new table that don't have a match. This is likely to not change much if anything at all, but will ensure you have the smallest file you can achieve before exporting.

	~~~sql
	CREATE TABLE CT_2019StateName AS
		SELECT * From MTCHST_2019 
		WHERE placenm like "%cityname%";
	~~~

6. Export `CT_2019StateName` as a .csv file.

###Prepare PUMS data in Excel
1. Open `CT_2019StateName.csv` in Excel and save it as `Analysis_2019StateName.xlsx`.
2. Format the data as a table.
3. Go to the `Data` tab and click the button to remove duplicates. Don't uncheck anything here -- we only want to remove completely duplicated records.
4. Add three new columns to the beginning of the sheet but after `SERIALNO`. Name them `Above200k`, `HispYN`, and `ADJINFL`. 
5. In `ADJINFL`, select the first empty cell and type in the formula

	~~~
	=([@ADJINC]/1000000)*[@PINCP]
	~~~

	This adjusts the income for inflation to 2019 dollars.
	
	If you're working in a file from before 2019, then you'll want to adjust that result to 2019. [Here is a website you can use to figure out which values you need for inflation adjustments.](https://www.census.gov/topics/income-poverty/income/guidance/current-vs-constant-dollars.html). The formula you'd use in this case, would look something like:
	
	~~~
	=(([@ADJINC]/1000000)*[@PINCP])*{2019 CPI-U-RS} / {2009 CPI-U-RS}
	~~~
	
	What this formula does is first unifies everything in the PUMS file to adjust for inflation to whatever year that data set represents (like 2009). Then, it adjusts for inflation to the year you really want (in this case, 2019).
	
	Once you hit enter, the formula will autofill the whole column for the table.
	
6. In `Above200k` insert a formula to determine whether the person's income (now adjusted for inflation) is above or below the bracket you decided on.[^2] In this case, we had a single threshhold, which was $200,000.

	~~~
	=if([@ADJINFL]>199999.99, "Above", "Below")
	~~~

7. The `HispYN` column is to identify whether a person is Hispanic or Latinx. This is an if-formula that converts the code in the `HISP` column into a plain-english way to identify whether that person is Hispanic/Latinx or not.[^3] This formula was developed in reference to the PUMS data dictionaries.

	~~~
	=if([@HISP]=1, "NotHisp", "Hisp")
	~~~

### Analyze PUMS data in Excel
The rest of this process will be to create PivotTables and then combine those results into a table that allows you to compare one place to another.

1. Go to the `Insert` tab and click PivotTable. The field for what area you want to select will say "Table 1" -- this is the table you created earlier.
2. Click `OK` without changing anything else. This will send the PivotTable to a new sheet in your workbook.
3. Rename that sheet to `200k_RaceAll`.
4. Build out the table by dragging the following fields into different sections of the dialogue box.
	* Columns: `Above200k`, `RAC1P`
	* Rows: `PUMA`
	* Values: `PUMA`
		* Click the little i that appears next to this one and make sure it's calculating the **count** of the field, not sum. Then click the `Show data as` button and change the dropdown to choose `% of Row Total` then click OK.

This creates a PivotTable that tells you the percent of people who make more than 200k in the whole geographic area, disaggregated by race. If you want to know the distribution within a specific race, move `RAC1P` from the Columns section into the Filters section, and then use the dropdown to choose the code that corresponds to the race you're interested in. (The codes are in the PUMs data dictionaries.)

For each new analysis you want to run on the PUMS data, create a new pivot table. In our case, we created PivotTables to look at All races, Black Only, White Only, Asian Only, both Hispanic and not Hispanic, and Hispanic Only. 

### Combining analyses for comparison

This last portion of combining analysis for comparison is done in a whole new sheet. In this case, I used Google Sheets to share with colleagues, but this can also be done in Excel. For simplicity, formulas are still in Excel syntax.

1. Create a tab for each PivotTable you created in your analysis files.
2. Copy those tables into this new workbook and clean them so that the tables are unified.
	* If you're combining data from multiple states, you'll need to create a column that indicates which state each PUMA is in. The same applies if you're comparing data from different years.
3. Format them as tables, and name those tables to match the tab name to help you easily identify all your tables.

### Removing unnecessary PUMAs
This is a double-chck step to weed out any PUMAs that you captured with your code but don't actually want to include. 

Some of these steps can be skipped/would be done just as quickly by hand if you're working with only a couple of states.

1. Import the PUMA name reference file into a new sheet in the workbook that has all your combined data. Name that tab something like `PUMA_Reference2010`

	If you're working with PUMAs from 2000, then you'll need to clean through the MCDC file you created and remove duplicates. Make sure the PUMA name you're preserving when removing duplicates is the name you will recognize.
	
	The Census does not have a 2000 PUMA name reference file.
	
2. Copy a list of state names and codes into some blank space in the PUMA reference file. [This USDA table contains the codes you'll need.](https://www.nrcs.usda.gov/wps/portal/nrcs/detail/?cid=nrcs143_013696) **Move the FIPS column to be first.** Highlight the names and codes and format them as a table, and change the name to StateCodes
3. Highlight the PUMAs data and also format it as a table, naming it `PUMA_Ref`.
4. Add a column to `PUMA_Ref` and name it `StateLookup`. In the first empty cell, [create a VLOOKUP formula](https://exceljet.net/excel-functions/excel-vlookup-function) that will pull in the state name based on the state code of each PUMA.

	~~~
	=VLOOKUP([@state], StateCode[#All], 2, FALSE)
	~~~

5. Now make a column that concatenates the state name and the PUMA code to create a unique ID, and call the column `PUMA_Code`. Make this the first column in the `PUMA_Ref` table. (`Home` > `Insert` > `Insert table columns to the left`)

	~~~
	=Concatenate([@StateLookup], " ", [@puma12])
	~~~

6. Now create a new column in your combined data and use the concatenate formula to make an identical `PUMA_Code` column. This formula will look like

	~~~
	=CONCATENATE([@State], " ", [@PUMA])
	~~~

7. Add another column and call it `PUMA_Name`. Use a VLOOKUP to pull in the recognizable name of the PUMA. You can adjust the column index number to pull in other information like the County name.

	~~~
	=VLOOKUP([@[PUMA_Code]], PUMA_Ref[#All], 11, FALSE)
	~~~
	
8. Go thrhough the names of all the PUMAs to confirm that you're only looking at the ones you want to. Repeat this for each combined comparison table you've created.

### Connecting Census data to make estimates
If you want to be able to turn a percent of a population into an estimation of how many people that actually is, you'll need to download and link Census data to your combined comparison tables.

> #### Some notes on comparing Census data
* You'll want to use the ACS from whichever year you're looking at and the estimate that matches the PUMS data you downloaded. For example, if you use the 1-year PUMS, then use the 1-year ACS data.
* The previous steps to confirm you have exactly the PUMAs you want will be very important here, because it will reduce how many PUMAs you have to manually look up in the Data Explorer.
* If you're using PUMS data in a 5-year estimate that includes both 2010 and 2000 PUMAs, just don't. It's really funky and difficult to accurately match them to the right PUMAs and Census data. Instead, switch over to 1-year estimates. 

1. Go to the Census data explorer and find the table you want to use. If you're looking for age, sex, race, and ethnicity data, just search for `DP05`. 
2. Once you've pulled up the table editor, click on geographies and scroll down until you see PUMAs.
3. Choose that option and then in each new panel, further narrow down to the PUMAs you want. You can select from multiple states at once. 
4. Download the resulting table as a .csv file
5. Import the census table into your workbook with the combined comparisons. Format it as a table. Open up the other .csv you got in the download in a new workbook -- this will be helpful for figuring out which columns you want to reference. 
6. Add a VLOOKUP formula that pulls in the census data for the specific groups of people you want to make estimates for. This can only work when your table is focused on a specific group of people (like Black Only).[^4] For 2019 PUMAs, use `PUMA_Name` as your lookup. For 2009, you'll need to make a new ID that matches the Census file with a CONCATENATE formula. There are a couple of ways you can complete the VLOOKUP formula:
	* Upload the whole Census data file and use the column reference file to figure out which index number you should use in your column reference.
	* Narrow down the Census data file to just the columns you want to use before uploading, making it far easier to figure out the index number you need for column reference.

### Comparing results and estimates
The final step is to make yet another PivotTable, this time using the PUMA names as your rows, or the other geography level that you're examining. You may want to make and manually fill out a `Target City` column in your comparison tables to achieve prettier labels than the PUMA names.

If you're combining multiple PUMAs into a city like I did, you'll need to treat the percentages and estimated numbers differently. For percentage, I determined median to be the most stable process to unify them. For figures, totaling them was most appropriate.

Once you've completed the analysis you want, the final step, would be to visualize the data. Below you can see an example visualization from my analysis.

<div class="flourish-embed flourish-scatter" data-src="visualisation/6196019"><script src="https://public.flourish.studio/resources/embed.js"></script></div>


[^1]: In an ideal world, this would be a 5-year estimate because it's not as accurate to compare a 5-year estimate to a 1-year estimate. However, the 5-year estimates did not allow me to select PUMAs. I made the decision to chane to the 1-year estimate, because to make  all estimates uniform, I would have needed to change all my other PUMS, PUMA, and Census data sources to 1-year estimates, which are ultimately less accurate. I decided that I would rather have one, slightly less accurate data source that wasn't a perfect match than all my data sources be the less accurate options available.

[^2]: We decided on $200,000 because our very first question wasn't of income, but wealth. After researching and understanding how subjective a term "wealth" is, we instead shifted to $200,000 income indicator for several reasons. First, income is a much more easily understood term for readers to think about, and there's less table-setting required to make sure people are thinking of the same thing when we talk about "income." Second, we decided that $200,000 waas an appropriate amount because it is a relatively high income in cities, where cost of living can make high salaries just enough to get by.

[^3]: When  analyzing the race of individuals, we felt it important to also understand the same for people with Hispanic or Latinx ethnicities. We understand that ethnicity is not the same as race. It is inappropriate to compare a race to ethnicity, as people can be a combination of race and ethnicity, creating overlap. As a result, our article and visualizations separate the two so that visual overlap is minimized.

[^4]: When calculating the estimated number of people within a race, you can only use the ACS columns that are BlackONLY or WhiteONLY, because the PUMS data does not get more specific. **This is a large gap within our analysis.** 
