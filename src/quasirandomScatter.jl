vandercorput(num::Integer, base::Integer) = sum(d * Float64(base) ^ -ex for (ex,d) in enumerate(digits(num, base=base)))

function quasirandom(x, y;order=:none, squish=0.9)
	
	if order == :none
		grps = unique(x)
	else
		grps = order
	end

	nGroups = length(grps)
	width= squish/nGroups

	k = Array{UnivariateKDE}(undef, nGroups)
	maxDensity = zeros(nGroups)

	xTemp = zeros(length(x))
	for i in 1:nGroups
		xTemp[findall(elements -> elements == grps[i], x)] .= i
	end

	q = zeros(length(x))
	d = zeros(length(x))
	for i in 1:nGroups
		k[i] = kde(y[x .== grps[i]])
		d[x .== grps[i]] .= pdf(k[i], y[x .== grps[i]])
		maxDensity[i] = maximum(d[x .== grps[i]])
		q[x .== grps[i]] .= vandercorput.(1:length(q)
			, 2)[competerank(y[x .== grps[i]])]
	end

	x_jitter = xTemp .+ width./maxDensity[nGroups] .*  (q .- 0.5) .* 2 .* d

	return x_jitter .- 0.5
end

function quasirandomScatter(x, y; order=:none, squish=0.9, kwargs...)

	plt = scatter(x, y; markercolor=:white, markerstrokewidth=0,
		xlim=(0, length(unique(x))), margin=2mm)
	scatter!(quasirandom(x, y;order=order, squish), y; kwargs...)

	return plt
end