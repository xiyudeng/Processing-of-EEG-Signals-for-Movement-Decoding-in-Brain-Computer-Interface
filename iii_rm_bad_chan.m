%%% Remove bad channels & Interpolate channels.
% EEG = pop_interp(EEG, originalEEG.chanlocs, 'spherical');

numPersons = 9;
numRuns = [3:7,10:13];
numberRuns = length(numRuns);
numChannels = 63;

ori_eeg = eegNoAFz;

for i = 1:numPersons
    for j = 1:numberRuns
%         eegNoAFz{j,i} = pop_eegfiltnew(eegNoAFz{j,i}, 49,  51,  1650, 1, [], 0);  % Line noise suppression ~50Hz
        cleanedRAW{j,i} = clean_rawdata(eegNoAFz{j,i}, 5, -1, 0.85, 4, 20, 0.25);
        
        cleanedRAW{j,i} = pop_interp(cleanedRAW{j,i}, ori_eeg{j,i}.chanlocs, 'spherical');
        
        cleanedRAW{j,i}.nbchan = cleanedRAW{j,i}.nbchan+1;
        cleanedRAW{j,i}.data(end+1,:) = zeros(1, cleanedRAW{j,i}.pnts);
        cleanedRAW{j,i}.chanlocs(1,cleanedRAW{j,i}.nbchan).labels = 'initialReference';
        cleanedRAW{j,i} = pop_reref(cleanedRAW{j,i}, []);
        cleanedRAW{j,i} = pop_select( cleanedRAW{j,i},'nochannel',{'initialReference'});
    
               
%         for k = 1:numChannels
%             m = mean(cleanedraw{j,i}.data(k,:));
%             cleanedraw{j,i}.data(k,:) = cleanedraw{j,i}.data(k,:) - repmat(m,1,51200);
%         end
    end
end


% clean_artifacts
% All-in-one function for artifact removal, including ASR.
% for i = 1:numPersons
%     for j = 1:numRuns 
%         eegNoAFz{j,i} = clean_artifacts(eegNoAFz{j,i});
%         eegNoAFz{j,i} = pop_interp(eegNoAFz{j,i}, ori_eeg{j,i}.chanlocs, 'spherical');        
%     end
% end


% cd /Users/dengxiyu/Desktop/BEngProject/dataset
% raw = pop_loadset('P01Run3.set');
% 
% originalEEG = raw;
% 
% clean = clean_artifacts(raw);
% 
% clean = pop_interp(clean, originalEEG.chanlocs, 'spherical');