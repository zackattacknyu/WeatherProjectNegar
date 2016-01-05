n = 7;

mVals = 8:150;
prob = zeros(size(mVals));
for i = 1:length(mVals)
    
    m = mVals(i);

    numer = nchoosek(m-1,n-1);
    denom = nchoosek(n+m-1,n-1);
    prob(i)= 1-(numer/denom);
    
    
end

figure 
plot(mVals,prob,'g-');