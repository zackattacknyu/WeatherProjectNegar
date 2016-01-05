n = 7;

mVals = 8:150;
prob = zeros(size(mVals));
for i = 1:length(mVals)
    
    m = mVals(i);

    numer = nchoosek(m-1,n-1);
    denom = nchoosek(n+m-1,n-1);
    prob(i)= 1-(numer/denom);
    
    
end
%%
figure 
hold on
plot(mVals,prob,'g-');

mu = expfit(prob);
xx = mVals;
yy = (1/mu).*exp(xx./(-mu));
plot(xx+min(mVals),yy,'r-');
hold off