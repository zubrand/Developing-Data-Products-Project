library(shiny)

shinyUI(pageWithSidebar(
    headerPanel(title = 'Body Mass Index Calculator'),
    mainPanel(width = 6,
    h3('Description of the application'),
    h5("Thiny Shiny application calculates body mass index (BMI), which depends of the height and weight of a person. Program takes as an input person's heigth and weight either in mertic (m, kg) or imperial (pounds, feet and iches) units. Progeam calculates your BMI, makes conslusion to what category it belongs and what is the recommended weight person of indicated height."),
    selectInput(inputId = "units",
                label = "Input units:",
                choices = c('Metric', 'Imperial'),
                selected = 'Metric'),
    
    h6(textOutput(outputId = 'h_comment')),
    
    textInput(inputId = 'height', label = "Height", value = 1.7),
    
    h6(textOutput(outputId = 'w_comment')),
    
    textInput(inputId = 'weight', label = "Weight", value = 80)
    ),
    
    sidebarPanel(
    h2('Body Mass Index'),
    
    h4(textOutput(outputId = 'BMI')),
    
    h4('Table of BMI categories:'),
    
    tableOutput(outputId = 'BMItable'),
    
    h5(textOutput(outputId = 'recom'))
    )    
))