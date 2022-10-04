clear;
folder = 'U:\Data1\SiyuTaskfiles\SiyuTaskFiles_new'; % default dir in Fellous lab
tsk = task_EERat(folder);
tsk.settask({'Twenty','Gerald','Ratzo', 'Rizzo'}, ...
    {'randomlights','randomlights','EEsound_noguided','EEsound_noguided'});
tsk.gettask;