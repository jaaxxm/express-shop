mongoose = require("mongoose")
schema = mongoose.Schema(
  accessToken: String
  refreshToken: String
  expiredIn: Number
  clientId: String
  userId: String
  createdTime: Number
)
schema.pre "save", (next) ->
  return next()  unless @isNew
  @createdTime = Date.now()
  next()
  return


# create the model for users and expose it to our app
module.exports = mongoose.model("AccessToken", schema)
