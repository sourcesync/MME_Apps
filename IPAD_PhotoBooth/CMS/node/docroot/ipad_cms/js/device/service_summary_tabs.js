//	public...
var service_summary_tabs = null;

//	private state...
var sst_panel_Y = null;
var sst_tabs = [ "Wide_Format", "3D_Scan", "Laser", "Rapid_Prototype" ];  // TODO: use this array exclusively...
var sst_tab_event = null;
var sst_event_id = null;

function service_summary_tabs_select(idx)
{
	// TODO: HACK TO FORCE FIRST TAB TO INITIALIZE
	sst_tab_event.fire("service_summary_tabs", {
                             message: "Wide_Format",
                             origin: sst_event_id 
                             });
}


function service_summary_tabs_show(Y)
{
	if ( service_summary_tabs )
	{
		service_summary_tabs.render();
	}
}

function service_summary_tabs_init(Y, parentName)
{
	sst_panel_Y  = Y;

	//	event broadcast for tab...
        sst_event_id = Y.guid();
	sst_tab_event = common_create_event(Y,"service_summary_tabs");

	//	get the parent div...
	var tparent = Y.one("#" + parentName);
	
	//	create the YUI3 tabs ul hierarchy...
	var s = '<div id="service_summary_tabs">' +
			'<ul>' +
				'<li><a href="#">Wide_Format</a></li>' +
				'<li><a href="#">3D_Scan</a></li>' +
				'<li><a href="#">Laser</a></li>' + 
				'<li><a href="#">Rapid_Prototype</a></li>' +
			'</ul>' +
			'<div>' +
        			'<div id="Wide_Format"><div id="service_wide_summary"></div></div>' + 
				'<div id="3D_Scan"><div id="service_3dscan_summary"></div></div>' +
				'<div id="Laser"><div id="service_laser_summary"></div></div>' + 
				'<div id="Rapid_Prototype"><div id="service_rapid_summary"></div></div>' +
			'</div>' + 
		'</div>';
        tparent.set("innerHTML", s);

	//	create the YUI tabview...
    	service_summary_tabs = new Y.TabView({
				srcNode:'#service_summary_tabs'
			   });

	//	tab selected callback...
	var displayIndex = function (tabview) 
	{
    		var sel = tabview.get('selection');
    		var idx = tabview.indexOf(sel);
		var name = sst_tabs[idx];
	
		sst_tab_event.fire("service_summary_tabs", {
                             message: name,
                             origin: sst_event_id
                             });
  	}
	
	Y.after('click', 
		function(e) {
			displayIndex(this);
			},
		'#'+parentName,
		service_summary_tabs);

	//	Create the child controls...
	service_wide_init(Y, "service_wide_summary");
	service_rapid_init(Y, "service_rapid_summary");
	service_3dscan_init(Y, "service_3dscan_summary");

	//	change status panel...
	//change_status_panel_init(Y);
	
	//	change status panel...
	//change_milestone_panel_init(Y);
}


