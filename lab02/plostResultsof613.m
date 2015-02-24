close all
sampleRate = 1000;
numberSecond = length(InputSignal)/1000;

currentSNR = snr(InputSignal,(OutputSignalPlusNoise-InputSignal));
verifySNR = mean(InputSignal.^2)/mean(((OutputSignalPlusNoise-InputSignal).^2));
verifySNRdB = 10 * log10(verifySNR);
time = linspace(0,numberSecond,length(InputSignal));
nsamples = length(time);
nSymbols = length(inputSymbols);


figure();
subplot(1,2,1)
plot(time,InputSignal);
xlabel('time(s)')
ylabel('symbols(t)')
ylim([-5 5])
xlim([0 numberSecond])
title([num2str(nSymbols),' symbols for input',]);
subplot(1,2,2)
plot(time,OutputSignalPlusNoise);
xlabel('time(s)')
ylabel('symbols(t)')
title([num2str(nSymbols),' symbols with SNR of ', num2str(currentSNR), ' dB' ]);
ylim([-5 5])
xlim([0 numberSecond])
arrayError = (inputSymbols ~= totalResults);
BER = sum(arrayError)/length(inputSymbols);

timeSymbols = linspace(0,numberSecond,nSymbols);
figure();
subplot(2,2,1)
stem(timeSymbols,inputSymbols);
xlabel('time(s)')
ylabel('symbols(t)')
ylim([0 5])
xlim([0 numberSecond])
title([num2str(nSymbols),' symbols ID for input',]);
subplot(2,2,2)
stem(timeSymbols,totalResults);
xlabel('time(s)')
ylabel('symbols(t)')
title([num2str(nSymbols),' detected symbols ID with SNR ', num2str(currentSNR), ' and BER of ', num2str(BER) ]);
ylim([0 5])
xlim([0 numberSecond])
subplot(2,2,3)
stem(timeSymbols,inputSymbols .* arrayError);
xlabel('time(s)')
ylabel('symbols(t)')
title(['Symbols ID for input that was incorected detected']);
ylim([0 5])
xlim([0 numberSecond])
subplot(2,2,4)
stem(timeSymbols,totalResults .* arrayError);

xlabel('time(s)')
ylabel('symbols(t)')
title(['Incorrect detected symbols with SNR of ', num2str(currentSNR),' dB']);
ylim([0 5])
xlim([0 numberSecond])