function gardnerAltman!(plt, x, control, test, b; shape_outline=false, kwargs...)
    k = kde(b.boot)
    lb = b.ci.low
    ub = b.ci.high
    lbTrimmed = lb .- 0.15 .* (ub .- lb)
    ubTrimmed = ub .+ 0.15 .* (ub .- lb)
    shapes = []
            
    subset = findall(x -> x >= lbTrimmed && x <= ubTrimmed, k.x)
    subX = k.x[subset]
    subY = k.density[subset]
    kdeShape = Shape(vcat([0], subY, [0]), vcat(minimum(subX), 
        subX, maximum(subX)))

    xmin = minimum(k.density) - 0.25 * (maximum(k.density) - minimum(k.density))
    xmax = maximum(k.density) + 0.25 * (maximum(k.density) - minimum(k.density))

    if shape_outline == true
        lw = 1
    else
        lw = 0
    end

    lims = ylims(plt)
    yoffset = (mean(test) - lims[1])
    println(yoffset)

    p2 = plot(kdeShape, xlim = (-1, xmax), 
        ylim = lims .- yoffset, ymirror = true, xticks=([0], ["Test-Control"]); kwargs..., linewidth=lw)
    hline!([0], linewidth=1, color=:black)
    hline!([mean(b.boot)], linewidth=1, color=:black)
    
    plot!([x[1], x[1]], [lb, ub], color=:black; kwargs...)

    scatter!([x[1]], [mean(b.boot)]; kwargs...)
    l = @layout [a b{0.3w}]
    pGA = plot(plt, p2, layout=l)

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
	
	if sigTests != :none
		
		for row in eachrow(sigTests)
			plot!(
				[
					(xLocs[row.loc1]-0.5*scaleFactor)/2,
					(xLocs[row.loc2]-0.5*scaleFactor)/2
				], 
			repeat([maximum(ubs) + 0.1*(maximum(ubs) - minimum(lbs))], 2), 
			color=:black,
			linewidth=2)
			
			if row.pval >= 0.05
				mytext = "ns"
			elseif row.pval < 0.05 && row.pval >= 0.01
				mytext = "*"
			elseif row.pval < 0.01 && row.pval >= 0.001
				mytext = "**"
			else
				mytext = "***"
			end
			
			annotate!(mean([(xLocs[row.loc1]-0.5*scaleFactor)/2,
					(xLocs[row.loc2]-0.5*scaleFactor)/2]), 
                    zoffset*(maximum(ubs) + 0.1*(maximum(ubs) - minimum(lbs))),
                    text(mytext, annotationSize))
		end
	end
    
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