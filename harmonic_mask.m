function mask = harmonic_mask(D,melody,w,dataset)
% harmonic_mask: for the melody annotation, computes
%
%          / 1, if abs(f-n*F0(t))<w/2,
% M(f,t) = |
%          \ 0, otherwise.
%
% Here D is the spectrogram,
%      F0(t) is the vocal fundamental frequency at time t,
%      n is the order of the harmonic, and
%      w is the width of the mask.
%
% Returns D.*M.

%	Tak-Shing Chan, 20160405

[m,n] = size(D);
melody = load(melody);

if strcmp(dataset,'ikala')
    % interpolate melody to fit spectrogram (human-annotated)
    melody = interp1(linspace(0,1,length(melody)),melody,linspace(0,1,n),'nearest')';

    % convert from MIDI to frequencies
    index = find(melody);
    melody(index) = 440*2.^((melody(index)-69)/12);
else
    % clear non-vocal segments (Melodia-annotated)
    melody(melody<0) = 0;

    % interpolate melody to fit spectrogram
    melody = interp1(melody(:,1),melody(:,2),linspace(0,melody(end,1),n),'nearest','extrap')';
end

% convert frequencies to rectangular pulses
mask = cell2mat(arrayfun(@(f0) pulstran(linspace(0,11025,m),f0:f0:11025,'rectpuls',w),melody,'UniformOutput',false))';

% Wiener filtering
mask = D.*mask;
