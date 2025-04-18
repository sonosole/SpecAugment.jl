export minmaxnorm
export minmaxnorms
export divmaxnorm
export divmaxnorms


"""
    minmaxnorms(x::AbstractArray{T}; dims::Union{Int,Dims}=1) where T <: Real

Normalize elements of `x` to range [0,1] via

    (x .- xmin) ./ (xmax .- xmin)

where `xmin=minimum(x; dims)`,  `xmax = maximum(x; dims)`. Elements of `x` can be positive or negtive.
"""
function minmaxnorms(x::AbstractArray{T}; dims::Union{Int,Dims}=1) where T <: Real
    xmax = maximum(x; dims) .+ eps(T)
    xmin = minimum(x; dims)
    return (x .- xmin) .* inv.(xmax - xmin)
end


"""
    minmaxnorm(x::AbstractArray{T}) where T <: Real

Normalize elements of `x` to range [0,1] via

    (x .- xmin) ./ (xmax - xmin)

where `xmin=minimum(x)`,  `xmax = maximum(x)`. Elements of `x` can be positive or negtive.
"""
function minmaxnorm(x::AbstractArray{T}) where T <: Real
    xmax = maximum(x) .+ eps(T)
    xmin = minimum(x)
    return (x .- xmin) .* inv.(xmax - xmin)
end


"""
    divmaxnorms(x::AbstractArray{T}; dims::Union{Int,Dims}=1) where T <: Real

Normalize elements of `x` to range [0,1] via
    `x ./ xmax`
where `xmax = maximum(x; dims)`. Elements of `x` must be positive.
"""
function divmaxnorms(x::AbstractArray{T}; dims::Union{Int,Dims}=1) where T <: Real
    xmax = maximum(x; dims) .+ eps(T)
    return x .* inv.(xmax)
end


"""
    divmaxnorm(x::AbstractArray{T}) where T <: Real

Normalize elements of `x` to range [0,1] via
    `x ./ xmax`
where `xmax = maximum(x)`. Elements of `x` must be positive.
"""
function divmaxnorm(x::AbstractArray{T}) where T <: Real
    xmax = maximum(x) .+ eps(T)
    return x .* inv.(xmax)
end

