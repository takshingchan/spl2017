function eval_dsd100(sources,outDirs)
% eval_dsd100: DSD100 evaluation (downmixed).

%	Tak-Shing Chan, 20160404

s1 = load_audio(fullfile(sources,'bass.wav'),false,true);
s2 = s1;
s1 = load_audio(fullfile(sources,'drums.wav'),false,true);
s2 = s2+s1;
s1 = load_audio(fullfile(sources,'other.wav'),false,true);
s2 = s2+s1;
s1 = load_audio(fullfile(sources,'vocals.wav'),false,true);
x = s2+s1;

% Load separation results
se1 = audioread(fullfile(outDirs,'mixture_E.wav'));
se1 = mean(se1,2);
se1 = [se1;zeros(length(s1)-length(se1),1)];
se2 = audioread(fullfile(outDirs,'mixture_A.wav'));
se2 = mean(se2,2);
se2 = [se2;zeros(length(s2)-length(se2),1)];

% Normalize to prevent artificial boosting
[SDR,SIR,SAR] = bss_eval_sources([se1 se2]'/norm(se1+se2),[s1 s2]'/norm(s1+s2));
[NSDR,NSIR,NSAR] = bss_eval_sources([x x]'/norm(x+x),[s1 s2]'/norm(s1+s2));
NSDR = SDR-NSDR;
NSIR = SIR-NSIR;
NSAR = SAR-NSAR;
save(fullfile(outDirs,'mixture.mat'),'SDR','SIR','SAR','NSDR','NSIR','NSAR');
