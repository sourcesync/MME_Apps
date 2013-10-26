
exports.project = { 
	'PROJECT_NAME':			'TEST_PROJECT',
	'PROJECT_DATE_CREATED':		'1/1/2013',
	'PROJECT_NUMBER_OF_JOBS':	2 
};

exports.jobs = [
	{
		'JOB_TYPE':		'Wide Format',
		'JOB_ID':		'JbID1234Poly',
		'JOB_DATE_CREATED':	'2/2/2013',
		'JOB_NUMBER_OF_PARTS':	1
	},
	{
		'JOB_TYPE':		'3D Scan',
		'JOB_ID':		'3DID1234Steinhart',
		'JOB_DATE_CREATED':	'2/4/2013',
		'JOB_NUMBER_OF_PARTS':	1
	}
];

exports.parts = {
	'JbID1234Poly':	{
		0: {
			'PART_ID':	'1',
			'PART_STATUS':	'Normal'
		}
	},
	'3DID1234Steinhart':	{
		0: {
			'PART_ID':	'1',
			'PART_STATUS':	'Normal'
		}
	}
}
		
