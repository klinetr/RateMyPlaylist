module.exports = {

    confirm: id => ({
      subject: 'Please confirm your email to use RateMyPlaylist!',
      html: `
        <a href='https://ratemyplaylist0.herokuapp.com/confirm'>
          Click here to confirm email
        </a>
      `,      
      text: `Copy and paste this link: https://ratemyplaylist0.herokuapp.com/confirm`
    }),

    fconfirm: id => ({
      subject: 'Reset Password',
      html: `
        <a href='https://ratemyplaylist0.herokuapp.com/password'>
          Click here to reset your password
        </a>
      `,      
      text: `Copy and paste this link: https://ratemyplaylist0.herokuapp.com/password`
    })
    
  }