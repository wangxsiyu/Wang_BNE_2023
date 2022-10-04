function data = filter_longRT(data, RTthres)
    tmax = max(data.time_blinkEnd_blinkStart,[],2);
    if ~exist('RTthres') || isempty(RTthres)
        RTthres = 0.9;
    end
    RTthres = quantile(tmax,RTthres);
    data = data(RTthres > tmax,:);
end