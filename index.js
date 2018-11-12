//Bitcointalk ANN crawler

var express = require('express');
var app = express();

//GET method route
app.get('/', function(req, res) {
});

app.use(express.static('data'));

// POST method route
app.post('/', function (req, res) {
    console.log(JSON.stringify(req.body));
    res.end();
});

var server = app.listen(9999, function () {
var host = server.address().address;
var port = server.address().port;
  console.log('Data listening at http://%s:%s', host, port);
});
