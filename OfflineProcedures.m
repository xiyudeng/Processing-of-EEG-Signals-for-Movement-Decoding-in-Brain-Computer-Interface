%% Offline Procedures

cd /Users/dengxiyu/Desktop/BEngProject/code

diary myDiaryFile

% Load the data and read the configuration documents
i_Import_eeglab

% Remove NaN value and AFz channel for all run
ii_remove_AFz
iii_rm_bad_chan

% % Trials Segment, remove baseline
% epochdata

% CAR common average reference
% iv_CAR

% Apply Butterworth Filter(4th order range from 0.3Hz to 70Hz)
iv_BWfilter70

%remove bad channel
% rm_bad_chan

%%%ICA
v_MAD
vi_PcaIca

%%% epoch the data according to 5 gestures
% viii_epochdata
vii_reject_abnormal
% 
% ix_reject_abnormal
% 
viii_BWfilter3
ix_combinedata
 
x_extraction_window 
% %% classifier
% 
% movemean
% % reshape_expand