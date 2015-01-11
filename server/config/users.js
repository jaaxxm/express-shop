
exports.appname = 'Express Shop';
exports.url = 'http://localhost:3000';

// email settings
exports.emailType = 'nodemailer-smtp-transport';
exports.emailSettings = {
  service: 'Mailgun',
  auth: {
    user: 'postmaster@sandboxe3c01b63aad2426480bebf697ed4d616.mailgun.org',
    pass: 'b34e77e600a2088219e1712afb84ab3f'
  }
};

// lock account
exports.failedLoginsWarning = 3;
exports.failedLoginAttempts = 5;
exports.accountLockedTime = '20 minutes';

// signup settings
exports.signup = {
  route: '/signup',
  tokenExpiration: '1 day',
  views: {
    signup: '',         // input fields 'username', 'email' and 'password' | local variable 'error' | POST /'signup.route'
    linkExpired: '',    // message link has expired | input field 'email' | POST /'signup.route'/resend-verification
    verified: '',       // message email is now verified and maybe link to /'login.route'
    signedUp: '',       // message email has been sent => check your inbox
    resend: ''          // input field 'email' | local variable 'error' | POST /'signup.route'/resend-verification
  },
  handleResponse: true  // let lockit handle the response after signup success
};

// login settings
exports.login = {
  route: '/login',
  logoutRoute: '/logout',
  handleResponse: true  // let lockit handle the response after login/logout success
};

// forgot password settings
exports.forgotPassword = {
  route: '/forgot-password',
  tokenExpiration: '1 day',
  views: {
    forgotPassword: '', // input field 'email' | POST /'forgotPassword.route' | local variable 'error'
    newPassword: '',    // input field 'password' | POST /'forgotPassword.route'/#{token} | local variable 'error'
    changedPassword: '',// message that password has been changed successfully
    linkExpired: '',    // message that link has expired and maybe link to /'forgotPassword.route'
    sentEmail: ''       // message that email with token has been sent
  }
};

// delete account settings
exports.deleteAccount = {
  route: '/delete-account',
  views: {
    remove: '',         // input fields 'username', 'phrase', 'password' | POST /'deleteAccount.route' | local variable 'error'
    removed: ''         // message that account has been deleted
  },
  handleResponse: true  // let lockit handle the response after delete account success
};

// simple white email template
exports.emailTemplate = 'lockit-template-blank';

// from email address
exports.emailFrom = 'info@ridnaua.org';

// email signup template
exports.emailSignup = {
  subject: 'Welcome to <%- appname %>',
  text: [
    '<h2>Hello <%- username %></h2>',
    'Welcome to <%- appname %>.',
    '<p><%- link %> to complete your registration.</p>'
  ].join(''),
  linkText: 'Click here'
};

// signup process -> email already taken
exports.emailSignupTaken = {
  subject: 'Email already registered',
  text: [
    '<h2>Hello <%- username %></h2>',
    'you or someone else tried to sign up for <%- appname %>.',
    '<p>Your email is already registered and you cannot sign up twice.',
    ' If you haven\'t tried to sign up, you can safely ignore this email. Everything is fine!</p>',
    '<p>The <%- appname %> Team</p>'
  ].join('')
};

// signup process -> resend email with verification link
exports.emailResendVerification = {
  subject: 'Complete your registration',
  text: [
    '<h2>Hello <%- username %></h2>',
    'here is the link again. <%- link %> to complete your registration.',
    '<p>The <%- appname %> Team</p>'
  ].join(''),
  linkText: 'Click here'
};

// forgot password
exports.emailForgotPassword = {
  subject: 'Reset your password',
  text: [
    '<h2>Hey <%- username %></h2>',
    '<%- link %> to reset your password.',
    '<p>The <%- appname %> Team</p>'
  ].join(''),
  linkText: 'Click here'
};


// settings for local MongoDB
exports.db = {
  url: 'mongodb://localhost:27017/',
  name: 'expressshop-dev',
  collection: 'users'
};

// using rest
exports.rest = {

  // set starting page for single page app
  index: '../../dist/index.html',

  // use view engine (render()) or send static file (sendfile())
  useViewEngine: false

};
