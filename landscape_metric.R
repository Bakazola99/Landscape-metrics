## Libraries
library(tidyverse)
library(raster)
library(sf)
#install.packages(c("landscapetools","landscapemetrics"))
library(landscapetools)
library(landscapemetrics)

## Loading the tiff file
NDBI <-raster("data/Classified_Image.tif")
plot(NDBI)

## To crop out unnecessary areas
Beijing_shp <- st_read("data/boundry.shp")
study_area<- Beijing_shp[4]
plot(study_area)

## To make the shapefile having the same CRS as the raster
study_area_tr <-st_transform(study_area, crs = crs(NDBI))
plot(study_area_tr)

### To mask the NDBI with Beijing shapefile
NDBI_1 <- mask(NDBI, study_area)
plot(NDBI_1)

## To check our classes
N <-show_landscape(NDBI_1, discrete = T)
plot(N)

## To check if the NDBI is in right format
check_landscape(NDBI_1)

## To get all the metrics necessary
print(list_lsm(), n=133)

n<-calculate_lsm(landscape = NDBI_1,
                 what = c("lsm_c_np", 
                          "lsm_c_pd",
                          "lsm_c_lsi",
                          "lsm_c_lpi",
                          "lsm_c_pland"),
                 full_name = TRUE)
n
write.table(n, "landscapemetrics.csv", sep = ",")

class_area<-calculate_lsm(landscape = NDBI_1,
                 what = c("lsm_c_area_mn"),
                 full_name = TRUE)
class_area
write.table(class_area, "landscapemetrics2.csv", sep = ",")

class_euclidean<-calculate_lsm(landscape = NDBI_1,
                          what = c("lsm_c_enn_mn"),
                          full_name = TRUE)
class_euclidean
write.table(class_euclidean, "landscapemetrics3.csv", sep = ",")