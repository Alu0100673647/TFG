# Cargar libreria de TwitterR

library("twitteR");
library("tm");
library("RTextTools");
library("SnowballC");
library("e1071");
library("randomForest");
library("stringi");
library("reader");


# Leer fichero credenciales
# cuando ejecutamos el PIN lo teniamos qu poner en consola para   q crear el ficher myoauth

source('credenciales.R')

# Función para buscar #hastags, @users, words

tweets <- searchTwitter("Canarias", n=10, lang="es",since="2017-06-01")

# vuelca la informacion de los tweets a un data frame

df = twListToDF(tweets)

# obtiene el texto de los tweets

txt = df$text

##### inicio limpieza de datos #####
# remueve retweets
txtclean = gsub("(RT|via)((?:\\b\\W*@\\w+)+)", "", txt)
# remove @otragente
txtclean = gsub("@\\w+", "", txtclean)
# remueve simbolos de puntuación
txtclean = gsub("[[:punct:]]", "", txtclean)
# remove números
txtclean = gsub("[[:digit:]]", "", txtclean)
# remueve links
txtclean = gsub("http\\w+", "", txtclean)
##### fin limpieza de datos #####


# construye un corpus
corpus = Corpus(VectorSource(txtclean))

# convierte a minúsculas
corpus = tm_map(corpus, tolower)

# remueve palabras vacías (stopwords) en español
corpus <- tm_map(corpus,removeWords,stopwords("spanish"))

# carga archivo de palabras vacías personalizada y lo convierte a ASCII
sw <- readLines("spanish.txt",encoding="UTF-8")
sw = iconv(sw, to="ASCII//TRANSLIT")

# remueve palabras vacías personalizada
corpus = tm_map(corpus, removeWords, sw)

# remove espacios en blanco extras
corpus = tm_map(corpus, stripWhitespace)

# crea una matriz de términos
tdm <- TermDocumentMatrix(corpus)

# convierte a una matriz
m = as.matrix(tdm)
