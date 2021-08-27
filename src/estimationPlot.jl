function estimationPlot(x, xLocs, bootArray; xticks=false, kwargs...)
    kArray = kde.([b.boot for b in bootArray])
    lbs = [b.ci.low for b in bootArray]
    ubs = [b.ci.high for b in bootArray]
    lBArray = lbs .- 0.15 .* (ubs .- lbs)
    uBArray = ubs .+ 0.15 .* (ubs .- lbs)
    shapes = []
    
    scaleFactor = 2*maximum(vcat([k.density for k in kArray]...))
    xLocs = scaleFactor.*xLocs .- 0.5 * scaleFactor
    nBreaks = length(unique(x))
    
    for i in 1:length(kArray)
        subset = findall(x -> x >= lBArray[i] && x <= uBArray[i],
            kArray[i].x)
        subX = kArray[i].x[subset]
        subY = kArray[i].density[subset]
        kdeShape = Shape(vcat([0], subY, [0]), 
            vcat(minimum(subX), subX, maximum(subX)))
        kdeShape.x .+= xLocs[i]
        push!(shapes, kdeShape)
    end

    plt = plot(shapes[1]; kwargs...)
    
    for i in 1:length(shapes)
        if i > 1
            plot!(shapes[i]; kwargs...)
        end

        if xticks != false
            plot!([xLocs[i],xLocs[i]], [lbs[i], ubs[i]],
                xticks=(collect(1:1:nBreaks).*scaleFactor .- 0.5*scaleFactor, xticks),
                color=:black, linewidth=2, dpi=300, legend=false,
                xlim=(0,nBreaks*scaleFactor))
        else
            plot!([xLocs[i],xLocs[i]], [lbs[i], ubs[i]], xticks=false,
                color=:black, linewidth=2, dpi=300, legend=false,
                xlim=(0,nBreaks*scaleFactor))
        end
        scatter!([xLocs[i]], 
            [mean(bootArray[i].boot)], markersize=5, color=:white,
        markerstrokewidth=2, dpi=300)
    end
    hline!([0], color=:black, linewidth=1, linestyle=:dash)

    return plt
end