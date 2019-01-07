function [defaults] = polly_1v2_read_defaults()
%polly_1v2_read_defaults read default settings for polly_1v2
%   Example:
%       [defaults] = polly_1v2_read_defaults(file)
%   Inputs:
%       file: char
%   Outputs:
%       defaults:
%           default settings for polly lidar system. More detailed information can be found in doc/polly_defaults.md
%   History:
%       2018-12-19. First Edition by Zhenping
%   Contact:
%       zhenping@tropos.de

defaultFile = 'polly_1v2_defaults.json';

if ~ exist(defaultFile, 'file')
    error('Default file for polly_1v2 does not exist!\n%s\n', defaultFile);
end

defaults = loadjson(defaultFile);

end