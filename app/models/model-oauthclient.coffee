mongoose = require("mongoose")
bcrypt = require("bcrypt-nodejs")
utils = require("#{__appbase_dirname}/app/utils/utils")
schema = mongoose.Schema(
  name: String
  clientId: String
  clientSecret: String
  redirectURI: String
  
  # grant_type is 4
  # 'authorization_code', ('implicit',) 'password', 'client_credentials'
  # first item : grant_type string
  # second item : is it possible to refresh token
  grantType: [
    String
    Boolean
  ]
)
schema.pre "save", (next) ->
  return next()  unless @isNew
  @clientId = utils.uid(16)  unless @clientId
  @clientSecret = utils.uid(32)  unless @clientSecret
  next()
  return

module.exports = mongoose.model("OauthClient", schema)
