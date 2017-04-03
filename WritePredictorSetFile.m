function [  ] = WritePredictorSetFile( csv_file_name,Filename,x )
% Given name of CSV file in working directory from
% http://fitbit-export.azurewebsites.net/ (csv_file_name) and name of file
% to write to (Filename), generate text file containing predictor sets
% csv_file_name and Filename should be in single quotes
% x=size of test set

Data=parseCSV(csv_file_name);
%x=14;
Data1=str2double(Data(2:end,[6,8,11,12,13,16]));
%x is number of days at end reserved for test set >> don't include in
%training set; predictors for last day in training set are not used 
PredictorData=Data1(1:end-x-1,:);
%7 consecutive days of predictors used for each input set, so number of
%input sets is length of training set - 7
PredictorN=length(PredictorData(:,1))-6;
%if no steps taken, set number of steps and number floors to NaN
PredictorData((PredictorData(:,1)==0),[1,2])=NaN;
%if no light activity logged, set lightly, fairly, and very active minutes to NaN
PredictorData((PredictorData(:,3)==0),[3,4,5])=NaN;
%if no sleep logged, set minutes asleep to NaN;
PredictorData((PredictorData(:,6)==0),6)=NaN;
SleepData=(str2double(Data(9:end-x,16)));
y=1;
isAbnormal=DetermineNormalAbnormalbyStDev1(SleepData,y);
fid=fopen(Filename,'w');
NumDays=PredictorN+7;
PrintString=['Number of days in training set:  ' int2str(NumDays)];
fprintf(fid,PrintString);
PrintString=['\nNumber of consecutive input sets generated from training set:  ' int2str(PredictorN)];
fprintf(fid,PrintString);
for i=1:PredictorN
    PrintString=['\nDate range for input set ' int2str(i) ':  ' char(Data(i+1,1)) ' to ' char(Data(i+7,1))];  
    fprintf(fid,PrintString);
    PrintString=['\nDate of sleep value to use for prediction:  ' char(Data(i+8,1))];  
    fprintf(fid,PrintString);
    Sleep2predict=str2double(Data(i+8,16));
    if Sleep2predict==0
        Sleep2predict=NaN;
    end
    PrintString='\nMinutes asleep on 8th day:  ';  
    fprintf(fid,PrintString);
    PrintString=['\n' int2str(Sleep2predict)];
    fprintf(fid,PrintString);
    PrintString=['\nis this normal(0) or abnormal(1)?'];
    fprintf(fid,PrintString);
    PrintString=['\n' int2str(isAbnormal(i))];
    fprintf(fid,PrintString);
    PrintString=['\n' char(Data(1,1)) ',' char(Data(1,6)) ',' char(Data(1,8)) ',' char(Data(1,11)) ',' char(Data(1,12)) ',' char(Data(1,13)) ',' char(Data(1,16))];
    fprintf(fid,PrintString);
    for j=1:7
        PrintString=['\n' char(Data(i+j,1)) ',' int2str(PredictorData(i+j-1,1)) ',' int2str(PredictorData(i+j-1,2)) ',' int2str(PredictorData(i+j-1,3)) ',' int2str(PredictorData(i+j-1,4)) ',' int2str(PredictorData(i+j-1,5)) ',' int2str(PredictorData(i+j-1,6))];
        fprintf(fid,PrintString);
    end
end
fclose(fid);
end

