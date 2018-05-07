% -----------Matching function
%    Author: Behnam Anjomruz
%    Email: behnam.anjomruz@gmail.com
%       Description: Looking for matched bitstrings


clear all;
clc

load('bitstrings.mat');
h = size(bitstrings,1);



[FileName,PathName] = uigetfile('*.tif','Select the Image which you want to compare');

finger_features = extract_finger(FileName);

Newbitstring = HashFnc(finger_features);

test=0;
for i=1:h
    per = sum(Newbitstring == bitstrings{i,3});
    if (per>=0.7)
        match = strcat(bitstrings{i,1},'.tif')
        percent=(per/60)*100
        test = 1;
        break;
    end
    
end

if (test==0)
        disp('There''s no matching case in this Database');
end


