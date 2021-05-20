-- [1] Look up PUMA number for the place you want.
	CREATE TABLE smPUMAs_2010 SELECT * From PUMAs_2010 WHERE placenm like "%cityname%";
	
	
-- [2] Narrow down State to only rows with PUMAs that you want.
	CREATE TABLE ST_2019StateName AS
		SELECT * From StateName2019 WHERE	
		-- List out the pumas you found in step [1], and format them like this:
		PUMA = 112 OR
		PUMA = 126 OR
		PUMA = 128 OR
		PUMA = 129 OR
		PUMA = 110 OR
		PUMA = 112 OR
		PUMA = 113 OR
		PUMA = 114 OR
		PUMA = 115 OR
		PUMA = 116 OR
		PUMA = 117 OR
		PUMA = 118 OR
		PUMA = 119 OR
		PUMA = 120 OR
		PUMA = 121 OR
		PUMA = 122 OR
		PUMA = 123 OR
		PUMA = 125 OR
		PUMA = 128 OR
		PUMA = 129 OR
		PUMA = 133 OR
		PUMA = 3413;

-- [3] Match to PUMAs_2010. This is going to take some time to complete, so before you run it, SAVE YOUR DATABASE. That way, in case it gets funky, you won't lose any work. 
	CREATE TABLE MTCHST_2010 AS
		SELECT ST_2019StateName.SERIALNO, ST_2019StateName.PINCP, ST_2019StateName.HISP, ST_2019StateName.RAC1P, ST_2019AStateName.PUMA, ST_2019StateName.AGEP, ST_2019StateName.COW, ST_2019StateName.JWMNP, ST_2019StateName.JWTRNS, ST_2019StateName.PAP, ST_2019StateName.SEX, ST_2019StateName.ST, ST_2019StateName.ADJINC,
			smPUMAs_2010.county, smPUMAs_2010.state, smPUMAs_2010.puma12, smPUMAs_2010.stab, smPUMAs_2010.cntyname, smPUMAs_2010.placenm
		FROM ST_2019StateName
		LEFT JOIN smPUMAs_2010 ON ST_2019StateName.PUMA = smPUMAs_2010.puma12 AND ST_2019StateName.ST = smPUMAs_2010.state;		
		
-- [4] Filter out empty matches
	CREATE TABLE CT_2019Arizona AS
		SELECT * From MTCHST_2010 
		WHERE placenm like "%cityname%";
