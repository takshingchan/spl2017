%% run_melodia.m
% Extract melodies from the DSD100 dataset
%   require MELODIA 1.0 and Sonic Annotator
%   http://mtg.upf.edu/technologies/melodia
%   http://vamp-plugins.org/sonic-annotator
% ----------------------------------
% Tak-Shing Chan 10-Dec-2015
% takshingchan@gmail.com
% Copyright: Music and Audio Computing Lab, Academia Sinica, Taiwan
%%

sonic = 'sonic-annotator-1.3-win32\release\sonic-annotator';
vocals = 'Datasets\DSD100\Sources\Test\*\vocals.wav';
files = importdata('splits\dsd100_test.txt','\n');
outDir = 'SPL2016\dsd100_annotation';

% extract vocal annotations
[~,~] = mkdir(outDir);
for m = 1:length(files)
    vocal = strrep(vocals,'*',files{m});
    system([sonic ' -d vamp:mtg-melodia:melodia:melody "' vocal '" -w csv --csv-force --csv-basedir "' outDir '"']);
    movefile(fullfile(outDir,'vocals_vamp_mtg-melodia_melodia_melody.csv'),fullfile(outDir,[files{m} '_vamp_mtg-melodia_melodia_melody.csv']));
end
