mongoose = require('mongoose')
dbUrl = 'mongodb://localhost/express-shop'
initialize = ->
  mongoose.connect dbUrl
  return

module.exports.initialize = initialize
