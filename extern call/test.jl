cd(@__DIR__)

u = zeros(2, 2)
ccall((:test, "c/libkit.so"), Nothing, (Ref{Cdouble},), u)
@show u

u .= 0.0
ccall((:test1_, "fortran/libkit.so"), Nothing, (Ref{Float64},Ref{Int},Ref{Int},), u, 2, 2)
@show u

ccall((:test_, "fortran/libkit.so"), Nothing, (Ref{Float64},), u)