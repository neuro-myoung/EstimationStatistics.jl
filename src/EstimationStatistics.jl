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

Base.broadcastable(x::Bootstrap) = Ref(x)

export Bootstrap, ConfidenceInterval
export quasirandomScatter, addSummaryStat!, estimationPlot, quasirandomScatter!
export meanDiff, medianDiff, BCaBoot

end
