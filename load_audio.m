function x = load_audio(inFile,sisec,downmix)
% load_audio: Load a 30-sec segment.

%	Tak-Shing Chan, 20150530

if sisec
    x = audioread(inFile,[105 135]*44100);  % 1'45" to 2'15"
else
    x = audioread(inFile);
end

if downmix
    x = downsample(mean(x,2),2);
else
    x = downsample(x,2);
end
