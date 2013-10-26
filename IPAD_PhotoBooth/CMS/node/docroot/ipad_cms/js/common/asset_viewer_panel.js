//	controls...
var asset_view_panel = null;

//	state...
var av_Y = null;
var av_state = {};
var av_state_type = null;
var av_state_device = null;

//	defs...
var av_definition_dct= {
    'VV_AVPARENT':'',
};		

function asset_view_panel_return( )
{
	asset_view_panel.show();
	
	common_setglobalstate( av_state, null );
}

function asset_viewer_panel_show( url )
{
	if (asset_viewer_panel)
	{
		asset_viewer_panel.destroy();
		asset_viewer_panel = null;
	}

	av_init( av_Y, url );
	
	//	set current global state...
	//common_setglobalstate( av_state, null );

	asset_viewer_panel.show();
}

var av_part_template_html = '\
                <div style="width:500px;height:500px;" id="{VV_CJPARENT}">\
                </div>';

function av_create_panel(Y)
{
	//      create the panel ancestry...
        var a = Y.Node.create('<div id="asset_viewer_panel" class="yui3-skin-mine" ></div>');
        var b = Y.Node.create('<div class="yui3-widget-bd"></div>');
        a.append(b);

	//      initialize various state from definition...
        av_state = common_instantiate_definition( av_definition_dct, "VV_CJPARENT", "", null );

	//	create the content area via substitution...
	var str = Y.Lang.sub( av_part_template_html, av_state['html'] );
        var el = Y.Node.create( str );
        b.append(el);

        //      add to body...
        var bodyNode = Y.one(document.body);
        bodyNode.append( a );

	//	do DOM-related state initialization...
	common_dom_configure( Y, av_state, function( el ) 
		{
		});

}

function asset_viewer_panel_init(Y)
{
	if (Y)
	{
		av_init(Y);
	}
	else
	{	
        	YUI( {  filter:'raw', combine:false, gallery: 'gallery-2012.12.19-21-23' })
                	.use(   "io-xdr", "json-parse", "node", "datatable-sort",  'cssfonts', "cssbutton",
                        	"datatype", 'gallery-datatable-selection', 'event-custom', 'event-mouseenter',
                        	"panel", "datatable-base", "dd-plugin",
                        	"uploader","button",
                	function(Y)
                	{
				av_init(Y);
			});
	}
}
	
function av_init(Y, url)
{
	//	stash ref to sandbox...
	av_Y = Y; 

	//	create the panel contents...
	//av_create_panel(Y);

	
	//      create the panel ancestry...
        var a = Y.Node.create('<div id="asset_viewer_panel"></div>');
        var b = Y.Node.create('<div class="yui3-widget-bd"></div>');
        a.append(b);

        var c = Y.Node.create('<img style="max-width:100%;" src="' + url + '"></img>');
        b.append(c);

        //      add to body...
        var bodyNode = Y.one(document.body);
        bodyNode.append( a );

	//	make the panel...
	asset_viewer_panel = new Y.Panel({
                		srcNode      : '#asset_viewer_panel',
                		headerContent: 'Asset Viewer',
                		width        : 500,
                		zIndex       : 30,
                		centered     : true,
                		modal        : true,
                		visible      : false,
                		render       : true,
                		plugins      : [Y.Plugin.Drag]
        		});
	
	//	Download button...
        asset_viewer_panel.addButton({
                                value  : 'Download',
                                section: Y.WidgetStdMod.FOOTER,
                                action : function (e) {
                                                e.preventDefault();
						alert("Not implemented.");	
                                        }});

	//	OK button...
        asset_viewer_panel.addButton({
                                value  : 'OK',
                                section: Y.WidgetStdMod.FOOTER,
                                action : function (e) {
                                                e.preventDefault();
						
						asset_viewer_panel.hide();
                                        }});
}

