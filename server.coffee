express = require('express')
faker = require('faker')
cors = require('cors')
path = require('path')

dist = path.join(__dirname, '/dist')

app = express()

app.use(cors())
app.use express.static(dist)

app.get '/random-user', (req, res) ->
  user = faker.Helpers.userCard()
  user.avatar = faker.Image.avatar()
  res.json user

app.listen 3000, ->
  console.log 'App listening on port 3000'