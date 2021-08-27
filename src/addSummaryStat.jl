function addSummaryStat!(df::DataFrame, x::Symbol, y::Symbol, func; 
    colors=[:black, :black, :black, :black], kwaargs...)

    if func == mean
        temp = combine(groupby(df, x), y => func => :mean, y=> std => :sd)
        
        for i in 1:size(temp)[1]
            plot!([i-0.1, i-0.1], 
                [temp.mean[i] - temp.sd[i], temp.mean[i] + temp.sd[i]],
                linewidth=3, color=colors[i]; kwaargs...)
            scatter!([i-0.1, i-0.1], 
                [temp.mean[i], temp.mean[i]],
                markersize=2, marker=:square,
                color=:white,
                markerstrokewidth=2,
                markerstrokecolor=:white)
        end
        
    elseif func == median
        temp = combine(groupby(df, x), 
            y => func => :median,
            y => (x -> percentile(x,25)) => :ybot,
            y => (x -> percentile(x,75)) => :ytop)
        
        println(temp)
        
        for i in 1:size(temp)[1]
            plot!([i-0.1, i-0.1], 
                [temp.ybot[i], temp.ytop[i]],
                linewidth=3;kwaargs...)
            scatter!([i-0.1, i-0.1], 
                [temp.median[i], temp.median[i]],
                markersize=2, marker=:square,
                color=:white,
                markerstrokewidth=2,
                markerstrokecolor=:white)
        end
    
    end
end