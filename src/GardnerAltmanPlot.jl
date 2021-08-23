function GardnerAltmanPlot(df, x, y, bootstrap; distColor=:grey, kwargs...)
		
    k = kde(bootstrap.boot)
    lB = bootstrap.ci.low - 0.15*(bootstrap.ci.high - bootstrap.ci.low)
    uB = bootstrap.ci.high+ 0.15*(bootstrap.ci.high - bootstrap.ci.low)
    subset = findall(x -> x >= lB && x <= uB, k.x)
    subX = k.x[subset]
    subY = k.density[subset]
    
    kdeShape = Shape(vcat([0], subY, [0]),
        vcat(minimum(subX), subX, maximum(subX)))
    
    grp = groupby(df, x)
    offset = mean(grp[1][!,y])
    
    l = @layout [a{0.7w} b]
    p1 = quasirandomScatter(df[!,x], df[!,y], group= df[!, x], dpi=300,
        left_margin=10mm; kwargs...)
    p2 = plot(kdeShape, legend=:none, grid = false, xticks=false,
        ylim=(ylims(p1)[1]-offset, ylims(p1)[2]-offset), dpi=300,
        ymirror = true, fill=distColor, alpha=0.4, linewidth = 0,
        xlim=(-0.4 * maximum(k.density), 1.2 * maximum(k.density)),
        ylab="Mean Difference", right_margin=5mm, left_margin=-4mm)
    plot!([0,0], [bootstrap.ci.low, bootstrap.ci.high],
        color=:black, linewidth=3, dpi=300)
    scatter!([0], [mean(bootstrap.boot)], markersize=6, color=:white,
        markerstrokewidth=3, dpi=300)
    hline!([0], color=:black, linewidth=2)
    
    return plot(p1, p2, layout = l, size=(300, 400))
end