oauth2orize = require("oauth2orize")
utils = require("#{__appbase_dirname}/app/utils/utils")
tokenizer = require("#{__appbase_dirname}/app/utils/tokenizer")
predefine = require("./predefine")

# requires databases
AuthorizeCode = require("#{__appbase_dirname}/app/models/model-authorizecode")
Token = require("#{__appbase_dirname}/app/models/model-token")
OauthClient = require("#{__appbase_dirname}/app/models/model-oauthclient")
User = require("#{__appbase_dirname}/app/models/model-user")
server = null
initialize = ->
  
  # create a server for oauth2 provider 
  if server
    console.log "oauth2 server was already initialized!"
    return
  server = oauth2orize.createServer()
  
  # serialization & deserialization 
  server.serializeClient (client, done) ->
    done null, client.clientId

  server.deserializeClient (id, done) ->
    OauthClient.findOne
      clientId: id
    , (err, client) ->
      return done(err)  if err
      done null, client

    return

  setGrant server
  setExchangeToken server
  return

setGrant = (server) ->
  throw Error()  unless server
  
  # register grant for 'code' and 'token' (only two types are supported to user authorization endpoint)
  # The other grant types are directly requested to authroization server from client
  server.grant oauth2orize.grant.code((client, redirectURI, user, ares, done) ->
    AuthorizeCode.findOne
      clientId: client.clientId
      userId: user.id
      redirectURI: redirectURI
    , (err, authCode) ->
      console.log "enter authorization_code type for grant"
      return done(new oauth2orize.AuthorizationError("Error occurs during finding code", "server_error"))  if err
      if authCode is null
        
        # TODO how to generate 'authorize code'
        code = utils.uid(16)
        authCode = new AuthorizeCode()
        
        # save new authorize code into db
        authCode.code = code
        authCode.clientId = client.clientId
        authCode.redirectURI = redirectURI
        authCode.userId = user.id # this id is identifier of User, not email
        authCode.save (err) ->
          return done(new oauth2orize.AuthorizationError("Error occurs during saving code", "server_error"))  if err
          console.log authCode
          done null, code

      else
        done null, authCode.code
      return

    return
  )
  
  # this grant type is used for mobile app or browser based web app
  # client id and redirect uri are needed for get access token
  # in case of mobile native app, redirect uri would have custom scheme
  #  e.g) fb00000000://authorize (this server will redirect it like the following)
  #        --> fb00000000://authroize#access_token=2YotnFZFEjr1zCsicMWpA&expires_in=3600
  # in case of mobile web app, redirect uri would be like the following
  #  e.g) http://example.com/cb
  #      --> http://example.com/cb#access_token=2YotnFZFEjr1zCsicMWpA&expires_in=3600
  server.grant oauth2orize.grant.token((client, user, ares, done) ->
    console.log "clientId: " + client.clientId
    console.log "userId: " + user.id
    Token.findOne
      clientId: client.clientId
      userId: user.id
    , (err, token) ->
      console.log "enter implicit grant"
      return done(new oauth2orize.TokenError("Error occurs during finding token", "server_error"))  if err
      if token is null
        tokenizer.create client.clientId, user.id, predefine.oauth2.type.implicit, (err, newToken) ->
          return done(new oauth2orize.TokenError("Error occurs during creating token", "server_error"))  if err
          console.log "token for implicit type created!: " + newToken
          done null, newToken.accessToken,
            expires_in: newToken.expiredIn


      else
        console.log "token for implicit type exists!: " + token
        
        # check access token expiration
        done null, token.accessToken,
          expires_in: token.expiredIn

      return

    return
  )
  return

