% PCA part decomposation
tic;
fprintf('\nPCA part\n');
numPersons = 9;
numRuns = [3:7,10:13];
numberRuns = length(numRuns);
numEpochs = 40;

% pcaEEG = madEEG;
% pcaCOPY = madEEG;

icaEEG = pcaEEG;
icaCOPY = pcaEEG;

for i = 1:numPersons
    for j = 1:numberRuns
%         for k = 1:numEpochs
%         pcaCOPY{j,i} = eeg_epoch2continuous(pcaCOPY{j,i});
        
        fprintf('\nP0%d Run%d\n',i,numRuns(j));
        [coeff,score,latent,tsquared,explained] = pca(icaCOPY{j,i}.data);
        percentages = cumsum(explained);
        PC99 = find(percentages >= 99,1)
%         
%         pcaCOPY{j,i} = pop_select(icaCOPY{j,i},'nochannel',[61,62,63]);

%         event_list = extractfield(icaCOPY{j,i}.event,'type');
%         boundary_index = find(strcmp(event_list, 'boundary'));
%         icaCOPY{j,i} = pop_editeventvals(icaCOPY{j,i},'delete',boundary_index);
%         
%         icaCOPY{j,i} = pop_epoch(icaCOPY{j,i}, {'776' '777' '779' '925' '926'} , [-2 3]);
%         icaCOPY{j,i} = pop_rmbase(icaCOPY{j,i},[-2000 0],[],[]);
        
%         pcaCOPY{j,i} = pop_runica(pcaCOPY{j,i},'pca',PC99,'interupt','off');

        icaCOPY{j,i} = pop_runica(icaCOPY{j,i},'pca',PC99,'interupt','off');
        
%         unmix = icaCOPY{j,i}.icaweights * icaCOPY{j,i}.icasphere;
%         mix = pinv(unmix);
%         icaCOPY{j,i}.data = mix * icaCOPY{j,i}.icaact;
       
%         ICs_to_remove = find(icaCOPY{j,i}.reject.gcompreject); 
%         icaEEG{j,i} = pop_subcomp(icaCOPY{j,i}, ICs_to_remove, 0);
        
    end  
end
icatest = icaCOPY;
toc;
%% MARA
tic;
icaCOPY = icatest;
options = [0,0,0,0,0]
fprintf('begin MARA here!\n');
for i = 1:numPersons
    for j = 1:numberRuns
        [ALLEEG,icaMARA{j,i},CURRENTSET] = processMARA(icaCOPY{j,i},icaCOPY{j,i},1,options);
        icaMARA{j,i}.reject.gcompreject = zeros(size(icaMARA{j,i}.reject.gcompreject));
        icaMARA{j,i}.reject.gcompreject(icaMARA{j,i}.reject.MARAinfo.posterior_artefactprob > 0.70) = 1;

        if mean(icaMARA{j,i}.reject.gcompreject) == 1
            icaMARA{j,i}.reject.gcompreject = zeros(size(icaMARA{j,i}.reject.gcompreject));
            [b,c] = sort(icaMARA{j,i}.reject.MARAinfo.posterior_artefactprob);
            l = size(icaMARA{j,i}.reject.MARAinfo.posterior_artefactprob,2);
            icaMARA{j,i}.reject.gcompreject(1,c(l-4)) = 1;
            icaMARA{j,i}.reject.gcompreject(1,c(l-3)) = 1;
            icaMARA{j,i}.reject.gcompreject(1,c(l-2)) = 1;
            icaMARA{j,i}.reject.gcompreject(1,c(l-1)) = 1;
            icaMARA{j,i}.reject.gcompreject(1,c(l)) = 1;            
        end
        ICs_to_remove = find(icaMARA{j,i}.reject.gcompreject);
        icaMARA{j,i} = pop_subcomp(icaMARA{j,i}, ICs_to_remove, 0);
        
%         unmix = icaMARA{j,i}.icaweights * icaMARA{j,i}.icasphere;
%         mix = pinv(unmix);
%         icaMARA{j,i}.data = mix * icaCOPY{j,i}.icaact;
    end
