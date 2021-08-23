function jackknifeEstimate(x, func, θ::Float64)
    n = length(x)
    obsn = θ * n
    
    pv = zeros(n)
    for i in 0:n-1
        pv[i+1] = obsn-(n-1) * func(x[1:end-i])
    end
    
    return mean(pv) .- pv
end

function jackknifeEstimate(x, y, func, θ::Float64)
    n = minimum([length(x), length(y)])
    obsn = θ * n
    
    pv = zeros(n)
    for i in 0:n-1
        pv[i+1] = obsn-(n-1) * (func(x[1:end-i], y[1:end-i]))
    end
    
    return mean(pv) .- pv
end