export quadwrap, quadwrapmap
export sqrtwrap, sqrtwrapmap
export sinwrap, sinwrapmap
export abssinwrap, abssinwrapmap


# 对坐标轴进行扭曲，但是坐标轴的起点跟终点保持不变

"""
    quadwrap(s::AbstractArray{T}, a::AbstractFloat=rand(T); dim::Int=1) where T <: Real

Move peak to the right side by quadratic wrapping along dimension `dim`. 
0 ≤ `a` ≤ 1, if `a`==0, then peaks stand still, the closer the value of 
a is to 1, the more the peaks shift to the right. Test the effect via 
function `quadwrapmap`.

# Math
    y(x) = a*x² + b*x
    y(0) = 0 + 0 = 0
    y(1) = a + b = 1
    y'(x) = 2a*x + b > 0 
    ⟹  x > -b / 2a 
    ⟹  xmin = 0 > -b / 2a
    ⟹  a*b > 0 
    ⟹  a>0 and b>0

then chose `y(x)` be the wrapping mapping.
"""
function quadwrap(s::AbstractArray{T}, a::AbstractFloat=rand(T); dim::Int=1) where T <: Real
    @assert 0 ≤ a ≤ 1 "0 ≤ a ≤ 1, but got $a"
    b = one(T) - a

    N = size(s, dim)
    n = 1 : N
    x = n ./ N
    
    newid = n[@. ceil(Int, N*(a*x^2 + b*x))]
    sizes = size(s)
    indxs = ntuple(i -> isequal(i,dim) ? newid : (1:sizes[i]), ndims(s))
    return s[indxs...]
end


"""
    quadwrapmap(a::AbstractFloat, length_at_dim::Int) -> old_indices, new_indices

Test the wrapping effect of `quadwrap`.

# Example
```julia-repl
julia> begin
           using Plots
           oldids, newids = quadwrapmap(0.9, 2560);
           plot(oldids, oldids, label="origin mapping");
           plot!(oldids, newids, label="re-mapping")
           xlabel!("input indices");
           ylabel!("output indices")
       end
```
"""
function quadwrapmap(a::AbstractFloat, length_at_dim::Int)
    @assert 0 ≤ a ≤ 1 "0 ≤ a ≤ 1, but got $a"
    b = 1 - a
    N = length_at_dim
    n = 1 : N                                 # old indices
    x = n ./ N                              # map to [1/N, 1]
    m = n[@. ceil(Int, N*(a*x^2 + b*x))]    # new indices
    return n, m
end




"""
    sqrtwrap(s::AbstractArray{T}, a::AbstractFloat=rand(T); dim::Int=1) where T <: Real

Move peak to the left side by quadratic wrapping along dimension `dim`. 
0 ≤ `a` ≤ 1, if `a`==1, then peaks stand still, the closer the value of 
a is to 0, the more the peaks shift to the left. Test the effect via 
function `sqrtwrapmap`.

# Math
    y(x) = a*x² + b*x
    y(0) = 0 + 0 = 0
    y(1) = a + b = 1
    y'(x) = 2a*x + b > 0 
    ⟹  x > -b / 2a 
    ⟹  xmin = 0 > -b / 2a
    ⟹  a*b > 0 
    ⟹  a>0 and b>0

then chose `z(x) = √y(x)` be the wrapping mapping.
"""
function sqrtwrap(s::AbstractArray{T}, a::AbstractFloat=rand(T); dim::Int=1) where T <: Real
    @assert 0 ≤ a ≤ 1 "0 ≤ a ≤ 1, but got $a"
    b = one(T) - a

    N = size(s, dim)
    n = 1 : N
    x = n ./ N
    
    newid = n[@. ceil(Int, N*sqrt(a*x^2 + b*x))]
    sizes = size(s)
    indxs = ntuple(i -> isequal(i,dim) ? newid : (1:sizes[i]), ndims(s))
    return s[indxs...]
end


"""
    sqrtwrapmap(a::AbstractFloat, length_at_dim::Int) -> old_indices, new_indices

Test the wrapping effect of `sqrtwrap`.

# Example
```julia-repl
julia> begin
           using Plots
           oldids, newids = sqrtwrapmap(0.3, 2560);
           plot(oldids, oldids, label="origin mapping");
           plot!(oldids, newids, label="re-mapping")
           xlabel!("input indices");
           ylabel!("output indices")
       end
```
"""
function sqrtwrapmap(a::AbstractFloat, length_at_dim::Int)
    @assert 0 ≤ a ≤ 1 "0 ≤ a ≤ 1, but got $a"
    b = 1 - a
    N = length_at_dim
    n = 1 : N                                # old indices
    x = n ./ N                               # map to [1/N, 1]
    m = n[@. ceil(Int, N*sqrt(a*x^2 + b*x))] # new indices
    return n, m
end




