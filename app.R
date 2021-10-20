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
team_info <- read.csv("data/team_info.csv")
team_names <- unique(team_info$team)


# Define UI 
ui <- navbarPage(
    title = "Basketball Economics",
    #first visualization
    tabPanel(
        
        sidebarLayout(
            titlePanel(title = "Historic Team Performance and Total Salary"),
            sidebarPanel(
                selectizeInput(inputId = "id_name",
                               label = "Identify teams to be shown:",
                               choices = team_names,
                               selected = NULL,
                               multiple = TRUE),
                
                sliderInput(inputId = "year_slider", 
                            label = h3("Year range"), 
                            min = 1990, 
                            max = 2020, 
                            value = c(1990, 2020))
            ),
            
            mainPanel(plotOutput(outputId = "team_historic_scatterplot"))
        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
    team_data <- reactive({
        data <- team_info %>%
            filter(team %in% input$id_name) %>%
            filter(start_year %in% input$year_slider)
    })

    output$distPlot <- renderPlot({
        team_data() %>%
            ggplot(aes(x = start_year, y = winper)) +
                geom_point(aes(size = total_salary))
    })
}
 
# Run the application 
shinyApp(ui = ui, server = server)
