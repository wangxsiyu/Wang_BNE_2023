% main preprocess tracker data
maindir = '/Volumes/WANGSIYU/Lab_Fellous/Data/Data_Raw/';
rat = 'Ratzo';
datadir = fullfile(maindir, rat, 'Rawdata');
day = '033020';
daydir = fullfile(datadir, day);
filename = fullfile(daydir, 'TrackData.txt');
[trackdata]=Import_TrackData(filename);
