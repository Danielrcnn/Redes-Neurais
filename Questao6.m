clear; clc; close all;
k = 1000; % Quantidade de amostras
q = 0.7; % Distância entre as classes
A = [rand(1,k)-q; rand(1,k)+q];
B = [rand(1,k)+q; rand(1,k)-q];

A (3,:)=1;
B (3,:)=-1;
Matriz = [A B];
Outra_Matriz_Com_Indices_Trocados=randperm(length(Matriz));
Treinamento=zeros(length(Matriz)*0.7,3);
Classificacao=zeros(length(Matriz)*0.3,2);
for k=1:length(Matriz)
    if k<=length(Matriz)*0.7
        Treinamento(k,:)=Matriz(:,(Outra_Matriz_Com_Indices_Trocados(k)))';
    else
        Classificacao(k-length(Matriz)*0.7,:)=Matriz(1:2,(Outra_Matriz_Com_Indices_Trocados(k)))';
    end
end
[Linhas_Treinamento, Colunas_Treinamento]=size(Treinamento);
for i=1:Colunas_Treinamento
    if i<=Colunas_Treinamento-1
        Entradas(:,i) = Treinamento(:,i);
    else
        Saidas(:,1) =Treinamento(:,i);
    end
end
[Linhas, Colunas]=size(Entradas);
Max_Epocas = 100000;
Epocas=0;
Pesos = rand(1, Colunas);
PesosIniciais = Pesos;
Bias = rand();
BiasInicial = Bias;
n=0.0025;
Precisao = 0.0000001;
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
        EQMAnterior = F/Linhas; %Computa EQM anterior
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
    E = E + (Erro)^2;
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
Epocas = Epocas/Linhas;
if Stop == 1
    fprintf('Não foi posível treinar a rede\n');
    return
end
if Stop == 0
    fprintf('\nO total de epocas: %d\n', Epocas);
   	fprintf('Os Pesos iniciais: W1 = %f e W2 = %f\n', PesosIniciais(1,1),PesosIniciais(1,2));
    fprintf('Os Pesos finais: W1 = %f e W2 = %f\n', Pesos(1,1),Pesos(1,2));
    fprintf('Bias inicial e final: W0 = %f e W0 = %f\n', BiasInicial, Bias);
end

subplot(1,3,1)
% Gráfico
plot(A(1,:),A(2,:),'bs'); hold on; grid on
plot(B(1,:),B(2,:),'go')
% Texto
text(.5-q,.5+2*q,'Class A')
text(.5+q,.5-2*q,'Class B')
title('Dados gerados para k=1000')

subplot(1,3,2)
for k=1:length(Entradas)
   u = Entradas(k,:)*Pesos' - Bias;
   if u>=0
       y(k)=1;
       plot(Entradas(k,1),Entradas(k,2),'y*-');hold on, grid on;
       title('Treinameto com 700 amostras')
   else
       y(k)=-1;
       plot(Entradas(k,1),Entradas(k,2),'cx-'); hold on, grid on;
   end
end
P = [-1:0.01:2];
P2=(Bias-Pesos(1,1)*P)/Pesos(1,2);
plot(P,P2,'b');

subplot(1,3,3)
for k=1:length(Classificacao)
   u = Classificacao(k,:)*Pesos' - Bias;
   if u>=0
       o(k)=1;
       plot(Classificacao(k,1),Classificacao(k,2),'y*-');hold on, grid on;
       title('Classicifação de 300 amostras')
   else
       o(k)=-1;
       plot(Classificacao(k,1),Classificacao(k,2),'cx-'); hold on, grid on;
   end
end
P = [-1:0.01:2];
P2=(Bias-Pesos(1,1)*P)/Pesos(1,2);
plot(P,P2,'b');

figure
X = [1:1:length(ParaPlotarGrafico)];
plot(X, ParaPlotarGrafico), title('EQM x Épocas de treinamento'),xlabel('Épocas'),ylabel('EQM')