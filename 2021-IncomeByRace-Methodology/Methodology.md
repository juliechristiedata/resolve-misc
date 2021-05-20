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
11. Create a new database in DB Browser and import the .csv files. If you're working with more than one state, the PUMS files are very large and I recommend that you create one database for each state so that you can save your progress as you go and reduce your risk of having to start completely over.
	* When uploading the PUMS file, rename it to `ST_2019STATENAME`

### Match PUMS to PUMAs




***
#####Footnotes
[^1]: In an ideal world, this would be a 5-year estimate because it's not as accurate to compare a 5-year estimate to a 1-year estimate. However, the 5-year estimates did not allow me to select PUMAs. I made the decision to chane to the 1-year estimate, because to make  all estimates uniform, I would have needed to change all my other PUMS, PUMA, and Census data sources to 1-year estimates, which are ultimately less accurate. I decided that I would rather have one, slightly less accurate data source that wasn't a perfect match than all my data sources be the less accurate options available.
