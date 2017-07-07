%% gen_codebooks.m
% Generate codebooks from instrumental data
%   require SPAMS (SPArse Modeling Software) for online dictionary learning
%   http://spams-devel.gforge.inria.fr/
% ----------------------------------
% Yi-Hsuan Yang 3-Oct-2013, Tak-Shing Chan 10-Dec-2015
% {affige,takshingchan}@gmail.com
% Copyright: Music and Audio Computing Lab, Academia Sinica, Taiwan
%%

addpath tools;

% load ikala corpus
files = importdata(fullfile('splits','ikala_train.txt'),'\n');
corpus = [];
for i = 1:length(files)
    x = load_audio(fullfile('Datasets','iKala','Wavfile',[files{i} '.wav']),false,false);
    X = stft1411(x(:,1));
    corpus = [corpus abs(X)];   % could be like 706x82368
end

% train ikala dictionary
param.K = 100;
param.lambda = 1/sqrt(size(corpus,1));
param.iter = 500;
codebook = nnsc(corpus,param);
save(fullfile('codebooks','ikala.mat'),'codebook')
clear all

% load dsd100 corpus
files = importdata(fullfile('splits','dsd100_train.txt'),'\n');
basses = [];
drumss = [];
others = [];
corpus = [];
for i = 1:length(files)
    bass = load_audio(fullfile('Datasets','DSD100','Sources','Dev',files{i},'bass.wav'),false,true);
    drums = load_audio(fullfile('Datasets','DSD100','Sources','Dev',files{i},'drums.wav'),false,true);
    other = load_audio(fullfile('Datasets','DSD100','Sources','Dev',files{i},'other.wav'),false,true);
    basses = [basses abs(stft1411(bass))];
    drumss = [drumss abs(stft1411(drums))];
    others = [others abs(stft1411(other))];
    corpus = [corpus abs(stft1411(bass+drums+other))];
end

% train dsd100 dictionaries
param.K = 100;
param.lambda = 1/sqrt(size(corpus,1));
param.iter = 500;
codebook = [nnsc(basses,param) nnsc(drumss,param) nnsc(others,param)];
save(fullfile('codebooks','dsd100x3.mat'),'codebook')
param.K = 300;
codebook = nnsc(corpus,param);
save(fullfile('codebooks','dsd300.mat'),'codebook')
clear all
