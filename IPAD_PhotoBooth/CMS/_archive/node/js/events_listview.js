//	private, state...

var ev_Y = null;
var ev_datatable = null;
var ev_event_id = null;
var ev_data = null;
var ev_current_tab = null;

//<ul id="ev_paginator" style="margin-right:12px;position:fixed;right:0px;" class="pure-paginator">\

function events_listview_init(Y, parentName)
{
	ev_Y = Y;

	//	id for events...
	ev_event_id = Y.guid();

	//	create the html for the region...
	var html = 	'<div id="ev_parent" style="height:100%" class="pure-skin-mine4">\
				<div id="ev_datatable" ></div>\
				</ul>\
			</div>';
	var el = Y.Node.create(html);
	var parent = Y.Node('#' + parentName);
	parent.append( el );	

}

function events_listview_show(Y)
{
	//ev_data = ev_get_data(Y, serviceuid, deviceuid, search, findjob, page);
}

function ev_create_table(Y)
{

	//	destroy last table...	
	if ( ev_datatable)
	{
		ev_datatable.destroy();
		ev_datatable = null;
	}

/*
	var gen_onclick = function(i)
	{
		return 'ev_page(' + i +');';
	};
*/

	//common_config_paginator('ev_paginator', ev_data['paging'], null, gen_onclick);

	var serviceFormatter = function(o)
	{
		var icon = o.data['icon'];
		return '<img style="max-height:25px;" src="' + icon + '"></img>';
	};

	var paymentFormatter =  function (o)
        {
        	var onclick = 'ev_checkout("' + o.data['jobid'] + '");'
		var width = 70;
		var fpr = o.data['progress'];
		var pr = Math.round( o.data['progress'] * width );
		if (fpr<0) // error
                	return '<div style="width:' + width + 'px;height:30px"><div style="width:' + width + 'px;height:30px;background-color:red;">'+
                       		'<button onclick=' + onclick + ' style="width:70px;height:30px;background:transparent;" >Checkout</button>' + 
                       '</div>';
		else if (fpr==1.0) //paid !!
                	return '<div style="width:' + width + 'px;height:30px"><div style="width:' + width + 'px;height:30px;background-color:lightgreen;">'+
                       		'<button onclick=' + onclick + ' style="width:70px;height:30px;background:transparent;" >Paid</button>' +
                       '</div>';
		else if (fpr>1.0) //overpaid !!
                	return '<div style="width:' + width + 'px;height:30px"><div style="width:' + width + 'px;height:30px;background-color:pink;">'+
                       		'<button onclick=' + onclick + ' style="width:70px;height:30px;background:transparent;" >Paid</button>' +
                       '</div>';
		else
                	return '<div style="width:' + width + 'px;height:30px"><div style="width:' + pr + 'px;height:30px;background-color:lightgreen;">'+
                       		'<button onclick=' + onclick + ' style="width:70px;height:30px;background:transparent;" >Checkout</button>' +
                       '</div>';
        };

        var iconFormatter =  function (o)
        {
                var path = o.data['status']['icon'];
                return '<div><img style="max-width:20px;" src="' + path + '" ></img></div>';
        };

	var getmsname = function(num)
	{
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
                var vl = new Date(o.data['lms_date']);
                var dt = Y.DataType.Date.format(vl, { format: "%m/%d/%Y %H:%M"});
		var nm = getmsname( o.data['lms_id'] );
                //return vl && dt;
		return dt + " " +nm;
        };

        var cols = [
		{
			key:		'q',
			label:		"Queue",
			sortable:	true
		},
                { 
                        key:            'service',
                        allowHTML:      true, // to avoid HTML escaping
                        label:          'Service',
                        formatter:      serviceFormatter,
                        width:          25
                },
		{
			key:'device', label:'Device', sortable:true
		},
                {
                        key:"status",
                        label:"Status",
                        sortable:true,
                        allowHTML: true,
                        formatter: iconFormatter
                },
		{
			key:		'jid',
			label:		"Job Number",
			sortable:	true
		},
		{
			key:		'cname',
			label:		"Client",
			sortable:	true
		},
		{
			key:		'dcode',
			label:		'Department',
			sortable:	true
		},
		{ key:"description", label:"Description", sortable:true, width:100 },
		{
			key:		'lms',
			label:		'Latest Milestone',
			sortable:	true,
                        allowHTML: 	true,
                        formatter: 	formatDates
		},
		{
                        key:"progress",
                        label:"Payment",
                        sortable:true,
                        allowHTML: true,
                        formatter: paymentFormatter
                }
		];

	ev_datatable = new Y.DataTable({
                columns:cols,
                data:ev_data['data'],
                summary:"Quotes",
                width:"100%",
                //caption:"Jobs Queue"

                // "selection" config stuff begins here ...
                highlightMode: 'row',
                selectionMode: 'row',
                selectionMulti: false

                //}).render("#" + ev_parentName);
                }).render("#ev_datatable");

        ev_datatable.on("selected",
                function(obj)
                {
                        if (obj.record)
                        {
                                var jobid = obj.record.get('jobid');
				Y.log("selected jobid", jobid);

                        }
                });


}

function ev_get_data(Y)
{
/*
	// prepare web service config...
        var handleSuccess = function(id, o, a)
        {
            var resp = Y.JSON.parse(o.responseText);
            Y.log(resp);
	    if ( resp && resp['status'] )
	    {
            	ev_data = resp;
	    	ev_create_table(Y);
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
                failure: function(id,o,a) { Y.log("ERROR",id,o,a); }
            }
        };

	//	append paging...
	var page_no=1;
	var page_no = 1;  //default to first page...
	if (page) page_no = page;

	//	possibly override/append page size based on available size...
	var page_size = 1;  // default to some number...
	var el = Y.Node('#ev_parent');
	
	el = Y.Node("#lower_tabs_parent");
	var act_el = Y.Node("#action_bar");
	var ht = el.get("offsetHeight") - act_el.get("offsetHeight");

	page_size = Math.floor( ( ht -50) /35)
	if ( page_size<=0 ) page_size = 1;

        var url = CONFIG_BASE_URL + "jobs?active=true&page_no=" + page_no + "&page_size=" + page_size;
	if (serviceuid && (serviceuid!="0") )
		url += "&serviceuid=" + serviceuid;
	if (deviceuid && (deviceuid!="0"))
		url += "&deviceuid=" + deviceuid;
	if (search && (search!="") && (search!=null) )
		url += "&search=" + search;
	if (findjob &&(findjob!="") && (findjob!=null))
		url += "&find=" + findjob;
        Y.io.header('X-Requested-With');
	Y.io(url, cfg );
	
	
	//	TODO: check error...
	return ev_data;
*/
}

