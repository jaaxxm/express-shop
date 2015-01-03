mongoose = require("mongoose")
schema = mongoose.Schema(
  userId: String
  content: String
  modifiedTime: Number
  createdTime: Number
)
schema.pre "save", (next) ->
  unless @isNew
    @modifiedTime = Date.now()
    return next()
  @createdTime = Date.now()
  @modifiedTime = @createdTime
  next()
  return


# create the model and expose it to our app
module.exports = mongoose.model("Wish", schema)
