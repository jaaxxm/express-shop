express = require('express')
faker = require('faker')
cors = require('cors')
path = require('path')
bodyParser = require('body-parser')
jwt = require('jsonwebtoken')
expressJwt = require('express-jwt')

dist = path.join(__dirname, '/dist')

# Util functions and objects
jwtSecret = 'shop-secret'

user =
  username: 'user'
  password: 'p'

authenticate = (req, res, next) ->
  body = req.body
  if not body.username or not body.password
    res.status(400).end 'Must provide username or password'
  if body.username isnt user.username or body.password isnt user.password
    res.status(401).end 'Username or password incorrect'
  next()

# Server config
app = express()

app.use cors()
app.use bodyParser.json()
app.use express.static(dist)
app.use expressJwt({secret: jwtSecret}).unless({path: ['/login']})

app.get '/random-user', (req, res) ->
  user = faker.Helpers.userCard()
  user.avatar = faker.Image.avatar()
  res.json user
  return

app.post '/login', authenticate, (req, res) ->
  token = jwt.sign {username: user.username}, jwtSecret
  res.send {
    token: token,
    user: user
  }
  return

app.get '/me', (req, res) ->
  res.send req.user
  return

app.listen 3000, ->
  console.log 'App listening on port 3000'