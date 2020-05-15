
%% epoch data and reject abnormal trials
numPersons = 9;
numRuns = [3:7,10:13];
numberRuns = length(numRuns);

% checkEEG = epochEEG;
test = icaAdjust;

for i = 1:numPersons    
    for j = 1:numberRuns
        
        
        test{j,i} = pop_select(test{j,i},'nochannel',[61,62,63]);
        checkEEG{j,i} = test{j,i};
        if size(checkEEG{j,i}.data,3)
        event_list = extractfield(test{j,i}.event,'type');
        boundary_index = find(strcmp(event_list, 'boundary'));
        test{j,i} = pop_editeventvals(test{j,i},'delete',boundary_index);
        
        epochEEG{j,i} = pop_epoch(test{j,i}, {'776' '777' '779' '925' '926'} , [-2 3]);
        epochEEG{j,i} = pop_rmbase(epochEEG{j,i},[-2000 0],[],[]);
        checkEEG{j,i} = epochEEG{j,i};
        end
%         for k = 1:60
%             for l = 1:40
%                 m = mean(epochEEG{j,i}.data(k,:,l));
%                 epochEEG{j,i}.data(k,:,l) = epochEEG{j,i}.data(k,:,l) - repmat(m,1,1280);
%             end
%         end
        
        fprintf('\nP0%d Run%d\n',i,numRuns(j));
        if size(checkEEG{j,i},3) >1
        [checkEEG{j,i} Indexes] = pop_eegthresh(checkEEG{j,i},1,1:checkEEG{j,i}.nbchan,-100,100,-2,3,0,1); 
        end
        if size(checkEEG{j,i},3) >1
        checkEEG{j,i} = pop_jointprob(checkEEG{j,i},1,1:checkEEG{j,i}.nbchan,5,5);
        end
        if size(checkEEG{j,i},3) >1
        checkEEG{j,i} = pop_rejkurt(checkEEG{j,i},1,1:checkEEG{j,i}.nbchan,5,5);
        end
    end
end
% 
%% classify data into 5 classes
for i = 1:numPersons
    for j = 1:numberRuns
        fprintf('\nP0%d Run%d\n',i,numRuns(j)); 
        event_list = extractfield(checkEEG{j,i}.event,'type');
        if(find(strcmp(event_list, '776')))
            labelSup{j,i} = pop_epoch(checkEEG{j,i}, {'776'} , [-2 3]);
        end
        if(find(strcmp(event_list, '777')))
            labelPro{j,i} = pop_epoch(checkEEG{j,i}, {'777'} , [-2 3]);
        end
        if(find(strcmp(event_list, '779')))
            labelOpe{j,i} = pop_epoch(checkEEG{j,i}, {'779'} , [-2 3]);
        end
        if(find(strcmp(event_list, '925')))
            labelPar{j,i} = pop_epoch(checkEEG{j,i}, {'925'} , [-2 3]);
        end
        if(find(strcmp(event_list, '926')))
            labelLat{j,i} = pop_epoch(checkEEG{j,i}, {'926'} , [-2 3]);
        end
    end
end

