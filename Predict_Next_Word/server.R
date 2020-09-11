library(shiny)
source('Predictor.R')

shinyServer(function(input, output) {
    
    output$predictedText <- renderText({
        text_input = input$userText
        next_word(text_input)
    })
})
