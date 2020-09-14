library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
    titlePanel(title = h1("Predict Next Word App", align = "center"), 
               windowTitle = 'Predict Next Word'),
    
    sidebarLayout(
        sidebarPanel(
            width = 6,
            textInput("userText",
                      "Please enter something and then press Submit",
                      value = 'I want to eat'),
            submitButton(text = 'Submit')
        ),
        
        mainPanel(
            width = 6,
            h4('The next word is:'),
            h3(textOutput("predictedText"))
        )
    )
))
