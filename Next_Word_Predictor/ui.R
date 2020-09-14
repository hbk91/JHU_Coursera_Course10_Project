library(keras)
library(reticulate)
library(tensorflow)
library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
    titlePanel(title = h1("Predict Next Word", align = "center"), 
                             windowTitle = 'Predict Next Word'),
    
  sidebarLayout(
    sidebarPanel(
       textInput("userText",
                   "Please enter a few words and then press Submit"),
       submitButton(text = 'Submit')
    ),
    
    mainPanel(
       textOutput("predictedText")
    )
  )
))
