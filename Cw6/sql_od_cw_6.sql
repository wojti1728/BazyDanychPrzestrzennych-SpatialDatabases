
# Analiza

CREATE TABLE zelasko.intersects AS
SELECT a.rast, b.municipality
FROM rasters.dem AS a, vectors.porto_parishes AS b
WHERE ST_Intersects(a.rast, b.geom) AND b.municipality ilike 'porto';

alter table zelasko.intersects
add column rid SERIAL PRIMARY KEY;


CREATE INDEX idx_intersects_rast_gist ON zelasko.intersects
USING gist (ST_ConvexHull(rast));

-- schema::name table_name::name raster_column::name
SELECT AddRasterConstraints('zelasko'::name,
'intersects'::name,'rast'::name);


CREATE TABLE zelasko.clip AS
SELECT ST_Clip(a.rast, b.geom, true), b.municipality
FROM rasters.dem AS a, vectors.porto_parishes AS b
WHERE ST_Intersects(a.rast, b.geom) AND b.municipality like 'PORTO';

CREATE TABLE zelasko.union AS
SELECT ST_Union(ST_Clip(a.rast, b.geom, true))
FROM rasters.dem AS a, vectors.porto_parishes AS b
WHERE b.municipality ilike 'porto' and ST_Intersects(b.geom,a.rast);

CREATE TABLE zelasko.porto_parishes AS
WITH r AS (
SELECT rast FROM rasters.dem
LIMIT 1
)
SELECT ST_AsRaster(a.geom,r.rast,'8BUI',a.id,-32767) AS rast
FROM vectors.porto_parishes AS a, r
WHERE a.municipality ilike 'porto';

DROP TABLE zelasko.porto_parishes; --> drop table porto_parishes first
CREATE TABLE zelasko.porto_parishes AS
WITH r AS (
SELECT rast FROM rasters.dem
LIMIT 1
)
SELECT st_union(ST_AsRaster(a.geom,r.rast,'8BUI',a.id,-32767)) AS rast
FROM vectors.porto_parishes AS a, r
WHERE a.municipality ilike 'porto';


DROP TABLE zelasko.porto_parishes; --> drop table porto_parishes first
CREATE TABLE zelasko.porto_parishes AS
WITH r AS (
SELECT rast FROM rasters.dem
LIMIT 1 )
SELECT st_tile(st_union(ST_AsRaster(a.geom,r.rast,'8BUI',a.id,-
32767)),128,128,true,-32767) AS rast
FROM vectors.porto_parishes AS a, r
WHERE a.municipality ilike 'porto';

create table zelasko.intersection as
SELECT
a.rid,(ST_Intersection(b.geom,a.rast)).geom,(ST_Intersection(b.geom,a.rast)
).val
FROM rasters.landsat8 AS a, vectors.porto_parishes AS b
WHERE b.parish ilike 'paranhos' and ST_Intersects(b.geom,a.rast);

CREATE TABLE zelasko.dumppolygons AS
SELECT
a.rid,(ST_DumpAsPolygons(ST_Clip(a.rast,b.geom))).geom,(ST_DumpAsPolygons(ST_Clip(a.rast,b.geom))).val
FROM rasters.landsat8 AS a, vectors.porto_parishes AS b
WHERE b.parish ilike 'paranhos' and ST_Intersects(b.geom,a.rast);

CREATE TABLE zelasko.landsat_nir AS
SELECT rid, ST_Band(rast,4) AS rast
FROM rasters.landsat8;

CREATE TABLE zelasko.paranhos_dem AS
SELECT a.rid,ST_Clip(a.rast, b.geom,true) as rast
FROM rasters.dem AS a, vectors.porto_parishes AS b
WHERE b.parish ilike 'paranhos' and ST_Intersects(b.geom,a.rast);

CREATE TABLE zelasko.paranhos_slope AS
SELECT a.rid,ST_Slope(a.rast,1,'32BF','PERCENTAGE') as rast
FROM zelasko.paranhos_dem AS a;


CREATE TABLE zelasko.paranhos_slope_reclass AS
SELECT a.rid,ST_Reclass(a.rast,1,']0-15]:1, (15-30]:2, (30-9999:3',
'32BF',0)
FROM zelasko.paranhos_slope AS a;


SELECT st_summarystats(ST_Union(a.rast))
FROM zelasko.paranhos_dem AS a;

WITH t AS (
SELECT st_summarystats(ST_Union(a.rast)) AS stats
FROM zelasko.paranhos_dem AS a
)
SELECT (stats).min,(stats).max,(stats).mean FROM t;

WITH t AS (
SELECT b.parish AS parish, st_summarystats(ST_Union(ST_Clip(a.rast,
b.geom,true))) AS stats
FROM rasters.dem AS a, vectors.porto_parishes AS b
WHERE b.municipality ilike 'porto' and ST_Intersects(b.geom,a.rast)
group by b.parish
)
SELECT parish,(stats).min,(stats).max,(stats).mean FROM t;


SELECT b.name,st_value(a.rast,(ST_Dump(b.geom)).geom)
FROM
rasters.dem a, vectors.places AS b
WHERE ST_Intersects(a.rast,b.geom)
ORDER BY b.name;

create table zelasko.tpi30 as
select ST_TPI(a.rast,1) as rast
from rasters.dem a;

CREATE INDEX idx_tpi30_rast_gist ON zelasko.tpi30
USING gist (ST_ConvexHull(rast));

SELECT AddRasterConstraints('zelasko'::name,
'tpi30'::name,'rast'::name);


create table zelasko.tpi30_porto as
with porto as 
(
select geom 
from vectors.porto_parishes
where municipality ilike 'porto'
)
select ST_TPI(a.rast,1) as rast
from rasters.dem a, porto p
where ST_Intersects(a.rast, p.geom)
