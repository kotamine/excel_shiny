
# This is not a part of the app

# setwd("/Users/kota/Documents/shiny/AutomaticCalfFeeder")
setwd("/Users/kota/Documents/apps/AutomaticCalfFeeder")

library(xlsx)
library(dplyr)
library(tidyr)
library(broom)
library(ggplot2)

# mortgage payment function 
pmt <- function(rate, nper, pv, fv=0, type=0) {
  rr <- 1/(1+rate)^nper
  res <- (-pv-fv*rr)*rate/(1-rr)
  return(res/(1+rate*type))
}


survey_data <- read.xlsx("survey.xlsx", sheetIndex = 1, startRow=2, stringsAsFactors =FALSE) 
question_key <- read.xlsx("survey.xlsx", sheetIndex = 2, stringsAsFactors =FALSE)  


head(survey_data)
head(question_key)

# Drop non-question columns 
survey_data <- survey_data %>% select(- starts_with("NA."))

# Drop non-data raw
survey_data <- survey_data %>% filter(!(farm_id=="" | is.na(farm_id))) 
question_key <- question_key %>% filter(!(variable=="" | is.na(variable))) 



for (v in c("farm_id", "num_feeders", "change")) {
  survey_data[[v]]  %>% table() %>% print()
}

# Adjust num_feeders and change variables 
survey_data <- survey_data %>%
  mutate(
    planned_obs = grepl("long term", farm_id), 
    num_feeders = as.numeric(num_feeders), 
    change = recode(change, 
                    "n"="new barn",
                    "n "="new barn",
                    "r"="remodelled",
                    "o"="other")
  )

for (v in c("num_feeders", "change")) {
  survey_data[[v]]  %>% table() %>% print()
}

# Create a variable for experiencce with the feeder in months 
survey_data <- survey_data %>%
  mutate(  # months by the beginning of 2014  
    exper_days = as.Date("2014-01-01", format = "%Y-%m-%d") - 
      as.Date(paste0(using_since_year,"-",using_since_mon,"-01"), format = "%Y-%m-%d"),
    exper_mons = (as.numeric(exper_days)/30) %>% round()
  )


# Create per head operating cost variables: assuming 60 days per turn and 6 turns   
survey_data <- survey_data %>%
  mutate(
    num_calves = calves_total / num_feeders, 
    feed_hd =  ifelse(is.na(feed_day_hd), NA, 
                      feed_day_hd * 60),
    fuel_hd =  ifelse(is.na(fuel_yr), NA, 
                      fuel_yr / ( num_calves * 6)),
    utilities_hd =  ifelse(is.na(utilities_yr), NA, 
                           utilities_yr / ( num_calves * 6)),
    bedding_hd =  ifelse(is.na(bedding_day_hd), NA, 
                         bedding_day_hd * 60),
    building_lease_hd = ifelse(is.na(building_lease_yr), NA, 
                               building_lease_yr / ( num_calves * 6)),
    farm_insurance_hd = ifelse(is.na(farm_insurance_yr), NA, 
                               farm_insurance_yr / ( num_calves * 6)),
    misc_hd = ifelse(is.na(misc_yr), NA, 
                     misc_yr / ( num_calves * 6))
    )


# Create summary variables 
survey_data <- survey_data %>%
  mutate(
   # group_turns = 365 / days_on_feeder_clean,
    group_turns = 365 / (days_on_feeder + 5),
    calves_yr = calves_total * group_turns,
    feeder_cost = feeder_cost_total/ num_feeders,
    cost_investment = feeder_cost_total + building_cost,
    # capital_cost = -pmt(0.05, life_feeder, cost_investment),  # interest rate 5%
    capital_cost = -pmt(0.05, 20, cost_investment),  # interest 5%, 20 years of lifespan 
    capital_cost_calf = capital_cost / calves_yr, 
    repair_calf =  (repair_cost_feeder * num_feeders + repair_cost_building ) / calves_yr,
    labor_total = (labor_feeder * 365 + labor_repairs ) * wage, 
    labor_calf = labor_total / calves_yr,
    operating_calf = feed_hd + vet_hd + supplies_hd + fuel_hd + utilities_hd +
      + bedding_hd + building_lease_hd + farm_insurance_hd + misc_hd,
    cost_calf = capital_cost_calf + repair_calf + labor_calf + operating_calf + value_calf_in,
    net_return_calf = value_calf_out - cost_calf
  )

