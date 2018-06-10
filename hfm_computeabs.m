function [ val] = hfm_computeabs(X,Y,ae_mat,aenum,S,n)
sY=size(find(Y>0));
if(sY(2)>0)
    val=replasso(X,Y,S,n);
end 
%filename
f1=ae_mat{aenum};
f2='_HFMABS.xlsx';
filename = [f1 f2];
%write the output into excel
xlswrite(filename,val);
end

