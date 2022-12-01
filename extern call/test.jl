cd(@__DIR__)

# C
u = zeros(2, 2)
ccall((:test, "c/libkit.so"), Nothing, (Ref{Cdouble},), u)
@show u

# Fortran
u .= 0.0
ccall((:test1_, "fortran/libkit.so"), Nothing, (Ref{Float64}, Ref{Int}, Ref{Int}), u, 2, 2)
@show u

ccall((:test_, "fortran/libkit.so"), Nothing, (Ref{Float64},), u)

# C++
module KitCxx
using CxxWrap
@wrapmodule(joinpath(@__DIR__, "c++/build/libkit"))
function __init__()
    @initcxx
end
end # module

using .KitCxx
KitCxx.test1(u)
@show u

KitCxx.test2(u, 1, 2022.0)
@show u

u = collect(-5:0.0001:5)
H = zero(u)
prim = [1.0, 0.0, 1.0]

using BenchmarkTools
@btime KitCxx.maxwellian_xt($H, $u, $prim)
"""1.786 ms (0 allocations: 0 bytes)"""

function maxwellian_jl(H, u, prim)
    for i in eachindex(H)
        H[i] = prim[1] * (prim[3] / pi)^0.5 * exp(-prim[2] * (u[i] - prim[1])^2)
    end
    nothing
end
@btime maxwellian_jl($H, $u, $prim)
"""2.934 ms (0 allocations: 0 bytes)"""

function maxwellian_jl1(H, u, prim)
    for i in eachindex(H)
        @inbounds H[i] = prim[1] * (prim[3] / pi)^0.5 * exp(-prim[2] * (u[i] - prim[1])^2)
    end
    nothing
end
@btime maxwellian_jl1($H, $u, $prim)
"""2.909 ms (0 allocations: 0 bytes)"""

function maxwellian_jl2(H, u, prim)
    for i in eachindex(H)
        @fastmath H[i] = prim[1] * (prim[3] / pi)^0.5 * exp(-prim[2] * (u[i] - prim[1])^2)
    end
    nothing
end
@btime maxwellian_jl2($H, $u, $prim)
"""3.023 ms (0 allocations: 0 bytes)"""

function maxwellian_jl3(H, u, prim)
    @. H = prim[1] * (prim[3] / pi)^0.5 * exp(-prim[2] * (u - prim[1])^2)
    nothing
end
@btime maxwellian_jl3($H, $u, $prim)
"""3.066 ms (0 allocations: 0 bytes)"""