setExchangeToken = (server) ->
  throw Error()  unless server
  
  # register exchange to get access token from authorization server
  # 1. grant_type = authorization_code 
  server.exchange oauth2orize.exchange.code((client, code, redirectURI, done) ->
    AuthorizeCode.findOne
      code: code
      clientId: client.clientId
      redirectURI: redirectURI
    , (err, authCode) ->
      return done(new oauth2orize.TokenError("Error occurs during finding given code", "server_error"))  if err
      return done(new oauth2orize.TokenError("The provided authorization grant is not valid", "invalid_grant"))  if authCode is null
      
      # we need to check if access token for this user exists 
      Token.findOne
        clientId: authCode.clientId
        userId: authCode.userId
      , (err, token) ->
        return done(new oauth2orize.TokenError("Error occurs during finding token", "server_error"))  if err
        if token is null
          tokenizer.create authCode.clientId, authCode.userId, predefine.oauth2.type.authorizationCode, (err, newToken) ->
            return done(new oauth2orize.TokenError("Error occurs during creating token", "server_error"))  if err
            done null, newToken.accessToken, newToken.refreshToken,
              expires_in: newToken.expiredIn


        else
          
          # check access token expiration
          done null, token.accessToken, token.refreshToken,
            expires_in: token.expiredIn

        return

      return

    return
  )
  
  # 2. grant_type = password
  server.exchange oauth2orize.exchange.password((client, username, password, scope, done) ->
    console.log "enter exchange function 'password' grant type"
    
    # client is already verified using middleware(basic), but not user
    # check username type 
    query = undefined
    isLocalAccount = false
    switch username
      when "twitter"
        query = "twitter.token": password
      when "facebook"
        query = "facebook.token": password
      when "google"
        query = "google.token": password
      when "yahoo"
        query = "yahoo.token": password
      when "linkedin"
        query = "linkedin.token": password
      when "github"
        query = "github.token": password
      else
        isLocalAccount = true
        query = "local.email": username
    User.findOne query, (err, user) ->
      return done(new oauth2orize.TokenError("Error occurs during finding token", "server_error"))  if err
      return done(new oauth2orize.TokenError("resource owner credential is not correct", "invalid_grant"))  if user is null
      return done(new oauth2orize.TokenError("resource owner credential is not correct", "invalid_grant"))  unless user.validPassword(password)  if isLocalAccount
      
      # we need to check if access token for this user exists 
      Token.findOne
        clientId: client.clientId
        userId: user.id
      , (err, token) ->
        return done(new oauth2orize.TokenError("Error occurs during finding token", "server_error"))  if err
        if token is null
          tokenizer.create client.clientId, user.id, predefine.oauth2.type.password, (err, newToken) ->
            return done(new oauth2orize.TokenError("Error occurs during creating token", "server_error"))  if err
            done null, newToken.accessToken, newToken.refreshToken,
              expires_in: newToken.expiredIn
              user_id: user.id


        else
          
          # check access token expiration
          done null, token.accessToken, token.refreshToken,
            expires_in: token.expiredIn
            user_id: user.id

        return

      return

    return
  )
  
  # 3. grant_type = client_credentials
  server.exchange oauth2orize.exchange.clientCredentials((client, scope, done) ->
    Token.findOne
      clientId: client.clientId
    , (err, token) ->
      return done(new oauth2orize.TokenError("Error occurs during finding token", "server_error"))  if err
      if token is null
        tokenizer.create client.clientId, null, predefine.oauth2.type.clientCredentials, (err, newToken) ->
          return done(new oauth2orize.TokenError("Error occurs during creating token", "server_error"))  if err
          done null, newToken.accessToken, newToken.refreshToken,
            expires_in: newToken.expiredIn


      else
        
        # check access token expiration
        done null, token.accessToken, token.refreshToken,
          expires_in: token.expiredIn

      return

    return
  )
  
  # this exchange is for refreshing access token
  server.exchange oauth2orize.exchange.refreshToken((client, refreshToken, scope, done) ->
    Token.findOne
      clientId: client.clientId
      refreshToken: refreshToken
    , (err, token) ->
      return done(new oauth2orize.TokenError("Error occurs during finding token", "server_error"))  if err
      return done(new oauth2orize.TokenError("This refresh token doesn't exist", "invalid_grant"))  unless token
      tokenizer.refresh token, (err, updatedToken) ->
        return done(new oauth2orize.TokenError("Error occurs during refreshing token", "server_error"))  if err
        done null, updatedToken.accessToken, updatedToken.refreshToken,
          expires_in: updatedToken.expiredIn


      return

    return
  )
  return


# user authorization endpoint
authorize = ->
  [
    error()
    server.authorization((clientId, redirectURI, done) ->
      OauthClient.findOne
        clientId: clientId
        redirectURI: redirectURI
      , (err, oauthClient) ->
        console.log "clientId: " + clientId
        console.log "redirectURI: " + redirectURI
        return done(new oauth2orize.AuthorizationError("Error occurs during finding OAuth client", "server_error"))  if err
        return done(new oauth2orize.AuthorizationError("There is not matched client", "unauthorized_client"))  if oauthClient is null
        done null, oauthClient, redirectURI

      return
    )
    (req, res) ->
      res.render "local_account_oauth",
        transactionID: req.oauth2.transactionID
        user: req.user
        client: req.oauth2.client

  ]

decision = ->
  server.decision()

token = ->
  [
    error()
    server.token()
    server.errorHandler()
  ]

error = ->
  (err, req, res, next) ->
    server.errorHandler() err, req, res  if err
    return

exports.initialize = initialize
exports.authorize = authorize
exports.decision = decision
exports.token = token
exports.error = error
