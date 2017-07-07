function go(action,method,dataset,krange,lrange)
% go: Run experiments.
%
% Usage: go(action,method,dataset,krange,lrange) performs action:
%   'separation'  - Audio separation
%   'report'      - Report results
%
% using method:
%   'rpca'        - Robust PCA
%   'rpcai'       - Robust PCA (informed)
%   'lrr'         - Low rank representation
%   'lrri'        - Low rank representation (informed)
%   'gsr'         - Group sparse representation
%   'gsri'        - Group sparse representation (informed)
%
% with dataset:
%   'ikala'       - iKala (single dictionary)
%   'dsd300'      - DSD100 (single dictionary)
%   'dsd100x3'    - DSD100 (three dictionaries)

%	Tak-Shing Chan, 20160409

addpath tools;

% Global parameters
param.maxiter = 500;
param.mu = 1e-3;
param.rho = 1.2;
param.tol = 1e-5;

% Check inputs
action = validatestring(action,{'separation','report'});
method = validatestring(method,{'rpca','rpcai','lrr','lrri','gsr','gsri'});
dataset = validatestring(dataset,{'ikala','dsd300','dsd100x3'});

switch dataset
    case 'ikala'
        evaluator = @eval_ikala;
        files = importdata('splits\ikala_test.txt','\n');
        load('codebooks\ikala.mat');
        mixtures = 'Datasets\iKala\Wavfile\*.wav';
        sources = 'Datasets\iKala\Wavfile\*.wav';
        runDirs = ['SPL2016\ikala_test\' method '\#\$'];
        outDirs = ['SPL2016\ikala_test\' method '\#\$'];
        outName = '*';
        melodies = 'Datasets\iKala\PitchLabel\*.pv';
        w = 80;
    case 'dsd300'
        evaluator = @eval_dsd100;
        files = importdata('splits\dsd100_test.txt','\n');
        load('codebooks\dsd300.mat');
        mixtures = 'Datasets\DSD100\Mixtures\Test\*\mixture.wav';
        sources = 'Datasets\DSD100\Sources\Test\*';
        runDirs = ['SPL2016\dsd300_test\' method '\#\$'];
        outDirs = ['SPL2016\dsd300_test\' method '\#\$\*'];
        outName = 'mixture';
        melodies = 'SPL2016\dsd100_annotation\*_vamp_mtg-melodia_melodia_melody.csv';
        w = 60;
    case 'dsd100x3'
        evaluator = @eval_dsd100;
        files = importdata('splits\dsd100_test.txt','\n');
        load('codebooks\dsd100x3.mat');
        mixtures = 'Datasets\DSD100\Mixtures\Test\*\mixture.wav';
        sources = 'Datasets\DSD100\Sources\Test\*';
        runDirs = ['SPL2016\dsd100x3_test\' method '\#\$'];
        outDirs = ['SPL2016\dsd100x3_test\' method '\#\$\*'];
        outName = 'mixture';
        melodies = 'SPL2016\dsd100_annotation\*_vamp_mtg-melodia_melodia_melody.csv';
        w = 60;
end

switch method
    case 'rpca'
        separator = @inexact_alm_rpca;
    case 'rpcai'
        separator = @inexact_alm_rpcai;
    case 'lrr'
        separator = @inexact_alm_lrr;
    case 'lrri'
        separator = @inexact_alm_lrri;
    case 'gsr'
        separator = @inexact_alm_gsr;
    case 'gsri'
        separator = @inexact_alm_gsri;
end

switch action
    case 'separation'
        % Separate all files
        for k = krange
            for l = lrange
                disp([method ' (k = ' num2str(k) ', l = ' num2str(l) ')']);
                runtimes = [];
                for m = 1:length(files)
                    disp(['Separating ' files{m} '...']);
                    mixture = strrep(mixtures,'*',files{m});
                    source = strrep(sources,'*',files{m});
                    melody = strrep(melodies,'*',files{m});
                    outDir = strrep(strrep(strrep(outDirs,'#',num2str(k)),'$',num2str(l)),'*',files{m});
                    [~,outName] = fileparts(mixture);
                    x = load_audio(mixture,false,true);
                    X = stft1411(x);
                    D = abs(X);
                    P = angle(X);
                    M = harmonic_mask(D,melody,w,dataset);
                    param.lambda = k/sqrt(length(X));
                    param.gamma = l/sqrt(length(X));
                    tstart = tic;
                    [A,E,iter] = separator(D,codebook,M,param);
                    runtimes = [runtimes;iter toc(tstart)];
                    a = istft1411(recon(A,P))';
                    e = istft1411(recon(E,P))';
                    [~,~] = mkdir(outDir);
                    audiowrite(fullfile(outDir,[outName '_A.wav']),wavnormalize(a),22050);
                    audiowrite(fullfile(outDir,[outName '_E.wav']),wavnormalize(e),22050);
                    evaluator(source,outDir);
                end
                save(fullfile(strrep(strrep(runDirs,'#',num2str(k)),'$',num2str(l)),'runtimes.mat'),'runtimes');
            end
        end
    case 'report'
        % Report GNSDR, GSDR, GSIR, and GSAR
        NSDRs = zeros(2,length(files));
        SDRs = NSDRs;
        SIRs = NSDRs;
        SARs = NSDRs;
        for k = krange
            for l = lrange
                disp([method ' (k = ' num2str(k) ', l = ' num2str(l) ')']);
                load(fullfile(strrep(strrep(runDirs,'#',num2str(k)),'$',num2str(l)),'runtimes.mat'));
                disp(['Total iterations = ' num2str(sum(runtimes(:,1))) ', total time = ' datestr(datenum(0,0,0,0,0,sum(runtimes(:,2))),'HH:MM:SS')]);
                for m = 1:length(files)
                    outDir = strrep(strrep(strrep(outDirs,'#',num2str(k)),'$',num2str(l)),'*',files{m});
                    evalName = strrep(outName,'*',files{m});
                    load(fullfile(outDir,[evalName '.mat']));
                    NSDRs(:,m) = NSDR;
                    SDRs(:,m) = SDR;
                    SIRs(:,m) = SIR;
                    SARs(:,m) = SAR;
                end
                disp([mean(NSDRs,2) mean(SDRs,2) mean(SIRs,2) mean(SARs,2)]);
            end
        end
end
