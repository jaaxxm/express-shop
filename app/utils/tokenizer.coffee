oauth2orize = require("oauth2orize")
Token = require("#{__appbase_dirname}/app/models/model-token")
utils = require("./utils")
createToken = (clientId, userId, grantType, cb) ->
  token = new Token()
  token.accessToken = utils.uid(256)
  token.refreshToken = utils.uid(256)  if grantType.token_refreshable
  token.expiredIn = grantType.token_duration
  token.clientId = clientId
  token.userId = userId
  
  # TODO add scope
  token.save (err) ->
    return cb(err)  if err
    cb err, token

  return

refreshToken = (token, cb) ->
  return cb(new Error())  unless token
  
  # recreate access token
  token.accessToken = utils.uid(256)
  token.createdTime = Date.now()
  
  # TODO update scope
  Token.update
    clientId: token.clientId
    userId: token.userId
    refreshToken: token.refreshToken
  ,
    accessToken: token.accessToken
    createdTime: token.createdTime
  , (err, result) ->
    return cb(new Error())  if err
    cb err, token

  return

validateToken = (accessToken, cb) ->
  return cb(new oauth2orize.TokenError("access token is not given", "invalid_request"))  unless accessToken
  Token.findOne
    accessToken: accessToken
  , (err, token) ->
    return cb(err)  if err
    return cb(new oauth2orize.TokenError("There is not matched access token", "invalid_grant"))  if token is null
    if (Date.now() - token.createdTime) > (token.expiredIn * 1000)
      console.log "token is expired!!"
      return cb(new oauth2orize.TokenError("given access token was expired", "invalid_grant"))
    cb null, token

  return

module.exports.create = createToken
module.exports.refresh = refreshToken
module.exports.validate = validateToken
