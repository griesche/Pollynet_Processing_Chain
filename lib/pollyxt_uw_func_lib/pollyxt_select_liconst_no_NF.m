function LCUsed = pollyxt_select_liconst(data, config, dbFile)
%POLLYXT_SELECT_LICONST select the most suitable lidar calibration constants.
%Example:
%   LCUsed = pollyxt_select_liconst(data, config, dbFile)
%Inputs:
%   data.struct
%       More detailed information can be found in
%       doc/pollynet_processing_program.md
%   config: struct
%       More detailed information can be found in
%       doc/pollynet_processing_program.md
%   dbFile: char
%       absolute path of the database.
%Outputs:
%   LCUsed: struct
%       LCUsed355: float
%           applied lidar constant at 355 nm.
%       LCUsedTag355: integer
%           source of the applied lidar constant at 355 nm.
%           (1: klett; 2: raman; 3: defaults; 4: history) 
%       flagLCWarning355: integer
%           flag to show whether the calibration constant is unstable.
%       LCUsed532: float
%           applied lidar constant at 532 nm.
%       LCUsedTag532: integer
%           source of the applied lidar constant at 532 nm.
%           (1: klett; 2: raman; 3: defaults; 4: history) 
%       flagLCWarning532: integer
%           flag to show whether the calibration constant is unstable.
%       LCUsed1064: float
%           applied lidar constant at 1064 nm.
%       LCUsedTag1064: integer
%           source of the applied lidar constant at 1064 nm.
%           (1: klett; 2: raman; 3: defaults; 4: history) 
%       flagLCWarning1064: integer
%           flag to show whether the calibration constant is unstable.
%       LCUsed387: float
%           applied lidar constant at 387 nm.
%       LCUsedTag387: integer
%           source of the applied lidar constant at 387 nm.
%           (1: klett; 2: raman; 3: defaults; 4: history) 
%       flagLCWarning387: integer
%           flag to show whether the calibration constant is unstable.
%       LCUsed607: float
%           applied lidar constant at 607 nm.
%       LCUsedTag607: integer
%           source of the applied lidar constant at 607 nm.
%           (1: klett; 2: raman; 3: defaults; 4: history) 
%       flagLCWarning607: integer
%           flag to show whether the calibration constant is unstable.
%       LCUsed532NR: float
%           applied lidar constant at near-range 532 nm.
%       LCUsedTag532NR: integer
%           source of the applied lidar constant at near-range 532 nm.
%           (1: klett; 2: raman; 3: defaults; 4: history) 
%       flagLCWarning532NR: integer
%           flag to show whether the calibration constant is unstable.
%       LCUsed607NR: float
%           applied lidar constant at near-range 607 nm.
%       LCUsedTag607NR: integer
%           source of the applied lidar constant at near-range 607 nm.
%           (1: klett; 2: raman; 3: defaults; 4: history) 
%       flagLCWarning607NR: integer
%           flag to show whether the calibration constant is unstable.
%       LCUsed355NR: float
%           applied lidar constant at near-range 355 nm.
%       LCUsedTag355NR: integer
%           source of the applied lidar constant at near-range 355 nm.
%           (1: klett; 2: raman; 3: defaults; 4: history) 
%       flagLCWarning355NR: integer
%           flag to show whether the calibration constant is unstable.
%       LCUsed387NR: float
%           applied lidar constant at near-range 387 nm.
%       LCUsedTag387NR: integer
%           source of the applied lidar constant at near-range 387 nm.
%           (1: klett; 2: raman; 3: defaults; 4: history) 
%       flagLCWarning387NR: integer
%           flag to show whether the calibration constant is unstable.
%History:
%   2020-04-18. First Edition by Zhenping
%Contact:
%   zp.yin@whu.edu.cn

global defaults campaignInfo

LC = data.LC;

LCUsed = struct();
flagChannel355 = config.isFR & config.is355nm & config.isTot;
flagChannel355NR = config.isNR & config.is355nm & config.isTot;
flagChannel532 = config.isFR & config.is532nm & config.isTot;
flagChannel532NR = config.isNR & config.is532nm & config.isTot;
flagChannel1064 = config.isFR & config.is1064nm & config.isTot;
flagChannel387 = config.isFR & config.is387nm;
flagChannel387NR = config.isNR & config.is387nm;
flagChannel607 = config.isFR & config.is607nm;
flagChannel607NR = config.isNR & config.is607nm;

%% far-range calibration constants
[LCUsed.LCUsed355, ~, LCUsed.LCUsedTag355, LCUsed.flagLCWarning355] = ...
    select_liconst(LC.LC_raman_355, zeros(size(LC.LC_raman_355)), ...
        LC.LC_start_time, ...
        LC.LC_stop_time, ...
        mean(data.mTime), dbFile, campaignInfo.name, '355', 'far_range', ...
        'flagUsePrevLC', config.flagUsePreviousLC, ...
        'flagLCCalibration', config.flagLCCalibration, ...
        'deltaTime', datenum(0, 1, 7), ...
        'default_liconst', defaults.LC(flagChannel355), ...
        'default_liconstStd', defaults.LCStd(flagChannel355));
[LCUsed.LCUsed532, ~, LCUsed.LCUsedTag532, LCUsed.flagLCWarning532] = ...
    select_liconst(LC.LC_raman_532, zeros(size(LC.LC_raman_532)), ...
        LC.LC_start_time, ...
        LC.LC_stop_time, ...
        mean(data.mTime), dbFile, campaignInfo.name, '532', 'far_range', ...
        'flagUsePrevLC', config.flagUsePreviousLC, ...
        'flagLCCalibration', config.flagLCCalibration, ...
        'deltaTime', datenum(0, 1, 7), ...
        'default_liconst', defaults.LC(flagChannel532), ...
        'default_liconstStd', defaults.LCStd(flagChannel532));
