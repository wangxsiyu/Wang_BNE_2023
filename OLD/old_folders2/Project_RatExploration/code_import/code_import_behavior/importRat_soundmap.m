function [out]= importRat_soundmap(Filename)
    if ~exist(Filename,'file')
        disp('no sound map file');
        out = [];
        return;
    end
    fp= fopen(Filename);
    hd= split(fgetl(fp));		% first line is header
    lines=textscan(fp,'%f %s %f', 'Delimiter',{','});
    soundside=lines{3};
    sounds=lines{2};
    locations=lines{1};
    out = table(locations, sounds, soundside);
end
