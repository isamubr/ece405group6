% clear;
% clc;
X = outputTotal;
% sv are signal vectors
sv =zeros(4,3);
sv(1,:)=[sqrt(3) 1 0];
sv(2,:)=[sqrt(3) 1 1];
sv(3,:)=[sqrt(3) 0 0];
sv(4,:)=[-sqrt(3) -2 0];

% sv(1,:)=[1 0 0];
% sv(2,:)=[0 1 0];
% sv(3,:)=[1 0 1];
% sv(4,:)=[-1 0 1];

% E(i) is the energy
E = [0 0 0 0];
for i=1:4
    E(i) = sv(i,1)^2+sv(i,2)^2+sv(i,3)^2;
end

% Accumulator and subtraction
for j = 1:number
    sx = X(j+((j-1)*3000):j*3000);
    Xs1(j) = dot(X(1+((j-1)*3000):j*3000), s1)
    Xs2(j) = dot(X(1+((j-1)*3000):j*3000), s2)
    Xs3(j) = dot(X(1+((j-1)*3000):j*3000), s3)
    Xs4(j) = dot(X(1+((j-1)*3000):j*3000), s4)
end

figure();
subplot(2,2,1)
plot(Xs1);
xlabel('time')
ylabel('X*s1(t)')
title('Accumulator for X*s1(t)')
subplot(2,2,2)
plot(Xs2);
xlabel('time')
ylabel('X*s2(t)')
title('Accumulator for X*s2(t)')
subplot(2,2,3)
plot(Xs3);
xlabel('time')
ylabel('X*s3(t)')
title('Accumulator for X*s3(t)')
subplot(2,2,4)
plot(Xs4);
xlabel('time')
ylabel('X*s4(t)')
title('Accumulator for X*s4(t)')


Xs1 = Xs1-E(1)/2;
Xs2 = Xs2-E(2)/2;
Xs3 = Xs3-E(3)/2;
Xs4 = Xs4-E(4)/2;


% Select largest
decoded_symbols = X;
for j= 1:number
    if  ((Xs1(j)> Xs2(j))&&(Xs1(j)> Xs3(j))&&(Xs1(j)> Xs4(j)))
        decoded_symbols(1+((j-1)*3000):j*3000) = s1;
    elseif ((Xs2(j)> Xs3(j))&&(Xs2(j)> Xs4(j)))
        decoded_symbols(1+((j-1)*3000):j*3000) = s2;
    elseif (Xs3(j)> Xs4(j))
        decoded_symbols(1+((j-1)*3000):j*3000) = s3;
    else
        decoded_symbols(1+((j-1)*3000):j*3000) = s4;
    end
end

%q is the difference between the input and the decoded symbols
q = decoded_symbols-inputTotal;
errors = 1;
for j= 1:number
    if sum(q(1+((j-1)*3000):j*3000))~=0
        q(1+((j-1)*3000):j*3000) = errors*ones(1:3000,1);
        errors = errors+1;
    end
end
errors
percent_errors = 100*errors/number

% Plot
figure();
subplot(2,2,1)
plot(inputTotal);
xlabel('time')
ylabel('symbols(t)')
title([num2str(number),' Input Symbols']);

subplot(2,2,2)
plot(X);
xlabel('time')
ylabel('symbols(t)')
title([num2str(number),' Symbols; Noise Variance of ', num2str(variance) ]);

subplot(2,2,3)
plot(decoded_symbols);
xlabel('time')
ylabel('samples(t)')
title([num2str(number), ' Decoded Symblos']);

subplot(2,2,4)
plot(q);
xlabel('time')
ylabel('number of incorrect signals')
title(['Mismatched Symbols for ',num2str(number)]);

figure()
plot(q);
xlabel('time')
ylabel('number of incorrect signals')
title(['Mismatched Symbols for ',num2str(number)]);

