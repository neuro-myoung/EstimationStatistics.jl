function jackknifeEstimate(x, func, θ::Float64)
    n = length(x)
    
    je = zeros(n)
    for i in 0:n-1
        je[i+1] = func(x[1:end-i])
    end
    
    return mean(je) .- je
end

function jackknifeEstimate(x, y, func, θ::Float64)
    n = minimum([length(x), length(y)])
    je = zeros(n)

    for i in 0:n-1
		je[i+1] = func(x[1:end-i], y[1:end-i])
    end

	return mean(je) .- je
end