<h1 id="toc_0">Methodology for analyzing income by racial demographics</h1>

<p>Created by Julie Christie, Data &amp; Impact Editor at <a href="https://www.resolvephilly.org">Resolve Philly</a>.</p>

<h2 id="toc_1">Goal of analysis</h2>

<p>This project came about becasue we were unable to easily find hyperlocal figures that could answer the question: </p>

<blockquote>
<p><em>&quot;How many Black people have an income more than $200,000 in different cities around the United States?&quot;</em></p>
</blockquote>

<p>Sadly, the U.S. Census data tools could give us either race or income, but wouldn&#39;t allow us to combine the two for an estimat of how many people earn a specific amount within a racial group. The following is a detailed analysis of the process by which we created this analysis and the decisions we made along the way.</p>

<h3 id="toc_2">Glossary</h3>

<ul>
<li><strong>ACS</strong> — American Community Survey; An annual survey the U.S. Census bureau conducts to collect an annual snapshot of demographic, housing and other information on United States residents. The presentation of this area is always aggregated by a geographic location.</li>
<li><strong>PUMS</strong> — Public Use Microdata Sample; A sample of the ACS that contains individual-level data and far more details than usually found in ACS exploration tools.</li>
<li><strong>PUMAs</strong> — Public Use Microdata Areas; A gegographic area defined by the number of residents within them and adhering to county and state borders. A single PUMA can encompass multiple towns, or many PUMAs can make up a single city. <a href="https://www.census.gov/programs-surveys/geography/guidance/geo-areas/pumas.html">Learn more about them here.</a></li>
</ul>

<h2 id="toc_3">Resources used</h2>

<h3 id="toc_4">Data</h3>

<ul>
<li><a href="http://www2.census.gov/programs-surveys/acs/data/pums/">2019 and 2009 ACS 5-year Public Use Microdata Sample (PUMS) person files</a> — Individual-level data that provided income, race, and location.</li>
<li><a href="https://mcdc.missouri.edu/applications/geocorr.html">Missouri Census Data Center Geocorr App 2014 and 2000 5%</a> — A list of Public Use Microdata Areas (PUMAs) that would match up with the PUMAs listed in the PUMS files that included names of the areas. PUMAs are the most specific geographies available in a PUMS file. These were not Super-PUMAs.</li>
<li><a href="https://www2.census.gov/geo/docs/reference/puma/2010_PUMA_Names.txt">2010 PUMA Name reference file 5%</a> — A cleaned, simplified list of PUMA codes and their names.</li>
<li><a href="https://data.census.gov/cedsci/table?q=dp05&amp;tid=ACSDP5Y2019.DP05">ACS 5-year estimate 2019 DP05</a> — ACS information for the 2019 PUMA geographies I was specifically looking into.</li>
<li><a href="https://data.census.gov/cedsci/table?q=dp05&amp;tid=ACSDP1Y2010.DP05">ACS 1-year estimate 2010 DP05</a> — ACS information for the 2009 PUMA geographics I was specifically looking into.<sup id="fnref1"><a href="#fn1" rel="footnote">1</a></sup></li>
</ul>

<h3 id="toc_5">Tools</h3>

<ul>
<li><a href="https://sqlitebrowser.org/">DB Browser for SQLite</a> — To match PUMS with PUMAs and narrow down very large data files</li>
<li><a href="https://www.sublimetext.com/">Sublime Text</a> — Text editor</li>
<li><a href="https://www.microsoft.com/en-us/microsoft-365/excel">Excel</a> — To  calculate inflation, determine income brackets, and create PivotTables.</li>
<li><a href="https://airtable.com/">Airtable</a> — To de-duplicate the 2000 PUMAs files from MCDC Geocorr</li>
<li><a href="https://www.google.com/sheets/about/">Google Sheets</a> — To share final data results with editors</li>
<li><a href="https://flourish.studio/">Flourish</a> — To visualize the results of the data.</li>
</ul>

<h2 id="toc_6">Methodology</h2>

<h3 id="toc_7">Get your data ready</h3>

<ol>
<li>Download the 2019 5-year PUMS data for each state holding a city that will be examined. In our case, we looked at Philadelphia, PA; Pittsburgh, PA; Phoenix, AZ; Miami, FL; Atlanta, GA; Chicago, IL; Baltimore, MD; Boston, MA; Detroit, MI; Cleveland, OH; Austin, TX; Houston, TX; and Washington, DC. <strong>Download them as .csv files.</strong></li>
<li><p>Go to MCDC 2014 Geocorr and download a complete list of the PUMAs for each state you want. </p>

