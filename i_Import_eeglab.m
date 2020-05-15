clc;
clear;
close all;
eeglab;


%% Initial variables
% 9 participants, all participants but P04 were male. 
% The right hand was tested in all participants except P07 where we tested the left hand. 
% All participants were orininally right-handed
% 15 runs for each participants
numPersons = 9;
numRuns = 15;
filename = cell(numRuns,numPersons);
Offline_eeglab = cell(numRuns,numPersons);
cd /Users/dengxiyu/Desktop/BEngProject
chanloc = 'standard_1005.elc';
% option = [];

%% Load the .gdf data-- Preprocessing
for i = 1:numPersons
    for j = 1:numRuns           
        path = sprintf('/Users/dengxiyu/Desktop/BEngProject/data/P0%d',i);
        fprintf (path);
        cd (path);
        filename{j,i} = sprintf('P0%dRun%d.gdf',i,j);
        fprintf('\n%s\n',filename{j,i});
%         option.filename = filename{j,i};
%         option.filepath = path;
        Offline_eeglab{j,i} = pop_biosig(filename{j,i});
        Offline_eeglab{j,i}.setname = filename{j,i};
        Offline_eeglab{j,i} = pop_chanedit(Offline_eeglab{j,i},'lookup',chanloc);
        
    end
end

%%
cd /Users/dengxiyu/Desktop/BEngProject/code
save Offline_eeglab Offline_eeglab -v7.3

fprintf ('eeg(.gdf) documents for each run are all readed.\n')