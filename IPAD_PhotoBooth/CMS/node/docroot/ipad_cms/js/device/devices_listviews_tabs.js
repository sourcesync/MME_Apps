
//	private, state...
var dlvt_Y = null;
var dlvt_tabs = null;
var dlvt_tab_names = ["active"];
var dlvt_tab_event = null;
var dlvt_event_id = null;
var dlvt_current_tab = null;

function devices_listviews_tabs_select(idx)
{
        // TODO: HACK TO FORCE FIRST TAB TO INITIALIZE
        dlvt_tab_event.fire("devices_listviews_tabs", {
                             message: "active",
                             origin: dlvt_event_id
                             });
}

function devices_listviews_tabs_show(Y)
{
        //      render it...
        dlvt_tabs.render();

	//	render children...
	//active_jobs_listview_show(Y);
}


function dlt_search(obj)
{
        alert("This is not implemented.");

        var el = Y.Node( "#devices_search_text" );
        el.set("value","");

/*
        var vl = el.get("value");
        common_notify_projects_search( plvt_event_id, vl );
*/
}

function devices_listviews_tabs_init(Y, parentName)
{
	dlvt_Y = Y;

        //      event broadcast for tab...
        dlvt_event_id = Y.guid();
        dlvt_tab_event = common_create_event(Y,"devices_listviews_tabs");

	//	get the parent div...
	var tparent = Y.one("#" + parentName);
	
	//	create the YUI3 tabs ul hierarchy...
	var s = '<div id="dlvt_tabview">' +
			'<ul>' +
				'<li><a href="#">active</a></li>' +
			'</ul>' +
			'<div>' +
        			'<div id="active"><div id="jobs_listviews_active"></div></div>' + 
			'</div>' +
			'<div style="position:absolute;right:0px;top:0px;">' +
                        	'<button id="devices_search" style="float:right;margin-right:10px;" onclick="dlt_search(this);" >go</button>' +
                        	'<input style="float:right;" id="devices_search_text" type=text width=50 placeholder="Search..." />' +
                        	'<div style="clear:both;width:0px;" /></div>' +
                	'</div>' + 
		'</div>';
        tparent.set("innerHTML", s);

	//	create the YUI tabview...
    	dlvt_tabs = new Y.TabView({
				srcNode:'#dlvt_tabview'
				   });

	//	tab selected callbacks...
	var displayIndex = function (tabview) 
	{
    		var sel = tabview.get('selection');
    		var idx = tabview.indexOf(sel);
		var name = dlvt_tab_names[idx];


		if ( dlvt_current_tab != name )
		{
			dlvt_current_tab = name;

			//	fire notification event to tab views...
			dlvt_tab_event.fire("devices_listviews_tabs", {
                             message: name,
                             origin: dlvt_event_id
                             });
		}
	}
	
	Y.after('click', 
		function(e) 
		{
			displayIndex(this);
		}, '#'+parentName, dlvt_tabs);


	//	Create the child controls...
	active_jobs_listview_init( Y, "jobs_listviews_active" );


}