# Create groups 
survey_data <- survey_data %>% 
  mutate(
    calves_gr = ifelse(calves_total <= 30, "1-30", 
                       ifelse(calves_total <= 60, "31-60",
                              ifelse(calves_total <= 90, "61-90", "91+"))
                       ) %>% ordered(levels = c("1-30", "31-60", "61-90", "91+")),
    mortality_gr = ifelse(is.na(mortality), NA, 
                          ifelse(mortality <= 0.02, "< 2.0 %",
                                 ifelse(mortality <= 0.03, "2.1 - 3.0 %",
                                        ifelse(mortality <= 0.04, "3.1 - 4.0 %",
                                               ifelse(mortality <= 0.05, "4.1 - 5.0 %", "> 5.0 %"))))
                          ) %>% ordered(levels = c("< 2.0 %", "2.1 - 3.0 %", "3.1 - 4.0 %","4.1 - 5.0 %", "> 5.0 %"))
  )


survey_current  <- survey_data %>% filter(planned_obs==FALSE) 
survey_planned <- survey_data %>% filter(planned_obs==TRUE) 

for (v in c("capital_cost_calf", "repair_calf", "labor_calf", 
            "operating_calf", "value_calf_in", "cost_calf", 
            "value_calf_out", "net_return_calf")) {
  tmp <- survey_current[[v]] %>% summary()
  cat(paste(v, "\n")); print(tmp) 
}

survey_current$building_lease_hd %>% summary()
survey_current$misc_hd %>% summary()

save(survey_data, survey_current, survey_planned, question_key, file = "survey_data.RData")


# --------- examples of plots -----------


survey_current %>%
  ggplot(aes(x = value_calf_in, y = value_calf_out)) +
  geom_point() +
  geom_smooth(method="lm")

survey_current %>%
  filter(capital_cost_calf < 100) %>%
  ggplot(aes(x = capital_cost_calf, y = value_calf_out)) +
  geom_point() 

survey_current %>%
  ggplot(aes(x = labor_calf, y = value_calf_out )) +
  geom_point() 

survey_current %>%
  ggplot(aes(x = repair_calf, y = value_calf_out )) +
  geom_point() 

survey_current %>%
  ggplot(aes(x = feed_hd, y = value_calf_out)) +
  geom_point() 

survey_current %>%
  ggplot(aes(x = exper_mons, y = value_calf_out)) +
  geom_point()




survey_current %>%
  ggplot(aes(x = exper_mons, y = mortality)) +
  geom_point() 


survey_current %>%
  ggplot(aes(x = num_calves, y = mortality)) +
  geom_point() 


survey_current %>%
  filter(capital_cost_calf < 100) %>%
  ggplot(aes(x = capital_cost_calf, y = mortality)) +
  geom_point() 


survey_current %>%
  ggplot(aes(x = feed_hd, y = mortality)) +
  geom_point() 


survey_current %>%
  filter(bedding_hd < 50) %>%
  ggplot(aes(x = bedding_hd, y = mortality)) +
  geom_point() 

survey_current %>%
  ggplot(aes(x = repair_calf, y = mortality)) +
  geom_point() 

survey_current %>%
  ggplot(aes(x = labor_calf, y = mortality)) +
  geom_point() 



survey_current %>%
  filter(capital_cost_calf < 100) %>%
  ggplot(aes(x = labor_calf, y = capital_cost_calf)) +
  geom_point(aes(color = exper_mons))

survey_current %>%
  filter(capital_cost_calf < 100) %>%
  ggplot(aes(x = labor_calf, y = capital_cost_calf)) +
  geom_point(aes(color = calves_gr))

survey_current %>%
  filter(capital_cost_calf < 100) %>%
  ggplot(aes(x = labor_calf, y = capital_cost_calf)) +
  geom_point(aes(color = mortality_gr))

survey_current %>%
  filter(capital_cost_calf < 100) %>%
  ggplot(aes(x = labor_calf, y = capital_cost_calf)) +
  geom_point(aes(color = labor_calf))



