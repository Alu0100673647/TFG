# obtiene el texto de los tweets
txt = df$text

##### inicio limpieza de datos #####
# remueve retweets
txtclean = gsub("(RT|via)((?:\\b\\W*@\\w+)+)", "", txt)
# remove @otragente
txtclean = gsub("@\\w+", "", txtclean)
# remueve simbolos de puntuaci?n
txtclean = gsub("[[:punct:]]", "", txtclean)
# remove n?meros
txtclean = gsub("[[:digit:]]", "", txtclean)
# remueve links
txtclean = gsub("http\\w+", "", txtclean)
##### fin limpieza de datos #####


# construye un corpus
corpus = Corpus(VectorSource(txtclean))

# convierte a min?sculas
corpus = tm_map(corpus, tolower)

# remueve palabras vac?as (stopwords) en espa?ol
corpus <- tm_map(corpus,removeWords,stopwords("spanish"))

# carga archivo de palabras vac?as personalizada y lo convierte a ASCII
sw <- readLines("spanish.txt",encoding="UTF-8")
sw = iconv(sw, to="ASCII//TRANSLIT")

# remueve palabras vac?as personalizada
corpus = tm_map(corpus, removeWords, sw)

# remove espacios en blanco extras
corpus = tm_map(corpus, stripWhitespace)

# crea una matriz de t?rminos
tdm <- TermDocumentMatrix(corpus)

# convierte a una matriz
m = as.matrix(tdm)

# conteo de palabras en orden decreciente
wf <- sort(rowSums(m),decreasing=TRUE)

# crea un data frame con las palabras y sus frecuencias
dm <- data.frame(word = names(wf), freq=wf)

#####################################################
############ Exportaci?n de df a fichero csv ########
#####################################################

write.csv(dm, 'dataframe.csv')

######################################################