end
toc;
%% ICLabel
tic;
icaLabel = icatest;
fprintf('begin IClabel here!\n');
for i = 1:numPersons
    for j = 1:numberRuns
        fprintf('\nP0%d Run%d\n',i,numRuns(j));
        icaLabel{j,i} = iclabel(icaLabel{j,i});
        icaLabel{j,i}.reject.gcompreject = zeros(size(icaLabel{j,i}.reject.gcompreject));
        threshod = icaLabel{j,i}.etc.ic_classification.ICLabel.classifications(:,1)+icaLabel{j,i}.etc.ic_classification.ICLabel.classifications(:,7);
        icaLabel{j,i}.reject.gcompreject(threshod<0.6) = 1;
        ICs_to_remove = find(icaLabel{j,i}.reject.gcompreject)
        icaLabel{j,i} = pop_subcomp(icaLabel{j,i}, ICs_to_remove, 0);
    end
end
toc;


%% Adjust

icaAdjust = pcaEEG;
icatest = icaCOPY;
fprintf('begin Adjust here!\n');
for i = 1:numPersons
    for j = 1:numberRuns
         
        % copy ICA weights that would be transferred 
        ICA_WINV{j,i}=icatest{j,i}.icawinv; 
        ICA_SPHERE{j,i} = icatest{j,i}.icasphere;
        ICA_WEIGHTS{j,i} = icatest{j,i}.icaweights;
        ICA_CHANSIND{j,i} = icatest{j,i}.icachansind;
        
        % transfer the ICA weights to the original dataset
        icaAdjust{j,i}.icawinv=ICA_WINV{j,i}; 
        icaAdjust{j,i}.icasphere=ICA_SPHERE{j,i}; 
        icaAdjust{j,i}.icaweights=ICA_WEIGHTS{j,i}; 
        icaAdjust{j,i}.icachansind=ICA_CHANSIND{j,i};
        
        % epoch again
        event_list = extractfield(icatest{j,i}.event,'type');
        boundary_index = find(strcmp(event_list, 'boundary'));
        icatest{j,i} = pop_editeventvals(icatest{j,i},'delete',boundary_index);
        
        icatest{j,i} = pop_epoch(icatest{j,i}, {'776' '777' '779' '925' '926'} , [-2 3],'newname','epoched','epochinfo', 'yes');
        icatest{j,i} = pop_rmbase(icatest{j,i},[-2000 0],[],[]);
        
        icatest{j,i}.chanlocs(61).theta = -50;
        icatest{j,i}.chanlocs(62).theta = 120;
        icatest{j,i}.chanlocs(63).theta = 50;
        icatest{j,i}.chanlocs(61).radius = 0.5;
        icatest{j,i}.chanlocs(63).radius = 0.5;
        icatest{j,i}.chanlocs(62).radius = 0;
        icatest{j,i}.chanlocs(61).X = 0;
        icatest{j,i}.chanlocs(63).X = 0;
        icatest{j,i}.chanlocs(62).X = 0;
        icatest{j,i}.chanlocs(61).Y = 0;
        icatest{j,i}.chanlocs(63).Y = 0;
        icatest{j,i}.chanlocs(62).Y = 0;
        icatest{j,i}.chanlocs(61).Z = 0;
        icatest{j,i}.chanlocs(63).Z = 0;
        icatest{j,i}.chanlocs(62).Z = 0;
        
        icatest{j,i} = eeg_checkset(icatest{j,i});

        
        
        % run adjust to find bad IC/s
        if [i,j]~=[2,9]
            if [i,j]~= [6,4]
        badIC{j,i} = ADJUST(icatest{j,i}, [icatest{j,i}.setname,'_adjust_report']);
        
        % mark the bad ICs identified by ADJUST
        for ic = 1:length(badIC{j,i}) 
            icatest{j,i}.reject.gcompreject(1, badIC{j,i}(ic))=1;
        end
        % remove artifact laden ICs from dataset
        ICs_to_remove = find(icatest{j,i}.reject.gcompreject); 
        icatest{j,i} = pop_subcomp(icatest{j,i}, ICs_to_remove, 0);
        icaAdjust{j,i} = icatest{j,i};
            end
        end

    end   
end


            
            





