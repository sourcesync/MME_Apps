//	private, state...
var clp_Y = null;
var clp_event_id = null;
var clp_parent = null;
var clp_current_tab = null;
var clp_clientid = null;
var clp_datatable = null;
var clp_data = null;

function clp_show()
{
	if (clp_clientid && clp_data && clp_data['status'] )
	{
		var ov = clp_data['overview']['overview'];

                var html =      '<div style="height:120px;">';

		//      header...
                html +=         '<div style="height:20px;">\
                                        <div style="top:0px;float:left;">\
                                                <textspan style="font-weight:bold">Client Name:&nbsp;</textspan>\
                                                        <textspan style="font-weight:normal;">' + ov['name'] + '</textspan><br>\
                                        </div><textspan>&nbsp;&nbsp;&nbsp;</textspan>\
                                        <div style="top:0px;float:left;">\
                                                <textspan style="font-weight:bold">&nbsp;&nbsp;&nbsp;&nbsp;Total Projects::&nbsp;</textspan>\
                                                        <textspan style="font-weight:normal;">' + clp_data['data'].length + '</textspan><br>\
                                        </div><textspan>&nbsp;&nbsp;&nbsp;</textspan>\
                                </div>';

		html +=        		'<div style="float:left;margin-left:20px;margin-top:10px;max-height:80px;overflow:auto;" id="clp_datatable"></div>';
		html +=         	'<div style="float:left;margin-left:20px;">' +
                                       		//'<button style="width:130px;" class="pure-button" id="clp_full" onclick="clp_fullview(' + common_selected_jobid + ');" >Full View</button><br>' +
                                	'</div>';
		html +=		'</div>';

		clp_parent.set("innerHTML",html);

		clp_create_table(clp_Y);
	}
	else
	{
		clp_parent.set("innerHTML",'<div style="min-height:100px;"></div>');
	}
}

function clp_fullview(clientid)
{
	alert("Not implemented");
}

function clp_pay(jobid)
{
	make_payment_wizard_show(jobid);
}

function clp_create_table(Y)
{
	if ( clp_datatable )
	{
		clp_datatable.destroy();
		clp_datatable = null;
	}

        var numberFormatter =  function (o)
        {
                var num = o.data['ms'];
                return num + " of 9";
        };
        var milestoneFormatter =  function (o)
        {
                var num = o.data['ms'];
		if (num=="1") return "Job Created";
		else if (num=="2") return "Awaiting Administrator Approval For Test";
		else if (num=="3") return "Ready For Test";
		else if (num=="4") return "Test Completed";
		else if (num=="5") return "Awaiting Client Approval";
		else if (num=="6") return "Test Approved";
		else if (num=="7") return "Awaiting Administrator Approval For Final";
		else if (num=="8") return "Ready For Final";
		else if (num=="9") return "Final Completed";
		else return "Unknown";
        };

	function formatDates(o) {
		var vl = new Date(2006, 5, 1);
            	var dt = Y.DataType.Date.format(vl, { format: "%m/%d/%Y %H:%M" });
		vl = new Date(o.value);
            	dt = Y.DataType.Date.format(vl, { format: "%m/%d/%Y %H:%M"});
        	return vl && dt;
    	};

	function payFormatter(o) {
		return '<button onclick="clp_pay(' + o.data['ii'] + ');" >checkout</button>';
	};

	var cols = [
	   {
                key:"name",
                label:"Project Name",
		sortable:false
           }
	];

	var data = ( clp_data && clp_data['data'] ) ? clp_data['data']: [];

	var rev_data = [];
	for (var i=data.length-1;i>=0;i--)
	{
		var item = data[i];
		rev_data.push(item);
	}
	
        clp_datatable = new Y.DataTable({
                columns:cols,
                data:rev_data,
                summary:"Client Jobs"

                // "selection" config stuff begins here ...
                //highlightMode: 'row',
                //selectionMode: 'row',
                //selectionMulti: false

                }).render("#clp_datatable");


}

function clp_refresh(clientid)
{
	Y = clp_Y;

	clp_clientid = clientid;

        var handleSuccess = function(id, o, a)
        {
            	clp_data = Y.JSON.parse(o.responseText);
		if ( clp_data && clp_data['data'] )
		{
			clp_show();
		}
		else
		{
			clp_show();
		}
        }
        var cfg =
        {
            sync: true,
            method: "GET",
            xdr: { use:'native' },
            on: {
                start: function(id,a) {},
                success: handleSuccess,
                failure: function(id,o,a) { console.log("ERROR: client projects."); }
            }
        };
        
	var url = CONFIG_BASE_URL + "clients?sessionid=" + page_sessionid + "&projects=true&clientid=" + clientid;

        Y.io.header('X-Requested-With');
        var obj = Y.io( url, cfg );
}

function client_projects_init(Y, parentName)
{
	clp_Y = Y;

	clp_event_id = Y.guid();

	clp_parent = Y.Node("#" + parentName);

        //      listen to tab changes in parent...
        common_subscribe_event( Y, "client_summary_tabs", clp_event_id, function(e)
        {
                clp_current_tab = e.message;
		if ((clp_current_tab=="projects") && (common_selected_clientid))
			clp_refresh(common_selected_clientid);
        });
        
	//      listen to selected clientid...
        common_subscribe_event( Y, "selected_clientid", clp_event_id, function(e)
        {
		var new_clientid = e.message;
                if ((clp_current_tab=="projects") && (new_clientid))
                        clp_refresh(new_clientid);
		else
			clp_show();
        });

        //      listen to clients changes...
        common_subscribe_event( Y, "clients_changed", clp_event_id, function(e)
        {
                if ((clp_current_tab=="projects") && (common_selected_clientid))
                        clp_refresh(common_selected_clientid);

        });
        

	clp_show();
}
