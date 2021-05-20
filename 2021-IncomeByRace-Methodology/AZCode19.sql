-- Look up PUMA number for cities
	SELECT * From PUMAs_2010 WHERE placenm like "%phoenix%";
	
	
-- Narrow down State to only city PUMAs
		CREATE table ST_2019Arizona AS
			SELECT * From STATE_Arizona WHERE	
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

-- Match to PUMAs_2010
	CREATE TABLE MTCHST_2010 AS
		SELECT ST_2019Arizona.SERIALNO, ST_2019Arizona.PINCP, ST_2019Arizona.HISP, ST_2019Arizona.RAC1P, ST_2019Arizona.PUMA, ST_2019Arizona.AGEP, ST_2019Arizona.COW, ST_2019Arizona.JWMNP, ST_2019Arizona.JWTRNS, ST_2019Arizona.PAP, ST_2019Arizona.SEX, ST_2019Arizona.ST, ST_2019Arizona.ADJINC,
					PUMAs_2010.county, PUMAs_2010.state, PUMAs_2010.puma12, PUMAs_2010.stab, PUMAs_2010.cntyname, PUMAs_2010.placenm
		FROM ST_2019Arizona
		LEFT JOIN PUMAs_2010 ON ST_2019Arizona.PUMA = PUMAs_2010.puma12 AND ST_2019Arizona.ST = PUMAs_2010.state;		
		
-- Filter out empty matches
	CREATE TABLE CT_2019Arizona AS
		SELECT * From MTCHST_2010 
		WHERE placenm like "%phoenix%";