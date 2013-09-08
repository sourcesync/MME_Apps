var express = require('express')
var processs = require('process');
var http = require('http')
var path = require('path');

//var metrics = require('./routes/metrics');

//
//	initialize express...
//
var app = express();

app.set('port', process.env.PORT || 80);
app.set('views', __dirname + '/views');
app.set('view engine', 'jade');
app.use( express.favicon());
app.use( express.logger('dev'));

app.use(express.bodyParser({ keepExtensions: true, uploadDir: global.TMP_POST_DIR }));
app.use(express.methodOverride());
app.use(app.router);

var oneYear = 31557600000;
app.use("/js",express.static('js',{maxAge:oneYear}));

// development only
if ('development' == app.get('env')) 
{
	app.use(express.errorHandler());
}

app.all('/*', function(req, res, next) {
  res.header("Access-Control-Allow-Origin", "*");
  res.header("Access-Control-Allow-Headers", "X-Requested-With");
  next();
});

http.createServer(app).listen(app.get('port'), "127.0.0.1", function()
{
	console.log('Express server listening on port ' + app.get('port'));
});

