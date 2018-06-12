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
  headerPanel("SAyAS (Sistema de Alerta y Análisis de Sentimientos)"),
  sidebarLayout(
    sidebarPanel(
      textInput("busqueda", label = "Búsqueda:", value = "#mujer"),
      numericInput("obs", "Número de tweets:", 15, min = 3, max = 20),
      submitButton("Buscar"),
      textInput("gmail", label = "Gmail:", value = "example@gmail.com"),
      submitButton("email")
  ),
    mainPanel(
        tabsetPanel( type = "tabs",
                  tabPanel("Tweets analizados", tableOutput("table"))
                  ),
       plotOutput('graphic2'),
       plotOutput("histogram")
    ) 
  )
))