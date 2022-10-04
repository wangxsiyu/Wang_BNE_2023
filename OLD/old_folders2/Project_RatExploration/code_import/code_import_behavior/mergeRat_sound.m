function maze = mergeRat_sound(maze, sound)
    if isempty(sound)
        maze.sound = repmat("NoSound", height(maze),1);
        return
    end
    maze.sound = arrayfun(@(x)string(sound.sounds{x == sound.locations}), maze.number);
end