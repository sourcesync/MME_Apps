//	controls...
var pvp_panel = null;

//	state...
var pvp_Y = null;
var pvn_state = {};
var pvn_state_type = null;
var pvn_state_device = null;

//	defs...
var pvp_definition_dct= {
    'VV_PVPARENT':'',
};		

function print_viewer_panel_show( url )
{
	if (pvp_panel)
	{
		pvp_panel.destroy();
		sset_viewer_panel = null;
	}

	pvp_init( pvp_Y, url );
	
	//	set current global state...
	//common_setglobalstate( pvp_state, null );

	pvp_panel.show();
}

var pvp_part_template_html = '\
                <div style="width:500px;height:500px;" id="{VV_CJPARENT}">\
                </div>';

function pvp_create_panel(Y)
{
	//      create the panel ancestry...
        var a = Y.Node.create('<div id="print_viewer_panel" class="yui3-skin-mine" ></div>');
        var b = Y.Node.create('<div class="yui3-widget-bd"></div>');
        a.append(b);

	//      initialize various state from definition...
        pvp_state = common_instantiate_definition( pvp_definition_dct, "VV_CJPARENT", "", null );

	//	create the content area via substitution...
	var str = Y.Lang.sub( pvp_part_template_html, pvp_state['html'] );
        var el = Y.Node.create( str );
        b.append(el);

        //      add to body...
        var bodyNode = Y.one(document.body);
        bodyNode.append( a );

	//	do DOM-related state initialization...
	common_dom_configure( Y, pvp_state, function( el ) 
		{
		});

}

function print_viewer_panel_init(Y)
{
	if (Y) pvp_init(Y);
}
	
function pvp_init(Y, url)
{
	//	stash ref to sandbox...
	pvp_Y = Y; 

	//	create the panel contents...
	//av_create_panel(Y);

	
	//      create the panel ancestry...
        var a = Y.Node.create('<div id="print_viewer_panel"></div>');
        var b = Y.Node.create('<div class="yui3-widget-bd"></div>');
        a.append(b);

        var c = Y.Node.create('<img style="max-width:100%;" src="' + url + '"></img>');
        b.append(c);

        //      add to body...
        var bodyNode = Y.one(document.body);
        bodyNode.append( a );

	//	make the panel...
	pvp_panel = new Y.Panel({
                		srcNode      : '#print_viewer_panel',
                		headerContent: 'Print Viewer',
                		width        : 500,
                		zIndex       : 30,
                		centered     : true,
                		modal        : true,
                		visible      : false,
                		render       : true,
                		plugins      : [Y.Plugin.Drag]
        		});

	//	OK button...
        pvp_panel.addButton({
                                value  : 'OK',
                                section: Y.WidgetStdMod.FOOTER,
                                action : function (e) {
                                                e.preventDefault();
						print_viewer_panel.hide();
                                        }});
}

