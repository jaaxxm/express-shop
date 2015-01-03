passport = require("passport")
oauth2Server = require("#{__appbase_dirname}/app/oauth2_server/server")
User = require("#{__appbase_dirname}/app/models/model-user")
module.exports = (router) ->
  
  # TODO these apis should not be accessible by 3rd party app
  # So we need to use 'scope' of OAuth2 spec 
  
  # api for activating session 
  # this would be useful to save its data into specific user with a token after connecting other social apps
  router.get "/api/session", passport.authenticate("bearer",
    session: true
  ), (req, res) ->
    console.log "token is validated and session is created"
    res.send 200
    return

  router.post "/api/connect/local", passport.authenticate("bearer",
    session: false
  ), oauth2Server.error(), (req, res, next) ->
    passport.authenticate("local-signup",
      session: false
    , (err, user, info) ->
      return next(err)  if err
      unless user
        console.log info
        return res.json(401, info)
      res.send 200
    ) req, res, next
    return

  router.get "/api/disconnect/local", passport.authenticate("bearer",
    session: false
  ), oauth2Server.error(), (req, res) ->
    console.log "disconnect local"
    process.nextTick ->
      
      # TODO replace this to token way
      User.findOne
        "local.email": req.user.local.email
      , (err, user) ->
        return done(err)  if err
        unless user
          res.json 401,
            reason: "no-user"

        user.local = `undefined`
        user.save (err) ->
          throw err  if err
          res.send 200

        return

      return

    return

  
  # connect to current session
  router.get "/api/connect/:socialapp", (req, res, next) ->
    
    # TODO if social apps require any option except scope,
    # add it here along to social app (e.g. state)
    scope = null
    state = null
    switch req.params.socialapp
      when "twitter"
        scope = "email"
      when "facebook"
        scope = "email"
      when "google"
        scope = "email"
      when "yahoo", "linkedin"
        scope = [
          "r_fullprofile"
          "r_emailaddress"
        ]
        state = "aZae0AD" # dummy value
      when "github"
      else
        return res.json(400,
          reason: "unknown-socialapp"
        )
    
    # this new property will be used in route logic of callback url
    req.session.passport.connect = true
    passport.authenticate(req.params.socialapp,
      session: true
      scope: scope
      state: state
    ) req, res, next
    return

  
  # disconnect from current session
  router.get "/api/disconnect/:socialapp", passport.authenticate("bearer",
    session: false
  ), oauth2Server.error(), (req, res) ->
    user = req.user
    eval "user." + req.params.socialapp + " = undefined;"
    user.save (err) ->
      console.error err  if err
      res.send 200
      return

    return

  return
