function [ Y ] = frequencymatrix( abs,rx,r,c)
% r=s(1); %%here r,c are size of abs input matrix(19683 * 4128)
% c=s(2);
Y= zeros(r,c); % 19683, 4128
for i=1:c
    numpatusingdrug=str2double(rx{i,2});
    for j=1:r
        Y(j,i)= str2double(abs{j,i})/numpatusingdrug;
    end
end
Y=Y'; % transpose matrix to get matrix in drug to AE format
TF=isnan(Y);

for i=1:c
    for j=1:r 
        if(TF(i,j)==1)
            Y(i,j)=0;
        end
    end
end
end

