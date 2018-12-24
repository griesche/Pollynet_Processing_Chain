function [pollyHistory] = polly_history(task, pollynetHistory)
%POLLY_HISTORY search for the history information from polly_history file.
%	Example:
%		[pollyHistory] = polly_history(task, config)
%	Inputs:
%		task: struct
%			todoPath: char
%			dataPath: char
%			dataFilename: char
%			dataFullpath: char
%			dataSize: integer
%			pollyVersion: char
%			dataTime: datenum
%		config: struct
%			configurations for polly system. More detailed information can be found in doc/polly_config.md
%	Outputs:
%		pollyHistory: struct
%			name: char
%			location: char
%			startTime: datenum
%			endTime: datenum
%			lon: double
%			lat: double
%			asl: double
%			depolConst: double
%			molDepol: double 
%			caption: char
%	History:
%		2018-12-17. First edition by Zhenping
%	Contact:
%		zhenping@tropos.de

pollyHistory = struct();
pollyHistory.name = '';
pollyHistory.location = '';
pollyHistory.startTime = [];
pollyHistory.endTime = [];
pollyHistory.lon = [];
pollyHistory.lat = [];
pollyHistory.asl = [];
pollyHistory.depolConst = [];
pollyHistory.molDepol = [];
pollyHistory.caption = '';

isCurrentPolly = strcmpi(task.pollyVersion, pollynetHistory.name);
isWithinMeasPeriod = (task.dataTime < pollynetHistory.endTime) & (task.dataTime >= pollynetHistory.startTime);

if (sum(isCurrentPolly) == 0) || (sum(isWithinMeasPeriod) == 0) || (sum(isCurrentPolly & isWithinMeasPeriod) == 0)
	error('Failure in searching the history info for %s.\nPlease check the pollynet history file.\n', task.dataFilename);
elseif sum(isWithinMeasPeriod & isCurrentPolly) > 1
	lineOutputStr = sprintf('%d, ', find(isWithinMeasPeriod & isCurrentPolly) + 1);
	error('More than one history info was found.\nSee line %s\nPlease check the pollynet_history file.\nOr check the data file: %s\n', lineOutputStr, task.dataFilename);
elseif sum(isCurrentPolly & isWithinMeasPeriod) == 1
	flag = isCurrentPolly & isWithinMeasPeriod;
	pollyHistory.name = pollynetHistory.name{flag};
	pollyHistory.location = pollynetHistory.location{flag};
	pollyHistory.startTime = pollynetHistory.startTime[flag];
	pollyHistory.endTime = pollynetHistory.endTime[flag];
	pollyHistory.lon = pollynetHistory.lon[flag];
	pollyHistory.lat = pollynetHistory.lat[flag];
	pollyHistory.asl = pollynetHistory.asl[flag];
	pollyHistory.depolConst = pollynetHistory.depolConst[flag];
	pollyHistory.molDepol = pollynetHistory.molDepol[flag];
	pollyHistory.caption = pollynetHistory.caption{flag};
else
	error('Unknown error in searching the history info for %s.\n', task.dataFilename);
end

end