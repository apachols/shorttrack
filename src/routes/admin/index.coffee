UserModel = require '../../models/user'
util = require 'util'

auth = require '../../helpers/authenticator'

class Admin
  constructor: (@app) ->
    @locals =
      brand: 'Admin Console'

    # Require authentication for all admin routes
    @app.all /^\/admin/, auth.user

    # Route the /admin requests.
    @app.get '/admin', @home

  home: (req, res) ->
    res.render '../../public/templates/admin/home'

module.exports = (app) -> new Admin app
