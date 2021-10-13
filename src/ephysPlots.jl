function loadSweeps(path)
    f = h5open(path, "r")
    dfDat = read(f["df"]["block0_values"])'
    headers = read(f["df"]["block0_items"])
    temp = DataFrame(dfDat, :auto)
    rename!(temp, headers)
    nSweeps = div(length(temp.index), length(unique(temp.index)))
    insertcols!(temp, 1,
        :sweep => repeat(1:nSweeps, inner=length(unique(temp.index))))
    
    return temp
end


function plotSweeps(df, sweep;window=[650, 1250], title=false; 
    force_ylims=[-10,300], work_ylims=[-10,400], current_ylims=[-2000, 100],
     kwargs...)
    sweepGrps = groupby(df, :sweep)
    plotRegion = subset(sweepGrps[sweep], 
        :ti => ByRow(>=(window[1])), :ti => ByRow(<=(window[2])))
    
    l = @layout [a{0.1h}; b{0.1h}; c{0.1h}; d{0.7h}]
    
    p1 = plot(plotRegion.tz, -1 .* plotRegion.position, ylim=(-6000,3000);
            kwargs...)
    p2 = plot(plotRegion.tin0, plotRegion.force, ylim=(-10,300); kwargs...)
    p3 = plot(plotRegion.tin0, plotRegion.work, ylim=(-10,400); kwargs...)
    p4 = plot(plotRegion.ti, plotRegion.i, ylim=(-1800,100); kwargs...)
    
    plt = plot(p1, p2, p3, p4, layout=l)
    if title == true
        annotate!(450, 2800, subplot=1, text("Position", :black,:left, 10))
        annotate!(450, 300, subplot=2, text("Force", :black,:left, 10))
        annotate!(450, 300, subplot=3, text("Work", :black,:left, 10))
        annotate!(450, 100, subplot=4, text("Current", :black,:left, 10))
    end
    
    return plt
end