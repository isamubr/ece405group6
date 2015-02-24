% % clear;
% % clc;
% 
X = outputTotal;
% 
% % sv are signal vectors
sv =zeros(4,3);
sv(1,:)=[2/sqrt(3) 2/sqrt(6) 0];
sv(2,:)=[0 0 sqrt(2)];
sv(3,:)=[sqrt(3) 0 0];
sv(4,:)=[-1/sqrt(3) -4/sqrt(6) -1];
% 
% %E(i) is the energy
E = [0 0 0 0];
for i=1:4
    E(i) = sv(i,1)^2+sv(i,2)^2+sv(i,3)^2;
end
% 
% % Accumulator and subtraction
for j = 1:number
    Xs1(j) = dot(X(1+((j-1)*3000):j*3000), s1);
    Xs2(j) = dot(X(1+((j-1)*3000):j*3000), s2);
    Xs3(j) = dot(X(1+((j-1)*3000):j*3000), s3);
    Xs4(j) = dot(X(1+((j-1)*3000):j*3000), s4);
end

Ys1 = Xs1-(E(1)/2);
Ys2 = Xs2-(E(2)/2);
Ys3 = Xs3-(E(3)/2);
Ys4 = Xs4-(E(4)/2);

Zs1 = Xs1/1000;
Zs2 = Xs2/1000;
Zs3 = Xs3/1000;
Zs4 = Xs4/1000;

As1 = Zs1-(E(1)/2);
As2 = Zs2-(E(2)/2);
As3 = Zs3-(E(3)/2);
As4 = Zs4-(E(4)/2);
% 
% figure()
% subplot(2,2,1)
% plot(Xs1);
% xlabel('time')
% ylabel('X*s1(t)')
% title('Accumulator for X*s1(t)')
% 
% subplot(2,2,2)
% plot(Xs2);
% xlabel('time')
% ylabel('X*s2(t)')
% title('Accumulator for X*s2(t)')
% 
% subplot(2,2,3)
% plot(Xs3);
% xlabel('time')
% ylabel('X*s3(t)')
% title('Accumulator for X*s3(t)')
% 
% subplot(2,2,4)
% plot(Xs4);
% xlabel('time')
% ylabel('X*s4(t)')
% title('Accumulator for X*s4(t)')
% 

% 
% % Select largest
decoded_symbols_with_energy = X; % for size
for j= 1:number
    if  ((Xs1(j)> Xs2(j))&&(Xs1(j)> Xs3(j))&&(Xs1(j)> Xs4(j)))
        decoded_symbols_with_energy(1+((j-1)*3000):j*3000) = s1;
    elseif ((Xs2(j)> Xs3(j))&&(Xs2(j)> Xs4(j)))
        decoded_symbols_with_energy(1+((j-1)*3000):j*3000) = s2;
    elseif (Xs3(j)> Xs4(j))
        decoded_symbols_with_energy(1+((j-1)*3000):j*3000) = s3;
    else
        decoded_symbols_with_energy(1+((j-1)*3000):j*3000) = s4;
    end
end
% %q is the difference between the input and the decoded symbols
q_with = decoded_symbols_with_energy-inputTotal;
errors_with_energy = 0;
for j= 1:number
    if sum(q_with(1+((j-1)*3000):j*3000))~=0
        errors_with_energy = errors_with_energy+1;
        %q_with(1+((j-1)*3000):j*3000) = errors_with_energy*ones(1:3000,1);       
    end
end
percent_errors_with_energy = 100*errors_with_energy/number;

decoded_symbols_without_energy = X; % for size
for j= 1:number
    if  ((Ys1(j)> Ys2(j))&&(Ys1(j)> Ys3(j))&&(Ys1(j)> Ys4(j)))
        decoded_symbols_without_energy(1+((j-1)*3000):j*3000) = s1;
    elseif ((Ys2(j)> Ys3(j))&&(Ys2(j)> Ys4(j)))
        decoded_symbols_without_energy(1+((j-1)*3000):j*3000) = s2;
    elseif (Ys3(j)> Ys4(j))
        decoded_symbols_without_energy(1+((j-1)*3000):j*3000) = s3;
    else
        decoded_symbols_without_energy(1+((j-1)*3000):j*3000) = s4;
    end
