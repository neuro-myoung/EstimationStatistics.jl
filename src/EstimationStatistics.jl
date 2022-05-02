module EstimationStatistics

using Plots
using KernelDensity
using StatsBase
using Statistics
using DataFrames
using Distributions


include("quasirandomScatter.jl")
include("jackknife.jl")
include("bootstrap.jl")
include("estimationPlots.jl")
      
struct ConfidenceInterval
    low::Float64
    high::Float64
end

ConfidenceInterval(arr) = ConfidenceInterval(arr[1], arr[2])

struct Bootstrap
    boot::Array
    ci::ConfidenceInterval
end

Base.broadcastable(x::Bootstrap) = Ref(x)

export Bootstrap, ConfidenceInterval
export quasirandom, quasirandomScatter, quasirandomScatter!, gardnerAltman!
export meanDiff, medianDiff, BCaBoot

end