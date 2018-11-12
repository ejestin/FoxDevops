const Express = require('express'),
      Request = require('request'),
      Config = require('./config'),
      App = Express();

App.use('/', Express.static('public'))

App.get('/movies', (req, res) => {
    Request.get(Config.BACKEND_URL+"/movies", {}, (err, r, body) => {
        if (err) {
            console.error("Did not work : " + err)
            return;
          }
        console.log("getting " + Config.BACKEND_URL+"/movies")
        res.send(JSON.parse(body))
    })
})

App.listen(Config.PORT, () => {
    console.log('Listening on port', Config.PORT)
})