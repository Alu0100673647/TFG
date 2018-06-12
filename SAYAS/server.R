#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
# Autor: Constanza Polette León Baritussio
#
# Cargar libreria de TwitterR


library("tm");
library("reader");
library("shiny");
library("plyr"); # proporciona herramientas para aplicar operaciones a los datos
library("dplyr");
library("stringr"); # facilita las operaciones con cadenas
library("ggplot2"); # graficos
library("leaflet");
library("rsconnect");
library("ggthemes");
library(mailR)
library("RPushbullet");
# Leer fichero credenciales
# cuando ejecutamos el PIN lo teniamos qu poner en consola para   q crear el ficher myoauth
source('credenciales.R')

shinyServer(function(input, output) {
  
  # Obteniendo los tweets de twitter ************************************************************
  dataInput <- reactive({
    
   if(input$gmail != "example@gmail.com") {
      
      recipient = "Recipient 1 ";
      i = "<";
      d = ">";
      r = paste(i,input$gmail,d,sep = "",collapse = NULL);
      para =  paste(recipient,r, sep = "", collapse = NULL);
      # #   
      
      
      send.mail(from = "alu0100673647@ull.edu.es",
                to = c(para),
                subject = "alerta SAyAS3",
                body = "alerta sobre busqueda en la app https://alu0100673647.shinyapps.io/SAYAS/ ",
                smtp = list(host.name = "aspmx.l.google.com.", port = 25),
                authenticate = FALSE,
                send = TRUE)
   }
   
   
    # obtenemos un data frame
    tweets <- searchTwitter(input$busqueda, n = 100, lang="es", 
                            geocode = "28.5,-16.5,10000km")

    if(length(tweets)== 0)
      output$table <- renderText("No existen resultados")
    
    tweets.df <- twListToDF(tweets)
    tweets.df$created <- as.character(tweets.df$created)
    colnames(tweets.df)[which(names(tweets.df) == "text")] <- "Tweet"
    colnames(tweets.df)[which(names(tweets.df) == "screenName")] <- "User"
    tweets.df
  })

  analysis <- reactive({
    tweets <- searchTwitter(input$busqueda, n = 100, lang="es", 
                            geocode = "28.5,-16.5,10000km")
    tweets.df <- twListToDF(tweets)
    tweets.df$created <- as.character(tweets.df$created)
    
    if (file.exists(paste(input$busqueda, '_stack.csv')) == FALSE) 
      write.csv(tweets.df, file = paste(input$busqueda, '_stack.csv'), row.names = F)
    
    # Unimos el ultimo acceso con el fichero acumulativo y eliminamos duplicados
    
    stack <- read.csv(file = paste(input$busqueda, '_stack.csv'))
    stack <- rbind(stack, tweets.df)
    stack <- subset(stack, !duplicated(stack$text))
    write.csv(stack, file = paste(input$busqueda, '_stack.csv'), row.names = F)
    
    # Analisis de sentimiento 
    
    scoreSentiment <- function(sentences, pos.words, neg.words, .progress='none') {
      scores <- laply(sentences, function(sentence, pos.words, neg.words) {
        # remueve links
        sentence <- gsub('http\\w+', '', sentence)
        sentence <- gsub('[[:punct:]]', '', sentence)
        sentence <- gsub('[[:cntrl:]]', '', sentence)
        sentence <- gsub('\\d+', '', sentence)
      
        # Transforma a minuscula
        sentence <- tolower(sentence)
        
        # divide en palabras
      
        word.list <- str_split(sentence, '\\s+')
        
        # sometimes a list() is one level of hierarchy too much
        words <- unlist(word.list)
        words <-  enc2utf8(words)
        
        # compare our words to the dictionaries of positive & negative terms
        pos.matches <- match(words, pos.words)
        neg.matches <- match(words, neg.words)
        
        # match() returns the position of the matched term or NA
        # we just want a TRUE/FALSE:
        pos.matches <- !is.na(pos.matches)
        neg.matches <- !is.na(neg.matches)
        
        # and conveniently enough, TRUE/FALSE will be treated as 1/0 by sum():
        score <- sum(pos.matches) - sum(neg.matches)
        return(score)
      }, pos.words, neg.words, .progress=.progress)
      
      scores.df <- data.frame(score = scores, text = sentences)
      return(scores.df)
    }
    
    # Diccionarios con las palabras positivas y negativas
    pos <- scan('positive-words.txt', what = 'character', comment.char = ';')
    neg <- scan('negative-words.txt', what = 'character', comment.char = ';')
    
    posWords <- c(pos)
    negWords <- c(neg)
    
    Dataset <- stack
    Dataset$text <- as.factor(Dataset$text)
    scores <- scoreSentiment(Dataset$text, posWords, negWords, .progress='text')
    write.csv(scores, file = paste(input$busqueda, '_scores.csv'), row.names = TRUE)
    
    # Evaluacion
    stat <- scores
    stat$created <- stack$created
    stat$created <- as.Date(stat$created)
    stat <- mutate(stat, tweet=ifelse(stat$score > 0, 'positivo', ifelse(stat$score < 0, 'negativo', 'neutro')))
    by.tweet <- group_by(stat, tweet, created)
    by.tweet <- summarise(by.tweet, number=n())
    write.csv(by.tweet, file=paste(input$busqueda, '_opin.csv'), row.names=TRUE)
    return(by.tweet)
  })
  
  # Crea la tabla con los tweets
  
  output$table <- renderTable({
    head(dataInput()[, c("Tweet","User")], n = input$obs)
  })
  output$value <- renderPrint({ output$table })
  
  # Crear grafico de analisis
  
  output$graphic2 <- renderPlot({
    data <- analysis()
    ggplot(data,aes(x = created, y = number, group = tweet, color = tweet)) +
     geom_line() +
     geom_point(size = 4) +
     ggtitle(input$busqueda) +
     theme_hc() +
     scale_colour_hc()
  }) 
  
  })

