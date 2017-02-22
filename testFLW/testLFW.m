%directed by watersink2016.12.26
%any question,send me watersink2016@gmail.com

clc;clear;

pair = importfile('pair.txt',1, 6001);
pic1=pair(:,1);
num1=pair(:,2);
pic2_num2=pair(:,3);
num2=pair(:,4);
LFW_Feature=load('LFW_Feature');

similarone=[];
similartwo=[];

for i=2:6001
%    第一行不做处理
i
str1='';
str2='';
if  length(pic2_num2{i})<4
    %处理同一个人
    str1=strcat(strcat(strcat(pic1{i},'_'),num2str(num1{i},'%04d')),'.jpg');
    str2=strcat(strcat(strcat(pic1{i},'_'),num2str(str2num(pic2_num2{i}),'%04d')),'.jpg');
else
    %处理不同人
    str1=strcat(strcat(strcat(pic1{i},'_'),num2str(num1{i},'%04d')),'.jpg');
    str2=strcat(strcat(strcat(pic2_num2{i},'_'),num2str(num2{i},'%04d')),'.jpg');
end
    numnum1=find(strcmp(LFW_Feature.list,str1)==1);
    numnum2=find(strcmp(LFW_Feature.list,str2)==1);
    similar=dot(LFW_Feature.feature(:,numnum1),LFW_Feature.feature(:,numnum2))/norm(LFW_Feature.feature(:,numnum1))...
        /norm(LFW_Feature.feature(:,numnum2));

    if length(pic2_num2{i})<4
        similarone=[similarone;similar];
    else
        similartwo=[similartwo;similar];
    end

end

%画最后相似性得分图
%figure,plot(similarone);
%xlabel('category');ylabel('similarity');title('oneself to oneself');
%figure,plot(similartwo);
%xlabel('category');ylabel('similarity');title('oneself to otherselves');
figure,figure('visible','off'),h=plot(similarone);
xlabel('category');ylabel('similarity');title('oneself to oneself');
saveas(h,'1.jpg');
figure,figure('visible','off'),h=plot(similartwo);
xlabel('category');ylabel('similarity');title('oneself to otherselves');
saveas(h,'2.jpg');

%测试不同阈值下的最终识别率
similiarityAll=[];
for threshold=0:0.0001:1
    threshold
    numpos=0;
    numneg=0;
    for i=1:size(similarone,1)
        if similarone(i)>=threshold
            numpos=numpos+1;
        else
            numneg=numneg+1;
        end
         if similartwo(i)<threshold
             numpos=numpos+1;
         else
             numneg=numneg+1;
        end
    end
    similiarity=numpos/(numpos+numneg);
    similiarityAll=[similiarityAll;similiarity];
    
end
bestthreshold=find(similiarityAll==max(similiarityAll));
%figure,plot([0:0.0001:1],similiarityAll),hold on,plot(bestthreshold/10000,max(similiarityAll),'*r');
%xlabel('threshold');ylabel('similarity');title('different threshold generate different similiarity');
figure,figure('Visible','off'),plot([0:0.0001:1],similiarityAll),hold on,plot(bestthreshold/10000,max(similiarityAll),'*r');
xlabel('threshold');ylabel('similarity');title('different threshold generate different similiarity');
saveas(gcf,'3.jpg');
