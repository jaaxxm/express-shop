###*
Return a unique identifier with the given `len`.

utils.uid(10);
// => "FDaS435D2z"

@param {Number} len
@return {String}
@api private
###

###*
Return a random int, used by `utils.uid()`

@param {Number} min
@param {Number} max
@return {Number}
@api private
###
getRandomInt = (min, max) ->
  Math.floor(Math.random() * (max - min + 1)) + min
exports.uid = (len) ->
  buf = []
  chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
  charlen = chars.length
  i = 0

  while i < len
    buf.push chars[getRandomInt(0, charlen - 1)]
    ++i
  buf.join ""
