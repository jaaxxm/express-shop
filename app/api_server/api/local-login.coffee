passport = require("passport")
Strategy = require("passport-local").Strategy
User = require("#{__appbase_dirname}/app/models/model-user")
initialize = (router) ->
  setPassportStrategy()
  setRouter router
  return

setRouter = (router) ->
  
  # set route for login and its passport
  # login/out is only used for 3rd app to get grant of OAuth2 authorization
  router.post "/auth/login", (req, res, next) ->
    passport.authenticate("local-login",
      session: true
    , (err, user, info) ->
      return next(err)  if err
      unless user
        console.log info
        return res.status(401).json(info)
      req.login user, (err) ->
        return next(err)  if err
        res.json 200

      return
    ) req, res, next
    return

  router.get "/auth/logout", (req, res) ->
    
    # TODO replace this to token way
    if req.user
      
      # TODO why not clear session using req.logout()?
      req.session.destroy()
    else
      console.log "this user is not authenticated"
    
    # TODO what do we remove for this request??
    res.sendStatus 200
    return

  
  # set route for signup and its passport
  router.post "/auth/signup", (req, res, next) ->
    passport.authenticate("local-signup",
      session: false
    , (err, user, info) ->
      console.log "success to local-signup passport"
      return next(err)  if err
      unless user
        console.log info
        return res.status(401).json(info)
      res.sendStatus 200
    ) req, res, next
    return

  return

setPassportStrategy = ->
  
  # set login strategy
  passport.use "local-login", new Strategy(
    usernameField: "email"
    passwordField: "password"
    passReqToCallback: true
  , (req, email, password, done) ->
    console.log "passport local login verify callback"
    email = email.toLowerCase()  if email
    User.findOne
      "local.email": email
    , (err, user) ->
      return done(err)  if err
      unless user
        return done(null, false,
          reason: "Invalid email"
        )
      unless user.validPassword(password)
        return done(null, false,
          reason: "Invalid password"
        )
      done null, user

    return
  )
  
  # set signup strategy
  passport.use "local-signup", new Strategy(
    usernameField: "email"
    passwordField: "password"
    passReqToCallback: true
  , (req, email, password, done) ->
    console.log "local-signup strategy"
    email = email.toLowerCase()  if email
    process.nextTick ->
      
      # TODO replace this to token way
      
      # in case of invalid access, just return current data
      return done(null, req.user)  if req.user and req.user.local and req.user.local.email
      User.findOne
        "local.email": email
      , (err, user) ->
        return done(err)  if err
        if user
          console.log "an user with email exists!"
          return done(null, false,
            reason: "registered-email"
          )
        user = undefined
        unless req.user
          user = new User()
        else user = req.user  unless req.user.local.email
        user.local.email = email
        user.local.password = user.generateHash(password)
        user.save (err) ->
          throw err  if err
          done null, user

        return

      return

    return
  )
  return

module.exports = initialize
