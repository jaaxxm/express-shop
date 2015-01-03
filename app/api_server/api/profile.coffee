passport = require("passport")
tokenizer = require("#{__appbase_dirname}/app/utils/tokenizer")
oauth2Server = require("#{__appbase_dirname}/app/oauth2_server/server")
initialize = (router) ->
  setRouter router
  return

setRouter = (router) ->
  
  # TODO these apis should not be accessible by 3rd party app
  # So we need to use 'scope' of OAuth2 spec 
  
  # api for getting user profile
  router.get "/api/profile", passport.authenticate("bearer",
    session: false
  ), oauth2Server.error(), (req, res) ->
    console.log "send profile after checking authorization"
    res.json req.user
    return

  return

module.exports = initialize
