module EstimationStatistics

using Plots
using KernelDensity
using Measures
using StatsBase
using Distributions
using Statistics
using DataFrames
using DataStructures

include("quasirandomScatter.jl")
include("jackknife.jl")
include("bootstrap.jl")
include("estimationPlot.jl")
include("addSummaryStat.jl")

struct ConfidenceInterval
    low::Float64
    high::Float64
end

ConfidenceInterval(arr) = ConfidenceInterval(arr[1], arr[2])

struct Bootstrap
    boot::Array
    ci::ConfidenceInterval
end

function customSort!(df::DataFrame, sortops)
    sortv = []
    sortOptions = []
    if(isa(sortops, Array))
        sortv = sortops
    else
        push!(sortv,sortops)
    end
    for i in sortv
        if(isa(i, Tuple))
            if (isa(i[2], Array)) # The second option is a custom order
                orderArray = Array(collect(union(OrderedSet(i[2]),  OrderedSet(unique(df[!, i[1]])))))
                push!(sortOptions, order(i[1], by = x->Dict(x => i for (i,x) in enumerate(orderArray))[x] ))
            else                  # The second option is a reverse direction flag
                push!(sortOptions, order(i[1], rev = i[2]))
            end
        else
          push!(sortOptions, order(i))
        end
    end
    return sort!(df, sortOptions)
end

export Bootstrap, ConfidenceInterval
export quasirandomScatter, addSummaryStat!, estimationPlot
export meanDiff, medianDiff, BCaBoot

end