survey_current %>%
  filter(capital_cost_calf < 100) %>%
  ggplot(aes(x = capital_cost_calf, y = value_calf_out - value_calf_in)) +
  geom_point() 

survey_current %>%
  ggplot(aes(x = labor_calf, y = value_calf_out - value_calf_in)) +
  geom_point() 

survey_current %>%
  ggplot(aes(x = repair_calf, y = value_calf_out - value_calf_in)) +
  geom_point() 

survey_current %>%
  ggplot(aes(x = feed_hd, y = value_calf_out - value_calf_in)) +
  geom_point() 

survey_current %>%
  ggplot(aes(x = exper_mons, y = value_calf_out - value_calf_in)) +
  geom_point()



survey_current %>%
  ggplot(aes(x = exper_mons, y = value_calf_out - value_calf_in,
             color = calves_gr)) +
  geom_point() 

survey_current %>%
  ggplot(aes(x = exper_mons, y = value_calf_out - value_calf_in,
             color = mortality_gr)) +
  geom_point() 




survey_current %>%
  ggplot(aes(x = feed_day_hd, y = value_calf_out)) +
  geom_point() +
  geom_smooth(method="lm")

survey_current %>% 
  filter(bedding_hd < 50) %>%
  ggplot(aes(x = bedding_hd, y = value_calf_out)) +
  geom_point() +
  geom_smooth(method="lm")

survey_current %>%  
  filter(capital_cost_calf < 100) %>%
  ggplot(aes(x = capital_cost_calf, y = value_calf_out)) +
  geom_point() +
  geom_smooth(method="lm")






survey_current %>%
  filter(bedding_hd < 50) %>%
  ggplot(aes(x = exper_mons, y = labor_calf)) +
  geom_point() +
  geom_smooth(method="lm")


survey_current %>%
  ggplot(aes(x = exper_mons, y = labor_calf)) +
  geom_point() +
  geom_smooth(method="lm")

survey_current %>%
  ggplot(aes(x = exper_mons, y = repair_calf)) +
  geom_point() +
  geom_smooth(method="lm")


survey_current %>%
  ggplot(aes(x = wage, y = labor_calf)) +
  geom_point() +
  geom_smooth(method="lm")


survey_current %>%
  ggplot(aes(x = utilities_hd, y = mortality)) +
  geom_point(aes(color = exper_mons)) 


survey_current %>%
  ggplot(aes(x = feed_hd, y = capital_cost_calf + repair_calf + labor_calf)) +
  geom_point(aes(color = mortality)) 


survey_current %>%
  filter(capital_cost_calf < 100) %>%
  ggplot(aes(x = labor_calf, y = capital_cost_calf)) +
  geom_point(aes(color = mortality)) 

survey_current %>%
  filter(capital_cost_calf < 100) %>%
  ggplot(aes(x = labor_calf, y = capital_cost_calf)) +
  geom_point(aes(color = exper_mons))  

survey_current %>%
  filter(capital_cost_calf < 100) %>%
  ggplot(aes(x = labor_calf, y = capital_cost_calf)) +
  geom_point(aes(color = feed_hd))

survey_current %>%
  ggplot(aes(x = feed_hd, y = labor_feeder)) +
  geom_point(aes(color = mortality)) 



survey_current %>%
  ggplot(aes(x = value_calf_out, y = capital_cost_calf )) +
  geom_point(aes(color = mortality)) 

survey_current %>%
  ggplot(aes(x = value_calf_out, y = days_on_feeder)) +
  geom_point(aes(color = mortality)) 

survey_current %>%
  ggplot(aes(x = value_calf_out, y = calves_total)) +
  geom_point(aes(color = mortality)) 


survey_current %>%
  ggplot(aes(x = value_calf_out, y = labor_feeder)) +
  geom_point(aes(color = mortality)) 


survey_current %>%
  with(
    lm(mortality ~ num_calves + exper_mons + capital_cost_calf + feed_hd + bedding_hd) %>% summary()
  )

survey_current %>%
  with(
    lm(mortality ~ num_calves + exper_mons + capital_cost_calf ) %>% summary()
  )
