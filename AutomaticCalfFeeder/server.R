
library(shiny)

# ----------- Functions independent of session variables  -----------
source("helpers.R",local=TRUE)
source("helpers_excel.R",local=TRUE)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  
  vars <- reactiveValues()
  inputColumns <- c(1, 2, 3, "-mobile")

  # main calculations
  lapply(inputColumns, function(i) {
    
    observe({
      # reactive to inputs stored in user_values 
      user_values <- sapply(df_vars$variable[df_vars$by_user==1][-1], 
                            function(v) input[[paste0(v,i)]])  
      
      stop <- ifelse(length(user_values)>0,
                     ifelse(any(is.na(user_values)) |
                              length(user_values)!= (sum(df_vars$by_user==1) - 1) |
                              !is.numeric(user_values),
                            TRUE, FALSE), FALSE)
      
      if (!stop) {
        
        isolate({
          
          vars[[paste0("sc",i)]]$calves_total <- input[[paste0("num_feeders",i)]] * input[[paste0("num_calves",i)]]
          vars[[paste0("sc",i)]]$group_turns <- 365/input[[paste0("days_on_feeder",i)]]
          vars[[paste0("sc",i)]]$calves_yr <- vars[[paste0("sc",i)]]$calves_total * vars[[paste0("sc",i)]]$group_turns
          vars[[paste0("sc",i)]]$feeder_cost_total <- input[[paste0("feeder_cost",i)]] * input[[paste0("num_feeders",i)]]
          vars[[paste0("sc",i)]]$cost_investment <- vars[[paste0("sc",i)]]$feeder_cost_total + input[[paste0("building_cost",i)]]
          
          vars[[paste0("sc",i)]]$capital_cost <- -pmt(input[[paste0("interest_rate",i)]]/100, input[[paste0("life_feeder",i)]],
                                                      vars[[paste0("sc",i)]]$cost_investment)
          vars[[paste0("sc",i)]]$capital_cost_calf <- vars[[paste0("sc",i)]]$capital_cost / vars[[paste0("sc",i)]]$calves_yr
          
          vars[[paste0("sc",i)]]$repair_calf <- (input[[paste0("repair_cost_feeder",i)]] * input[[paste0("num_feeders",i)]] +
                                                   + input[[paste0("repair_cost_building",i)]]) / vars[[paste0("sc",i)]]$calves_yr
          vars[[paste0("sc",i)]]$labor_total <- (input[[paste0("labor_feeder",i)]] * 365 +
                                                   + input[[paste0("labor_repair",i)]]) * input[[paste0("wage",i)]]
          vars[[paste0("sc",i)]]$labor_total_calf <- vars[[paste0("sc",i)]]$labor_total / vars[[paste0("sc",i)]]$calves_yr
          vars[[paste0("sc",i)]]$cap_rep_lab_calf <-   vars[[paste0("sc",i)]]$capital_cost_calf + 
            + vars[[paste0("sc",i)]]$repair_calf +  vars[[paste0("sc",i)]]$labor_total_calf
          
          vars[[paste0("sc",i)]]$operating_calf <- sum(c(input[[paste0("feed",i)]],
                                                         input[[paste0("vet",i)]],
                                                         input[[paste0("supplies",i)]],
                                                         input[[paste0("fuel",i)]],
                                                         input[[paste0("utilities",i)]],
                                                         input[[paste0("bedding",i)]],
                                                         input[[paste0("building_lease",i)]],
                                                         input[[paste0("farm_insurance",i)]],
                                                         input[[paste0("misc",i)]]))
          vars[[paste0("sc",i)]]$cost_total_calf <-  vars[[paste0("sc",i)]]$operating_calf +  
            + vars[[paste0("sc",i)]]$cap_rep_lab_calf
          vars[[paste0("sc",i)]]$cost_price_calf <- input[[paste0("price_calf",i)]] + vars[[paste0("sc",i)]]$cost_total_calf
          vars[[paste0("sc",i)]]$breakeven <-   vars[[paste0("sc",i)]]$cost_price_calf/(1 - input[[paste0("mortality",i)]]/100)
          
        })
      }
  })
  })
  
  # UI output for calculated variables
  lapply(inputColumns, function(j) {
    df_all %>% 
      with(
        lapply(1:nrow(df_all),
               function(i) {
                 if (by_user[i] == 0 & header[i] =="") {
                   output[[paste0(variable[i],j)]] <<- renderUI({
                     # browser()
                     if (length(vars[[paste0("sc",j)]][[variable[i]]])==0) return()
                     
                     num <- ifelse(dollars[i],
                                   vars[[paste0("sc",j)]][[variable[i]]] %>% formatdollar(round[i]),
                                   vars[[paste0("sc",j)]][[variable[i]]] %>% round(round[i])
                     )
                     div(num)
                   })
                 }
               })
      )
  })
  
  
  # scenario names
  observe({
    vars$label <- if(anyDuplicated(c(input$scenario_label1, input$scenario_label2, input$scenario_label3)) > 0) {
      c("Scenario 1","Scenario 2", "Scenario 3")
    } else {
      c(input$scenario_label1, input$scenario_label2, input$scenario_label3)
    }
  })
   
  # cost summary table
  summary_items <- c("Capital cost","Repairs & maintenance", "Labor cost",
                     "Operating costs", "Calf market value", "Total cost")

  df_rlt <- reactive({
    data.frame(
     cost_category = rep(ordered(summary_items, levels = summary_items),3),
      
     value = sapply(1:3, function(i) {
       c(vars[[paste0("sc",i)]]$capital_cost_calf, 
         vars[[paste0("sc",i)]]$repair_calf, 
         vars[[paste0("sc",i)]]$labor_total_calf,
         vars[[paste0("sc",i)]]$operating_calf,
         input[[paste0("price_calf",i)]],
         vars[[paste0("sc",i)]]$cost_price_calf)}) %>% c(),
       
      scenario = c(rep(vars$label[1],6),
                   rep(vars$label[2],6),
                   rep(vars$label[3],6)) %>% 
       ordered(levels = vars$label)
    )
  })
 

 # cost plot   
  output$cost_plot <- renderPlot({
    
    df_rlt() %>% filter(cost_category != "Total cost") %>%
      ggplot(aes(x = scenario, y = value, fill = cost_category, 
                 label = ifelse(value > 10, paste0("$", round(value,0)),"") )) +
      geom_bar(stat="identity", width = .7) +
      scale_fill_brewer(palette = "Set3") +
      geom_text(size = 4, position = position_stack(vjust=0.5)) +
      theme(aspect.ratio = .7) +
      labs(y = "Cost  ($/calf)", 
           title = "Cost Analysis")
  })
  
  
  # breakeven plot
  output$breakeven_plot <- renderPlot({
    
    data.frame(
      scenario = ordered(vars$label, levels = vars$label),
      value = sapply(1:3,  function(i) vars[[paste0("sc",i)]]$breakeven) %>% c()
    ) %>% 
      ggplot(aes(x = scenario, y = value, fill= scenario, label = paste0("$", round(value,0)))) +
      geom_bar(stat="identity", width = .7) +
      scale_fill_brewer(palette = "Set2") +
      geom_text(size = 6, position = position_stack(vjust=0.5)) +
      theme(aspect.ratio = .7, legend.position="none") +
      labs(y = "Market calf-sale value ($/calf)", 
           title = "Breakeven Analysis") 
  })
  
})
