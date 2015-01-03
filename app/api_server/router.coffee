express = require('express')
passport = require('passport')

# var socialStrategy = require('./social-strategy');
User = require("#{__appbase_dirname}/app/models/model-user")
initialize = (app) ->
  setPassport()
  setApiRoutes app
  return

setPassport = ->
  
  # initialize passport 
  passport.serializeUser (user, done) ->
    
    #console.log('Serialization: ' + user);
    done null, user.id
    return

  passport.deserializeUser (id, done) ->
    
    #console.log('Deserialization: ' + id);
    User.findById id, (err, user) ->
      
      #console.log(user);
      done err, user
      return

    return

  return


# socialStrategy.initialize();
setApiRoutes = (router) ->
  require('./api/local-login') router
  
  # require('./api/social-login')(router);
  require('./api/connect') router
  require('./api/profile') router
  require('./api/wish') router
  return

module.exports.initialize = initialize
