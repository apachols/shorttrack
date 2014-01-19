# module.exports = (app) ->

#Index
app.get '/', (req, res) ->
  req.locals =
    brand: 'Homepage'
    my: req.user

  res.render 'index'

app.get '/logout', (req, res) ->
  req.logout()
  res.redirect '/'

require './register'
require './admin'
require './login'
