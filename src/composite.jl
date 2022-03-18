
"""
Union of several basis functions in the imaginary-time/real-frequency domain
domains
"""
struct CompositeBasisFunction
    polys::Vector{PiecewiseLegendrePoly}
end


"""
Evaluate basis function at position x
"""
function (obj::CompositeBasisFunction)(x::Real)
    hcat((p(x) for p in obj.polys))
end


"""
Union of several basis functions in the imaginary-frequency domain
domains
"""
struct CompositeBasisFunctionFT
    polys::Vector{PiecewiseLegendreFT}
end


"""
Evaluate basis function at frequency n
"""
function (obj::CompositeBasisFunctionFT)(n::Union{Int64, Vector{Int64}})
    hcat((p(n) for p in obj.polys))
end


struct CompositeBasis
    beta :: Float64
    size :: Int64
    bases :: Vector{Basis}
    u::CompositeBasisFunction
    v::CompositeBasisFunction
    uhat::CompositeBasisFunctionFT
end

function _collect_polys(polys)
    if any((p === nothing for p in polys))
        return nothing
    else
        return [b.u for b in bases]
    end
end

function CompositeBasis(bases::Vector{Basis})
    size = sum((size(b) for b in bases))
    u = CompositeBasisFunction([b.u for b in bases])
    v = CompositeBasisFunction(_collect_polys([b.v for b in bases]))
    uhat = CompositeBasisFunctionFT(_collect_polys([b.uhat for b in bases]))
    CompositeBasis(bases[1].beta, size, bases, u, v, uhat)
end

function default_tau_sampling_points(basis::CompositeBasis)
    sort(unique(vcat((default_tau_sampling_points(b) for b in basis.bases))))
end


function default_matsubara_sampling_points(basis::CompositeBasis; mitigate=true)
    sort(unique(vcat((default_matsubara_sampling_points(b, mitigate=mitigate) for b in basis.bases))))
end