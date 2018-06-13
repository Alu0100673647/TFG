###############################################
# Autor: Constanza Polette Leon Baritussio    #
###############################################

#Carga de las librerias siguientes:

library("ROAuth"); # para autenticaci?n OAuth
library("base64enc"); # provee herramientas con base64 para ASCII
library("twitteR"); # libreria de twitter para R
library("streamR"); # Provee funciones en R para usuarios con acceso a twitter.

# Cargar parametros de configuracion

reqURL <- "https://api.twitter.com/oauth/request_token"
accessURL <- "https://api.twitter.com/oauth/access_token"
authURL <- "https://api.twitter.com/oauth/authorize"
options(httr_oauth_cache=T)



# Cargar las credenciales obtenidas del paso anterior
  

# Creamos la conexión a twitter

setup_twitter_oauth(consumer_key, consumer_secret, access_token, access_secret)
 
# streamR authentication


credentials_file <- "my_oauth.Rdata"

if (file.exists(credentials_file)){
  load(credentials_file)
} else {
  cred <- OAuthFactory$new(consumerKey = consumer_key, consumerSecret =
                             consumer_secret, requestURL = reqURL, accessURL = accessURL, authURL = authURL)
  cred$handshake(cainfo = system.file("CurlSSL", "cacert.pem", package = "RCurl"))

  save(cred, file = credentials_file)
}



