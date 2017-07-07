function eval_ikala(source,outDir)
% eval_ikala: iKala evaluation.

%	Tak-Shing Chan, 20150530

[~,name] = fileparts(source);
x = load_audio(source,false,false);
s1 = x(:,2);
s2 = x(:,1);
x = mean(x,2);

% Load separation results
se1 = audioread(fullfile(outDir,[name '_E.wav']));
se1 = mean(se1,2);
se1 = [se1;zeros(length(s1)-length(se1),1)];
se2 = audioread(fullfile(outDir,[name '_A.wav']));
se2 = mean(se2,2);
se2 = [se2;zeros(length(s2)-length(se2),1)];

% Normalize to prevent artificial boosting
[SDR,SIR,SAR] = bss_eval_sources([se1 se2]'/norm(se1+se2),[s1 s2]'/norm(s1+s2));
[NSDR,NSIR,NSAR] = bss_eval_sources([x x]'/norm(x+x),[s1 s2]'/norm(s1+s2));
NSDR = SDR-NSDR;
NSIR = SIR-NSIR;
NSAR = SAR-NSAR;
save(fullfile(outDir,[name '.mat']),'SDR','SIR','SAR','NSDR','NSIR','NSAR');
