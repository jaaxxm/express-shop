passport = require("passport")
module.exports = (router) ->
  
  # login (authenticate)
  router.get "/auth/login/:socialapp", (req, res, next) ->
    
    # TODO if social apps require any option except scope,
    # add it here along to social app (e.g. state)
    scope = null
    state = null
    switch req.params.socialapp
      when "twitter"
        scope = "email"
      when "facebook"
        scope = "email user_birthday"
      when "google"
        scope = "profile email"
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
    passport.authenticate(req.params.socialapp,
      session: false
      scope: scope
      state: state
    ) req, res, next
    return

  router.get "/auth/login/:socialapp/callback", (req, res, next) ->
    switch req.params.socialapp
      when "twitter", "facebook", "google", "yahoo", "linkedin", "github"
      else
        return res.send(404)
    callback = "/auth/login/" + req.params.socialapp + "/callback"
    passport.authenticate(req.params.socialapp,
      successRedirect: callback + "/success"
      failureRedirect: callback + "/failure"
    ) req, res, next
    return

  router.get "/auth/login/:socialapp/callback/:state", (req, res) ->
    calltype = null
    socialToken = null
    if req.session.passport.connect
      console.log "this oauth is for connect, not login"
      calltype = "connect"
    else
      calltype = "login"
    socialData = null
    if req.params.state is "success"
      eval "socialToken = req.user." + req.params.socialapp + ".token"
      socialData =
        name: req.params.socialapp
        token: socialToken
    else
      socialData = message: req.params.socialapp + " authentication failed."
    
    # destroy session first, which is not used later
    req.session.destroy()
    res.render "extenral_account_oauth",
      type: calltype
      state: req.params.state
      data: socialData

    return

  return
