var COMM_DEBUG = false;

function comm_get_sync( uri, dct, cb_success, cb_fail )
{
	//	YUI IO success callback...
        var gethandleSuccess = function(id, o, a)
        {
       		if (COMM_DEBUG) Y.log("YIO: success: ",o.responseText);
	
	    	// parse the json response...
            	var status = Y.JSON.parse(o.responseText);

		// invoke callback...
		if ( a && a.success )
		{
			var _cb_success = a.success;
			_cb_success( status );
		}
        }
	
	//	YUI IO failure callback...
	var gethandleFailure = function(id, o, a )
	{
		if (COMM_DEBUG) Y.log("YIO: failure: ",id,o,a);

		if ( a && a.failure )
		{
			var _cb_fail = a.failure;
			if (_cb_fail) _cb_fail( );
		}
	}

	//	YUI IO config object...
        var cfg =
        {
            sync: true,
            method: "GET",
            xdr: { use:'native' },
            on: // callback funcs...
		{
                	start: 		function(id,a) {},
                	success: 	gethandleSuccess,
                	failure:  	gethandleFailure
            	},
	    arguments: // arguments for callback funcs...
		{
			start: null,
			success: cb_success,
			failure: cb_fail
		}
        };

	// always add session...
	var parms = "?sessionid=" + page_sessionid;

	// iterate args dct and compose the get params...
	if (dct) 
	{
		for ( ky in dct )
		{
			parms += "&";
	
			var val = dct[ky] + "";  // stringify
			parms += ky + "=" + val
		}
	}

	//	form the url...	
        var url = CONFIG_BASE_URL + uri + parms;

	//	make the request synchronous...
        Y.io.header('X-Requested-With');
        var retv = Y.io( url, cfg );
	// TODO: parse this obj for status possibly...

        return retv;
}

function comm_post_sync( uri, dct, obj, cb_success, cb_fail )
{
        //      YUI IO success callback...
        var posthandleSuccess = function(id, o, a)
        {
                if (COMM_DEBUG) Y.log("YIO: success: ",o.responseText);

                // parse the json response...
                var status = Y.JSON.parse(o.responseText);

                // invoke callback...
		if ( a && a.success )
		{
                	var _cb_success = a.success;
                	_cb_success( status );
		}
        }

        //      YUI IO failure callback...
        var posthandleFailure = function(id, o, a )
        {
                if (COMM_DEBUG) Y.log("YIO: failure: ",id,o,a);
		if ( a && a.failure )
		{
                	var _cb_fail = a.failure;
                	if (_cb_fail) _cb_fail( );
		}
        }

	//	YUI IO config object...
       	var cfg =
        {
        	sync: true,
            	method: "POST",
            	xdr: { use:'native' },
            	data: Y.JSON.stringify( obj ),
            	headers:
                {
                        'Content-Type': 'text/plain',
                },
            	on:
                {
                        start: function(id,a) {},
                        success: posthandleSuccess,
                        failure: posthandleFailure
                },
		arguments:
		{
			start: null,
			success: cb_success,
			failure: cb_fail
		}
        };

       	// always add session...
        var parms = "?sessionid=" + page_sessionid;

        // iterate args dct and compose the get params...
        if (dct)
        {
                for ( ky in dct )
                {
                        parms += "&";

                        var val = dct[ky] + "";  // stringify
                        parms += ky + "=" + val
                }
        }

        //      form the url...
        var url = CONFIG_BASE_URL + uri + parms;

        //      make the request synchronous...
        Y.io.header('X-Requested-With');
        var retv = Y.io( url, cfg );
        // TODO: parse this obj for status possibly...

        return retv;
}


