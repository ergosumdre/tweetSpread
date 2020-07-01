# Tool to analysis number of tweets per minute. 

library(data.table)

args <- commandArgs(trailingOnly = FALSE) # Allows argument from SLURM job
fileName_var <- args[6] # Takes argument from SLURM job
fileLocation <- fileName_var # issues with using fileName_var... passing value to new var solves issue

timeSpread <- function(x){
  df <- fread(x,# Reads in only `created_at` column in table/tweet
              integer64 = "character",
              select = "created_at")
  df2 <- as.factor(substr(df$created_at, 12, 16)) # parse only hour and min from entire string
  return(data.frame(tweetsPerMinute = summary(df2))) # summary of df2 (gives number of tweets per min)
}

tweetSpread <- timeSpread(fileLocation) # do function
endLocation <- paste0("/shares_bgfs/si_twitter/covid19/tables/metadata/", # establish where to save csv
                      substr(fileLocation,46, 58), "_numOfTweets.csv")# grabs YYYY-MM-DD-HH from original fileLocation string
write.csv(x = tweetSpread,  file = endLocation) # writes csv to file location

print(paste0("Finished with: ",substr(fileLocation,46, 58))) # progess indicator -- Mainly for SLURM job output
rm(list=ls()) # Save memory
quit() 
