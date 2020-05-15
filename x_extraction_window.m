
numPersons = 9;
nbchan = 60;


%% reshape the data
% for i = 1:numPersons
%     s = size(all_sup{i,1},3);
%     fed_sup{i,1} = reshape(permute(all_sup{i,1}(:,9:1280,:),[3 2 1]),s,60*1272);
%     p = size(all_pro{i,1},3);
%     fed_pro{i,1} = reshape(permute(all_pro{i,1}(:,9:1280,:),[3 2 1]),p,60*1272);
%     o = size(all_open{i,1},3);
%     fed_open{i,1} = reshape(permute(all_open{i,1}(:,9:1280,:),[3 2 1]),o,60*1272);
%     pa = size(all_palmar{i,1},3);
%     fed_palmar{i,1} = reshape(permute(all_palmar{i,1}(:,9:1280,:),[3 2 1]),pa,60*1272);
%     l = size(all_lateral{i,1},3);
%     fed_lateral{i,1} = reshape(permute(all_lateral{i,1}(:,9:1280,:),[3 2 1]),l,60*1272);
% end

%% calculate the movemean by step of 16 samples / 58 windows from 8 - 1280

t = linspace(8,920,58);
w = 3480;
for i = 1:9
    
    s = size(per_sup{i,1},1);
    for j = 1:s
        for k = 1:w
            f_sup{i,1}(j,k) = mean(per_sup{i,1}(j,(k-1)*16+1:(k-1)*16+360));
        end
    end
    
    p = size(per_pro{i,1},1);
    for j = 1:p
        for k = 1:w
            f_pro{i,1}(j,k) = mean(per_pro{i,1}(j,(k-1)*16+1:(k-1)*16+360));
        end
    end    
    
    o = size(per_ope{i,1},1);
    for j = 1:o
        for k = 1:w
            f_ope{i,1}(j,k) = mean(per_ope{i,1}(j,(k-1)*16+1:(k-1)*16+360));
        end
    end    

    pa = size(per_pal{i,1},1);
    for j = 1:pa
        for k = 1:w
            f_pal{i,1}(j,k) = mean(per_pal{i,1}(j,(k-1)*16+1:(k-1)*16+360));
        end
    end
    
    l = size(per_lat{i,1},1);
    for j = 1:l
        for k = 1:w
            f_lat{i,1}(j,k) = mean(per_lat{i,1}(j,(k-1)*16+1:(k-1)*16+360));
        end
    end
    
%     subout = [];
%     for i = 1:nbchan
%         a = (matlab.tall.movingWindow(@mean,360,input(i,:,t)','Stride',16,'Endpoint','discard'))';
%         subout = cat(1,subout,a);
%     end
    
%     output = cat(3,output,subout);    
end

