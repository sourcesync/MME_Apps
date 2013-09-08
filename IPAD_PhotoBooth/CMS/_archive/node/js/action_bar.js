//	controls...
var action_bar = null;

//	state...
var ac_Y = null;
var ac_state = null;
var ac_event_id = null;

function action_bar_show(Y)
{
	if (action_bar)
	{
		action_bar.show();
	}
}

var ac_events_html = '\
	<div id="events_action_box" style="width:100%;height:40px;background-color:rgb(245,245,245);" >\
		<button type="button" id="action_new_event" class="pure-button">New Event</button>\
	</div>';

function ac_create(Y, parentName, tab)
{
	ac_create_events(Y, parentName);

	ac_show(Y, tab );
}

function hide_all(Y)
{
	var node = Y.Node("#events_action_box");
	node.setStyle("display","none");
}

function ac_show(Y, tab)
{
	hide_all(Y);

	if (tab=="events")
	{
		var node = Y.Node("#events_action_box");
		node.setStyle("display","block");
	}
}

function ac_create_events(Y, parentName)
{
	//	Create the dom hierarchy... 
	var parent = Y.Node('#' + parentName);
        var el = Y.Node.create( ac_events_html );
	parent.append(el);

	//	Add button callbacks...
	var btn = Y.Node('#action_new_event');
	btn.on("click", function(e)
		{
			alert('yo!');	
		});
	
}

function action_bar_init(Y, parentName)
{
        //      stash ref to sandbox...
        ac_Y = Y;

        //      event id...
        ac_event_id = Y.guid();

	//	create the contents dynamically...
	ac_create(Y, parentName, "event");

}

