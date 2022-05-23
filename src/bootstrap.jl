"""
	meanDiff(x, y)
	
Calculates the difference in the means between two arrays `x` and `y`.

```jldoctest
julia> meanDiff([3,5,4,10], [6, 6, 3, 4])
0.75
```
"""
function meanDiff(x, y)
    return mean(x) - mean(y)
end

"""
	medianDiff(x, y)
	
Calculates the difference in the means between two arrays `x` and `y`.

```jldoctest
julia> medianDiff([3,5,4,10], [6, 6, 3, 4])
0.75
```
"""
function medianDiff(x, y)
    return median(x) - median(y)
end

function BCaBoot(x::AbstractArray, func; iter::Int64=10000, α::Float64=0.05, seed=23)
    θₛ = func(x)
    boot = zeros(iter)
    rng = MersenneTwister(seed)
    
    for i in 1:iter
        xTemp = sample(rng, x, length(x), replace=true)
        boot[i] = func(xTemp)
    end
    
    ## Calculate bias
    bias = quantile(Normal(), (sum(boot .> θₛ) + sum(boot .== θₛ)/2)/iter)
    
    ## Estimate acceleration
    je = jackknifeEstimate(x, func, θₛ)
    
    a = sum(je.^3)/(6*sum(je.^2))^(3/2)
    
    z = quantile(Normal(), [α/2, 1-α/2])
    p = @. cdf(Normal(), (z-bias)/(1-a*(z-bias))-bias)
    ABC = quantile(boot, p)
    
    return Bootstrap(boot, ConfidenceInterval(ABC))
end

"""
	BCaBoot(x, y, func; iter, α)
	
Calculates bias-corrected and accelerated confidence intervals for a summary
statistic of two vectors `x` and `y`. The code is adapted from Martinez & Martinez
Computational Statistics Handbook with MATLAB 2002. 

```jldoctest
julia> ADD LATER
```
"""
function BCaBoot(x::AbstractArray, y::AbstractArray, func; iter::Int64=10000, α::Float64=0.05, seed=23)
    θₛ = func(x,y)
    boot = zeros(iter)
    rng = MersenneTwister(seed)
    
    ## Resample with replacement to generate arrays of the same size as the original sample
    ## and recalculate the summary statistic
    for i in 1:iter
        xTemp = sample(rng, x, length(x), replace=true)
        yTemp = sample(rng, y, length(y), replace=true)
        boot[i] = func(xTemp, yTemp)
    end
    
    ## Calculate bias using invcdf of number of bootstrap replicates below sample statistic
    ## over the number of iterations
    bias = quantile(Normal(), sum(boot .< θₛ)/iter)
    
    ## Estimate acceleration using jackknife
    je = jackknifeEstimate(x, y, func, θₛ)
    a = sum(je.^3)/(6*sum(je.^2)^(3/2))
    
    ## Standard Percentile CIs
    z = quantile(Normal(), [α/2, 1-α/2])

    ## Bias-corrected accelerated CIs
    p = @. cdf(Normal(), bias + (bias + z)/(1-a*(bias+z)))
    println(je)
    BCa = quantile(boot, p)
    
    return Bootstrap(boot, ConfidenceInterval(BCa))
end

function BCaBoot(x::Vector, ys::Vector{Vector}, func; iter::Int64=10000, α::Float64=0.05, seed=23)
    θₛArr = func.(x,y)
    boot = fill(0.0, (iter, length(ys)))
    rng = MersenneTwister(seed)
    
    ## Resample with replacement to generate arrays of the same size as the original sample
    ## and recalculate the summary statistic
    for i in 1:iter
        xTemp = sample(rng, x, length(x), replace=true)
        for j in 1:length(ys)
            yTemp = sample(rng, ys[j], length(ys[j]), replace=true)
            boot[i,j] = func(xTemp, yTemp)
        end
    end
    println("hurrah!")

    ## Calculate bias using invcdf of number of bootstrap replicates below sample statistic
    ## over the number of iterations
    bias = quantile(Normal(), sum(boot .< θₛ)/iter)
    
    ## Estimate acceleration using jackknife
    je = jackknifeEstimate(x, y, func, θₛ)
    a = sum(je.^3)/(6*sum(je.^2)^(3/2))
    
    ## Standard Percentile CIs
    z = quantile(Normal(), [α/2, 1-α/2])

    ## Bias-corrected accelerated CIs
    p = @. cdf(Normal(), bias + (bias + z)/(1-a*(bias+z)))
    BCa = quantile(boot, p)
    
    return Bootstrap(boot, ConfidenceInterval(BCa))
end
