
function client_summary_update( parentName, data )
{
        var item = data[0];
	console.log("parentName->" + parentName);
        console.log(item)
        var html = "<div class=\"yui3-tabview-panel\">" +
                         "<dl>" +
                                "<dt>Client</dt>" +
                                "<dd>" + item['contact'] + "</dd>" +
                         "</dl>" +
                   "</div>";
        var parent = document.getElementById(parentName);
        parent.innerHTML = html;
}


var clientid = null;
function client_summary_get_data(Y,parentName,clientid)
{
        var handleStart = function(id, a)
        {
            Y.log("io:start firing.", "info", "example");
        }
        var handleSuccess = function(id, o, a)
        {
            Y.log(o.responseText);
            var data = Y.JSON.parse(o.responseText);
            client_summary_update( parentName, data )
        }
        var handleFailure = function(id, o, a)
        {
            Y.log("ERROR " + id + " " + a, "info", "example");
        }
        var cfg =
        {
            sync: true,
            method: "GET",
            xdr: { use:'native' },
            on: {
                start: handleStart,
                success: handleSuccess,
                failure: handleFailure
            }
        };

        var url = "http://127.0.0.1:8124/client?id=1";

        Y.io.header('X-Requested-With');
        var obj = Y.io( url, cfg );

}

function client_summary_init(parentName)
{
        YUI().use('tabview', 'event-custom',"io-xdr", "json-parse", "node",
                function(Y)
                {
                        var id = Y.guid();
                        Y.Global.on('job',
                                function (e)
                                {
                                        if (e.origin !== id)
                                        {
                                                //alert("message received from " + e.origin + ": " + e.message);
                                                Y.log( "client->" +e.message );

                                                clientid = e.message;
                                                client_summary_get_data(Y, parentName, clientid);
                                        }
                                });

                        Y.Global.on('tab',
                                function (e)
                                {
                                        if (e.origin !== id)
                                        {
                                                //alert("client tab message received from " + e.origin + ": " + e.message);
                                                Y.log( "client tab->" + e.message );

                                                var tab = e.message;
                                                client_summary_get_data(Y, parentName, clientid);
                                        }
                                });
                });

}

