# Express Module to allow authenticated users, or send 401 errors.
class Authenticator
  user: (req, res, next) ->
    return res.send 401 unless req.isAuthenticated()
    do next

  admin: (req, res, next) =>
    return res.send 401 unless req.user?.admin
    @user req, res, next


module.exports = new Authenticator
