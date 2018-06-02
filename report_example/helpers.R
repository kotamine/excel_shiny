
load("data/shape_states.RData")
load("data/df_shape_counties.RData")

cnty <- map_data("county") # using ggplot2
states <- map_data("state") # using ggplot2

# exclude alaska, hawaii, puerto rico,
all_stfips <- shape_states$FIPS 
all_regions <- states$region %>% unique()

keep_lower_states <- all_stfips[!(all_stfips %in% c("02","15","72"))]
keep_lower_resions <- all_regions[!(all_regions %in% c(""))]

states <- subset(states, region %in% keep_lower_resions)
df_shape_counties <- subset(df_shape_counties, STATEFP %in% keep_lower_states)


# county population data 
# http://www.nber.org/data/census-intercensal-county-population-age-sex-race-hispanic.html
load("data/county_pop.RData")

# take 2015 
county_pop2015 <- county_pop %>% filter(year==2015) %>%
  dplyr::mutate(
    FIPS = county,
    white = (nhwa_male + nhwa_female)/tot_pop,
    black = (nhba_male + nhba_female)/tot_pop,
    hispanic = (h_male + h_female)/tot_pop,
    asian = (nhaa_male + nhaa_female)/tot_pop,
    native = (nhia_male + nhia_female)/tot_pop,
    age_gr = recode_factor(agegrp, 
                           '0'='Total', '1'='0-4','2'='5-9',
                           '3'='10-14', '4'='15-19', '5'='20-24',
                           '6'='25-29', '7'='30-34', '8'='35-39',
                           '9'='40-44', '10' ='45-49', '11'='50-54', '12'='55-59',
                           '13'='60-64', '14'='66-69', '15'='70-74', '16'='75-79',
                           '17'='80-84', '18'='85+')
  ) %>%
  dplyr::select(stname, ctyname, FIPS, white, black, hispanic, asian, native,  age_gr)

# take "total" age group  
county_pop2015 <- county_pop2015 %>% 
  filter(age_gr=="Total") %>%
  dplyr::mutate(
    FIPS = FIPS %>% as.character(),
    FIPS = ifelse(nchar(FIPS)==4,
                  paste0("0", FIPS), FIPS)
  )


my_percent_map <- function(var, color, legend.title, min = 0, max = 100) {
  inc <- (max - min) / 4
  legend.cut <- c(max(1,min), min + inc, min + 2 * inc, min + 3 * inc) %>% round()
  legend.cut2 <- legend.cut
  legend.cut2[1] <- max(legend.cut2[1], 5)
  
  legend.text <- c(paste0(legend.cut[1], " % or less"),
                   paste0(legend.cut[2], " %"),
                   paste0(legend.cut[3], " %"),
                   paste0(legend.cut[4], " % or more")) 
  
  shades <- colorRampPalette(c("white", color))(100)
  
  df <- county_pop2015 
  
  df$var <- df[[var]] 
  
  df <- df %>% filter(var>=min/100, var<=max/100) %>%
    dplyr::mutate( 
      percents = as.integer(cut(var, 100, 
                                include.lowest = TRUE, ordered = TRUE)),
      fills =  shades[percents],
      bins = legend.text[ceiling(percents/inc)]
    )
  
  shades_fill <- rev(shades[shades %in% df$fills])
  
  df %>% filter(!is.na(fills)) %>%
    ggplot() +  
    geom_polygon(data =  cnty,
                 mapping = aes(x = long, y = lat, group = group),
                 colour ="gray75", size=.1, fill = NA) +
    geom_map(aes(map_id = FIPS, fill = fills), show.legend =T,
             map = subset(df_shape_counties, STATEFP %in% keep_lower_states)) +
    geom_point(aes(color=bins), x=-90, y=37, show.legend =T, size=0) +
    geom_polygon(data = states,
                 mapping = aes(x = long, y = lat, group = group),
                 colour ="white", size=.2, fill = NA) +
    coord_quickmap() +
    labs(y = NULL, x = NULL) +
    scale_fill_manual(values =  shades_fill) +
    scale_color_manual(values = shades[legend.cut2],
                       name=legend.title) +
    theme_void()  + 
    theme(legend.position="bottom") +
    guides( fill = "none", 
           color = guide_legend(override.aes = list(shape = 15, size=5)))
} 

