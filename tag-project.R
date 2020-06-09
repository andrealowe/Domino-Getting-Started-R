## Make sure to update line 9 before running

library(httr)

#store API key in environment variable
api_key <- Sys.getenv('DOMINO_USER_API_KEY')

#base url
base_url <- <your deployment url> #i.e. 'https://mycompany.domino.tech'

#get user id
url_user <- sprintf("%s/v4/users/self", base_url)
r_user <- httr::GET(url_user, httr::add_headers('X-Domino-Api-Key'= api_key))
user_id <-  content(r_user, as="parsed")$id

#get project id
project_name <- Sys.getenv('DOMINO_PROJECT_NAME')
url_project <- sprintf("%s/v4/projects?name=%s&ownerID=%s", base_url, project_name, user_id)
r_project <- httr::GET(url_project, httr::add_headers('X-Domino-Api-Key'= api_key))
project_id <-  content(r_project, as="parsed")[[1]]$id

#set project tag
url_tags <- sprintf("%s/v4/projects/%s/tags", base_url, project_id)
r <- httr::POST(url_tags, httr::add_headers('X-Domino-Api-Key'= api_key), body = list(tagNames=list('time-seriesR')), encode = "json")



