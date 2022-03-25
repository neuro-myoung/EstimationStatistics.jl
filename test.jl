using EstimationStatistics
using Distributions, StatsPlots, DataFrames

function gardnerAltman2!(plt, x, control, test, b; shape_outline=false, kwargs...)
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


## Create dataframe with dummy data
df = DataFrame(
	:x => vcat(repeat(["Control"], 30), repeat(["Test1"], 30)), 
	:y => vcat(rand(Normal(5, 3), 30), rand(Normal(0, 2), 30)),
	:group => vcat(repeat(["g1"], 30), repeat(["g2"], 30)),
	:sample => repeat(1:1:30, 2)
)

## Bootstrap from your two populations
gdf = groupby(df, :group)
b1 = BCaBoot(gdf[2].y, gdf[1].y, meanDiff, iter=100000)

## Create quasirandom scatterplot
p1 = @df df quasirandomScatter(:x, :y, group =:group, 
    legend=false, grid=false, 
    ylab="Value", markersize=6, alpha=0.6)
## Supplement with bootstrap data to make a Gardner-Altman plot
gardnerAltman2!(p1, df.x, gdf[1].y, gdf[2].y, BCaBoot(gdf[2].y, gdf[1].y, meanDiff, iter=100000), grid=false, legend=false, markersize=5, markercolor=:black, fillcolor=:gray, markerstrokewidth=3, linewidth=3, ylab="Mean Difference")

## Example Tufte slopegraph
p3 = @df df plot(:x, :y, group=:sample, legend=false, color=:black, xlim=(0, 2))
gardnerAltman!(p3, df.x, gdf[1].y, gdf[2].y, BCaBoot(gdf[2].y, gdf[1].y, meanDiff, iter=100000), grid=false, legend=false, markersize=5, markercolor=:white, fillcolor=:gray, markerstrokewidth=3, linewidth=3, ylab="Mean Difference")
