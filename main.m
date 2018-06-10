% load('faers_signatures_jan2018.mat','abs','kdr','ae_mat','rx');
sizOfAbs=size(abs);
aeCount=str2double(ae_mat(:,2));
drCount=cell2double(rx(:,2),1); %cell2double is function which converts cell value to double.
kdr_d=cell2double(kdr(:,3:end),2);
abs_d=frequencymatrix(abs(:,3:end),rx,sizOfAbs(1),(sizOfAbs(2)-2));
%% high frequency
highFreqAE=find(aeCount>1500);
highFreqDR=find(drCount>10000);
highFreqKDR=kdr_d(highFreqAE,highFreqDR)'; %high frequency KDR
highFreqae_mat=ae_mat(highFreqAE,:); %high frequency AE details
sizeofhighFreqae_mat=size(highFreqae_mat);%2003,2
%[AELIST]=aelist(highFreqAE,ae_mat);
[AELIST]=aelist2_updated(highFreqae_mat(:,1),ae_mat);
sizOfAELIST=size(AELIST);
hfabs=abs_d(highFreqDR,highFreqAE); %high frequency abs



%% To compute all at once
for i=1:sizOfAELIST(1)
    clear Y B Fitinfo val j k value;
    if(cellfun(@isempty,AELIST(i,2)))
        disp(AELIST(i,3));
    else
        hfaenum=AELIST{i,2};
        aenum=AELIST{i,4};
        Y=kdr_d(aenum,:);
        Y=Y';
        n=10;%number of iterations
        hfY=highFreqKDR(:,hfaenum);
        [value]=hfm_computeabs(hfabs,hfY,ae_mat,aenum,sizeofhighFreqae_mat(1),n);

        t=ones(1,n);
        count=0;
		%process to remove duplicates 
        for j=1:(n-1)
            for k=(j+1):n
                if( value(:,j)== value(:,k))
                    if(t(k)==1)
                        count=count + 1;
                        t(k)=0;
                        %else
                    end
                end                
            end
        end    
        model{i}=value(:,find(t>0));
        clear Y B  val j k count t;
    end
end
%%
k=1;
for k=1: sizOfAELIST(1)
    specmodel=model{k}; %specific model   
    if(cellfun(@isempty,model(k)))
        result{k}=0;
    else        
        hfaenum=AELIST{k,2};
        [ms,ns]=size(specmodel);
        if(ms>ns) ms=ns; end
        for i=1:ms
            valX=specmodel(:,i);
            nzvalX=find(valX~=0);
            X=hfabs(:,nzvalX);
            Y=highFreqKDR(:,hfaenum);
            [m, n]=size(X);
            initialTheta=zeros((n+1),1);
            [J,grad]=computeCost(X,Y,initialTheta);
            %run the function optimization algorithm
            options = optimset('GradObj','on','MaxIter',400);
            theta =fminunc(@(t)computeCost(X,Y,t),initialTheta,options);
            %
            predictions=predict(theta,X);
            pred=predictions;
            resp=Y;
            % check the accuracy of the predictions and plot it
            mdl = fitglm(pred,resp,'Distribution','binomial','Link','logit');
            scores = mdl.Fitted.Probability;
            [Xres,Yres,T,AUC] = perfcurve(Y,scores,'1');            
            res{i,1}=Xres;
            res{i,2}=Yres;
            res{i,3}=AUC;            
            if(AUC==1)
                res{i,3}=0;
            end                            
            clear valX nzvalX X1 Y1 m1 n1 initialTheta J grad a options theta pred; 
            clear predictions resp mdl scores Xres Yres T AUC i;
        end  
        s=cellstr(AELIST{k,3});
        legend('DisplayName',s{1});
        result{k}=res;
        clear res;
    end
    clear specmodel;
end
clear m n ns ms k aenum 

%% for base 

% baselist={
%  'enteritis';
% 'enterocolitis';
% 'diarrhoea';
% 'oesophagitis';
% 'necrotising colitis';
% 'colitis';
% 'diarrhoea haemorrhagic';
% 'vomiting';
% 'melaena'     
%  };
%INPUT baselist for given AE 
baselist={
'defaecation urgency';
'diarrhoea';
'diarrhoea haemorrhagic';
'diarrhoea neonatal';
'frequent bowel movements';
'gastrointestinal hypermotility';
'post procedural diarrhoea'
};


[m,n]=size(baselist);
if(m<n) 
    m=n; 
end 
for i=1:m
    baseaelistc{i,1}=i;
    baseaelistc{i,2}=find(strcmp(highFreqae_mat(:,1),baselist(i)));    
    if(isempty(baseaelistc{i,2}))
        baseaelistc{i,2}=0;
    end    
    baseaelistc{i,3}=baselist(i);
    baseaelistc{i,4}=find(strcmp(ae_mat,baselist(i)));
end 

clear X Y
    valx=find(cell2mat(baseaelistc(:,2))>0);                               
    X=hfabs(:,cell2mat(baseaelistc(valx,2)));
    Y=highFreqKDR(:,hfaenum);
    [m, n]=size(X);
    initialTheta=zeros((n+1),1);
    [J,grad]=computeCost(X,Y,initialTheta);
    %run the function optimization algorithm
    options = optimset('GradObj','on','MaxIter',400);
    theta =fminunc(@(t)computeCost(X,Y,t),initialTheta,options);
    %
    predictions=predict(theta,X);
    pred=predictions;
    resp=Y;
    % check the accuracy of the predictions and plot it
    mdl = fitglm(pred,resp,'Distribution','binomial','Link','logit');
    scores = mdl.Fitted.Probability;
    [Xres,Yres,T,AUC] = perfcurve(Y,scores,'1');            
    base{1}=Xres;
    base{2}=Yres;
    base{3}=AUC;            
    if(AUC==1)
        base{3}=0;
    end                            
    clear valX nzvalX X1 Y1 m1 n1 initialTheta J grad a options theta pred; 
    clear predictions resp mdl scores Xres Yres T AUC i;
%%         

%base: has base values X and Y 
%result: has features values X and Y

% b is a matrix with fixed set of color combinations__ increase the set if the number of unique model is more.
b=[0,0,1;
   0,1,0;
   1,0,0;
   0,1,1;
   1,0,1;
   1,1,0;
   0.5,0.5,0.5;
   1,0.5,0.5;
   0.5,1,0.5;
   0.5,0.5,1;
   0,0,0
   ];
 % since there can be at max 10 models, if number of models are increased increase b and c 
c=["model1";"model2";"model3";"model4";"model5";"model6";"model7";"model8";"model9";"model10"];
clear m n;
[m,n]=size(result);
for j=1:m
    val=result{j};
    %[j, index]=max(cell2mat(val(:,3)));
    [mi,ni]=size(val);
    for i=1:mi
        a=b(i,:);            
        Xres=val{i,1};
        Yres=val{i,2};
        plot(Xres,Yres,'Color',a,'DisplayName',strcat(c(i),"-> AUC = ",num2str(val{i,3})," Features: ",num2str(nnz(specmodel(:,i)))));
        hold on;
    end
    legend('Location','southeast');
end

a=[0,0,0];
Xres=base{:,1};
Yres=base{:,2};
plot(Xres,Yres,'Color',a,'DisplayName',strcat("Base MOdel-> AUC = ",num2str(base{1,3})," Features: ",num2str(nnz(cell2mat(baseaelistc(:,2))))));
title(highFreqae_mat(hfaenum));

clear a Xres Yres m mi n ni c valx X Y s i j;