%% Find value above/below -100uV and 100uV respectively and reject them
check_sup = epoch_sup;
check_pro = epoch_pro;
check_open = epoch_open;
check_palmar = epoch_palmar;
check_lateral = epoch_lateral;

 fprintf('\nFind -100u to 100uV part, and reject them\n');
 
 for i = 1:numPersons
     for j = 1:numberRuns
         [check_sup{j,i} Indexes_sup] = pop_eegthresh(check_sup{j,i},1,1:check_sup{j,i}.nbchan,-100,100,-2,2.9961,0,1);
         [check_pro{j,i} Indexes_pro] = pop_eegthresh(check_pro{j,i},1,1:check_pro{j,i}.nbchan,-100,100,-2,2.9961,0,1);
         [check_open{j,i} Indexes_open] = pop_eegthresh(check_open{j,i},1,1:check_open{j,i}.nbchan,-100,100,-2,2.9961,0,1);
         [check_palmar{j,i} Indexes_palmar] = pop_eegthresh(check_palmar{j,i},1,1:check_palmar{j,i}.nbchan,-100,100,-2,2.9961,0,1);
         [check_lateral{j,i} Indexes_lateral] = pop_eegthresh(check_lateral{j,i},1,1:check_lateral{j,i}.nbchan,-100,100,-2,2.9961,0,1);
         
         check_sup{j,i} = pop_jointprob(check_sup{j,i},1,1:check_sup{j,i}.nbchan,5,5);
         check_pro{j,i} = pop_jointprob(check_pro{j,i},1,1:check_pro{j,i}.nbchan,5,5);
         check_open{j,i} = pop_jointprob(check_open{j,i},1,1:check_open{j,i}.nbchan,5,5);
         check_palmar{j,i} = pop_jointprob(check_palmar{j,i},1,1:check_palmar{j,i}.nbchan,5,5);
         check_lateral{j,i} = pop_jointprob(check_lateral{j,i},1,1:check_lateral{j,i}.nbchan,5,5);
         
         check_sup{j,i} = pop_rejkurt(check_sup{j,i},1,1:check_sup{j,i}.nbchan,5,5);
         check_pro{j,i} = pop_rejkurt(check_pro{j,i},1,1:check_pro{j,i}.nbchan,5,5);
         check_open{j,i} = pop_rejkurt(check_open{j,i},1,1:check_open{j,i}.nbchan,5,5);
         check_palmar{j,i} = pop_rejkurt(check_palmar{j,i},1,1:check_palmar{j,i}.nbchan,5,5);
         check_lateral{j,i} = pop_rejkurt(check_lateral{j,i},1,1:check_lateral{j,i}.nbchan,5,5);
     end
 end
 
 
  %% Find the trials with abnormal joint probabilities
 % jointprob() Rejection of odd columns of a data array using joint probability of the values 
 % in that column (and using the probability distribution of all columns)
%  fprintf('\nFind abnormal joint probabilities part\n');
%  
%  for i = 1:numPersons
%    for j = 1:numberRuns
%        check_sup{j,i} = pop_jointprob(check_sup{j,i},1,1:check_sup{j,i}.nbchan,5,5);
%        check_pro{j,i} = pop_jointprob(check_pro{j,i},1,1:check_pro{j,i}.nbchan,5,5);
%        check_open{j,i} = pop_jointprob(check_open{j,i},1,1:check_open{j,i}.nbchan,5,5);
%        check_palmar{j,i} = pop_jointprob(check_palmar{j,i},1,1:check_palmar{j,i}.nbchan,5,5);
%        check_lateral{j,i} = pop_jointprob(check_lateral{j,i},1,1:check_lateral{j,i}.nbchan,5,5);       
%    end
%  end
%   
%  %% Find trials with abnormal kurtosis (5 times the standard deviation)
%  fprintf('\nFind abnormal kurtosis part\n');
% 
%  for i = 1:numPersons
%      for j = 1:numberRuns
%          fprintf('sup');
%          check_sup{j,i} = pop_rejkurt(check_sup{j,i},1,1:check_sup{j,i}.nbchan,5,5);
%          fprintf('pro');
%          check_pro{j,i} = pop_rejkurt(check_pro{j,i},1,1:check_pro{j,i}.nbchan,5,5);
%          fprintf('open');
%          check_open{j,i} = pop_rejkurt(check_open{j,i},1,1:check_open{j,i}.nbchan,5,5);
%          fprintf('palmar');
%          check_palmar{j,i} = pop_rejkurt(check_palmar{j,i},1,1:check_palmar{j,i}.nbchan,5,5);
%          fprintf('lateral');
%          check_lateral{j,i} = pop_rejkurt(check_lateral{j,i},1,1:check_lateral{j,i}.nbchan,5,5);
%      end
%  end
 
for i = 1:9
    for j = 1:9
        size(check{j,i}.data,3)
    end
end
