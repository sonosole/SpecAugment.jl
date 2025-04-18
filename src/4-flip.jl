export flip


"""
    flip(x::AbstractArray{T}; dims::Union{Int,Dims}=1) -> y::AbstractArray

The input `x` and output `y` satisfies `y` = maximum(`x`; `dims`) .- `x`
"""
function flip(x::AbstractArray{T}; dims::Union{Int,Dims}=1) where T <: Real
    return maximum(x; dims) .- x
end

