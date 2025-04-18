export slimorfat


"""
    slimorfat(x::AbstractArray{T};
              ratio::Real=2
              dims::Union{Int,Dims}=1,
              target::AbstractFloat=0.5) -> y::AbstractArray{T}

Make the spectrum peak more `slim` or `fat` along dimension `dims`, the dB difference 
between `x` and threshold `T` would be scaled by a positive `ratio`, that is

    10log10(y) - 10log10(T)      1
    ──────────────────────── = ─────
    10log10(x) - 10log10(T)    ratio

where

    T = target * (xmax - xmin) + xmin
    xmax = maximum(x; dims)
    xmin = minimum(x; dims)

if ratio < 1, the peak becomes thinner,
if ratio > 1, the peak becomes fatter.
"""
function slimorfat(x::AbstractArray{T};
                   dims::Union{Int,Dims}=1,
                   target::AbstractFloat=0.5,
                   ratio::Real=0.5) where T <: Real

    @assert (0 < ratio) "ratio > 0, but got $ratio"
    @assert (0 < target < 1) "0 < target < 1, but got $target"
    xthr = T(target)*maximum(x; dims)
    XdB = log.(x .+ eps(T))
    TdB = log.(xthr)
    C = T(1 / ratio - 1)
    return exp.(C .* (XdB .- TdB)) .* x
end


"""
    thin(x::AbstractArray{T};
         ratio::Real=2
         dims::Union{Int,Dims}=1,
         target::AbstractFloat=0.5) -> y::AbstractArray{T}

Make the spectrum peak more `slim` or `fat` along dimension `dims`, the dB difference 
between `x` and threshold `T` would be enlarged by `ratio`, that is

    f(y) - f(T)      1
    ─────────── =  ───── = k > 0  where f() is any logarithmic function, e.g. 20log10, 10log10, log
    f(x) - f(T)    ratio

    ⟹  (k-1) * (f(x) - f(T)) + f(x) = f(y)
    ⟹  (x/T)^(K-1) * x = y

    if f = 10log10, then (k-1) * (10log10(x) - 10log10(T)) = 10log10(y/x)
    finally y = x * 10^[(k-1)/10 * (XdB - TdB)].

    if f = log, then (k-1) * (log(x) - log(T)) = log(y/x)
    finally y = x * exp[(k-1) * (logx - logT)].

where

    T = target * (xmax - xmin) + xmin
    xmax = maximum(x; dims)
    xmin = minimum(x; dims)

if ratio < 1, the peak becomes thinner,
if ratio > 1, the peak becomes fatter.
"""
function refig(x::AbstractArray{T};
               dims::Union{Int,Dims}=1,
               target::AbstractFloat=0.5,
               ratio::Real=0.5) where T <: Real

    @assert (0 < ratio) "ratio > 0, but got $ratio"
    @assert (0 < target < 1) "0 < target < 1, but got $target"
    xmax = maximum(x; dims)
    xmin = minimum(x; dims)
    I = inv.(T(target)*(xmax - xmin) + xmin)
    Q = T(1 / ratio - 1)
    return (x .* I) .^ Q .* x
end # 跟 slimorfat 完全等价但是计算略慢就不导出了

