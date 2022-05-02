function gardnerAltman!(plt, x, control, test, b; shape_outline=false, kwargs...)
    k = kde(b.boot)
    lb = b.ci.low
    ub = b.ci.high
    lbTrimmed = lb .- 0.15 .* (ub .- lb)
    ubTrimmed = ub .+ 0.15 .* (ub .- lb)
            
    subset = findall(x -> x >= lbTrimmed && x <= ubTrimmed, k.x)
    subX = k.x[subset]
    subY = k.density[subset]
    kdeShape = Shape(vcat([0], subY, [0]), vcat(minimum(subX), 
        subX, maximum(subX)))

    xmax = maximum(k.density) + 0.25 * (maximum(k.density) - minimum(k.density))

    if shape_outline == true
        lw = 1
    else
        lw = 0
    end

    lims = ylims(plt)
    yoffset = [mean(test) - lims[1], lims[2] - mean(test)]
    println(yoffset)

    shapeCenter = mean(b.boot)

    plt2 = plot(kdeShape, xlim = (-1, xmax), 
        ylim = (shapeCenter-yoffset[1], shapeCenter + yoffset[2]), ymirror = true, xticks=([0], ["Test-Control"]); kwargs..., linewidth=lw)
    hline!([0], linewidth=1, color=:black)
    hline!([mean(b.boot)], linewidth=1, color=:black)
    
    plot!([0, 0], [lb, ub], color=:black; kwargs...)
    scatter!([0], [shapeCenter]; kwargs...)
    l = @layout [a b{0.3w}]
    pGA = plot(plt, plt2, layout=l)

    return pGA
end


function estimationPlot(x, xLocs, bootArray; sigTests=:none, zoffset=1.75, scaleKDE=2, xticks=false, annotationSize=10, kwargs...)
    kArray = kde.([b.boot for b in bootArray])
    lbs = [b.ci.low for b in bootArray]
    ubs = [b.ci.high for b in bootArray]
    lBArray = lbs .- 0.15 .* (ubs .- lbs)
    uBArray = ubs .+ 0.15 .* (ubs .- lbs)
    shapes = []
    
    scaleFactor = scaleKDE*maximum(vcat([k.density for k in kArray]...))
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
            [mean(bootArray[i].boot)], markersize=4, color=:white,
        markerstrokewidth=1, dpi=300)
    end
	
    hline!([0], color=:black, linewidth=1, linestyle=:dash)

    return plt
end