library(shiny)
library(keras)
library(reticulate)
library(tensorflow)


#tokenizer1 = py_load_object('tokenizer1.pickle', pickle = 'pickle')
#py_run_string('index_to_word1 = {value:key for key, value in tokenizer1.word_index.items()}')

shinyServer(function(input, output) {
    
    model1 = load_model_hdf5('model1.hf') 
    output$predictedText <- renderText({
    
    text_input = input$userText
    #token_list = texts_to_sequences(tokenizer1, text_input)
    #token_list1 = pad_sequences(token_list, maxlen = 13)
    
    
    predict_classes(model1, array(c(1,2,3,4,5,6,7,8,9,10,11,12,13)))
    #py_run_string('index_to_word1[predicted_index]')
    
    #py_run_string("token_list = keras.preprocessing.sequence.pad_sequences
    #([token_list], maxlen=max_sequence_len-1, 
                              # padding='pre', truncating = 'pre'")
    
    #py_run_string('predicted_index = model1.predict_classes(token_list, verbose=0)')
    #py_run_string('index_to_word1[predicted_index]')
    
  })
  
})
