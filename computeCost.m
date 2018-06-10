function [ j,grad ] = computeCost( X,Y,Theta )

m= size(X,1);
X=[ones(m,1) X];
% Theta=initialTheta;
% an=X*Theta;
h=Sigmoid(X*Theta);

j=-(1/m)*sum(Y.*log(h)+(1-Y).* log(1-h));
grad= zeros(size(Theta,1),1);
for i=1:size(grad)
    grad(i)=(1/m) * sum((h-Y)' *X(:,i));

end

