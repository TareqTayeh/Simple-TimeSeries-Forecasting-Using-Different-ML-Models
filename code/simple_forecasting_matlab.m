%Import data to table & format
T = readtable('Canada_CO2_Emissions_per_Capita.xlsx','Range','C51:D219');
header = {'Year','Canada CO2 Emissions per Capita'};
T.Properties.VariableNames = header;
%Create and fill the variables required
year = T{:,1};
emissions = T{:,2};
%Determine the training and test size
trainingSz = round(0.80*size(T,1));
testSz = size(T,1) - trainingSz;
%Setting the training and test sets
training = head(T,trainingSz);
test = tail(T,testSz);
%Plot chart with 168 data points
figure(1)
plot(year, emissions);
title("Canada CO2 Emissions per Capita")
xlabel("Year")
ylabel("CO2 Emissions per Capita (Tonnes per Capita)")
hold on;
%SVR Model & Visualization
Mdl = fitrsvm(training,'Canada CO2 Emissions per Capita');
svrPrediction = predict(Mdl, test);
plot(year(trainingSz + 1 : trainingSz + testSz), svrPrediction, '-red');
hold on;
%GPR Model & Visualization
Mdl = fitrgp(training,'Canada CO2 Emissions per Capita');
gprPrediction = predict(Mdl, test);
plot(year(trainingSz + 1 : trainingSz + testSz), gprPrediction, '-green');
hold on;
%BRTE Model & Visualization
Mdl = fitrensemble(training,'Canada CO2 Emissions per Capita');
brtePrediction = predict(Mdl, test);
plot(year(trainingSz + 1 : trainingSz + testSz), brtePrediction, '-black');
%Add Legend to Chart
legend(["Observed","SVR","GPR", "BRTE"])
%Calculating RMSE Errors
svrRMSE = sqrt(mean((emissions((trainingSz + 1) : (trainingSz + testSz)) - (svrPrediction)) .^2));
gprRMSE = sqrt(mean((emissions((trainingSz + 1) : (trainingSz + testSz)) - (gprPrediction)) .^2));
brteRMSE = sqrt(mean((emissions((trainingSz + 1) : (trainingSz + testSz)) - (brtePrediction)) .^2));
%Calculating MAPE Errors
svrMAPE = mean(abs(((svrPrediction - (test{:,2})) ./ (test{:,2})) * 100));
gprMAPE = mean(abs(((gprPrediction - (test{:,2})) ./ (test{:,2})) * 100));
brteMAPE = mean(abs(((brtePrediction - (test{:,2})) ./ (test{:,2})) * 100));
%Plot SVR Observed & Predicted & Errors
hold off;
figure(2);
subplot(3,1,1);
plot(test{:,2}, '-blue');
hold on;
plot(svrPrediction, '-red');
legend(["Observed","SVR"])
title("SVR: Observed vs Predicted Canada CO2 Emissions per Capita")
ylabel("CO2 Emissions per Capita")
subplot(3,1,2); 
stem(svrPrediction - test{:,2});
title("RMSE = " + svrRMSE);
xlabel("Year");
ylabel("Error");
subplot(3,1,3)
stem(((svrPrediction - (test{:,2}))./(test{:,2}))*100);
title("MAPE = " + svrMAPE);
xlabel("Year");
ylabel("Error %");
%Plot GPR Observed & Predicted & Errors
figure(3);
subplot(3,1,1);
plot(test{:,2}, '-blue');
hold on;
plot(gprPrediction, '-red');
legend(["Observed","GPR"])
title("GPR: Observed vs Predicted Canada CO2 Emissions per Capita")
ylabel("CO2 Emissions per Capita")
subplot(3,1,2); 
stem(gprPrediction - test{:,2});
title("RMSE = " + gprRMSE);
xlabel("Year");
ylabel("Error");
subplot(3,1,3)
stem(((gprPrediction - (test{:,2}))./(test{:,2}))*100);
title("MAPE = " + gprMAPE);
xlabel("Year");
ylabel("Error %");
%Plot BRTE Observed & Predicted & Errors
figure(4);
subplot(3,1,1);
plot(test{:,2}, '-blue');
hold on;
plot(brtePrediction, '-red');
legend(["Observed","BRTE"])
title("BRTE: Observed vs Predicted Canada CO2 Emissions per Capita")
ylabel("CO2 Emissions per Capita")
subplot(3,1,2); 
stem(brtePrediction - test{:,2});
title("RMSE = " + brteRMSE);
xlabel("Year");
ylabel("Error");
subplot(3,1,3)
stem(((brtePrediction - (test{:,2}))./(test{:,2}))*100);
title("MAPE = " + brteMAPE);
xlabel("Year");
ylabel("Error %");

