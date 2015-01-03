passport = require('passport')
BasicStrategy = require('passport-http').BasicStrategy
PublicClientStrategy = require('passport-oauth2-public-client').Strategy
BearerStrategy = require('passport-http-bearer').Strategy
OauthClient = require("#{__appbase_dirname}/app/models/model-oauthclient")
Token = require("#{__appbase_dirname}/app/models/model-token")
User = require("#{__appbase_dirname}/app/models/model-user")
oauth2orize = require('oauth2orize')
oauth2Server = require('./server')
oauth2TestClients = require('./test-clients')
predefine = require('./predefine')
tokenizer = require("#{__appbase_dirname}/app/utils/tokenizer")
url = require('url')
querystring = require('querystring')
initialize = (router) ->
  
  # oauth2 server start to run
  oauth2Server.initialize()
  oauth2TestClients()
  
  # set routes for oauth2
  setPassportStrategy()
  setRouter router
  return

setPassportStrategy = ->
  
  # our oauth server recieves client credentials for only two grant types. 
  #  * Authorization Code grant type
  #  * Resource Owner Credentials Password type
  #  * Client Credential grant type
  # because this request will be done by backend server of 3rd party app which can keep client secret securely.
  # To get access token, backend server of 3rd party app must request grant based on 'Authorization Basic' of http header which include client id and secret
  passport.use new BasicStrategy(
    passReqToCallback: true
  , (req, clientId, clientSecret, done) ->
    console.log 'enter basic strategy'
    unless req.body.grant_type
      error = new oauth2orize.TokenError('there is no grant_type field in body', 'invalid_request')
      return done(error)
    switch req.body.grant_type
      when predefine.oauth2.type.authorizationCode.name, predefine.oauth2.type.password.name, predefine.oauth2.type.clientCredentials.name
      else
        error = new oauth2orize.TokenError("This client cannot be used for #{req.body.grant_type}", 'unsupported_grant_type')
        return done(error)
    
    # validate client credential
    OauthClient.findOne
      clientId: clientId
      clientSecret: clientSecret
    , (err, oauthClient) ->
      if err
        error = new oauth2orize.TokenError('server error during validating client credential', 'server_error')
        return done(error)
      if oauthClient is null
        
        # this error will be handled by oauth2orize
        error = new oauth2orize.TokenError('Client authentication failed', 'invalid_client')
        return done(error)
      done new oauth2orize.TokenError("This client cannot be used for #{req.body.grant_type}", 'unsupported_grant_type')  if oauthClient.grantType[0] isnt req.body.grant_type
      done null, oauthClient

    return
  )
  passport.use new PublicClientStrategy(
    passReqToCallback: true
  , (req, clientId, done) ->
    console.log 'enter public client strategy'
    switch req.body.grant_type
      when predefine.oauth2.type.clientCredentials.name
        OauthClient.findOne
          clientId: req.body.client_id
        , (err, oauthClient) ->
          return done(new oauth2orize.TokenError('Error occurs during finding client', 'server_error'))  if err
          return done(new oauth2orize.TokenError('This client does not exist', 'invalid_client'))  unless oauthClient
          return done(new oauth2orize.TokenError("This client cannot be used for #{req.body.grant_type}", 'unsupported_grant_type'))  if oauthClient.grantType[0] isnt req.body.grant_type
          
          # if there is no error, oauth2 processing is continued
          done null, oauthClient

      else
        
        # this error will be handled by oauth2orize
        error = new oauth2orize.TokenError("#{req.body.grant_type} type is not supported", 'unsupported_grant_type')
        done err
  )
  passport.use new BearerStrategy(
    passReqToCallback: true
  , (req, accessToken, done) ->
    console.log 'bearer stretegy'
    tokenizer.validate accessToken, (err, token) ->
      return done(err)  if err
      User.findOne
        _id: token.userId
      , (err, user) ->
        return done(err)  if err
        unless user
          return done(null, false,
            reason: 'invalid-user'
          )
        
        # token info can be used for handling REST API
        # so token info is set to result which is returned after authentication 
        user.tokenInfo = token
        done null, user

      return

    return
  )
  return

setRouter = (router) ->
  
  # Just for authorization code, implicit grant type
  router.get '/oauth2/authorize', isLogined, oauth2Server.authorize()
  router.post '/oauth2/authorize/decision', isLogined, oauth2Server.decision()
  
  # Authenticate client and create access token 
  # 'basic' strategy: 'Authorization Code', 'Client Credential' grant type
  # 'public-client' strategy: 'Implicit', 'Resource owner password' type
  router.post '/oauth2/token', ((req, res, next) ->
    console.log 'session: ' + JSON.stringify(req.session)
    next()
    return
  ), passport.authenticate([
    'basic'
    'oauth2-public-client'
  ],
    session: false
  ), oauth2Server.token()
  
  # Delete access token for all grant types
  router.delete '/oauth2/token', passport.authenticate('bearer',
    session: false
  ), (req, res) ->
    console.log 'bearer strategy for token delete'
    Token.remove
      accessToken: req.user.tokenInfo.accessToken
      userId: req.user._id
    , (err) ->
      if err
        
        # TODO need to set proper error
        res.send 400
      else
        res.send 200
      return

    return

  
  # TODO in real practice, this route should be removed!!
  # this is just for test of dummy 3rd party app
  # if there is no error, this 3rd party app server should exchange token using received code
  # otherwise, 3rd party app server should handle error along to error type
  # (we just print received code here)
  router.get '/oauth2/authorize/callback', (req, res) ->
    console.log 'Redirected by authorization server'
    ret = {}
    if req.query.code
      ret.code = req.query.code
      ret.state = req.query.state
    else if req.query.access_token
      ret.access_token = req.query.access_token
      ret.refresh_token = req.query.refresh_token
      ret.expires_in = req.query.expires_in
      ret.scope = req.query.scope
      ret.state = req.query.state
      ret.token_type = req.query.token_type
    else if req.query.error
      ret.error = req.query.error
      ret.error_description = req.query.error_description
      ret.error_uri = req.query.error_uri
    else
      console.log 'invalid callback'
    console.log "req url: #{req.originalUrl}"
    
    # this sending is not meaningful, just for finishing response
    res.json ret
    return

  return

isLogined = (req, res, next) ->
  return next()  if req.isAuthenticated()
  
  # this error will be handled by oauth2orize
  error = new oauth2orize.TokenError('authorization server denied this request', 'access_denied')
  next error

module.exports.initialize = initialize