% ica_sup = bw_sup;
% ica_pro = bw_pro;
% ica_open = bw_open;
% ica_palmar = bw_palmar;
% ica_lateral = bw_lateral;
% 
% % supination
% for i = 1:numPersons
%     for j = 1:numberRuns
% %       ICA_activations = wts * sph * data;
%         ica_sup{j,i} = PCAICA(ica_sup{j,i});
%         ica_pro{j,i} = PCAICA(ica_pro{j,i});
%         ica_open{j,i} = PCAICA(ica_open{j,i});
%         ica_palmar{j,i} = PCAICA(ica_palmar{j,i});
%         ica_lateral{j,i} = PCAICA(ica_lateral{j,i});
% %         sup = reshape(ica_sup{j,i}.data(:,:,:),60,1280*8);
% %         [coeff,score,latent] = pca(sup);
% %         sumVar = sum(latent);
% %         cutVar = 0.99 * sumVar;
% %         currentVar = latent(1,1);
% %         for l = 1:length(latent)
% %             if currentVar < cutVar
% %                 currentVar = currentVar + latent(l,1);
% %             else
% %                 rank = l-1;
% %                 fprintf('current:%d\n',rank);
% %                 break
% %             end         
% %         end
% %         ica_sup{j,i}= pop_runica(ica_sup{j,i},'pca',rank);
% %         unmix = ica_sup{j,i}.icaweights * ica_sup{j,i}.icasphere;
% %         mix = pinv(unmix);
% %         for k = 1:numEpoch
% %         ica_sup{j,i}.data(:,:,k) = mix * ica_sup{j,i}.icaact(:,:,k);
% %         end
%     end
% end


        
% for i = 1:numPersons
%     for j = 1:(numEpochs * numPersons)
%         fprintf('\nPerson: %d,Epoch: %d\n',i,j);
%         % supination
%         [coeff1,score1,latent1] = pca(sup_bw{i,1}(:,:,j));
%         sumVar = sum(latent1);
%         cutVar = 0.99 * sumVar;
%         currentVar = latent1(1,1);
%         for k = 1:length(latent1)
%             if currentVar < cutVar
%                 currentVar = currentVar + latent1(k,1);
%             else
%                 rank_sup{i,j} = k-1;
%                 break
%             end
%         end
%         % pronation
%         [coeff2,score2,latent2] = pca(pro_bw{i,1}(:,:,j));
%         sumVar = sum(latent2);
%         cutVar = 0.99 * sumVar;
%         currentVar = latent2(1,1);
%         for k = 1:length(latent2)
%             if currentVar < cutVar
%                 currentVar = currentVar + latent2(k,1);
%             else
%                 rank_pro{i,j} = k-1;
%                 break
%             end
%         end
%         % open
%         [coeff3,score3,latent3] = pca(open_bw{i,1}(:,:,j));
%         sumVar = sum(latent3);
%         cutVar = 0.99 * sumVar;
%         currentVar = latent3(1,1);
%         for k = 1:length(latent3)
%             if currentVar < cutVar
%                 currentVar = currentVar + latent3(k,1);
%             else
%                 rank_open{i,j} = k-1;
%                 break
%             end
%         end
%         % palmar grasp
%         [coeff4,score4,latent4] = pca(palmar_bw{i,1}(:,:,j));
%         sumVar = sum(latent4);
%         cutVar = 0.99 * sumVar;
%         currentVar = latent4(1,1);
%         for k = 1:length(latent4)
%             if currentVar < cutVar
%                 currentVar = currentVar + latent4(k,1);
%             else
%                 rank_palmar{i,j} = k-1;
%                 break
%             end
%         end
%         [coeff5,score5,latent5] = pca(lateral_bw{i,1}(:,:,j));
%         sumVar = sum(latent5);
%         cutVar = 0.99 * sumVar;
%         currentVar = latent5(1,1);
%         for k = 1:length(latent5)
%             if currentVar < cutVar
%                 currentVar = currentVar + latent5(k,1);
%             else
%                 rank_lateral{i,j} = k-1;
%                 break
%             end
%         end
%         
%     end
% end

% for i = 1:numPersons
%     for j = 1:numRuns
%         fprintf('\nPerson: %d,Run: %d\n',i,j);
%         [coeff,score,latent] = pca(cleandata{j,i}.data);
%         sumVar = sum(latent);
%         cutVar = 0.99 * sumVar;
%         currentVar = latent(1,1);
%         for k = 1:length(latent)
%             if currentVar < cutVar
%                 currentVar = currentVar + latent(k,1);
%             else
%                 rank = k-1;
%                 break
%             end
%         end
%         
%         log = 'testlog';
%         ica_channel = 1:cleandata{j,i}.nbchan;
%         ica_data{j,i} = pop_runica(cleandata{j,i},'extended',1,'icatype','runica','logfile',log,'chanind',ica_channel,'pca',rank);
%     end
% end