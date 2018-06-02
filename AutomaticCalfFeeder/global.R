

# setwd("/Users/kota/Documents/shiny/AutomaticCalfFeeder")

library(shiny)
library(shinyBS)
library(shinyjs)
# library(V8)
library(shinydashboard)
library(rmarkdown)
library(DT)
# library(googleVis)
library(mongolite)
library(httr)
# library(googleAuthR) 
# library(googleID)
library(rJava)
# library(wesanderson)
library(plotly)
library(RColorBrewer)
suppressPackageStartupMessages({
  library(dplyr)
  library(tidyr)
  library(broom)
  library(ggplot2)
  # library(ggvis)
# library(xlsx)
# XLConnect)
})

# # color of tabs in Data Entry etc.
# headercolor_rlt <- "background-color:#900021; color:#fff;"
# warningcolor <- "background-color:#E98524; color:#fff;"
# background_rlt <-"background-color:#FFF5E1;"

ems <- function(txt) em(strong(txt)) 
h3s <- function(txt) h3(strong(txt))
h4s <- function(txt) h4(strong(txt))
h5s <- function(txt) h5(strong(txt))

ldquo <- HTML("&ldquo;")
rdquo <- HTML("&rdquo;")
emquo <- function(txt) em(HTML(paste0("&ldquo;",txt,"&rdquo;"))) 

# get current Epoch time
get_time_epoch <- function() {
  return(as.integer(Sys.time()))
}

# get a formatted string of the timestamp (exclude colons as they are invalid
# characters in Windows filenames)
get_time_human <- function() {
  format(Sys.time(), "%Y-%m-%d-%H:%M:%OS")
}

# returns string w/o leading or trailing whitespace
trim_sp <- function (x) gsub("^\\s+|\\s+$", "", x)


# # -----------  define text variables ----------- 
# source(file.path("ui_files","ui_text_vars.R"), local=TRUE)


# ------------- Load the min/max/step setting values from excel file  --------------------
df_all  <- read.csv("www/variables.csv", stringsAsFactors =FALSE) 
df_all <- drop_na(df_all, variable)
row_idx <- df_all$variable!=""
df_vars <- df_all[row_idx,] 


df_all <- df_all %>% 
  mutate(
    by_user = ifelse(is.na(by_user), 0, by_user),
    input = ifelse(by_user==1, TRUE, FALSE),
    default_num = gsub("%", "", gsub(",","", gsub("\\$","",default))) %>% as.numeric(),
    default_txt = ifelse(input & is.na(default_num), default, NA),
    dollars = grepl("\\$",default)
  )

    

