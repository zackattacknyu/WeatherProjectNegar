function e = rmse(obj,Xte,Yte)             
% err = rmse(obj, X,Y) : compute the root mean squared error of predictor "obj" on test data (X,Y)
    e = sqrt( mean( (Yte - predict(obj,Xte)).^2 ) );


