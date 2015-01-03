mongoose = require("mongoose")
bcrypt = require("bcrypt-nodejs")
schema = mongoose.Schema(
  code: String
  redirectURI: String
  clientId: String
  userId: String
)
module.exports = mongoose.model("AuthorizeCode", schema)
