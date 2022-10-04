clear;
folder = 'U:\Data1\SiyuTaskfiles\SiyuTaskFiles_new'; % default dir in Fellous lab
tsk = task_EERat(folder);
% ratidx = [0 0 0 0 1] == 1;
ratidx = [1 1 1] == 1;
rats = {'Gerald','Twenty','Bobo'};
versions = {'rattask_EEsound_magnitudeGLong','rattask_EEsound_magnitudeGLong','randomlightsound'};
rats = rats(ratidx);
versions = versions(ratidx);
idx = 1:length(rats);
tsk.settask(rats(idx), ...
    versions(idx));
tsk.gettask;