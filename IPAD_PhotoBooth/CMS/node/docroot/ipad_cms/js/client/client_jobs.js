//	private, state...
var cj_Y = null;
var cj_event_id = null;
var cj_parent = null;
var cj_current_tab = null;
var cj_clientid = null;
var cj_datatable = null;
var cj_data = null;

function cj_show(clientid, jobs, overview)
{
	cj_clientid = clientid;

	if (clientid)
	{
		var html = "";

                var html =      '<div style="height:100px;">';

                html +=         '<div>';
                html +=                 '<div style="height:20px;top:0px;float:left;">\
                                                <textpan style="font-weight:bold">Name:&nbsp;</textspan>\
                                                        <textspan style="font-weight:normal;">' + overview['name'] + '</textspan><br>\
                                        </div>\
                                        <textspan>&nbsp;&nbsp;&nbsp;</textspan>\
                                        <div style="top:0px;float:left;">\
                                                <textpan style="font-weight:bold">&nbsp;&nbsp;&nbsp;&nbsp;NetID:&nbsp;</textspan>\
                                                        <textspan style="font-weight:normal;">' + overview['netid'] + '</textspan><br>\
                                        </div>\
                                        <textspan>&nbsp;&nbsp;&nbsp;</textspan>\
                                        <div style="top:0px;float:left;">\
                                                <textpan style="font-weight:bold">&nbsp;&nbsp;&nbsp;&nbsp;Department:&nbsp;</textspan>\
                                                        <textspan style="font-weight:normal;">' + overview['dept'] + '</textspan><br>\
                                        </div>\
                                        <textspan>&nbsp;&nbsp;&nbsp;</textspan>\
                                        <div style="top:0px;float:left;">\
                                                <textpan style="font-weight:bold">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</textspan>\
                                                        <textspan style="font-weight:normal;">' + '' + '</textspan><br>\
                                        </div>';
                html +=                 '<div style="clear:both;width:0px;"></div>'
                html +=         '</div>';

	
/*

                                        // header...
                        var html =      '<div style="height:20px;">\
                                        <div style="top:0px;float:left;">\
                                                <textpan style="font-weight:bold">Order Number:&nbsp;</textspan>\
                                                        <textspan style="font-weight:normal;">' + overview['jid'] + '</textspan><br>\
                                        </div><textspan>&nbsp;&nbsp;&nbsp;</textspan>\
                                        <div style="top:0px;float:left;">\
                                                <textpan style="font-weight:bold">&nbsp;&nbsp;&nbsp;&nbsp;Service:&nbsp;</textspan>\
                                                        <textspan style="font-weight:normal;">' + overview['type'] + '</textspan><br>\
                                        </div><textspan>&nbsp;&nbsp;&nbsp;</textspan>\
                                        <div style="top:0px;float:left;">\
                                                <textpan style="font-weight:bold">&nbsp;&nbsp;&nbsp;&nbsp;Device:&nbsp;</textspan>\
                                                        <textspan style="font-weight:normal;">' + overview['device'] + '</textspan><br>\
                                        </div><textspan>&nbsp;&nbsp;&nbsp;</textspan>\
                                        <div style="top:0px;float:left;">\
                                                <textpan style="font-weight:bold">&nbsp;&nbsp;&nbsp;&nbsp;Client:&nbsp;</textspan>\
                                                        <textspan style="font-weight:normal;">' + overview['clientname'] + '</textspan><br>\
                                        </div>\
                                </div>';

               html += '<div style="min-height:100px;min-width:200px;" >' +
				'<button class="pure-button" style="float:left;" id="cm_button" onclick="" >Update</button>' +
                                '<div style="float:left;margin-left:20px;max-height:60px;overflow:auto;" id="jmp_datatable"></div>' +
				'<button class="pure-button" style="float:left;" id="cj_full" onclick="cj_fullview(' + jobid + ',' + msval + ');" >Full View</button>' +
                                '<div style="both:clear;width:0px;"></div>' +
			'</div>';
		

*/
		
		html +=        		'<div style="width:400px;max-width:400px;float:left;margin-left:20px;max-height:80px;overflow:auto;" id="cj_datatable"></div>';
		 html +=         	'<div style="float:left;margin-left:20px;">' +
                                       		'<button style="width:130px;" class="pure-button" id="cj_full" onclick="cj_fullview(' + common_selected_jobid + ');" >Full View</button><br>' +
                                	'</div>';
		html +=		'</div>';

		cj_parent.set("innerHTML",html);

		cj_create_table(cj_Y);
	}
	else
	{
		cj_parent.set("innerHTML",'<div style="min-height:100px;"></div>');
	}
}

