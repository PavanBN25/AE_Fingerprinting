function [ val ] = replasso( X,Y,S,n )
 %j=10; % number of iterations
 j=n;
val=zeros(S,j);
for i=1:j
    [B,Fitinfo]=lasso(X,Y,'CV',10);
    val(:,i)=B(:,Fitinfo.IndexMinMSE);
    clear  B Fitinfo;
end
clear  B Fitinfo;
end