<ul>
<li>Source Geographies: <code>County, County Subdivision/Town(ship)/MCD, Place, PUMA</code> (under 2012 Geographies)</li>
<li>Target Geographies: same as above</li>
<li>Weighting Variable: Population <code>unchanged</code></li>
<li>Ignore census blocks... : <code>checked</code></li>
<li>Keep subsequent three boxes unchecked </li>
<li>Save filename as <code>PUMAs_2010</code></li>
<li>Generage CSV: <code>checked</code>, include both codes</li>
<li><p>Generate a report: <code>UNchecked</code></p>

<blockquote>
<p><strong>A note about this data set:</strong> each place within a PUMA will receive its own row in the data, meaning that there will be duplicates. This gets addressed in the next section.</p>
</blockquote></li>
</ul></li>
<li><p>Create a new database in DB Browser and import the .csv files. If you&#39;re working with more than one state, the PUMS files are very large and I recommend that you create one database for each state so that you can save your progress as you go and reduce your risk of having to start completely over.</p>

<ul>
<li>When uploading the PUMS file, rename it to <code>StateName2019</code></li>
</ul></li>
</ol>

<h3 id="toc_8">Match PUMS to PUMAs</h3>

<p>This step will combine your PUMS and PUMA files so that you can sort through your files by the name of the city or place you&#39;re examining, rather than having to manually figure out which PUMA references you want to use.</p>

<p><a href="https://juliechristiedata.github.io/resolve-misc/2021-IncomeByRace-Methodology/TemplateCode.sql">Download a full copy of the code here.</a> </p>

<ol>
<li><p>Get a list of the PUMAs that make up the area you want to look at, and make a new table of PUMAs that are just the ones you want</p>

<div><pre><code class="language-sql">CREATE TABLE smPUMAs_2010 AS 
    SELECT * From PUMAs_2010 WHERE placenm like &quot;%cityname%&quot;;</code></pre></div></li>
<li><p>Copy the list of PUMA codes into a text editor like Sublime. Each PUMA will appear on its own line. Select the line indentation and then copy it into the search bar. Select <code>Find All</code> and your cursor will appear on every instance of a line indentation. Use the left arrow key to tab over to the very beginning of the line, and then type <code>PUMA =</code>. Then tab to the very end and type <code>OR</code>. This creates a list you will use in SQLite in the next step.</p></li>
<li><p>Create a new table of PUMS data that only includes the PUMAs you are looking for.</p>

<div><pre><code class="language-sql">CREATE TABLE ST_2019StateName AS
    SELECT * From StateName2019 WHERE   
    PUMA = 123 OR
    PUMA = 4567 OR
    PUMA = 890;</code></pre></div></li>
<li><p>Match this new, narrowed down table to the smaller PUMAs table. This connects the name of the PUMAs to other information like county name, town name, etc. </p>

<p>This selection of columns was specific to what I wanted to look at. There may be additional columns or fewer columns that you want to include. If you choose to include all the columns from the PUMS file, it this will take even longer to run and will be very slow when you open it in Excel later. The essential columns you must include are <code>SERIALNO</code> and <code>ADJINC</code> if you pull in any monetary info like I did, with <code>PINCP</code>.</p>

<p>You can find a detailed list of the fields in the <a href="https://www2.census.gov/programs-surveys/acs/tech_docs/pums/data_dict/PUMS_Data_Dictionary_2015-2019.pdf">PUMS metadata for 2019</a> and the <a href="https://www2.census.gov/programs-surveys/acs/tech_docs/pums/data_dict/PUMSDataDict05_09.pdf">metadata for 2009</a>.</p>

<div><pre><code class="language-sql">CREATE TABLE MTCHST_2019 AS
    SELECT ST_2019StateName.SERIALNO, ST_2019StateName.PINCP, ST_2019StateName.HISP, ST_2019StateName.RAC1P, ST_2019AStateName.PUMA, ST_2019StateName.AGEP, ST_2019StateName.COW, ST_2019StateName.JWMNP, ST_2019StateName.JWTRNS, ST_2019StateName.PAP, ST_2019StateName.SEX, ST_2019StateName.ST, ST_2019StateName.ADJINC,
        smPUMAs_2010.county, smPUMAs_2010.state, smPUMAs_2010.puma12, smPUMAs_2010.stab, smPUMAs_2010.cntyname, smPUMAs_2010.placenm
    FROM ST_2019StateName
    LEFT JOIN smPUMAs_2010 ON ST_2019StateName.PUMA = smPUMAs_2010.puma12 AND ST_2019StateName.ST = smPUMAs_2010.state;</code></pre></div></li>
