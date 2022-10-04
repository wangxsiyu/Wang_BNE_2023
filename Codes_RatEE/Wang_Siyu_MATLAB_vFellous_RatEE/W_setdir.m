[~,sysname] = system('hostname');
sysname = strip(sysname);
if ispc
    disp(sprintf('setting up SW dir for PC %s', sysname));
    switch sysname
        case 'MH02217045DT' % i9 PC - remote NIH
            addpath(genpath('E:\Github\Wang_MATLAB'));
        case 'MH02217195LT'
            addpath(genpath('C:\wangxsiyu\Github\Wang_Matlab'));
        otherwise
            disp(sprintf('error: needs to set up SW dir for %s', sysname));
    end
elseif ismac
    disp(sprintf('setting up SW dir for mac %s', sysname));
    addpath(genpath('/Users/wang/WANG/E_Codes/Wang_Siyu_MATLAB'));
    addpath(genpath('/Users/wang/WANG/E_Codes/Download_MATLAB'));
end
clear sysname;