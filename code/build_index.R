build_index <- function(path=getwd(), type=NULL, incl=FALSE, abbr=NULL){
  
  if(!is.null(type)){
    files <- list.files(path, pattern = paste("[.]", type, "$", sep=""))
  } else{
    files <- list.files(path)
  }
  df <- NULL
  pb <- txtProgressBar(min = 0, max = length(files), style = 3, char=">", width=getOption("width")-14)
  
  for(i in 1:length(files)){
    
    if(incl){
      x <- c(files[i], eval(parse(text=abbr)))
    } else{
      x <- c(substr(files[i], 1, nchar(files[i])-4), eval(parse(text=abbr)))
    }
    df <- rbind(df, x)
    
    setTxtProgressBar(pb, i)
  }
  close(pb)
  
  rownames(df) <- c(1:length(files))
  colnames(df) <- c("original", "code")
  df <- as.data.frame(df)
  df$original <- as.character(df$original)
  df$code <- as.character(df$code)
  
  return(df)
}
