%%
 % we computed the ICA only on samples with an absolute value of 
 % less than 10.4 times the median absolute deviation (MAD)85 of a channel. 
 
 % MAD part
 fprintf('\nMAD part\n');
numPersons = 9;
numRuns = [3:7,10:13];
numEpochs = 40;
numberRuns = length(numRuns);


pcaEEG = bwEEG;


% for i = 1:numPersons
%     for j = 1:numberRuns
%         [coeff,score,latent,tsquared,explained] = pca(pcaEEG{j,i}.data);
%         percentages = cumsum(explained);
%         PC99 = find(percentages >= 99,1);
%         pcaEEG{j,i}.data = score(:,1:PC99)*coeff(:,1:PC99)';
%     end
% end

madEEG = pcaEEG;

for i = 1:numPersons
     for j = 1:numberRuns
         fprintf('\nP0%d Run%d\n',i,numRuns(j));
         madEEG{j,i}.data = filloutliers(pcaEEG{j,i}.data,'clip','median',2,'ThresholdFactor',10.4);
    end
 end
 
%          10.4 * mad(madEEG{j,i}.data,1,2);
%          [numChan,len] = size(madEEG{j,i}.data);
%          t_mad = mad(madEEG{j,i}.data,1,2);
%          t_med = median(madEEG{j,i}.data,2);
%          [r,c] = find((abs(madEEG{j,i}.data-t_med)./t_mad)>10.4);
%          madEEG{j,i}.data(r,c) = 0;


%          madEEG{j,i}.data(madEEG{j,i}.data>hight | madEEG{j,i}.data<lowt)=0;
%          for k = 1:numChan
%              cutMad = repmat(10.4 * mad(madEEG{j,i}.data,2,2),1,len);
%              for l = 1:len
%                  if abs(madEEG{j,i}.data(k,l)) > cutMad
%                      madEEG{j,i}.data(k,l) = 0;
%                  end
%              end
%         end
 
%  
% %  rank = data_ori.nbchan;
%   for i = 1:rank
%     cutMad = 10.4 * mad(test_ica.icaact(i,:));
%     for j = 1:length(test_ica.icaact)
%         if abs(test_ica.icaact(i,j)) > cutMad 
%             test_ica.icaact(i,j) = 0;
%         end
%     end
%  end