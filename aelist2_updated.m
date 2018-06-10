function [ aelistc ] = aelist2_updated( a_r,ae_mat ) %highfreqmat    %ae_mat

% %For 2018 data
 aelist={
%  'enteritis';
% 'enterocolitis';
'diarrhoea';
% 'oesophagitis';
% 'necrotising colitis';
% 'colitis';
% 'diarrhoea haemorrhagic';
% 'vomiting';
% 'melaena'     
 };


[m,n]=size(aelist);

if(m<n) 
    m=n; 
end 

for i=1:m
    aelistc{i,1}=i;
    aelistc{i,2}=find(strcmp(a_r,aelist(i)));
    
%     if(isempty(aelistc{i,2}))
%         aelistc{i,2}=0;
%     end
    
    aelistc{i,3}=aelist(i);
    aelistc{i,4}=find(strcmp(ae_mat,aelist(i)));
end 

% aa=cell2mat(aelistc(:,1));
% cc=cell2mat(aelistc(:,1));
% dd=cell2mat(aelistc(:,1));

end

