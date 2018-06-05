# 
# # county population data 
# # http://www.nber.org/data/census-intercensal-county-population-age-sex-race-hispanic.html
# load("data/county_pop.RData")
# 
# # take 2015 
# county_pop2015 <- county_pop %>% filter(year==2015) %>%
#   dplyr::mutate(
#     FIPS = county,
#     white = (nhwa_male + nhwa_female)/tot_pop,
#     black = (nhba_male + nhba_female)/tot_pop,
#     hispanic = (h_male + h_female)/tot_pop,
#     asian = (nhaa_male + nhaa_female)/tot_pop,
#     native = (nhia_male + nhia_female)/tot_pop,
#     age_gr = recode_factor(agegrp, 
#                            '0'='Total', '1'='0-4','2'='5-9',
#                            '3'='10-14', '4'='15-19', '5'='20-24',
#                            '6'='25-29', '7'='30-34', '8'='35-39',
#                            '9'='40-44', '10' ='45-49', '11'='50-54', '12'='55-59',
#                            '13'='60-64', '14'='66-69', '15'='70-74', '16'='75-79',
#                            '17'='80-84', '18'='85+')
#   ) %>%
#   dplyr::select(stname, ctyname, FIPS, white, black, hispanic, asian, native,  age_gr)
# 
# # take "total" age group  
# county_pop2015 <- county_pop2015 %>% 
#   filter(age_gr=="Total") %>%
#   dplyr::mutate(
#     FIPS = FIPS %>% as.character(),
#     FIPS = ifelse(nchar(FIPS)==4,
#                   paste0("0", FIPS), FIPS)
#   )
# 
# save(county_pop2015, file = "data/county_pop2015.RData")
# 
