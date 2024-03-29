# Basketball Economics Shiny app
# Ziji zhou and Rohil Bathija


#Rohil took the lead on the second tab in our shiny output
#Ziji took the lead on the first tab in our shiny application
#throughout the code, you will see some comments saying our names to signify where each of us worked primarily
#however, we did do the majority of this project together.

#For the third tab, the website we scraped from changed their data on Wednesday due to the new NBA season starting. 
#We adjusted our data to reflect career stats but added a tab with the initial data that we scraped before the change. This data is not reproducible anymore however the career tab is.

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
#ROHIL
nba_salaries <- read.csv("data/nba_salaries.csv")
teams <- unique(nba_salaries$team)
#for radio buttons
stat_choice_values <- c("games", "points", "rebounds", "assists")
stat_choice_names <- c("Total Games", "Career Points Per Game", "Career Rebounds Per Game", "Career Assists Per Game")
names(stat_choice_values) <- stat_choice_names

#Backup data before it changed on Wednesday
nba_salaries2 <- read.csv("data-backup/nba_salaries.csv")
teams2 <- unique(nba_salaries$team)
#for radio buttons
stat_choice_values2 <- c("games", "points", "rebounds", "assists")
stat_choice_names2 <- c("Games", "Points Per Game", "Rebounds Per Game", "Assists Per Game")
names(stat_choice_values2) <- stat_choice_names2
# Define UI 
ui <- navbarPage(
    title = "Basketball Economics",
    #ZIJI
    tabPanel(
        title = "Historic Team Salary and Performance",
        sidebarLayout(
            sidebarPanel(
                #input for team names displayed
                selectizeInput(inputId = "id_name",
                               label = "Identify teams to be shown:",
                               choices = team_names,
                               selected = NULL,
                               multiple = TRUE),
                #input for which years to show
                sliderInput(inputId = "year_slider",
                            label = "Year range",
                            min = 1990,
                            max = 2020,
                            value = c(1990,2020))
            ),
            
            mainPanel(plotOutput(outputId = "team_historic_scatterplot"))
        )
    ),
    
    tabPanel(
        title = "Do Higher Paid Players Produce? (Career)",
        #getting a selector for teams to select
        sidebarLayout(
            sidebarPanel(
                selectizeInput(
                    inputId = "id",
                    label = "What teams do you want to show?",
                    choices = teams,
                    selected = NULL,
                    multiple = TRUE),
                # getting selector for which stat we want shown
                radioButtons(inputId = "pt_size",
                             label = "Which Stat do you Want?",
                             choices = stat_choice_values,
                             selected = NULL)),
                mainPanel(plotOutput(outputId = "NBA_salaries_plot"))
                
            )
        ),
    
    tabPanel(
        title = "Do Higher Paid Players Produce? (2020-2021)",
        #getting a selector for teams to select
        sidebarLayout(
            sidebarPanel(
                selectizeInput(
                    inputId = "id2",
                    label = "What teams do you want to show?",
                    choices = teams2,
                    selected = NULL,
                    multiple = TRUE),
                # getting selector for which stat we want shown
                radioButtons(inputId = "pt_size2",
                             label = "Which Stat do you Want?",
                             choices = stat_choice_values2,
                             selected = NULL)),
            mainPanel(plotOutput(outputId = "NBA_salaries_plot2"),
                      plotOutput(outputId = "NBA_salaries_plot_salary2"))
            
        )
    )
)
    
    #ROHIL (dont forget to add commas)


# Define server logic required to draw a histogram
server <- function(input, output) {
    #ZIJI
    #filter through the data based on user parameters
    team_data <- reactive({
        data <- team_info %>%
            filter(team %in% input$id_name) %>%
            filter(start_year %in% input$year_slider[1]:input$year_slider[2])
    })
    #create ggplot
    output$team_historic_scatterplot <- renderPlot({
            team_data() %>%
                ggplot(aes(x = start_year, y = total_salary/100000)) +
                geom_point(aes(size = winper, color = team)) +
                geom_line(aes(color = team)) +
                labs(
                    x = "Season",
                    y = "Total Salary $ in $100,000",
                    color = "Team", 
                    size = "Win Percentage"
                )
        
            
    })
    
    #ROHIL
    salary_data <- reactive({
        data <- nba_salaries %>%
            filter(team %in% input$id)
    })
    output$NBA_salaries_plot <- renderPlot({
        salary_data() %>%
            #plotting the data using a reactive element for the y axis
            ggplot(aes_string(x = "salaryProportion", y = input$pt_size)) +
            #having different colors and changing size of the points
            geom_point(aes(color = team), size = 6) +
            #adding labels
            labs(
                title = "Players' stats vs. Salary",
                x = "Ratio of Player's Salary to Median Income in Team's City",
                y = stat_choice_names[stat_choice_values == input$pt_size]
            )
    })
    #Ziji 
    salary_data2 <- reactive({
        data <- nba_salaries2 %>%
            filter(team %in% input$id2)
    })
    output$NBA_salaries_plot2 <- renderPlot({
        salary_data2() %>%
            #plotting the data using a reactive element for the y axis
            ggplot(aes_string(x = "salaryProportion", y = input$pt_size2)) +
            #having different colors and changing size of the points
            geom_point(aes(color = team), size = 6) +
            #adding labels
            labs(
                title = "Players' stats vs. Salary",
                x = "Ratio of Player's Salary to Median Income in Team's City",
                y = stat_choice_names2[stat_choice_values2 == input$pt_size2]
            )
    })
    
}

# Run the application 
shinyApp(ui = ui, server = server)
