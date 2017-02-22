function pair = importfile(filename, startRow, endRow)
%IMPORTFILE4 Import numeric data from a text file as a matrix.
%   pair = IMPORTFILE4(FILENAME) Reads data from text file FILENAME for
%   the default selection.
%
%   pair = IMPORTFILE4(FILENAME, STARTROW, ENDROW) Reads data from rows
%   STARTROW through ENDROW of text file FILENAME.
%
% Example:
%   pair = importfile('pair.txt', 1, 6001);
%
%    See also TEXTSCAN.

% Auto-generated by MATLAB on 2016/12/23 19:01:34

%% Initialize variables.
delimiter = '\t';
if nargin<=2
    startRow = 1;
    endRow = inf;
end

%% Format string for each line of text:
%   column1: text (%q)
%	column2: double (%f)
%   column3: text (%q)
%	column4: double (%f)
% For more information, see the TEXTSCAN documentation.
formatSpec = '%q%f%q%f%[^\n\r]';

%% Open the text file.
fileID = fopen(filename,'r');

%% Read columns of data according to format string.
% This call is based on the structure of the file used to generate this
% code. If an error occurs for a different file, try regenerating the code
% from the Import Tool.
dataArray = textscan(fileID, formatSpec, endRow(1)-startRow(1)+1, 'Delimiter', delimiter, 'EmptyValue' ,NaN,'HeaderLines', startRow(1)-1, 'ReturnOnError', false);
for block=2:length(startRow)
    frewind(fileID);
    dataArrayBlock = textscan(fileID, formatSpec, endRow(block)-startRow(block)+1, 'Delimiter', delimiter, 'EmptyValue' ,NaN,'HeaderLines', startRow(block)-1, 'ReturnOnError', false);
    for col=1:length(dataArray)
        dataArray{col} = [dataArray{col};dataArrayBlock{col}];
    end
end

%% Close the text file.
fclose(fileID);

%% Post processing for unimportable data.
% No unimportable data rules were applied during the import, so no post
% processing code is included. To generate code which works for
% unimportable data, select unimportable cells in a file and regenerate the
% script.

%% Create output variable
dataArray([2, 4]) = cellfun(@(x) num2cell(x), dataArray([2, 4]), 'UniformOutput', false);
pair = [dataArray{1:end-1}];