<li><p>Filter out any records in the new table that don&#39;t have a match. This is likely to not change much if anything at all, but will ensure you have the smallest file you can achieve before exporting.</p>

<div><pre><code class="language-sql">CREATE TABLE CT_2019StateName AS
    SELECT * From MTCHST_2019 
    WHERE placenm like &quot;%cityname%&quot;;</code></pre></div></li>
<li><p>Export <code>CT_2019StateName</code> as a .csv file.</p></li>
</ol>

<h3 id="toc_9">Prepare PUMS data in Excel</h3>

<ol>
<li>Open <code>CT_2019StateName.csv</code> in Excel and save it as <code>Analysis_2019StateName.xlsx</code>.</li>
<li>Format the data as a table.</li>
<li>Go to the <code>Data</code> tab and click the button to remove duplicates. Don&#39;t uncheck anything here -- we only want to remove completely duplicated records.</li>
<li>Add three new columns to the beginning of the sheet but after <code>SERIALNO</code>. Name them <code>Above200k</code>, <code>HispYN</code>, and <code>ADJINFL</code>. </li>
<li><p>In <code>ADJINFL</code>, select the first empty cell and type in the formula</p>

<div><pre><code class="language-none">=([@ADJINC]/1000000)*[@PINCP]</code></pre></div>

<p>This adjusts the income for inflation to 2019 dollars.</p>

<p>If you&#39;re working in a file from before 2019, then you&#39;ll want to adjust that result to 2019. <a href="https://www.census.gov/topics/income-poverty/income/guidance/current-vs-constant-dollars.html">Here is a website you can use to figure out which values you need for inflation adjustments.</a>. The formula you&#39;d use in this case, would look something like:</p>

<div><pre><code class="language-none">=(([@ADJINC]/1000000)*[@PINCP])*{2019 CPI-U-RS} / {2009 CPI-U-RS}</code></pre></div>

<p>What this formula does is first unifies everything in the PUMS file to adjust for inflation to whatever year that data set represents (like 2009). Then, it adjusts for inflation to the year you really want (in this case, 2019).</p>

<p>Once you hit enter, the formula will autofill the whole column for the table.</p></li>
<li><p>In <code>Above200k</code> insert a formula to determine whether the person&#39;s income (now adjusted for inflation) is above or below the bracket you decided on.<sup id="fnref2"><a href="#fn2" rel="footnote">2</a></sup> In this case, we had a single threshhold, which was $200,000.</p>

<div><pre><code class="language-none">=if([@ADJINFL]&gt;199999.99, &quot;Above&quot;, &quot;Below&quot;)</code></pre></div></li>
<li><p>The <code>HispYN</code> column is to identify whether a person is Hispanic or Latinx. This is an if-formula that converts the code in the <code>HISP</code> column into a plain-english way to identify whether that person is Hispanic/Latinx or not.<sup id="fnref3"><a href="#fn3" rel="footnote">3</a></sup> This formula was developed in reference to the PUMS data dictionaries.</p>

<div><pre><code class="language-none">=if([@HISP]=1, &quot;NotHisp&quot;, &quot;Hisp&quot;)</code></pre></div></li>
</ol>

<h3 id="toc_10">Analyze PUMS data in Excel</h3>

<p>The rest of this process will be to create PivotTables and then combine those results into a table that allows you to compare one place to another.</p>

<ol>
<li>Go to the <code>Insert</code> tab and click PivotTable. The field for what area you want to select will say &quot;Table 1&quot; -- this is the table you created earlier.</li>
<li>Click <code>OK</code> without changing anything else. This will send the PivotTable to a new sheet in your workbook.</li>
<li>Rename that sheet to <code>200k_RaceAll</code>.</li>
<li>Build out the table by dragging the following fields into different sections of the dialogue box.

<ul>
<li>Columns: <code>Above200k</code>, <code>RAC1P</code></li>
<li>Rows: <code>PUMA</code></li>
<li>Values: <code>PUMA</code>

<ul>
<li>Click the little i that appears next to this one and make sure it&#39;s calculating the <strong>count</strong> of the field, not sum. Then click the <code>Show data as</code> button and change the dropdown to choose <code>% of Row Total</code> then click OK.</li>
</ul></li>
</ul></li>
</ol>

<p>This creates a PivotTable that tells you the percent of people who make more than 200k in the whole geographic area, disaggregated by race. If you want to know the distribution within a specific race, move <code>RAC1P</code> from the Columns section into the Filters section, and then use the dropdown to choose the code that corresponds to the race you&#39;re interested in. (The codes are in the PUMs data dictionaries.)</p>

