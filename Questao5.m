clear; clc; close all;
Arquivo = load('Q5_Dados_Treinamento.txt');
[LArq,CArq] = size(Arquivo);
for i=1:CArq
    if i<=CArq-1
        Entradas(:,i) = Arquivo(:,i);
    else
        Saidas(:,1) = Arquivo(:,i); %Saidas: -1 - Valvula A e +1 - Valvula B
    end
end
[LEnt, CEnt] = size(Entradas);
Precisao = 0.000001;
Pesos = rand(1, CEnt);
PesosIniciais = Pesos;
Bias = rand();
BiasInicial = Bias;
Max_Epocas = 50000;
Epocas=0;
n=0.0025;
j=0;
U=0;
Erro = 0;
EQM=1; EQMAtual=0; EQMAnterior=0;
E=0;F=0;
Stop=0;
for i=1:LArq
    U = Entradas(i,:)*Pesos' - Bias;
    Erro = Saidas(i,1) - U;
    F = F + (Erro^2);
    if i==LArq
        EQMAnterior = F/LArq; %Computa EQM anterior
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
    fprintf('W1: %f\t W2: %f\t W3: %f\t W4: %f\t Bias: %f\t\n', Pesos(1,1), Pesos(1,2), Pesos(1,3), Pesos(1,4),Bias);
    E = E + (Erro^2);
    if j==LEnt
        EQMAtual = E/LEnt;
        EQM = abs(EQMAtual - EQMAnterior);
        j=0;
        E=0;
        ParaPlotarGrafico(Epocas/LEnt)=EQMAtual;
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
% for k=1:LEnt
%    u = Entradas(k,:)*Pesos' - Bias;
%    if u>=0
%        y(k,1)=1;
%        plot(Entradas(k,1),Entradas(k,2),'go');
%    else
%        y(k,1)=-1;
%        plot(Entradas(k,1),Entradas(k,2),'bs');
%    end
% end

EntradasClassificacao = load('Q5_Dados_Classificação.txt');
[LClassificacao, CClassificacao] = size(EntradasClassificacao);
for k=1:LClassificacao
   u = EntradasClassificacao(k,:)*Pesos' - Bias;
   if u>=0
       y(k,1)=1; %Valvula B
   else
       y(k,1)=-1;
   end
end
Epocas = Epocas/LEnt;
X = [1:1:length(ParaPlotarGrafico)];
plot(X, ParaPlotarGrafico), title('EQM x Épocas de treinamento'),xlabel('Épocas'),ylabel('EQM')
if Stop == 0
    fprintf('\nO total de epocas: %d\n', Epocas);
   	fprintf('Os Pesos iniciais: W1 = %f, W2 = %f, W3 = %f e W2 = %f\n', PesosIniciais(1,1),PesosIniciais(1,2), PesosIniciais(1,3), PesosIniciais(1,4));
    fprintf('Os Pesos finais: W1 = %f, W2 = %f, W3 = %f e W4 = %f\n', Pesos(1,1),Pesos(1,2),Pesos(1,3),Pesos(1,4));
    fprintf('Bias inicial e final: W0 = %f e W0 = %f\n', BiasInicial, Bias);
end