
% removed stationary artefacts by filtering the signals
% from 0.3 Hz to 70 Hz
% (4th order Butterworth zero-phase band-pass filter)

%% Set Butterworth filter parameter
sampleRate = 256;     % Hz
lowEnd = 0.3;         % Hz
highEnd = 3;         % Hz
filterOrder = 4;      % Filter order

[b, a] = butter(filterOrder,[lowEnd,highEnd]/(sampleRate/2),'bandpass');  % Generate filter coefficients

%% Apply Butterworth filter
fprintf('Apply Butterworth filter for 0.3Hz to 3Hz')
numPersons = 9;
numRuns = [3:7,10:13];
numberRuns  =length(numRuns);
numEpochs = 8;
% eegBW = cell(numRuns,numPersons);
% path = '/Users/dengxiyu/Desktop/BEngProject/dataset';

clean_sup = labelSup;
clean_pro = labelPro;
clean_open = labelOpe;
clean_palmar = labelPar;
clean_lateral = labelLat;

for i = 1:numPersons
    for j = 1:numberRuns
        if ~isempty(labelSup{j,i})
        labelSup{j,i}.data = double(labelSup{j,i}.data);
        end
        if ~isempty(labelPro{j,i})
        labelPro{j,i}.data = double(labelPro{j,i}.data);
        end
        if ~isempty(labelOpe{j,i})
        labelOpe{j,i}.data = double(labelOpe{j,i}.data);
        end
        if ~isempty(labelPar{j,i})
        labelPar{j,i}.data = double(labelPar{j,i}.data);
        end
        if ~isempty(labelLat{j,i})
        labelLat{j,i}.data = double(labelLat{j,i}.data);
        end
    end
end





for i = 1:numPersons
    for j = 1:numberRuns
        
        
        
        clear k1 k2 k3 k4 k5;
        if ~isempty(labelSup{j,i})
        [r,c,k1] = size(clean_sup{j,i}.data);
        for k = 1:k1
            clean_sup{j,i}.data(:,:,k) = filtfilt(b,a,labelSup{j,i}.data(:,:,k));
        end
        end
        
        if ~isempty(labelPro{j,i})
        [r,c,k2] = size(clean_pro{j,i}.data);
        for k = 1:k2
            clean_pro{j,i}.data(:,:,k) = filtfilt(b,a,labelPro{j,i}.data(:,:,k));
        end
        end
        
        if ~isempty(labelOpe{j,i})
        [r,c,k3] = size(clean_open{j,i}.data);
        for k = 1:k3
            clean_open{j,i}.data(:,:,k) = filtfilt(b,a,labelOpe{j,i}.data(:,:,k));
        end
        end
        
        if ~isempty(labelPar{j,i})
        [r,c,k4] = size(clean_palmar{j,i}.data);
        for k = 1:k4
            clean_palmar{j,i}.data(:,:,k) = filtfilt(b,a,labelPar{j,i}.data(:,:,k));
        end
        end
        
        if ~isempty(labelLat{j,i})
        [r,c,k5] = size(clean_lateral{j,i}.data);
        for k = 1:k5           
            clean_lateral{j,i}.data(:,:,k) = filtfilt(b,a,labelLat{j,i}.data(:,:,k));
        end
        end
    end
    fprintf('\nP0%d\n',i);
end



% cd /Users/dengxiyu/Desktop/BEngProject/code
% save Offline_postBW eegBW -v7.3
% fprintf('The data after BW filter has been saved.\n')

