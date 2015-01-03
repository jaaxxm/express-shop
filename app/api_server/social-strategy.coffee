passport = require("passport")
FacebookStrategy = require("passport-facebook").Strategy
GoogleStrategy = require("passport-google-oauth").OAuth2Strategy
GithubStrategy = require("passport-github").Strategy
LinkedinStrategy = require("passport-linkedin-oauth2").Strategy
TwitterStrategy = require("passport-twitter").Strategy
YahooStrategy = require("passport-yahoo-oauth").Strategy
oauthInfo = require("./oauth-info")
User = require("#{__appbase_dirname}/app/models/model-user")
module.exports.initialize = ->
  registerSocialAccount = (name, info, loginedUser, done) ->
    
    #var search = {};
    s = "{ \"" + name + ".id\": \"" + info.id + "\" }"
    search = JSON.parse(s)
    User.findOne search, (err, user) ->
      if err
        console.error err
        return done(err)
      
      # TODO in case of connect, how to handle this?
      if user
        console.log name + " account already exists!"
        return done(null, user)
      else
        console.log "user not found"
      changedUser = undefined
      if loginedUser
        console.log name + " account is appended to logined user"
        changedUser = loginedUser
      else
        console.log name + " account is not yet logined!"
        changedUser = new User()
      eval "changedUser." + name + " = info"
      changedUser.save (err) ->
        if err
          console.error err
          return done(err)
        done null, changedUser

      return

    return

  passport.use new TwitterStrategy(
    consumerKey: oauthInfo.twitter.consumerKey
    consumerSecret: oauthInfo.twitter.consumerSecret
    callbackURL: oauthInfo.twitter.callbackURL
    passReqToCallback: true
  , (req, token, tokenSecret, profile, done) ->
    console.log "twitter stragtegy"
    registerSocialAccount "twitter",
      id: profile.id
      token: token
      tokenSecret: tokenSecret
      displayName: profile.displayName
      photo: profile.photos[0].value
    , req.user, done
    return
  )
  passport.use new FacebookStrategy(
    clientID: oauthInfo.facebook.appId
    clientSecret: oauthInfo.facebook.appSecret
    callbackURL: oauthInfo.facebook.callbackURL
    
    #profileFields: ['id', 'displayName', 'photos'],
    passReqToCallback: true
  , (req, token, refreshToken, profile, done) ->
    console.log "facebook stragtegy"
    registerSocialAccount "facebook",
      id: profile.id
      token: token
      refreshToken: refreshToken
      displayName: profile.name.familyName + " " + profile.name.givenName
      email: (profile.emails[0].value or "").toLowerCase()
    , req.user, done
    return
  )
  passport.use new GoogleStrategy(
    clientID: oauthInfo.google.clientId
    clientSecret: oauthInfo.google.clientSecret
    callbackURL: oauthInfo.google.callbackURL
    passReqToCallback: true
  , (req, token, refreshToken, profile, done) ->
    console.log "google+ stragtegy"
    registerSocialAccount "google",
      id: profile.id
      token: token
      refreshToken: refreshToken
      displayName: profile.displayName
      email: profile.emails[0].value
      photo: profile._json.picture
    , req.user, done
    return
  )
  passport.use new YahooStrategy(
    consumerKey: oauthInfo.yahoo.consumerKey
    consumerSecret: oauthInfo.yahoo.consumerSecret
    callbackURL: oauthInfo.yahoo.callbackURL
    passReqToCallback: true
  , (req, token, refreshToken, profile, done) ->
    console.log "yahoo stragtegy"
    registerSocialAccount "yahoo",
      id: profile.id
      token: token
      refreshToken: refreshToken
    , req.user, done
    return
  )
  passport.use new LinkedinStrategy(
    clientID: oauthInfo.linkedin.apiKey
    clientSecret: oauthInfo.linkedin.secretKey
    callbackURL: oauthInfo.linkedin.callbackURL
    passReqToCallback: true
  , (req, token, refreshToken, profile, done) ->
    console.log "linkedin stragtegy"
    registerSocialAccount "linkedin",
      id: profile.id
      token: token
      refreshToken: refreshToken
      displayName: profile.displayName
      email: profile.emails[0].value
      industry: profile._json.industry
      headline: profile._json.headline
      photo: profile._json.pictureUrl
    , req.user, done
    return
  )
  passport.use new GithubStrategy(
    clientID: oauthInfo.github.clientId
    clientSecret: oauthInfo.github.clientSecret
    callbackURL: oauthInfo.github.callbackURL
    scope: [
      "user"
      "repo"
      "read:public_key"
    ]
    passReqToCallback: true
  , (req, token, refreshToken, profile, done) ->
    console.log "github stragtegy"
    registerSocialAccount "github",
      id: profile.id
      token: token
      refreshToken: refreshToken
      displayName: profile.username
      email: profile.emails[0].value
      photo: profile._json.avatar_url
    , req.user, done
    return
  )
  return
