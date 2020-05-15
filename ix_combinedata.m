numPersons = 9;
numRuns = [3:7,10:13];
numberRuns = length(numRuns);

% reshape(permute(clean_open{1,1}.data(:,:,:),[3 2 1]),8,58*1280);

%% CAR

for i = 1:numPersons
    for j = 1:numberRuns
        if ~isempty(clean_sup{j,i}) && ~isempty(clean_sup{j,i}.data)
        clean_sup{j,i} = pop_reref(clean_sup{j,i},[]);
        end
        if ~isempty(clean_pro{j,i}) && ~isempty(clean_pro{j,i}.data)
        clean_pro{j,i} = pop_reref(clean_pro{j,i},[]);
        end
        if ~isempty(clean_open{j,i})
        clean_open{j,i} = pop_reref(clean_open{j,i},[]);
        end
        if ~isempty(clean_palmar{j,i}) && ~isempty(clean_palmar{j,i}.data)
        clean_palmar{j,i} = pop_reref(clean_palmar{j,i},[]);
        end
        if ~isempty(clean_lateral{j,i})
        clean_lateral{j,i} = pop_reref(clean_lateral{j,i},[]);
        end
    end
end

%% reshape the data

for i = 1:numPersons
    if ~isempty(clean_sup{1,i})
        sup = clean_sup{1,i}.data;
    else
        sup = [];
    end
    if ~isempty(clean_pro{1,i})
    pro = clean_pro{1,i}.data;
    else
        pro = [];
    end
    
    if ~isempty(clean_open{1,i})
    open = clean_open{1,i}.data;
    else
        open = [];
    end
        
    if ~isempty(clean_palmar{1,i})
    palmar = clean_palmar{1,i}.data;
    else
        palmar = [];
    end
    
    if ~isempty(clean_lateral{1,i})
        lateral = clean_lateral{1,i}.data;
    else
        lateral = [];
    end
    
    for j=1:numberRuns-1
        fprintf('\nP0%d Run%d\n',i,numRuns(j));
        if ~isempty(clean_sup{j+1,i})
        sup = cat(3, sup, clean_sup{j+1,i}.data);
        end
        if ~isempty(clean_pro{j+1,i})
        pro = cat(3, pro, clean_pro{j+1,i}.data);
        end
        if ~isempty(clean_open{j+1,i})
        open = cat(3, open, clean_open{j+1,i}.data);
        end
        if ~isempty(clean_palmar{j+1,i})
        palmar = cat(3, palmar, clean_palmar{j+1,i}.data);
        end
        if ~isempty(clean_lateral{j+1,i})
        lateral = cat(3, lateral, clean_lateral{j+1,i}.data);
        end
    end
    all_sup{i,1} = sup;
    all_pro{i,1} = pro;
    all_open{i,1} = open;
    all_palmar{i,1} = palmar;
    all_lateral{i,1} = lateral;
end

%% permute
for i = 1:numPersons
    k1 = size(all_sup{i,1},3);
    per_sup{i,1} = reshape(permute(all_sup{i,1},[3 2 1]),k1,60*1280);
    k2 = size(all_pro{i,1},3);
    per_pro{i,1} = reshape(permute(all_pro{i,1},[3 2 1]),k2,60*1280);
    k3 = size(all_open{i,1},3);
    per_ope{i,1} = reshape(permute(all_open{i,1},[3 2 1]),k3,60*1280);
    k4 = size(all_palmar{i,1},3);
    per_pal{i,1} = reshape(permute(all_palmar{i,1},[3 2 1]),k4,60*1280);
    k5 = size(all_lateral{i,1},3);
    per_lat{i,1} = reshape(permute(all_lateral{i,1},[3 2 1]),k5,60*1280);   
end

% for i = 1:numPersons
%     s = size(all_sup{i,1},3);
%     for j = 1:s
%         all_sup{i,1}(:,:,j) = all_sup{i,1}(:,:,j) - repmat(mean(all_sup{i,1}(:,:,j),1),60,1);
%     end
%     
%     p = size(all_pro{i,1},3);
%     for j = 1:p
%         all_pro{i,1}(:,:,j) = all_pro{i,1}(:,:,j) - repmat(mean(all_pro{i,1}(:,:,j),1),60,1);
%     end
%     
%     o = size(all_open{i,1},3);
%     for j = 1:o
%         all_open{i,1}(:,:,j) = all_open{i,1}(:,:,j) - repmat(mean(all_open{i,1}(:,:,j),1),60,1);
%     end
%     
%     pa = size(all_palmar{i,1},3);
%     for j = 1:pa
%         all_palmar{i,1}(:,:,j) = all_palmar{i,1}(:,:,j) - repmat(mean(all_palmar{i,1}(:,:,j),1),60,1);
%     end
%     
%     l = size(all_lateral{i,1},3);
%     for j = 1:l
%         all_lateral{i,1}(:,:,j) = all_lateral{i,1}(:,:,j) - repmat(mean(all_lateral{i,1}(:,:,j),1),60,1);
%     end
% end

