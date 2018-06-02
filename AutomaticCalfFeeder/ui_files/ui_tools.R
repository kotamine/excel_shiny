is.even <- function(x) x %% 2 == 0

inlineTextInput <- function (inputId, label, value = "",...) {
  div(class="format-node ",
      #tags$label(label, `for` = inputId), 
      tags$input(id = inputId, type = "text", value = value,...))
}

inlineNumericInput <- function (inputId, label, value = NA, subclass, ...) {
  div(class=paste0("format-node ", subclass),
      span(class="number-overlay", ''),
      tags$input(class="number-input", id = inputId, type = "number", value = value, ...)
  )
}

myTextInput <- function(inputId, label, value="", ...) {
  fluidRow(div(class="textInputs",
               HTML(paste0('<label for="',inputId,'">',label,'</label>')),
               div(class="format-node",
                   tags$input(id = inputId, type = "text", value = value, ...)
               )
  ))
}

myNumericInput <- function(inputId, label, value="", unit_left="", unit_right="",...) {
  fluidRow(div(class="numberInputs",
               HTML(paste0('<label for="',inputId,'">',label,'</label>')),
               div(class="format-node",
                   insertUnit(unit_left,"units unitLeft"),
                   span(class="number-overlay", ''),
                   tags$input(class="number-input", id = inputId, type = "number", value = value, ...),
                   insertUnit(unit_right,"units")
               )
  ))
}

insertUnit <- function(unit,class) {
  if (unit=="") return(NULL)
  span(class=class, HTML(unit))
}

mobileDropdown <- function(label, name) {
  options <- list()
  option1 <- paste0(name, 1)
  option2 <- paste0(name, 2)
  option3 <- paste0(name, 3)
  options[[option1]] <- 1
  options[[option2]] <- 2
  options[[option3]] <- 3
  selectInput(paste0(label, "-mobile"), NULL,
              options)
}

# dataInputCheck <- function(id) {
#   fluidRow(column(6, offset=3,
#                   uiOutput(paste0("error_min",id)),
#                   uiOutput(paste0("error_max",id)),
#                   uiOutput(paste0("error_num",id))
#   )) 
# }
