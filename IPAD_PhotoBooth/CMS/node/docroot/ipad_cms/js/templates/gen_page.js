//	deps...
var fs 		= require('fs');
var cheerio 	= require('cheerio');
var process	= require('process');

var template	= "./" + process.argv[2];
var data_file	= "./" + process.argv[3];
 

//	load the template...
if ( !fs.existsSync( template ) )
{
	console.log("ERROR: file does not exist->", template);
	process.exit(1);
}

//	get template parts...
var body = fs.readFileSync( template, "utf8" );
$ = cheerio.load(body);

var el = $('head');
var head_template = $.html(el);
console.log('INFO: head template', head_template);

var el = $('#project_summary_info');
var project_template = $.html(el);
console.log('INFO: project template', project_template);

el = $('#project_wide_format_jobs_info');
var job_template = $.html(el);
console.log('INFO: job template', job_template);

el = $('#project_wide_format_job_part_info')
var part_template = $.html(el);
console.log('INFO: part template', part_template);

///var txt = $.html(el);
//console.log(txt);

//	load the data...
var data 	= require( data_file );

function instantiate( template, dct )
{
	var str = template;
	for ( var key in dct )
	{
		var val = dct[key];
		var repl_key = "{" + key + "}";
		str = str.replace(repl_key, val);
	}
	return str;
}

var str = "<html><body class='yui3-skin-mine' onload='init();' ><div id='project_summary_parent' style='overflow:auto;' >";

str += head_template;

//	instantiate the template...
str += instantiate( project_template, data.project );

var no_jobs = data.project['PROJECT_NUMBER_OF_JOBS'];
console.log("NO JOBS", no_jobs);
for (i=0;i<no_jobs;i++)
{
	str += instantiate( job_template, data.jobs[i] );

	var no_parts = data.jobs[i]['JOB_NUMBER_OF_PARTS'];
	console.log('no_parts', no_parts);
	var jobid = data.jobs[i]['JOB_ID'];
	for (j=0;j<no_parts;j++)
	{
		var part_dct = data.parts[jobid][j];
		str += instantiate( part_template, part_dct );
	}
}

str += "</div></body></html>";

var path = "out.html";
fs.writeFileSync( path, str );
console.log("DONE:  produced file->", path);


