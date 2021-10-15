eco_regions = readOGR('/home/yinonbaron/git/alpha_2017/terr_eco_regions/tnc_terr_ecoregions.shp')

moll = '+proj=moll +lon_0=0 +x_0=0 +y_0=0 +datum=WGS84 +units=m +no_defs'
shapemoll <- spTransform(eco_regions, CRS(moll))

crops <- raster('/home/yinonbaron/git/alpha_2017/cropland.tif')
mollraster <- projectRaster(crops, crs=moll)
ex = extract(mollraster,shapemoll,fun=mean,na.rm=TRUE,df=TRUE)

shapemoll$cropland = ex$cropland*area(shapemoll)

pastures <- raster('/home/yinonbaron/git/alpha_2017/pasture.tif')

mollpastures <- projectRaster(pastures, crs=moll)
expastures = extract(mollpastures,shapemoll,fun=mean,na.rm=TRUE,df=TRUE)

shapemoll$pastures = expastures$pasture*area(shapemoll)
shapemoll$area = area(shapemoll)
export_data = data.frame(shapemoll$WWF_MHTNAM,shapemoll$area,shapemoll$cropland,shapemoll$pastures)

write.csv(export_data,'biome_area.csv')