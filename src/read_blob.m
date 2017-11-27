
function [s, data] = read_blob(fn)

f = fopen(fn, 'r');
s = fread(f, [1 5], 'int32');

% s contains size of the blob e.g. num x chanel x length x height x width
m = s(1)*s(2)*s(3)*s(4)*s(5);

% data is the blob binary data in single precision (e.g float in C++)
data = fread(f, [1 m], 'single');
fclose(f);

end