"""
    sinwrap(s::AbstractArray{T}, k::Int=rand(20:5:50), a::AbstractFloat=rand(-1:0.2:1); dim::Int=1) where T <: Real

Perturbate peaks by sinusoidal wrapping along dimension `dim`. 
The half-periodic number `k` > 0, bigger `k` causes less distortion of the peak.
The amplitude of sine-wave's derivative `|a|` ≤ 1, larger `|a|` causes more distortion of the peak. 
Test the effect via function `sinwrapmap`.
# Math
    y(x) = x + a*sin(kπ*x) / kπ
    y(0) = 0 + 0 = 0
    y(1) = 1 + 0 = 1
    y'(x) = 1 + a*cos(kπ*x) > 0

then chose `y(x)` be the wrapping mapping.
"""
function sinwrap(s::AbstractArray{T}, k::Int=rand(20:5:50), amplitude::AbstractFloat=rand(-1:0.2:1); dim::Int=1) where T <: Real
    @assert k > 0 "k > 0, but got $k"
    @assert -1 ≤ amplitude ≤ 1 "-1 ≤ amplitude ≤ 1, but got $amplitude"
    a = T(amplitude)
    N = size(s, dim)
    n = 1 : N
    x = n ./ N
    kπ    = T(k * π)
    kπ⁻¹  = inv(kπ)
    newid = n[@. min(ceil(Int, N*(x + a*sin(kπ*x) * kπ⁻¹)), N) ]
    sizes = size(s)
    indxs = ntuple(i -> isequal(i,dim) ? newid : (1:sizes[i]), ndims(s))
    return s[indxs...]
end


"""
    sinwrapmap(k::Int, amplitude::AbstractFloat, length_at_dim::Int) -> old_indices, new_indices

Test the wrapping effect of `sinwrap`.

# Example
```julia-repl
julia> begin
           using Plots
           oldids, newids = sinwrapmap(4, 0.7, 1024);
           plot(oldids, oldids, label="origin mapping");
           plot!(oldids, newids, label="re-mapping")
           xlabel!("input indices");
           ylabel!("output indices")
       end
```
"""
function sinwrapmap(k::Int, amplitude::AbstractFloat, length_at_dim::Int)
    @assert k > 0 "k > 0, but got $k"
    @assert -1 ≤ amplitude ≤ 1 "-1 ≤ amplitude ≤ 1, but got $amplitude"
    kπ   = k * π
    kπ⁻¹ = inv(kπ)
    a = amplitude
    N = length_at_dim
    n = 1 : N
    x = n ./ N
    m = n[@. min(ceil(Int, N*(x + a*sin(kπ*x) * kπ⁻¹)), N) ]
    return n, m
end




"""
    abssinwrap(s::AbstractArray{T}, k::Int=rand(20:5:50), a::AbstractFloat=rand(-1:0.2:1); dim::Int=1) where T <: Real

Perturbate peaks by sinusoidal wrapping along dimension `dim`. 
The half-periodic number `k` > 0, bigger `k` causes less distortion of the peak.
The amplitude of sine-wave's derivative `|a|` ≤ 1, larger `|a|` causes more distortion of the peak. 
Test the effect via function `abssinwrapmap`.
# Math
    y(x) = x + a*|sin(kπ*x) / kπ|
    y(0) = 0 + 0 = 0
    y(1) = 1 + 0 = 1
    y'(x) = 1 + a*cos(kπ*x) > 0

then chose `y(x)` be the wrapping mapping.
"""
function abssinwrap(s::AbstractArray{T}, k::Int=rand(20:5:50), amplitude::AbstractFloat=rand(-1:0.2:1); dim::Int=1) where T <: Real
    @assert k > 0 "k > 0, but got $k"
    @assert -1 ≤ amplitude ≤ 1 "-1 ≤ amplitude ≤ 1, but got $amplitude"
    a = T(amplitude)
    N = size(s, dim)
    n = 1:N
    x = n ./ N

    kπ    = T(k * π)
    kπ⁻¹  = inv(kπ)
    newid = n[@. min(ceil(Int, N*(x + a*abs(sin(kπ*x)) * kπ⁻¹)), N) ]
    sizes = size(s)
    indxs = ntuple(i -> isequal(i,dim) ? newid : (1:sizes[i]), ndims(s))
    return s[indxs...]
end


"""
    abssinwrapmap(k::Int, amplitude::AbstractFloat, length_at_dim::Int) -> old_indices, new_indices

Test the wrapping effect of `abssinwrap`.

# Example
```julia-repl
julia> begin
           using Plots
           oldids, newids = abssinwrapmap(3, 0.8, 2560);
           plot(oldids, oldids, label="origin mapping");
           plot!(oldids, newids, label="re-mapping")
           xlabel!("input indices");
           ylabel!("output indices")
       end
```
"""
function abssinwrapmap(k::Int, amplitude::AbstractFloat, length_at_dim::Int)
    @assert k > 0 "k > 0, but got $k"
    @assert -1 ≤ amplitude ≤ 1 "-1 ≤ amplitude ≤ 1, but got $amplitude"
    kπ   = k * π
    kπ⁻¹ = inv(kπ)
    a = amplitude
    N = length_at_dim
    n = 1 : N
    x = n ./ N
    m = n[@. min(ceil(Int, N*(x + a*abs(sin(kπ*x)) * kπ⁻¹)), N) ]
    return n, m
end

