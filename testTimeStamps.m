
dataFiles = dir('data/compiledData/data*');
N = length(dataFiles);
timeStamps = cell(1,N);

for i =1:N
    curDate = dataFiles(i).name;
    curDate = curDate(5:end-4); 
    
    year = 2000 + str2double(curDate(1:2));
    month = str2double(curDate(3:4));
    day = str2double(curDate(5:6));
    hour = str2double(curDate(7:8));
    minute = str2double(curDate(9:10));
    
    timeStamps{i} = datetime(year,month,day,hour,minute,0);
end

timeSinceOrigin = zeros(1,N); %num hours since first file
originPt = timeStamps{1};
for i = 1:N
    curPt = timeStamps{i};
    timeSinceOrigin(i) = hours(curPt-originPt);
end

intervals = diff(timeSinceOrigin); %gets time intervals between data files
minInterval = min(intervals) %min interval, 0.5 hours