
//	private, state...
var clvt_Y = null;
var clvt_tabs = null;
var clvt_tab_names = ["active"];
var clvt_tab_event = null;
var clvt_event_id = null;
var clvt_current_tab = null;

function clients_listviews_tabs_select(idx)
{
	var tab = clvt_tab_names[idx];

	clvt_current_tab = tab;

        // TODO: HACK TO FORCE FIRST TAB TO INITIALIZE
        clvt_tab_event.fire("clients_listviews_tabs", {
                             message: tab,
                             origin: clvt_event_id
                             });
}

function clients_listviews_tabs_show(Y)
{
        //      render it...
        clvt_tabs.render();

	//	render children...
	//active_jobs_listview_show(Y);
}

function clients_listviews_tabs_init(Y, parentName)
{
	clvt_Y = Y;

        //      event broadcast for tab...
        clvt_event_id = Y.guid();
        clvt_tab_event = common_create_event(Y,"clients_listviews_tabs");

	//	get the parent div...
	var tparent = Y.one("#" + parentName);
	
	//	create the YUI3 tabs ul hierarchy...
	var s = '<div id="clvt_tabview">' +
			'<ul>' +
				'<li><a href="#">active</a></li>' +
			'</ul>' +
			'<div>' +
        			'<div id="active"><div id="clients_listviews_active"></div></div>' + 
			'</div>' + 
		'</div>';
         tparent.set("innerHTML", s);

	//	create the YUI tabview...
    	clvt_tabs = new Y.TabView({
				srcNode:'#clvt_tabview'
				   });

	//	tab selected callbacks...
	var displayIndex = function (tabview) 
	{
    		var sel = tabview.get('selection');
    		var idx = tabview.indexOf(sel);
		var name = clvt_tab_names[idx];

		console.log("TABSELECT!", sel, idx);

		if ( clvt_current_tab != name )
		{
			clvt_current_tab = name;

			//	fire notification event to tab views...
			clvt_tab_event.fire("clients_listviews_tabs", {
                             message: name,
                             origin: clvt_event_id
                             });
		}
	}
	
	Y.after('click', 
		function(e) 
		{
			displayIndex(this);
		}, '#'+parentName, clvt_tabs);

	//	Create the child controls...
	active_clients_listview_init( Y, "clients_listviews_active" );


}



