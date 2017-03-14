# Cargar libreria de TwitterR

library("twitteR");

# Leer fichero credenciales

source('credenciales.R')

# Función para buscar #hastags, @users, words

tweets <- searchTwitter("Tenerife", n=10, lang="es")




# Coger solo el primer tweet para datos concretos del mismo

#tweet <- tweets[[1]];

# Mostrar estructura del tweet

#str(tweet)

# Funcion para buscar retweets

#retweets <- Rtweets(n=25, lang="es", since=NULL)

#retweet <- retweets[[1]];

#str(retweet)
# Obtener información del usuario

#user <- getUser(tweet$getScreenName());


# Estructura del usuario

#str(user)

# Nombre del usuario

#user$getName()
#user$getId()
# Obtener el texto del tweet:

#tweet$getText()

# Obtener el texto del retweet:
#retweet$getText()

#for(i in 1:10) {
  #print(tweets)
 # tweet <- tweets[[i]];
 # print(str(tweet$getText()))
  #user <- getUser(tweet$getScreenName());
 # print(user)
  
#}