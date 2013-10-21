
var express	= require('express');
var http 	= require('http'); 
var execSync	= require('execSync')
var urllib	= require('url');

//console.log(http);
//console.log(express);

var app		= express();

app.set( 'port', 80 );
app.use( "/static", express.static("static"));
app.use( express.methodOverride() );

function write_header(res)
{
	res.writeHead(200, {
		'Content-Type':'text/plain',
		'Access-Control-Allow-Origin':'*',
		'Access-Control-Allow-Headers':'X-Requested-With'
	});
}

function respond_with_status(res, status)
{
	var statusstr = JSON.stringify(status);
	write_header(res);
	res.end(statusstr);
}


app.get("/printers", function(req,res) {
	var result = execSync.exec('getprinters.bat')['stdout'];
	var regex = /Printer name (.*)/g;
	var printers = [];
	var match = regex.exec(result);
	while (match!=null)
	{
		printers.push( match[1] );
		match = regex.exec(result);
	}
	return respond_with_status( res, {'status':true, 'data':printers} );
});

app.post("/print",
	express.bodyParser({keepExtensions:true, uploadDir: "/tmp/upload"}),
	function (req,res) {
		console.log( req['files'] );
		console.log( req['files']['filedata']['path'] );
		return respond_with_status( res, {'status':true} );
	}
);

app.all('/*', function( req, res, next ) {
	res.header('Access-Control-Allow-Origin', '*' );
	res.header('Acesss-Control-Allow-Headers','X-Requested-With');
	next();
});

http.createServer(app).listen( app.get('port'), "10.0.0.6", function() {
	console.log('Express server listening on port ' + app.get('port'));
});

