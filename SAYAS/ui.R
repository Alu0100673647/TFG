#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#
library("base64enc"); # provee herramientas con base64 para ASCII
library(shiny)
library(shinythemes)


shinyUI(fluidPage(theme = shinytheme("cerulean"),
  # Application title
  tags$head(
    tags$style(HTML("
      @import url('//fonts.googleapis.com/css?family=Lobster|Cabin:400,700');
      
      h1 {
        font-family: 'Lobster', cursive;
        font-weight: 500;
        line-height: 1.1;
        color: #00aced;
      }

    "))
  ),
 
  
  headerPanel("SAyAS (Sistema de Alerta y AnÃ¡lisis de Sentimientos)"),
  
  
  sidebarLayout(
    sidebarPanel(
      textInput("busqueda", label = "BÃºsqueda:", value = "#nieve"),
      numericInput("obs", "NÃºmero de tweets:", 5, min = 3, max = 20),
      submitButton("Buscar"), 
      actionButton("alerta","Recibir Alerta"),
      actionButton("remail","Recibir e-mail")
      
  ),
  
  
    mainPanel(
  #     navbarPage("sayas",
  #            tabPanel("Spanish",
  #                     verbatimTextOutput("summary")),
  #            tabPanel("English",
  #                     verbatimTextOutput("summary")),
  #            tabPanel("Portuguese",
  #                     verbatimTextOutput("summary"))
  # ),
      
        tabsetPanel( type = "tabs",
                  #tabPanel("Plot",plotOutput("plot")),
                  #tabPanel("Summary", verbatimTextOutput("Summary")),
                  tabPanel("Tweets analizados", tableOutput("table"))
                  ),
    #   plotOutput('graphic'),
       plotOutput('graphic2'),
       plotOutput("histogram")
    ) 
  )
))