function cj_fullview(clientid)
{
	alert("Not implemented");
}

function cj_pay(jobid)
{
	make_payment_wizard_show(jobid);
}

function cj_create_table(Y)
{
	if ( cj_datatable )
	{
		cj_datatable.destroy();
		cj_datatable = null;
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
		return '<button onclick="cj_pay(' + o.data['ii'] + ');" >checkout</button>';
	};

	var cols = [
	   {
                key:"jid",
                label:"Order Number",
		sortable:false
           },
	   {
                key:"type",
                label:"Service",
		sortable:false
           },
	   {
		key:'ii',
		label:"Payment",
		allowHTML: true,
		formatter: payFormatter
	  }
	   ];

	var data = ( cj_data && cj_data['jobs'] ) ? cj_data['jobs']: [];

	var rev_data = [];
	for (var i=data.length-1;i>=0;i--)
	{
		var item = data[i];
		rev_data.push(item);
	}
	
        cj_datatable = new Y.DataTable({
                columns:cols,
                data:rev_data,
                summary:"Client Jobs"

                // "selection" config stuff begins here ...
                //highlightMode: 'row',
                //selectionMode: 'row',
                //selectionMulti: false

                }).render("#cj_datatable");


}

function cj_refresh(clientid)
{
	console.log("cj_refresh: clientid");

	Y = cj_Y;

	cj_clientid = clientid;

        var handleSuccess = function(id, o, a)
        {
            	Y.log(o.responseText);
            	cj_data = Y.JSON.parse(o.responseText);
		if ( cj_data && cj_data['jobs'] )
		{
			var overview = cj_data['overview'];
			var jobs = cj_data['jobs'];
			var overview = cj_data['overview'];
			cj_show( cj_clientid, jobs, overview);
		}
		else
		{
			cj_show(null,null,null);
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
                failure: function(id,o,a) { console.log("ERROR: jc"); }
            }
        };
        
	var url = CONFIG_BASE_URL + "clients?sessionid=" + page_sessionid + "&jobs=true&clientid=" + clientid;

        Y.io.header('X-Requested-With');
        var obj = Y.io( url, cfg );
}

function client_jobs_init(Y, parentName)
{
	cj_Y = Y;

	cj_event_id = Y.guid();

	cj_parent = Y.Node("#" + parentName);

        //      listen to tab changes in parent...
        common_subscribe_event( Y, "client_summary_tabs", cj_event_id, function(e)
        {
                Y.log( "client_jobs: jobs_listviews_tab event sink->" + e.message );
                cj_current_tab = e.message;
		if ((cj_current_tab=="jobs") && (common_selected_clientid))
			cj_refresh(common_selected_clientid);
        });
        
	//      listen to selected clientid...
        common_subscribe_event( Y, "selected_clientid", cj_event_id, function(e)
        {
                console.log("client_jobs: selected_clientid event sink->", e.message);
		var new_clientid = e.message;
                if ((cj_current_tab=="jobs") && (new_clientid))
                        cj_refresh(new_clientid);
		else
			cj_show(null,null,null);
        });

        //      listen to clients changes...
        common_subscribe_event( Y, "clients_changed", cj_event_id, function(e)
        {
                console.log("client_jobs: clients_changed event sink->", e.message);
                if ((cj_current_tab=="jobs") && (common_selected_clientid))
                        cj_refresh(common_selected_clientid);

        });
        

	cj_show(null,null,null);
}
