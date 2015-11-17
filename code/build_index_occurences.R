build_index_occurences <- function(path=getwd(), sbst=NULL, elements=3){
  files <- list.files(path)
  df <- NULL
  pb <- txtProgressBar(min = 0, max = length(soi), style = 3, char=">", width=getOption("width")-14)
  
  for(i in 1:length(files)){
    
    x <- c(substr(files[i], 1, nchar(files[i])-4), tolower(paste(substr(unlist(strsplit(files[i], " ")), 1, elements), collapse = "_")))
    df <- rbind(df, x)
    
    setTxtProgressBar(pb, i)
  }
  close(pb)
  
  rownames(df) <- c(1:length(files))
  colnames(df) <- c("species", "short")
  df <- as.data.frame(df)
  df$species <- as.character(df$species)
  return(df)
}
