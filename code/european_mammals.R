european_mammals <- function(path=getwd(), type=c("points", "polygon", "country", "identify"), data, 
                             buffer=NULL, soi=NULL, index_species=NULL, index_spatial=NULL, mask=NULL){
  
# type            chose which type the data have. The choice is between coordinates (points), one polygon (polygon), a
#                 set of countries (country) or some shape drawn on the current plot (identify).
# data            give here the respective data, as defined in 'type'.
#                   - 'points' should be a data-frame with two (3) columns named 'X/lon', 'Y/lat' and optinally 'SQ'
#                     with the respective names of the AFE-grid the coordinates are located in.
#                   - 'polygon' should be an already defined polygon or the path to a shapefile which can be read in via
#                     readShapePoly().
#                   - 'country' should be a set of country names. Can be abbreviated, see build_index().
#                   - 'identify' should be the number of clicks on the current graph. Must be at least 3.
#                 All spatial data should be loaded into the environment already, otherwise a warning will appear and
#                 only the already loaded data will be used.
# buffer          meters around which the data should be buffered. One grid of the AFE-grid has an extent of 50kmx50km.
# soi             name of species to get information for. Can be abbreviated but than and index should be built
#                 (build_index()) or the species should be defined and loaded into the environment with their
#                 abbreviated names. 
# species_ind     give index where abbreviations in 'soi' and their original names are given.
# spatial_ind     
# mask            give the names of species here, which should be excluded from any querry. Must be defined as full 
#                 species name as given by the original data.
  
  laea <- c("+proj=laea +lat_0=52 +lon_0=10 +x_0=4321000 +y_0=3210000 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs")
  wgs84 <- c("+proj=longlat +datum=WGS84 +no_defs")

  type <- match.arg(type, c("points", "polygon", "country", "identify"))
  
  if(type=="identify" & attr(dev.cur(), "name")=="null device"){
    stop("please plot some map from which you want to select an area first.")
  }
  if(type=="points" & !(any(colnames(points)=="X") | any(colnames(points)=="lon")) | !(any(colnames(points)=="Y") | any(colnames(points)=="lat"))){
    stop("please give a dataframe which has at least two columns names 'X or lon' and 'Y or lat'.")
  }
  
  occurences <- NULL
  check_data(data = soi, index = index_species, column = "original", mask = mask)
  
  # the_grid <- define polygon which can be used here.
  
  if(type=="points"){
    
    coordinates(data) <- ~X+Y
    crs(data) <- laea
    
      for(j in 1:dim(data)[1]){
        
        if(!is.null(buffer)){
          data_buffered <- gBuffer(data[j,], byid=FALSE, width = buffer, quadsegs = 5)
          square <- gIntersection(the_grid, data_buffered, byid = TRUE)
          square_names <- c(unlist(lapply(strsplit(names(square), " "), function(x) x[[1]])))
        } else{
          square <- gIntersection(the_grid, data, byid = TRUE)
          square_names <- c(unlist(lapply(strsplit(row.names(square), " "), function(x) x[[1]])))
        }
        
        for(k in 1:length(soi2)){
          species <- get(soi2[k])
          species$SQ <- as.character(species$SQ)
          species_sub <- species[species$SQ %in% square_names,]
          ds <- dim(species_sub)[1]
          occurences_temp <- cbind(point=rep(j, ds), species=rep(soi2[k], ds), species_sub)
          occurences <- rbind(occurences, occurences_temp)
        }
        
        occurences$SQ <- as.factor(occurences$SQ)
        
      }
    } else if(type="polygon"){
    
    if(!is.null(buffer)){
      data <- gBuffer(data, width = buffer, capStyle = "SQUARE", quadsegs = 1)
    }
  } else if(type="country"){
    
    check_data(data, index = index_spatial, column = "grid")
    # next: intersect country-data with species-data
    
    
  } else if(type="identify"){
    
    if(!is.null(buffer)){
      data <- gBuffer(data, width = buffer, capStyle = "SQUARE", quadsegs = 1)
    }
  }
  
  
  # built area of interest (aoi)
  
  # intersect soi with aoi and provide it.
  
  

  
  
}