<p>For each new analysis you want to run on the PUMS data, create a new pivot table. In our case, we created PivotTables to look at All races, Black Only, White Only, Asian Only, both Hispanic and not Hispanic, and Hispanic Only. </p>

<h3 id="toc_11">Combining analyses for comparison</h3>

<p>This last portion of combining analysis for comparison is done in a whole new sheet. In this case, I used Google Sheets to share with colleagues, but this can also be done in Excel. For simplicity, formulas are still in Excel syntax.</p>

<ol>
<li>Create a tab for each PivotTable you created in your analysis files.</li>
<li>Copy those tables into this new workbook and clean them so that the tables are unified.

<ul>
<li>If you&#39;re combining data from multiple states, you&#39;ll need to create a column that indicates which state each PUMA is in. The same applies if you&#39;re comparing data from different years.</li>
</ul></li>
<li>Format them as tables, and name those tables to match the tab name to help you easily identify all your tables.</li>
</ol>

<h3 id="toc_12">Removing unnecessary PUMAs</h3>

<p>This is a double-chck step to weed out any PUMAs that you captured with your code but don&#39;t actually want to include. </p>

<p>Some of these steps can be skipped/would be done just as quickly by hand if you&#39;re working with only a couple of states.</p>

<ol>
<li><p>Import the PUMA name reference file into a new sheet in the workbook that has all your combined data. Name that tab something like <code>PUMA_Reference2010</code></p>

<p>If you&#39;re working with PUMAs from 2000, then you&#39;ll need to clean through the MCDC file you created and remove duplicates. Make sure the PUMA name you&#39;re preserving when removing duplicates is the name you will recognize.</p>

<p>The Census does not have a 2000 PUMA name reference file.</p></li>
<li><p>Copy a list of state names and codes into some blank space in the PUMA reference file. <a href="https://www.nrcs.usda.gov/wps/portal/nrcs/detail/?cid=nrcs143_013696">This USDA table contains the codes you&#39;ll need.</a> <strong>Move the FIPS column to be first.</strong> Highlight the names and codes and format them as a table, and change the name to StateCodes</p></li>
<li><p>Highlight the PUMAs data and also format it as a table, naming it <code>PUMA_Ref</code>.</p></li>
<li><p>Add a column to <code>PUMA_Ref</code> and name it <code>StateLookup</code>. In the first empty cell, <a href="https://exceljet.net/excel-functions/excel-vlookup-function">create a VLOOKUP formula</a> that will pull in the state name based on the state code of each PUMA.</p>

