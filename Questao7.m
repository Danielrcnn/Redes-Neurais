clear; clc; close all;
a=input('Coeficiente ''a'': ');
b=input('Coeficiente ''b'': ');
x=[0:0.1:10];
Yd=a*x+b;
Y2=Yd+(0.1*randn(1,length(x)));
Max_Epocas = 500000;
Epocas=0;
Pesos = rand();
PesosIniciais = Pesos;
Bias = rand();
BiasInicial = Bias;
n=0.001;
Precisao = 0.00001;
j=0;
U=0;
Erro = 0;
EQM=1; EQMAtual=0; EQMAnterior=0;
E=0;F=0;
Stop=0;

while EQM>=Precisao
    Epocas = Epocas + 1;
    j=j+1;
    U=x(1,j)*Pesos - Bias;
    Erro = Y2(1,j) - U;
    Pesos(1,1) = Pesos(1,1) + n*(Erro)*x(1,j);
    Bias = Bias + (n*(Erro))*(-1);
    fprintf('W1: %f\t Bias: %f\t\n', Pesos(1,1), -Bias);
    E = E + (Erro^2);
    if j==length(x) 
        EQMAtual = E/length(x);
        EQM = abs(EQMAtual - EQMAnterior);
        j=0;
        E=0;
        ParaPlotarGrafico(Epocas/length(x))=EQMAtual;
        EQMAnterior=EQMAtual;
    end
    if Epocas==Max_Epocas
        Stop = 1;
        break;
    end
    U=0;
end
if Stop == 1
    fprintf('Não foi posível treinar a rede\n');
    return
end
figure(1)
Epocas = Epocas/length(x);
X = [1:1:length(ParaPlotarGrafico)];
plot(X, ParaPlotarGrafico), title('EQM x Épocas de treinamento'),xlabel('Épocas'),ylabel('EQM')

figure(2)
hold on;
plot(x,Yd,'m'); %Reta original 
P2=(-Bias+Pesos(1,1)*x);
plot(x,P2,'r'); %Reta criada com os pesos do treinamento
plot(x,Y2,'*');
if Stop == 0
    fprintf('O total de epocas: %d\n', Epocas);
   	fprintf('O coeficiente ''a'' original e o encontrado após treinamento é, respectivamente: %f e %f\n' , a, Pesos(1,1));
    fprintf('O coeficiente ''b'' original e o encontrado após treinamento é, respectivamente: %f e %f\n', b, -Bias);
end