[LCUsed.LCUsed1064, ~, LCUsed.LCUsedTag1064, LCUsed.flagLCWarning1064] = ...
    select_liconst(LC.LC_raman_1064, zeros(size(LC.LC_raman_1064)), ...
        LC.LC_start_time, ...
        LC.LC_stop_time, ...
        mean(data.mTime), dbFile, campaignInfo.name, '1064', 'far_range', ...
        'flagUsePrevLC', config.flagUsePreviousLC, ...
        'flagLCCalibration', config.flagLCCalibration, ...
        'deltaTime', datenum(0, 1, 7), ...
        'default_liconst', defaults.LC(flagChannel1064), ...
        'default_liconstStd', defaults.LCStd(flagChannel1064));
[LCUsed.LCUsed387, ~, LCUsed.LCUsedTag387, LCUsed.flagLCWarning387] = ...
    select_liconst(LC.LC_raman_387, zeros(size(LC.LC_raman_387)), ...
        LC.LC_start_time, ...
        LC.LC_stop_time, ...
        mean(data.mTime), dbFile, campaignInfo.name, '387', 'far_range', ...
        'flagUsePrevLC', config.flagUsePreviousLC, ...
        'flagLCCalibration', config.flagLCCalibration, ...
        'deltaTime', datenum(0, 1, 7), ...
        'default_liconst', defaults.LC(flagChannel387), ...
        'default_liconstStd', defaults.LCStd(flagChannel387));
[LCUsed.LCUsed607, ~, LCUsed.LCUsedTag607, LCUsed.flagLCWarning607] = ...
    select_liconst(LC.LC_raman_607, zeros(size(LC.LC_raman_607)), ...
        LC.LC_start_time, ...
        LC.LC_stop_time, ...
        mean(data.mTime), dbFile, campaignInfo.name, '607', 'far_range', ...
        'flagUsePrevLC', config.flagUsePreviousLC, ...
        'flagLCCalibration', config.flagLCCalibration, ...
        'deltaTime', datenum(0, 1, 7), ...
        'default_liconst', defaults.LC(flagChannel607), ...
        'default_liconstStd', defaults.LCStd(flagChannel607));

%% near-range lidar calibration constants
% [LCUsed.LCUsed532NR, ~, LCUsed.LCUsedTag532NR, LCUsed.flagLCWarning532NR] = ...
%     select_liconst(LC.LC_raman_532_NR, zeros(size(LC.LC_raman_532_NR)), ...
%         LC.LC_start_time, ...
%         LC.LC_stop_time, ...
%         mean(data.mTime), dbFile, campaignInfo.name, '532', 'near_range', ...
%         'flagUsePrevLC', config.flagUsePreviousLC, ...
%         'flagLCCalibration', config.flagLCCalibration, ...
%         'deltaTime', datenum(0, 1, 7), ...
%         'default_liconst', defaults.LC(flagChannel532NR), ...
%         'default_liconstStd', defaults.LCStd(flagChannel532NR));
% [LCUsed.LCUsed607NR, ~, LCUsed.LCUsedTag607NR, LCUsed.flagLCWarning607NR] = ...
%     select_liconst(LC.LC_raman_607_NR, zeros(size(LC.LC_raman_607_NR)), ...
%         LC.LC_start_time, ...
%         LC.LC_stop_time, ...
%         mean(data.mTime), dbFile, campaignInfo.name, '607', 'near_range', ...
%         'flagUsePrevLC', config.flagUsePreviousLC, ...
%         'flagLCCalibration', config.flagLCCalibration, ...
%         'deltaTime', datenum(0, 1, 7), ...
%         'default_liconst', defaults.LC(flagChannel607NR), ...
%         'default_liconstStd', defaults.LCStd(flagChannel607NR));
% [LCUsed.LCUsed355NR, ~, LCUsed.LCUsedTag355NR, LCUsed.flagLCWarning355NR] = ...
%     select_liconst(LC.LC_raman_355_NR, zeros(size(LC.LC_raman_355_NR)), ...
%         LC.LC_start_time, ...
%         LC.LC_stop_time, ...
%         mean(data.mTime), dbFile, campaignInfo.name, '355', 'near_range', ...
%         'flagUsePrevLC', config.flagUsePreviousLC, ...
%         'flagLCCalibration', config.flagLCCalibration, ...
%         'deltaTime', datenum(0, 1, 7), ...
%         'default_liconst', defaults.LC(flagChannel355NR), ...
%         'default_liconstStd', defaults.LCStd(flagChannel355NR));
% [LCUsed.LCUsed387NR, ~, LCUsed.LCUsedTag387NR, LCUsed.flagLCWarning387NR] = ...
%     select_liconst(LC.LC_raman_387_NR, zeros(size(LC.LC_raman_387_NR)), ...
%         LC.LC_start_time, ...
%         LC.LC_stop_time, ...
%         mean(data.mTime), dbFile, campaignInfo.name, '387', 'near_range', ...
%         'flagUsePrevLC', config.flagUsePreviousLC, ...
%         'flagLCCalibration', config.flagLCCalibration, ...
%         'deltaTime', datenum(0, 1, 7), ...
%         'default_liconst', defaults.LC(flagChannel387NR), ...
%         'default_liconstStd', defaults.LCStd(flagChannel387NR));

end