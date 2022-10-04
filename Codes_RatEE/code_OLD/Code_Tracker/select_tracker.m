function out = select_tracker(track, t1, t2)
    idx = track.time >= t1 & track.time <= t2;
    out = [track.x(idx) track.y(idx)];
end