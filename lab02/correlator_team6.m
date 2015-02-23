clear all;
close all;
clc;
number=100;     % total transmission time (300s)/each signal duration (3s)

% randomly choose one of the four equiprobable signals
seedUsed = rng;

sampleRate = 1000;
% 1000 samples per second means 3000 samples per signal
time = linspace(0,3,3*sampleRate);
nsamples = length(time);

s1 = ones(1,nsamples);
s1(2*sampleRate:end) = 0;

s2 = ones(1,nsamples);
s2(1:sampleRate-1) = 1;
s2(sampleRate:(2*sampleRate)-1) = -1;
s2(2*sampleRate:end) = 0;

s3 = ones(1,nsamples);
s3(1:(2*sampleRate)-1) = 1;
s3(2*sampleRate:end) = -1;


s4 = -1*ones(1,nsamples);

figure();
subplot(2,2,1)
plot(time,s1);
xlabel('time')
ylabel('s1(t)')
title('Symbol s1(t)')
subplot(2,2,2)
plot(time,s2);
xlabel('time')
ylabel('s2(t)')
title('Symbol s2(t)')
subplot(2,2,3)
plot(time,s3);
xlabel('time')
ylabel('s3(t)')
title('Symbol s3(t)')
subplot(2,2,4)
plot(time,s4);
xlabel('time')
ylabel('s4(t)')
title('Symbol s4(t)')




% zero mean white Gaussian noise of variance 0.5 added
outputTotal = zeros(1, nsamples * number);
totalTime = linspace(0,3*number,nsamples * number);
inputTotal = zeros(1, nsamples * number);
sumInput = zeros(1,  number);
sumOutput = zeros(1, number);
variance = 0.1;
for indexNumber = 1:number
    
    
    sdNoise = sqrt(variance);
    noiseArray = sdNoise.*randn(1,nsamples);
    nextSignal = randi(4);
    tempInput = 0;
   
    switch nextSignal
        case 1
            tempInput = s1;
            
        case 2
            tempInput = s2;
            
        case 3
            tempInput = s3;
            
        case 4
            tempInput= s4;
            
    end
    tempOutput = tempInput + noiseArray;
    inputTotal(1+((indexNumber-1)*nsamples):indexNumber*nsamples) = tempInput;
    outputTotal(1+((indexNumber-1)*nsamples):indexNumber*nsamples) = tempOutput;
    
    
end
figure();
subplot(1,2,1)
plot(totalTime,inputTotal);
xlabel('time(s)')
ylabel('symbols(t)')
ylim([-5 5])
title([num2str(number),' symbols for input',]);
subplot(1,2,2)
plot(totalTime,outputTotal);
xlabel('time(s)')
ylabel('symbols(t)')
title([num2str(number),' symbols with AWGN with variance of ', num2str(variance) ]);
ylim([-5 5])





% Define the orthonormal functions {fm(t)}

fm1 = ones(1,nsamples);
fm1(1:(2*sampleRate)-1) = 1;
fm1(2*sampleRate:end) = -1;


fm2 = zeros(1,nsamples);
fm2(2*sampleRate:end) = 1;

fm3 = zeros(1,nsamples);
fm3(sampleRate:(2*sampleRate)-1) = -1;

figure();
subplot(2,2,1)
plot(time,fm1);
xlabel('time')
ylabel('fm1(t)')
title('Orthonormal function fm1(t)')
subplot(2,2,2)
plot(time,fm2);
xlabel('time')
ylabel('fm2(t)')
title('Orthonormal function fm2(t)')
subplot(2,2,3)
plot(time,fm3);
xlabel('time')
ylabel('fm3(t)')
title('Orthonormal function fm3(t)')


% Integration to get observation vector (ov)

sumOutputFM = zeros(4, number);
sumOutputSignalS = zeros(4, number);
for indexNumber = 1:number
    
    
  
    currentReceivedSymbol = outputTotal(1+((indexNumber-1)*nsamples):indexNumber*nsamples);
    
    multi1 = (currentReceivedSymbol .* s1);
    sumOutput(1,indexNumber) = sum(multi1);
        multi2 = (currentReceivedSymbol .* s2);
    sumOutput(2,indexNumber) = sum(multi2);
        multi3 = (currentReceivedSymbol .* s3);
    sumOutput(3,indexNumber) = sum(multi3);

    
    
end
% Plot
timeAxisSum = linspace(0,3*number,number);

figure();
subplot(2,2,1)
stem(timeAxisSum,sumOutput(1,:));
xlabel('time')
ylabel('Received Signal * fm1(t)')
title('Integration fm1(t) * X')
subplot(2,2,2)
stem(timeAxisSum,sumOutput(2,:));
xlabel('time')
ylabel('Received Signal * fm2(t)')
title('Integration fm2(t) * X')
subplot(2,2,3)
stem(timeAxisSum,sumOutput(3,:));
xlabel('time')
ylabel('Received Signal * fm3(t)')
title('Integration fm3(t) * X')
