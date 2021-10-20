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
        title = "Historic Team Salary and Performance",
        sidebarLayout(
            sidebarPanel(
                selectizeInput(inputId = "id_name",
                               label = "Identify teams to be shown:",
                               choices = team_names,
                               selected = NULL,
                               multiple = TRUE),
                
                sliderInput(inputId = "year_slider",
                            label = "Year range",
                            min = 1990,
                            max = 2020,
                            value = c(1990,2020))
            ),
            
            mainPanel(plotOutput(outputId = "team_historic_scatterplot"))
        )
    )
    
    #ROHIL (dont forget to add commas)
)

# Define server logic required to draw a histogram
server <- function(input, output) {
    #ZIJI
    team_data <- reactive({
        data <- team_info %>%
            filter(team %in% input$id_name) %>%
            filter(start_year %in% input$year_slider[1]:input$year_slider[2])
    })
    
    output$team_historic_scatterplot <- renderPlot({
        team_data() %>%
            ggplot(aes(x = start_year, y = total_salary)) +
            geom_point(aes(size = winper, color = team))
    })
    
    #ROHIL
}

# Run the application 
shinyApp(ui = ui, server = server)
