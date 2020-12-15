/* ===================================================
CREATE YOUR FIRST TABLE -- This will include all of the dates associated with the place(s) you select. To get a specific date, jump to the section on DATA FOR UPDATES*/

-- One place
CREATE TABLE sandbox AS
	SELECT * FROM RAWdata_12142020 
	WHERE fips_code="42101" AND collection_week="2020-12-04";	-- [1] This is one way to call a place. Reference the end of this document to see the other ways you can specify a place.

-- Multiple places
CREATE TABLE GreatPHL_Data_12142020 AS
	SELECT * FROM RAWdata_12142020
	WHERE fips_code="42101" OR fips_code="42091"; 			-- [2] To have multiple places, use the OR function to add each additional place. There are some restrictions that are explained in the reference.
	
	
/* ===================================================
DATA FOR UPDATES -- This is the code you'll use to get the additional data you want to update your spreadsheet with every week.*/

-- One place
CREATE TABLE SANDBOX_Data_12142020 AS
	SELECT * FROM RAWdata_12142020 
	WHERE fips_code="42101" AND collection_week="2020-12-04";
	
-- Multiple places
CREATE TABLE SANDBOX_Data_12142020 AS
	SELECT * FROM RAWdata_12142020 
	WHERE (fips_code="42101" OR fips_code="42091" OR fips_code="42045" 
	       OR fips_code="42017" OR fips_code="42029" OR fips_code="34007" 
	       OR fips_code="10001" OR fips_code="10003" OR fips_code="10005") 		-- Keep your list of all the different places you want to capture inside the parentheses.
		AND collection_week="2020-12-04";
	
	

/*REFERENCES ===================================================
	
	[1] 'fips_code' is another code for counties. If you want to select a whole state, change it to: state="ZZ" and use the two-letter state code you want to isolate. 
		You can narrow down to a specific city in a state with something like: state="ZZ" AND city="ZZZZZ"
		If you want to filter out for all the towns that start with the letter P, then you can put something like: city like "p%"
		Access the list of counties and their FIPS codes at https://www.nrcs.usda.gov/wps/portal/nrcs/detail/national/home/?cid=nrcs143_013697
	
	[2] You can't add any combination of ORs and ANDs to your query. Read this to get familiar with how to use them: https://www.techonthenet.com/sqlite/and_or.php
	
	
