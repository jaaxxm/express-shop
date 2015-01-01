express = require('express')
faker = require('faker')
cors = require('cors')
path = require('path')
bodyParser = require('body-parser')

dist = path.join(__dirname, '/dist')

# Server config
app = express()

app.use cors()
app.use bodyParser.json()
app.use express.static(dist)

app.get '/random-user', (req, res) ->
  user = faker.Helpers.userCard()
  user.avatar = faker.Image.avatar()
  res.json user
  return

app.get '/me', (req, res) ->
  res.send req.user
  return

# We use html5 mode, so we need redirect all pages to index
app.get '/*', (req, res) ->
  res.sendFile(__dirname + '/dist/index.html')
  return

app.listen 3000, ->
  console.log 'App listening on port 3000'