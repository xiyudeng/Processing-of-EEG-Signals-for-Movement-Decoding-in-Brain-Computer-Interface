
% removed stationary artefacts by filtering the signals
% from 0.3 Hz to 70 Hz
% (4th order Butterworth zero-phase band-pass filter)

%% Set Butterworth filter parameter
sampleRate = 256;     % Hz
lowEnd = 0.3;         % Hz
highEnd = 70;         % Hz
filterOrder = 4;      % Filter order

[b, a] = butter(filterOrder,[lowEnd,highEnd]/(sampleRate/2),'bandpass');  % Generate filter coefficients

%% Apply Butterworth non-epoch version
numPersons = 9;
numRuns = [3:7,10:13];
numberRuns = length(numRuns);

bwEEG = cleanedRAW;
for i =1:numPersons
    for j = 1:numberRuns
        bwEEG{j,i}.data = double(bwEEG{j,i}.data);
        bwEEG{j,i}.data = filtfilt(b,a,bwEEG{j,i}.data);
%         bwEEG{j,i} = pop_epoch(bwEEG{j,i}, {'768'} , [0 5],'newname',[Offline_eeglab{jj,i}.setname,'_epo2cont']);
%         bwEEG{j,i} = pop_rmbase(bwEEG{j,i},[0 2000],[],[]);
%         bwEEG{j,i} = eeg_epoch2continuous(bwEEG{j,i});
    end
end



%% Apply Butterworth filter epoch version
% numPersons = 9;
% numRuns = [3:7,10:13];
% numberRuns  =length(numRuns);
% numEpochs = 8;
% % eegBW = cell(numRuns,numPersons);
% % path = '/Users/dengxiyu/Desktop/BEngProject/dataset';
% bw_sup = car_sup;
% bw_pro = car_pro;
% bw_open = car_open;
% bw_palmar = car_palmar;
% bw_lateral = car_lateral;
% 
% for i = 1:numPersons
%     for j = 1:numberRuns
%         for k = numEpochs
%             bw_sup{j,i}.data(:,:,k) = filtfilt(b,a,bw_sup{j,i}.data(:,:,k));
%             bw_pro{j,i}.data(:,:,k) = filtfilt(b,a,bw_pro{j,i}.data(:,:,k));
%             bw_open{j,i}.data(:,:,k) = filtfilt(b,a,bw_open{j,i}.data(:,:,k));
%             bw_palmar{j,i}.data(:,:,k) = filtfilt(b,a,bw_palmar{j,i}.data(:,:,k));
%             bw_lateral{j,i}.data(:,:,k) = filtfilt(b,a,bw_lateral{j,i}.data(:,:,k));
%         end
%     end
%     fprintf('\nP0%d\n',i);
% end


% cd /Users/dengxiyu/Desktop/BEngProject/code
% save Offline_postBW eegBW -v7.3
% fprintf('The data after BW filter has been saved.\n')

