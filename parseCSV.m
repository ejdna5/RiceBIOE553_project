function data = parseCSV(filename)

fid = fopen(filename);
data = {};

maxCols = 0;
maxRows = 0;
while 1
    line = fgetl(fid);
    if ~ischar(line)
        break;
    end
    maxRows = maxRows + 1;
    words = strsplit(line,',');
    if maxCols < length(words)
        maxCols = length(words);
    end
end
fclose(fid);

data = cell(maxRows, maxCols);
fid = fopen(filename);
linecount = 0;
while 1
    line = fgetl(fid);
    if ~ischar(line)
        break;
    end
    linecount = linecount + 1;
    words = strsplit(line,',');
    data(linecount,1:length(words)) = words;
end
fclose(fid);
end

