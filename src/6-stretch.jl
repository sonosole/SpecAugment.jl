export stretch


# 将 [a,b] 比例区间的值线性映射到 [0,1] 比例区间 
"""
    stretch(s::AbstractArray{T},
            a::AbstractFloat=rand(0.02:0.02:0.1),
            b::AbstractFloat=rand(0.9:0.02:0.98); dim::Int=1) where T <: Real

Stretch `s` along dimension `dim`.
0 ≤ `a`≤ 1, is the starting point, 
0 ≤ `b`≤ 1, is the ending point.
If `a` < `b`, then stretch the proportional region [a,b] into [0,1] along dimension `dim`. 
If `a` > `b`, then stretch the proportional region [b,a] into [0,1] along dimension `dim` after flipping `s` along dimension `dim`. 
# Math
    y(x) = (b-a)x + a
    y(0) = a
    y(1) = b

then chose `y(x)` be the wrapping mapping.
"""
function stretch(s::AbstractArray{T},
                 a::AbstractFloat=rand(0.02:0.02:0.1),
                 b::AbstractFloat=rand(0.9:0.02:0.98); dim::Int=1) where T <: Real
    @assert 0 ≤ a ≤ 1 "0 ≤ a ≤ 1, but got $a"
    @assert 0 ≤ b ≤ 1 "0 ≤ b ≤ 1, but got $b"
    k = T(b - a)
    a = T(a)

    N = size(s, dim)
    n = 1:N
    x = n ./ N
    
    newid = n[@. ceil(Int, N*(k*x + a))]
    sizes = size(s)
    indxs = ntuple(i -> isequal(i,dim) ? newid : (1:sizes[i]), ndims(s))
    return s[indxs...]
end
