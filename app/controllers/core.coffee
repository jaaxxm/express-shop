'use strict'

path = require 'path'

exports.index = (req, res) ->
  console.log 'requesssstt'
  # res.sendfile('index.html', { root: path.resolve(__dirname + '/dist') })
  # res.render 'index',
  #   user: req.user or null

  return