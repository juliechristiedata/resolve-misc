	-- Match to PUMAs_2000
	CREATE TABLE MTCHST_2000 AS
		SELECT ST_2010Arizona.SERIALNO, ST_2010Arizona.PINCP, ST_2010Arizona.HISP, ST_2010Arizona.RAC1P, ST_2010Arizona.PUMA, ST_2010Arizona.AGEP, ST_2010Arizona.COW, ST_2010Arizona.JWMNP, ST_2010Arizona.JWTR, ST_2010Arizona.PAP, ST_2010Arizona.SEX, ST_2010Arizona.ST, ST_2010Arizona.ADJINC,
					PUMAs_2000.county, PUMAs_2000.state, PUMAs_2000.puma5, PUMAs_2000.stab, PUMAs_2000.cntyname, PUMAs_2000.placenm
		FROM ST_2010Arizona
		LEFT JOIN PUMAs_2000 ON ST_2010Arizona.PUMA = PUMAs_2000.puma5 AND ST_2010Arizona.ST = PUMAs_2000.state;		
		
	-- Filter for cities
	CREATE TABLE CT_2010Arizona AS
		SELECT * From MTCHST_2000 
		WHERE placenm like "%phoenix%";