end
% %q is the difference between the input and the decoded symbols
q_without = decoded_symbols_without_energy-inputTotal;
errors_without_energy = 0;
for j= 1:number
    if sum(q_without(1+((j-1)*3000):j*3000))~=0
        errors_without_energy = errors_without_energy+1;
        %q_without(1+((j-1)*3000):j*3000) = errors_without_energy*ones(1:3000,1);
    end
end
percent_errors_without_energy = 100*errors_without_energy/number;

decoded_symbols_divide = X; % for size
for j= 1:number
    if  ((Zs1(j)> Zs2(j))&&(Zs1(j)> Zs3(j))&&(Zs1(j)> Zs4(j)))
        decoded_symbols_divide(1+((j-1)*3000):j*3000) = s1;
    elseif ((Zs2(j)> Zs3(j))&&(Zs2(j)> Zs4(j)))
        decoded_symbols_divide(1+((j-1)*3000):j*3000) = s2;
    elseif (Zs3(j)> Zs4(j))
        decoded_symbols_divide(1+((j-1)*3000):j*3000) = s3;
    else
        decoded_symbols_divide(1+((j-1)*3000):j*3000) = s4;
    end
end
% %q is the difference between the input and the decoded symbols
q_divide = decoded_symbols_divide-inputTotal;
errors_divide = 0;
for j= 1:number
    if sum(q_divide(1+((j-1)*3000):j*3000))~=0
        errors_divide = errors_divide+1;
        %q_divide(1+((j-1)*3000):j*3000) = errors_divide*ones(1:3000,1);       
    end
end
percent_errors_divide = 100*errors_divide/number;

decoded_symbols = X; % for size
for j= 1:number
    if  ((As1(j)> As2(j))&&(As1(j)> As3(j))&&(As1(j)> As4(j)))
        decoded_symbols(1+((j-1)*3000):j*3000) = s1;
    elseif ((As2(j)> As3(j))&&(As2(j)> As4(j)))
        decoded_symbols(1+((j-1)*3000):j*3000) = s2;
    elseif (As3(j)> As4(j))
        decoded_symbols(1+((j-1)*3000):j*3000) = s3;
    else
        decoded_symbols(1+((j-1)*3000):j*3000) = s4;
    end
end

q_ = decoded_symbols-inputTotal;
errorz = 0;
for j= 1:number
    if sum(q_(1+((j-1)*3000):j*3000))~=0
        errorz = errorz+1;
        q_(1+((j-1)*3000):j*3000) = errorz*ones(1:3000,1);       
    end
end
percent_errorz = 100*errorz/number;

error_comparison = ['Without subtracting the symbol energies, there are ',num2str(percent_errors_with_energy),'% errors in ', num2str(number),' symbols.']
a = ['Removing the energy of the symbols, there are ',    num2str(percent_errors_without_energy),'% errors in ', num2str(number), ' symbols.     ']
b = ['Dividing by the samples, there are ', num2str(percent_errors_divide),'% errors in ',  num2str(number), ' symbols.  ']
c = ['Subtracting the energ of the symbols, there are ', num2str(percent_errorz),'% errors in ',  num2str(number), ' symbols.  ']
% 
% % Plot with energy
% figure();
% subplot(1,2,1)
% 
% subplot(2,2,1)
% plot(inputTotal);
% xlabel('time')
% ylabel('symbols(t)')
% title([num2str(number),' Input Symbols']);
% 
% subplot(2,2,2)
% plot(X);
% xlabel('time')
% ylabel('symbols(t)')
% title([num2str(number),' Symbols; Noise Variance of ', num2str(variance) ]);
% 
% subplot(2,2,3)
% plot(decoded_symbols_without_energy);
% xlabel('time')
% ylabel('samples(t)')
% title([num2str(number), ' Decoded Symblos']);
% 
% subplot(2,2,4)
% plot(q_without);
% xlabel('time')
% ylabel('number of incorrect signals')
% title(['Mismatched Symbols for ',num2str(number)]);