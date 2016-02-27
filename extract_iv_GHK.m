function [Vs, Is, filename, d] = extract_iv_GHK(filename,p)
%Extracts IV curves from the file in filename, if it can.
%Voltage information assumed to be p.minV to p.maxV in
%p.steV mV steps. IV averages the last 10% (hard coded) of 
%each sweep to get point, change if you want 
%(this is for very capacitive pores).
%p is the params file used to analyze the GHK

%Versioning
% 2014-created by Tszalay
% 2015-Hacked apart to my needs Ryan
% 4-7-15-minVfit and maxVfit sections added
% 10-13-15-cleaned up, fits removed by Ryan

try
    % try to load the entire file
    [d,~,h]=abfload(filename);
catch
    fprintf(2,'Failed to load file %s as I-V!\n',filename);
    return
end

% check if it's an IV curve
if (numel(size(d)) ~= 3)
    fprintf(2,'%s is not an IV curve.\n',filename);
    return
end
sz = size(d);
% make the voltages
Vs = linspace(p.minV,p.maxV,sz(3))';
% how much of the data do we want to use?
% start with last 1/10, for now
indst = floor(sz(1)*0.9);
% Get current values into a 1D/2D array, from 3D
Is = reshape(mean(d(indst:end,:,:),1),sz(2:3))';
%flip Is so that it goes from low to high, just like hard code Vs
if Is(end)<Is(1);Is=flipud(Is);end
