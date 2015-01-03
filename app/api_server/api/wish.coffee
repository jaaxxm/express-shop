passport = require("passport")
oauth2Server = require("#{__appbase_dirname}/app/oauth2_server/server")
Wish = require("#{__appbase_dirname}/app/models/model-wish")
initialize = (router) ->
  setRouter router
  return

setRouter = (router) ->
  router.get "/api/wish", passport.authenticate("bearer",
    session: false
  ), oauth2Server.error(), (req, res) ->
    console.log "This is query request!"
    process.nextTick ->
      Wish.find
        userId: req.user.id
      , (err, wishs) ->
        if wishs
          res.json wishs
        else
          res.json []
        return

      return

    return

  
  # api for getting user's item
  router.get "/api/wish/:id", passport.authenticate("bearer",
    session: false
  ), oauth2Server.error(), (req, res) ->
    process.nextTick ->
      Wish.findById req.params.id, (err, wish) ->
        if err
          console.log "err occurs"
          throw err
        unless wish?
          console.log "not exists!"
          return res.json({})
        if req.user.id isnt wish.userId
          return res.json(403,
            reason: "unauthroized access"
          )
        res.json wish

      return

    return

  router.post "/api/wish", passport.authenticate("bearer",
    session: false
  ), oauth2Server.error(), (req, res) ->
    newWish = new Wish()
    newWish.userId = req.user.id
    newWish.content = req.body.content
    newWish.save (err) ->
      throw err  if err
      console.log newWish
      res.json newWish

    return

  router.put "/api/wish/:id", passport.authenticate("bearer",
    session: false
  ), oauth2Server.error(), (req, res) ->
    Wish.findOne
      _id: req.params.id
    , (err, wish) ->
      throw err  if err
      return res.send(404)  unless wish?
      if req.user.id isnt wish.userId
        res.json 403,
          reason: "unauthroized access"

      else
        wish.content = req.body.content
        wish.save (err) ->
          throw err  if err
          res.json wish

      return

    return

  router.delete "/api/wish/:id", passport.authenticate("bearer",
    session: false
  ), oauth2Server.error(), (req, res) ->
    Wish.findOne
      _id: req.params.id
    , (err, wish) ->
      throw err  if err
      return res.send(404)  unless wish?
      if req.user.id isnt wish.userId
        res.json 403,
          reason: "unauthroized access"

      else
        Wish.remove
          _id: req.params.id
        , (err) ->
          throw err  if err
          res.send 200

      return

    return

  return

module.exports = initialize
