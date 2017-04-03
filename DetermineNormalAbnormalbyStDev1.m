function [ norm0_abnorm1_array, min, max ] = DetermineNormalAbnormalbyStDev1( SleepData, StDevCutoff )
% Given array of minutes of sleep, returns array of true/false values for normal (0) or
% abnormal (1) sleep for data where normal values are within StDevCutoff of the mean; 
% also returns range of normal sleep (min-max)
SleepData1=SleepData;
SleepData1(SleepData1==0)=NaN;
GoodSleepData=SleepData1;
GoodSleepData=GoodSleepData(~isnan(GoodSleepData));
AveSleep=mean(GoodSleepData);
StdSleep=std(GoodSleepData);
min=AveSleep-StdSleep*StDevCutoff;
max=AveSleep+StdSleep*StDevCutoff;
norm0_abnorm1_array=zeros(1,length(SleepData1));
for i=1:length(SleepData1)
    if isnan(SleepData1(i))
        norm0_abnorm1_array(i)=NaN;
    else 
        norm0_abnorm1_array(i)=SleepData(i)>max|SleepData(i)<min;
    end
end

