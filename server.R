library(shiny)
meters <- function(string) {
    string <- gsub(pattern = "''",replacement = '"', string)
    string <- gsub(pattern = ' ', replacement = '', string)
    
    if (grepl(paste0("^((\\d)+')*",'((\\d)+")*$'), string)) 
    {
        # Plausible value
        if (!grepl(paste0('(\\d)+"$'), string)) {
            string <- paste0(string, '0"')        
        } 
        if (!grepl(paste0("^(\\d)+'"), string)) 
        {
            string <- paste0("0'", string)        
        }
    }
    splitted <- strsplit(x = string,fixed = FALSE,split = paste0("['",'"]'))[[1]]
    sum(as.numeric(splitted)*c(0.3048,0.0254))
}

categoryBMI <- function(BMI) {
    ifelse(BMI <= 18.5, 'underweight',
           ifelse(BMI <= 25, 'normal',
                ifelse(BMI <= 30, 'overweight', 
                            'obese')))
}



shinyServer(function(input, output) {
    
    output$h_comment <- renderText(ifelse(input$units == 'Metric',
                                          'Enter height in meters (m). Example: 1.7',
                                          paste0("Enter height in feet (') and/or inches (",
                                                 '"). Examples: 5',"'3",'", 60"',", 6'")))
    
    output$w_comment <- renderText(ifelse(input$units == 'Metric',
                                          'Enter weight in kilograms (kg). Example: 80',
                                          "Enter weight in pounds (lbs). Example: 200"))
    
    height <- reactive({
        if (input$units == 'Imperial') 
        {                                            
            meters(input$height)
            
        } else {as.numeric(input$height)}
        
    })
    
    weight <- reactive({
        ifelse(input$units == 'Imperial', 0.453, 1) * as.numeric(input$weight)
    })
    
    output$BMI <- renderText(paste0('Your BMI is ',
                                round(weight()/height()^2, digits = 2),
                                ', you are ',
                                categoryBMI(weight()/height()^2), '.'
                                ))
    
    output$BMItable <- renderTable(options = list,expr = data.frame(
        Category = c('Underweight','Normal','Overweight','Obese'),
        BMI_range = c('less than 18.5', 'from 18.5 to 25', 'from 25 to 30', 'over 30')
        ))
    
    output$recom <- renderText(paste0('Recommended weight for your height is in the range of [',
                           paste(round(c(18.5, 25) * height()^2, digits = 1)
                                ,collapse = ', '), '] kg.'))
    
})