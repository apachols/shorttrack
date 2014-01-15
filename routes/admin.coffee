#/admin
exports.home = (req, res, next) ->
  if req.isAuthenticated()

    res.render 'admin', {
      user: req.user
    }
  else
    res.send 'boo-urns'

  next()
