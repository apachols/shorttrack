require './register'
require './admin'
require './login'

#Logout
app.get '/logout', (req, res) ->
  req.logout()
  res.redirect '/'

# Index needs to be last!
app.get '/', (req, res) ->
  res.locals =
    brand: 'Homepage'
    my: req.user

  res.render 'index'
