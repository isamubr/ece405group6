clear all;
close all;
clc;
number=5;     % total transmission time (300s)/each signal duration (3s)

% randomly choose one of the four equiprobable signals
seedUsed = rng;

sampleRate = 1000;
% 1000 samples per second means 3000 samples per signal
time = linspace(0,3,3*sampleRate);
nsamples = length(time);

s1 = ones(1,nsamples);
s1(2*sampleRate:end) = 0;
figure();
plot(time,s1);
xlabel('time')
ylabel('s1(t)')
title('Symbol s1(t)')

s2 = ones(1,nsamples);
s2(1:sampleRate-1) = 1;
s2(sampleRate:(2*sampleRate)-1) = -1;
s2(2*sampleRate:end) = 0;
figure();
plot(time,s2);
xlabel('time')
ylabel('s2(t)')
title('Symbol s2(t)')

s3 = ones(1,nsamples);
s3(1:(2*sampleRate)-1) = 1;
s3(2*sampleRate:end) = -1;
figure();
plot(time,s3);
xlabel('time')
ylabel('s3(t)')
title('Symbol s3(t)')

s4 = -1*ones(1,nsamples);
figure();
plot(time,s4);
xlabel('time')
ylabel('s4(t)')
title('Symbol s4(t)')




% zero mean white Gaussian noise of variance 0.5 added
outputTotal = zeros(1, nsamples * number);
inputTotal = zeros(1, nsamples * number);
variance = 0.5;
for indexNumber = 1:number
    
    
    sdNoise = sqrt(variance);
    noiseArray = sdNoise.*randn(1,nsamples);
    nextSignal = randi(4);
    switch nextSignal
        case 1
            inputTotal(1+((indexNumber-1)*nsamples):indexNumber*nsamples) = s1;
            outputTotal(1+((indexNumber-1)*nsamples):indexNumber*nsamples) = s1 + noiseArray;
        case 2
                        inputTotal(1+((indexNumber-1)*nsamples):indexNumber*nsamples) = s2;
            outputTotal(1+((indexNumber-1)*nsamples):indexNumber*nsamples) = s2 + noiseArray;
        case 3
                        inputTotal(1+((indexNumber-1)*nsamples):indexNumber*nsamples) = s3;
            outputTotal(1+((indexNumber-1)*nsamples):indexNumber*nsamples) = s3 + noiseArray;
        case 4
                        inputTotal(1+((indexNumber-1)*nsamples):indexNumber*nsamples) = s4;
            outputTotal(1+((indexNumber-1)*nsamples):indexNumber*nsamples) = s4 + noiseArray;
    end
end
figure();
plot(inputTotal);
xlabel('time')
ylabel('symbols(t)')
title(['Symbols for',num2str(number)]);
figure();
plot(outputTotal);
xlabel('time')
ylabel('symbols(t)')
title(['Symbols for ',num2str(number), ' Variance ', num2str(variance) ]);


% Define the orthonormal functions {fm(t)}

% Integration to get observation vector (ov)

% Plot
