function meanDifference(x, y)
    return mean(x) - mean(y)
end

function BCaBoot(x, func, iter::Int64; α=0.05)
    θₛ = func(x)
    boot = zeros(iter)
    
    for i in 1:iter
        xTemp = sample(x, length(x))
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

function BCaBoot(x, y, func, iter::Int64; α=0.05)
    θₛ = func(x,y)
    boot = zeros(iter)
    
    for i in 1:iter
        xTemp = sample(x, length(x))
        yTemp = sample(y, length(y))
        boot[i] = func(xTemp, yTemp)
    end
    
    ## Calculate bias
    bias = quantile(Normal(), (sum(boot .> θₛ) + sum(boot .== θₛ)/2)/iter)
    
    ## Estimate acceleration
    je = jackknifeEstimate(x, y, func, θₛ)
    
    a = sum(je.^3)/(6*sum(je.^2))^(3/2)
    
    z = quantile(Normal(), [α/2, 1-α/2])
    p = @. cdf(Normal(), (z-bias)/(1-a*(z-bias))-bias)
    ABC = quantile(boot, p)
    
    return Bootstrap(boot, ConfidenceInterval(ABC))
end