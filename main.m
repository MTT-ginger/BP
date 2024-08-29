%% BP����������Ԥ��
%% 1.��ʼ��
clear
close all
clc
format short  % ��ȷ��С�����4λ��format long�Ǿ�ȷ��С�����15λ
%% 2.��ȡ����
% Matlab2021�汾�����޷�ʹ��xlsread����������Load�������
input=xlsread('��������.xlsx');   % ����
output=xlsread('�������.xlsx');  % ���

output_name={'Y1','Y2','Y3'};  % ���������м���Y�����ü�����Yn
N=size(input,1);                    % ������������
testNum=68;               % �趨���Լ����������������ݼ�����ѡȡ
trainNum=N-testNum;       % �趨ѵ������������

%% 3.����ѵ�����Ͳ��Լ�
input_train = input(1:trainNum,:)';                  % ѵ��������
output_train =output(1:trainNum,:)';                 % ѵ�������
input_test =input(trainNum+1:trainNum+testNum,:)';   % ���Լ�����
output_test =output(trainNum+1:trainNum+testNum,:)'; % ���Լ����

%% 4.���ݹ�һ��
[inputn,inputps]=mapminmax(input_train,-1,1);        % ѵ���������һ��
[outputn,outputps]=mapminmax(output_train);          % ѵ���������һ��
inputn_test=mapminmax('apply',input_test,inputps);   % ���Լ�������ú�ѵ����������ͬ�Ĺ�һ����ʽ

%% 5.������������
inputnum=size(input,2);   %size������ȡ�����������������1����������2��������
outputnum=size(output,2);
disp(['�����ڵ�����',num2str(inputnum),',  �����ڵ�����',num2str(outputnum)])
disp(['������ڵ�����ΧΪ ',num2str(fix(sqrt(inputnum+outputnum))+1),' �� ',num2str(fix(sqrt(inputnum+outputnum))+10)])
disp(' ')
disp('���������ڵ��ȷ��...')

%����hiddennum=sqrt(m+n)+a��mΪ�����ڵ�����nΪ�����ڵ�����aȡֵ[1,10]֮�������
MSE=1e+5;                             %����ʼ��
transform_func={'tansig','purelin'};  %���������tan-sigmoid��purelin
train_func='trainlm';                 %ѵ���㷨
for hiddennum=fix(sqrt(inputnum+outputnum))+1:fix(sqrt(inputnum+outputnum))+10
    
    net=newff(inputn,outputn,hiddennum,transform_func,train_func); %����BP����
    
    % �����������
    net.trainParam.epochs=1000;       % ����ѵ������
    net.trainParam.lr=0.01;           % ����ѧϰ����
    net.trainParam.goal=0.000001;     % ����ѵ��Ŀ����С���
    
    % ��������ѵ��
    net=train(net,inputn,outputn);
    an0=sim(net,inputn);     %������
    mse0=mse(outputn,an0);   %����ľ������
    disp(['��������ڵ���Ϊ',num2str(hiddennum),'ʱ��ѵ�����������Ϊ��',num2str(mse0)])
    
    %���ϸ������������ڵ�
    if mse0<MSE
        MSE=mse0;
        hiddennum_best=hiddennum;
    end
end
disp(['���������ڵ���Ϊ��',num2str(hiddennum_best),'���������Ϊ��',num2str(MSE)])

%% 6.��������������BP������
net=newff(inputn,outputn,hiddennum_best,transform_func,train_func);

% �����������
net.trainParam.epochs=1000;       % ѵ������
net.trainParam.lr=0.01;           % ѧϰ����
net.trainParam.goal=0.000001;     % ѵ��Ŀ����С���

%% 7.����ѵ��
net=train(net,inputn,outputn);    % train��������ѵ�������磬������ɫ�������

%% 8.�������
an=sim(net,inputn_test);          % ѵ����ɵ�ģ�ͽ��з������
test_simu=mapminmax('reverse',an,outputps);  % Ԥ��������һ��

%% 9.������
disp(' ')
for i=1:outputnum
    
    error=test_simu(i,:)-output_test(i,:);     %Ԥ��ֵ����ʵֵ�����
    
    %%Ԥ��ֵ��ʵ��ֵ�ĶԱ�ͼ
    figure
    plot(output_test(i,:),'bo-','linewidth',1.5)
    hold on
    plot(test_simu(i,:),'rs-','linewidth',1.5)
    legend('ʵ��ֵ','Ԥ��ֵ')
    xlabel('��������'),ylabel('ָ��ֵ')
    title(['BP��(',output_name{i},')��Ԥ��ֵ��ʵ��ֵ�Ա�'])
    set(gca,'fontsize',12)
    
    figure
    plot(error,'bo-','linewidth',1.5)
    xlabel('��������'),ylabel('Ԥ�����')
    title(['BP��(',output_name{i},')��Ԥ�����'])
    set(gca,'fontsize',12)
    
    %�������������
    SSE1=sum(error.^2);                          % ���ƽ����
    MAE1=sum(abs(error))/testNum;                % ƽ���������
    MSE1=error*error'/testNum;                   % �������
    RMSE1=MSE1^(1/2);                            % ���������
    MAPE1=mean(abs(error./output_test(i,:)));    % ƽ���ٷֱ����
    r=corrcoef(output_test(i,:),test_simu(i,:)); % corrcoef�������ϵ�����󣬰�������غͻ����ϵ��
    R1=r(1,2);
    
    %��ʾ��ָ����
    disp(['(',output_name{i},')�������ָ����:'])
    disp(['���ƽ����SSEΪ��',num2str(SSE1)])
    disp(['ƽ���������MAEΪ��',num2str(MAE1)])
    disp(['�������MSEΪ��',num2str(MSE1)])
    disp(['���������RMSEΪ��',num2str(RMSE1)])
    disp(['ƽ���ٷֱ����MAPEΪ��',num2str(MAPE1*100),'%'])
    disp(['Ԥ��׼ȷ��Ϊ��',num2str(100-MAPE1*100),'%'])
    disp(['���ϵ��RΪ��',num2str(R1)])
    disp(' ')
end

%��ӡ���
for i=1:outputnum
    disp(['(',output_name{i},')�Ĳ��Լ������'])
    disp('    ���     ʵ��ֵ    BPԤ��ֵ')
    for j=1:testNum
        disp([j,output_test(i,j),test_simu(i,j)]) % ��ʾ˳��: ������ţ�ʵ��ֵ��Ԥ��ֵ
    end
    disp(' ')
end





