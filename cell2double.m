function [ Y ] = cell2double(X,T)
S=size(X);
Y=zeros(S);
if(T==1)
    for i=1:S
        Y(i)=str2double(X{i});
    end
    TF=isnan(Y);
    for i= 1:S
        if(TF(i)==1)
            Y(i)=0;
        end
    end
    
elseif(T==2)
    for i=1:S(1)
        for j=1:S(2)
            Y(i,j)=str2double(X(i,j));
        end
    end
    TF=isnan(Y);
    for i=1:S(1)
        for j=1:S(2)
            if(TF(i,j)==1)
                Y(i,j)=0;
            end
        end
    end
    
    % elseif(T==3)
    %     for i=1:S
    %         Y(i)=str2double(X(i));
    %     end
    %     TF=isnan(Y);
    %     for i= 1:S
    %         if(TF(i)==1)
    %             Y(i)=0;
    %         end
    %     end
end
end