<div><pre><code class="language-none">=VLOOKUP([@state], StateCode[#All], 2, FALSE)</code></pre></div></li>
<li><p>Now make a column that concatenates the state name and the PUMA code to create a unique ID, and call the column <code>PUMA_Code</code>. Make this the first column in the <code>PUMA_Ref</code> table. (<code>Home</code> &gt; <code>Insert</code> &gt; <code>Insert table columns to the left</code>)</p>

<div><pre><code class="language-none">=Concatenate([@StateLookup], &quot; &quot;, [@puma12])</code></pre></div></li>
<li><p>Now create a new column in your combined data and use the concatenate formula to make an identical <code>PUMA_Code</code> column. This formula will look like</p>

<div><pre><code class="language-none">=CONCATENATE([@State], &quot; &quot;, [@PUMA])</code></pre></div></li>
<li><p>Add another column and call it <code>PUMA_Name</code>. Use a VLOOKUP to pull in the recognizable name of the PUMA. You can adjust the column index number to pull in other information like the County name.</p>

<div><pre><code class="language-none">=VLOOKUP([@[PUMA_Code]], PUMA_Ref[#All], 11, FALSE)</code></pre></div></li>
<li><p>Go thrhough the names of all the PUMAs to confirm that you&#39;re only looking at the ones you want to. Repeat this for each combined comparison table you&#39;ve created.</p></li>
</ol>

<h3 id="toc_13">Connecting Census data to make estimates</h3>

<p>If you want to be able to turn a percent of a population into an estimation of how many people that actually is, you&#39;ll need to download and link Census data to your combined comparison tables.</p>

<blockquote>
<h4 id="toc_14">Some notes on comparing Census data</h4>

<ul>
<li>You&#39;ll want to use the ACS from whichever year you&#39;re looking at and the estimate that matches the PUMS data you downloaded. For example, if you use the 1-year PUMS, then use the 1-year ACS data.</li>
<li>The previous steps to confirm you have exactly the PUMAs you want will be very important here, because it will reduce how many PUMAs you have to manually look up in the Data Explorer.</li>
<li>If you&#39;re using PUMS data in a 5-year estimate that includes both 2010 and 2000 PUMAs, just don&#39;t. It&#39;s really funky and difficult to accurately match them to the right PUMAs and Census data. Instead, switch over to 1-year estimates. </li>
</ul>
</blockquote>

<ol>
<li>Go to the Census data explorer and find the table you want to use. If you&#39;re looking for age, sex, race, and ethnicity data, just search for <code>DP05</code>. </li>
<li>Once you&#39;ve pulled up the table editor, click on geographies and scroll down until you see PUMAs.</li>
<li>Choose that option and then in each new panel, further narrow down to the PUMAs you want. You can select from multiple states at once. </li>
<li>Download the resulting table as a .csv file</li>
<li>Import the census table into your workbook with the combined comparisons. Format it as a table. Open up the other .csv you got in the download in a new workbook -- this will be helpful for figuring out which columns you want to reference. </li>
<li>Add a VLOOKUP formula that pulls in the census data for the specific groups of people you want to make estimates for. This can only work when your table is focused on a specific group of people (like Black Only).<sup id="fnref4"><a href="#fn4" rel="footnote">4</a></sup> For 2019 PUMAs, use <code>PUMA_Name</code> as your lookup. For 2009, you&#39;ll need to make a new ID that matches the Census file with a CONCATENATE formula. There are a couple of ways you can complete the VLOOKUP formula:

<ul>
<li>Upload the whole Census data file and use the column reference file to figure out which index number you should use in your column reference.</li>
<li>Narrow down the Census data file to just the columns you want to use before uploading, making it far easier to figure out the index number you need for column reference.</li>
</ul></li>
</ol>

<h3 id="toc_15">Comparing results and estimates</h3>

<p>The final step is to make yet another PivotTable, this time using the PUMA names as your rows, or the other geography level that you&#39;re examining. You may want to make and manually fill out a <code>Target City</code> column in your comparison tables to achieve prettier labels than the PUMA names.</p>

<p>If you&#39;re combining multiple PUMAs into a city like I did, you&#39;ll need to treat the percentages and estimated numbers differently. For percentage, I determined median to be the most stable process to unify them. For figures, totaling them was most appropriate.</p>

<p>Once you&#39;ve completed the analysis you want, the final step, would be to visualize the data. Below you can see an example visualization from my analysis.</p>

<iframe src='https://flo.uri.sh/visualisation/6196019/embed' title='Interactive or visual content' frameborder='0' scrolling='no' style='width:100%;height:600px;' sandbox='allow-same-origin allow-forms allow-scripts allow-downloads allow-popups allow-popups-to-escape-sandbox allow-top-navigation-by-user-activation'></iframe>

<div class="footnotes">
<hr>
<ol>

<li id="fn1">
<p>In an ideal world, this would be a 5-year estimate because it&#39;s not as accurate to compare a 5-year estimate to a 1-year estimate. However, the 5-year estimates did not allow me to select PUMAs. I made the decision to chane to the 1-year estimate, because to make  all estimates uniform, I would have needed to change all my other PUMS, PUMA, and Census data sources to 1-year estimates, which are ultimately less accurate. I decided that I would rather have one, slightly less accurate data source that wasn&#39;t a perfect match than all my data sources be the less accurate options available.&nbsp;<a href="#fnref1" rev="footnote">&#8617;</a></p>
</li>

<li id="fn2">
<p>We decided on $200,000 because our very first question wasn&#39;t of income, but wealth. After researching and understanding how subjective a term &quot;wealth&quot; is, we instead shifted to $200,000 income indicator for several reasons. First, income is a much more easily understood term for readers to think about, and there&#39;s less table-setting required to make sure people are thinking of the same thing when we talk about &quot;income.&quot; Second, we decided that $200,000 waas an appropriate amount because it is a relatively high income in cities, where cost of living can make high salaries just enough to get by.&nbsp;<a href="#fnref2" rev="footnote">&#8617;</a></p>
</li>

<li id="fn3">
<p>When  analyzing the race of individuals, we felt it important to also understand the same for people with Hispanic or Latinx ethnicities. We understand that ethnicity is not the same as race. It is inappropriate to compare a race to ethnicity, as people can be a combination of race and ethnicity, creating overlap. As a result, our article and visualizations separate the two so that visual overlap is minimized.&nbsp;<a href="#fnref3" rev="footnote">&#8617;</a></p>
</li>

<li id="fn4">
<p>When calculating the estimated number of people within a race, you can only use the ACS columns that are BlackONLY or WhiteONLY, because the PUMS data does not get more specific. <strong>This is a large gap within our analysis.</strong> &nbsp;<a href="#fnref4" rev="footnote">&#8617;</a></p>
</li>

</ol>
</div>
