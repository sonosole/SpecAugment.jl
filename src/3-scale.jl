export randscale
export sinscale


"""
    randscale(x::AbstractArray{T},
              minscale::Real=0.9,
              maxscale::Real=1.1;
              dims::Union{Int,Dims}=1) where T <: Real

Apply rand scale ∈ [`minscale`, `maxscale`] to `x` along dimensions `dims`. 
"""
function randscale(x::AbstractArray{T},
                   minscale::Real=0.9,
                   maxscale::Real=1.1;
                   dims::Union{Int,Dims}=1) where T <: Real
    @assert maxscale > 0 "maxscale > 0, but got $maxscale"
    @assert minscale > 0 "minscale > 0, but got $minscale"
    D = ndims(x)
    sizex = size(x)
    sizen = ntuple(i -> (i ∈ dims) ? sizex[i] : 1, D)
    n = rand(T, sizen) .* (maxscale - minscale) .+ minscale
    return x .* n
end


"""
    sinscale(x::AbstractArray
             minscale::Real=0.9
             maxscale::Real=1.1;
             dims::Union{Int,Dims}=1,
             cycles::Real=4,
             phase::Real=0)

Apply sin scale ∈ [`minscale`, `maxscale`] to `x` along dimensions `dims`. 
`cycles` is the number of sine cycles, `phase` is the initial phase.
"""
function sinscale(x::AbstractArray{T},
                  minscale::Real=0.9,
                  maxscale::Real=1.1;
                  dims::Union{Int,Dims}=1,
                  cycles::Real=4,
                  phase::Real=0) where T <: Real
    @assert maxscale > 0 "maxscale > 0, but got $maxscale"
    @assert minscale > 0 "minscale > 0, but got $minscale"
    D = ndims(x)
    sizex = size(x)
    sizes = ntuple(i -> (i ∈ dims) ? sizex[i] : 1, D)
    N = prod(sizes)
    t = (zero(T) : T(N-1)) .* T(2*pi/N * cycles) .+ T(phase)
    s = (sin.(t) .+ one(T)) .* T(0.5) .* T(maxscale - minscale) .+ T(minscale)
    return reshape(s, sizes) .* x
end

