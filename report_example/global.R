library(maps)
library(mapproj)
library(sp)
library(rmarkdown)
library(knitr)
library(dplyr)
library(ggplot2)

get_time_epoch <- function() {
  return(as.integer(Sys.time()))
}

get_time_human <- function() {
  format(Sys.time(), "%Y-%m-%d-%H:%M:%OS")
}

source("helpers.R")
