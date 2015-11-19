load_spatial <- function(path=getwd(), sbst=NULL, load=NULL, index=NULL){
  # http://www.helsinki.fi/~rlampine/gmap/afegrid_kml.html
  # http://pakillo.github.io/R-GIS-tutorial/
  # http://www.luomus.fi/en/new-grid-system-atlas-florae-europaeae
  
  # path <- c("/home/steffen/Documents/git/European Mammals/data/")
  # setwd(path)
  # sbst <- c("France", "Estonia")
  
  
  # define projections
  laea <- c("+proj=laea +lat_0=52 +lon_0=10 +x_0=4321000 +y_0=3210000 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs")
  wgs84 <- c("+proj=longlat +datum=WGS84 +no_defs")
  
  shape <- list.files(paste(path, "/spatial/", sep=""), pattern="[.]shp$")
  grid <- list.files(paste(path, "/spatial/", sep=""), pattern="[.]kml$")
  if(!is.null(sbst)){
    if(!is.null(index)){
      shape <- index$shape[index$code %in% sbst]
      grid <- index$grid[index$code %in% sbst]
    } else{
      sbst_new <- c(paste(toupper(substr(sbst, 1, 1)), substr(sbst, 2, nchar(sbst)), sep=""), paste(tolower(substr(sbst, 1, 1)), substr(sbst, 2, nchar(sbst)), sep=""))
      sbst1 <- NULL; sbst2 <- NULL
      for(i in 1:length(sbst_new)){
        sbst1_temp <- grep(sbst_new[i], shape)
        sbst1 <- c(sbst1, sbst1_temp)
        sbst2_temp <- grep(sbst_new[i], grid)
        sbst2 <- c(sbst2, sbst2_temp)
      }
      shape <- shape[sbst1]
      grid <- grid[sbst2]
    }
  }
  
  
  # read in shapefiles for country delineation
  if(!is.null(load)){
    
    load <- match.arg(load, c("grids", "shapes", "both"))
    if(load=="both"){
      grids <- TRUE
      shapes <- TRUE
      j <- length(shape)
      max_pb <- length(shape) + length(grid)
      pb <- txtProgressBar(min = 0, max = max_pb, style = 3, char=">", width=getOption("width")-14)
    } else if(load=="grids"){
      grids <- TRUE
      shapes <- FALSE
      j <- 0
      max_pb <- length(grid)
      pb <- txtProgressBar(min = 0, max = max_pb, style = 3, char=">", width=getOption("width")-14)
    } else if(load=="shapes"){
      grids <- FALSE
      shapes <- TRUE
      j <- 0
      max_pb <- length(shape)
      pb <- txtProgressBar(min = 0, max = max_pb, style = 3, char=">", width=getOption("width")-14)
    }
    
    if(shapes){
      for(i in 1:length(shape)){
        x <- readOGR(paste(path, "/spatial/", shape[i], sep=""), substr(shape[i], 1, nchar(shape[i])-4), verbose=FALSE)
        names <- paste(unlist(strsplit(shape[i], '_'))[1:(length(unlist(strsplit(shape[i], '_')))-2)], collapse='_')
        assign(paste(names, "_shape", sep=""), x, envir = .GlobalEnv)
        
        setTxtProgressBar(pb, i)
      }
    }
    
    if(grids){
      for(i in 1:length(grid)){
        x <- readOGR(paste(path, "/spatial/", grid[i], sep=""), substr(grid[i], 1, nchar(grid[i])-4), verbose=FALSE)
        x <- spTransform(x, laea)
        names <- paste(paste(toupper(substr(unlist(strsplit(grid[i], '_'))[-1], 1, 1)), substr(unlist(strsplit(grid[i], '_'))[-1], 2, nchar(unlist(strsplit(grid[i], '_'))[-1])), sep=''), collapse='_')
        names <- substr(names, 1, nchar(names)-4)
        assign(paste(names, "_grid", sep=""), x, envir = .GlobalEnv)
        
        setTxtProgressBar(pb, j+i)
      }
    }
  }
  close(pb)
  
  # names_shape <- paste(lapply(strsplit(index$shape, "_"), function(x) x[[1]]), "_shape", sep="")
  # names_grid <- lapply(strsplit(index$grid, "_"), function(x) x[-1])
    # names <- paste(paste(toupper(substr(unlist(strsplit(grid, '_'))[-1], 1, 1)), substr(unlist(strsplit(grid[i], '_'))[-1], 2, nchar(unlist(strsplit(grid[i], '_'))[-1])), sep=''), collapse='_')
  
  # assign("index_spatial2", 
         # )
}