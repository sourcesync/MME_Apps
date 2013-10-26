//	public...
var client_summary_tabs = null;

//	private state...
var cst_panel_Y = null;
var cst_tabs = [ "overview", "projects", "accounts" ];  // TODO: use this array exclusively...
var cst_tab_event = null;
var cst_event_id = null;
var cst_current_tab = null;

function client_summary_tabs_select(idx)
{
	var tab = cst_tabs[idx];

	// TODO: HACK TO FORCE FIRST TAB TO INITIALIZE
	cst_tab_event.fire("client_summary_tabs", {
                             message: tab,
                             origin: cst_event_id 
                             });

	cst_current_tab = tab;
}


function client_summary_tabs_show(Y)
{
	if ( client_summary_tabs )
	{
		client_summary_tabs.render();
	}
}

function client_summary_tabs_init(Y, parentName)
{
	cst_panel_Y  = Y;

	//	event broadcast for tab...
        cst_event_id = Y.guid();
	cst_tab_event = common_create_event(Y,"client_summary_tabs");

	//	get the parent div...
	var tparent = Y.one("#" + parentName);
	
	//	create the YUI3 tabs ul hierarchy...
	var s = '<div id="client_summary_tabs">' +
			'<ul>' +
				'<li><a href="#">overview</a></li>' +
				'<li><a href="#">projects</a></li>' +
				'<li><a href="#">accounts</a></li>' +
			'</ul>' +
			'<div>' +
        			'<div id="overview"><div id="client_overview"></div></div>' + 
        			'<div id="projects"><div id="client_projects"></div></div>' + 
        			'<div id="accounts"><div id="client_accounts"></div></div>' + 
			'</div>' + 
		'</div>';
        tparent.set("innerHTML", s);

	//	create the YUI tabview...
    	client_summary_tabs = new Y.TabView({
				srcNode:'#client_summary_tabs'
			   });

	//	tab selected callback...
	var displayIndex = function (tabview) 
	{
    		var sel = tabview.get('selection');
    		var idx = tabview.indexOf(sel);
		var name = cst_tabs[idx];

		if ( cst_current_tab != name )
		{	
			cst_current_tab = name;

			cst_tab_event.fire("client_summary_tabs", {
                             message: name,
                             origin: cst_event_id
                             });
		}
  	}
	
	Y.after('click', 
		function(e) {
			console.log("client_summary_tabs: click event->",this);
			displayIndex(this);
			},
		'#'+parentName,
		client_summary_tabs);

	//	Create the child controls...
	client_overview_init(Y, "client_overview");
	client_projects_init(Y, "client_projects");
	client_accounts_init(Y, "client_accounts");

	//	change status panel...
	//change_status_panel_init(Y);
	
	//	change status panel...
	//change_milestone_panel_init(Y);
}


