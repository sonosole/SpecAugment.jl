@inline function ldotmul!(a::AbstractArray{T},
                          x::AbstractArray{T}) where T <: Real
    x .*= a
    return x
end


@inline function rdotsub!(x::AbstractArray{T},
                          a::AbstractArray{T}) where T <: Real
    x .-= a
    return x
end


export addrand
export addrandn


"""
    addrand(x::AbstractArray{T}; dims=1, snr=10) -> y::AbstractArray

Add rand noise to input `x` along dimensions `dims`. The signal-to-noise ratio `snr` is in dB unit.
"""
function addrand(x::AbstractArray{T}; dims::Union{Int,Dims}=1, snr::Real=10) where T <: Real
    n  = rand(T, size(x))
    Ex = sum(x; dims);             # energy of signal
    En = sum(n; dims) .+ eps(T)    # energy of noise

    # snr = 10log10(Ex/(K*En))
    k = T.(Ex ./ En * 10^(-snr/10))
    return x + ldotmul!(k, n)
end


"""
    addrandn(x::AbstractArray{T}; dims=1, snr=10) -> y::AbstractArray

Add randn noise to input `x` along dimensions `dims`. The signal-to-noise ratio `snr` is in dB unit.
"""
function addrandn(x::AbstractArray{T}; dims::Union{Int,Dims}=1, snr::Real=10) where T <: Real
    n = randn(T, size(x))
    M = minimum(n; dims)
    rdotsub!(n, M)                 # ensure ≥ 0
    Ex = sum(x; dims);             # energy of signal
    En = sum(n; dims) .+ eps(T)    # energy of noise

    # snr = 10log10(Ex/(K*En))
    k = T.(Ex ./ En * 10^(-snr/10))
    return x + ldotmul!(k, n)
end

