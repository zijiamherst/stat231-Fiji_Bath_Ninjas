# Basketball Economics Shiny app
# Ziji zhou and Rohil Bathija

#load libraries
library(shiny)
library(tidyverse)
library(rvest)
library(readxl)
library(dplyr)

#load datasets
#visualization 1
#ZIJI
team_info <- read.csv("data/team_info.csv")
team_names <- unique(team_info$team)


# Define UI 
ui <- navbarPage(
    title = "Basketball Economics",
    #ZIJI
    tabPanel(
        
        sidebarLayout(
            titlePanel(title = "Historic Team Performance and Total Salary"),
            sidebarPanel(
                selectizeInput(inputId = "id_name",
                               label = "Identify teams to be shown:",
                               choices = team_names,
                               selected = NULL,
                               multiple = TRUE)
                
                # sliderInput(inputId = "year_slider", 
                #             label = h3("Year range"), 
                #             min = 1990, 
                #             max = 2020)
            ),
            
            mainPanel(plotOutput(outputId = "team_historic_scatterplot"))
        )
    )
    
    #ROHIL (dont forget to add commas ^)
)

# Define server logic required to draw a histogram
server <- function(input, output) {
    #ZIJI
    team_data <- reactive({
        data <- team_info %>%
            filter(team %in% input$id_name)
    })

    output$team_historic_scatterplot <- renderPlot({
        team_data() %>%
            ggplot(aes(x = start_year, y = winper)) +
                geom_point(aes(size = total_salary))
    })
    
    #ROHIL
}
 
# Run the application 
shinyApp(ui = ui, server = server)
