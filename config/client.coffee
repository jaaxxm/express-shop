ASSETS =
  lib:
    css: []
    js: [
      'public/lib/hammerjs/hammer.js'
      'public/lib/angular/angular.js'
      'public/lib/angular-messages/angular-messages.js'
      'public/lib/angular-animate/angular-animate.js'
      'public/lib/angular-aria/angular-aria.js'
      'public/lib/ui-router/release/angular-ui-router.js'
      'public/lib/angular-material/angular-material.js'
      'public/lib/angular-local-storage/dist/angular-local-storage.js'
    ]
  css: [
    'public/assets/styles/*.css'
  ]
  modules: [
    'js/config.js'
    'js/accessConfig.js'
    'js/app.js'
    'js/**/*.js'
  ]
  tests: []

module.exports = {ASSETS}