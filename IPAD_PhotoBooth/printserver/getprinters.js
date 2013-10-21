
var express	= require('express');
var http 	= require('http'); 
var execSync	= require('execSync')

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

app.post("/upload",
	express.bodyParser({keepExtensions:true, uploadDir: "/tmp/upload"}),
	function (req,res) {
		//console.log( req.files );
		console.log( req.files['filedata']['path'] );
		var result = execSync.exec('getprinters.bat')['stdout'];
		console.log(result);
		var regex = /Printer name (.*)/g;
		var match = regex.exec(result);
		while (match!=null)
		{
			console.log(match[1]);
			match = regex.exec(result);
		}
		return respond_with_status( res, {'status':true} );
	}
);

app.all('/*', function( req, res, next ) {
	res.header('Access-Control-Allow-Origin', '*' );
	res.header('Acesss-Control-Allow-Headers','X-Requested-With');
	next();
});

http.createServer(app).listen( app.get('port'), "127.0.0.1", function() {
	console.log('Express server listening on port ' + app.get('port'));
});

