clear; clc; close all;
Entradas = load('Entradas.txt');
Saidas = load('Saidas.txt');
Max_Epocas = 20000;
Epocas=0;
[Linhas, Colunas] = size(Entradas);
Pesos = rand(1, Colunas);
PesosIniciais = Pesos;
Bias = rand();
BiasInicial = Bias;
n=0.01;
Precisao = 0.000001;
j=0;
U=0;
Erro = 0;
EQM=1; EQMAtual=0; EQMAnterior=0;
E=0;F=0;
Stop=0;
for i=1:Linhas
    U=Entradas(i,:)*Pesos' - Bias;
    Erro = Saidas(i,1) - U;
    F = F + (Erro^2);
    if i==Linhas
        EQMAnterior = F/Linhas;
        Erro=0;
    end
    U=0;
end
while EQM>=Precisao
    Epocas = Epocas + 1;
    j=j+1;
    U=Entradas(j,:)*Pesos' - Bias;
    Erro = Saidas(j,1) - U;
    Pesos(1,:) = Pesos(1,:) + n*(Erro)*Entradas(j,:);
    Bias = Bias + (n*(Erro))*(-1);
    fprintf('W1: %f\t W2: %f\t Bias: %f\t\n', Pesos(1,1), Pesos(1,2), Bias);
    E = E + (Erro^2);
    if j==Linhas 
        EQMAtual = E/Linhas;
        EQM = abs(EQMAtual - EQMAnterior);
        j=0;
        E=0;
        ParaPlotarGrafico(Epocas/Linhas)=EQMAtual;
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
hold on;
P = [-1:0.01:1];
P2=(Bias-Pesos(1,1)*P)/Pesos(1,2);
plot(P,P2,'r');
for k=1:Linhas
   u = Entradas(k,:)*Pesos' - Bias;
   if u>=0
       y(k)=1;
       plot(Entradas(k,1),Entradas(k,2),'go');
   else
       y(k)=-1;
       plot(Entradas(k,1),Entradas(k,2),'bs');
   end
end
Epocas = Epocas/Linhas;
X = [1:1:length(ParaPlotarGrafico)];
figure(2)
plot(X, ParaPlotarGrafico), title('EQM x Épocas de treinamento'),xlabel('Épocas'),ylabel('EQM')
if Stop == 0
    fprintf('O total de epocas: %d\n', Epocas);
   	fprintf('Os Pesos iniciais: W1 = %f e W2 = %f\n', PesosIniciais(1,1),PesosIniciais(1,2));
    fprintf('Os Pesos finais: W1 = %f e W2 = %f\n', Pesos(1,1),Pesos(1,2));
    fprintf('Bias inicial e final: W0 = %f e W0 = %f\n', BiasInicial, Bias);
end