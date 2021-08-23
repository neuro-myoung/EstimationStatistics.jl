module EstimationStatistics

using Plots
using KernelDensity
using Measures
using StatsBase
using Distributions
using Statistics
using DataFrames

include("quasirandomScatter.jl")
include("jackknife.jl")
include("bootstrap.jl")
include("GardnerAltmanPlot.jl")

struct ConfidenceInterval
    low::Float64
    high::Float64
end

ConfidenceInterval(arr) = ConfidenceInterval(arr[1], arr[2])

struct Bootstrap
    boot::Array
    ci::ConfidenceInterval
end

export Bootstrap, ConfidenceInterval
export quasirandomScatter, GardnerAltmanPlot
export meanDifference, BCaBoot

end