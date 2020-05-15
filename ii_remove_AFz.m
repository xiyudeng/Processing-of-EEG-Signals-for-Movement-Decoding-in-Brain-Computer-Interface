 %% remove default channel AFz as it is sensitive to eye blinks and eye movements

%% Initial variable
numPersons = 9;
numRuns = [3:7,10:13];
numberRuns = length(numRuns);

eegNoAFz = cell(numberRuns,numPersons);

options = [];
% remove AFz and EOG channel
options.nochannel = [1];
% options.nochannel = [1,62,63,64];
n = -1; % n is for pnt (number of time) and we want to find the largest n;
t = 0;


% %% CleanLine plug in to remove line noise
% for i = 1:numPersons
%     for j = 1:numberRuns
%         jj=numRuns(j);
%         CleanLine{j,i} = pop_cleanline(Offline_eeglab{jj,i},'LineFrequencies',50);        
%     end
% end

%% Remove AFz loop
for i = 1:numPersons
    for j = 1:numberRuns
        jj=numRuns(j);
        eegNoAFz{j,i} = pop_select(Offline_eeglab{jj,i},options);
%         fprintf ('Channel AFz');
%         fprintf ('Channel AFz, 3 EOG channels\n');
        
%       remove NaN value
        
        eegNoAFz{j,i}.data = eegNoAFz{j,i}.data(:,~any(isnan(eegNoAFz{j,i}.data)));
        
        [m,n] = size(eegNoAFz{j,i}.data);
        eegNoAFz{j,i}.pnts = n;
        eegNoAFz{j,i} = pop_epoch(eegNoAFz{j,i}, {'768'} , [0 5],'newname',[Offline_eeglab{jj,i}.setname,'_epo2cont']);
        eegNoAFz{j,i} = eeg_epoch2continuous(eegNoAFz{j,i});
    end
end

fprintf ('Epoch and concatenate to remove useless data\n');















