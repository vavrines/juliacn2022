using StaticArrays, Plots

begin
    plot_font = "Computer Modern"
    default(
        fontfamily = plot_font,
        linewidth = 1.5,
        framestyle = :box,
        label = :none,
        grid = false,
        size = (400, 400),
    )
end

struct Vec2D{T} <: FieldVector{2,T}
    x::T
    y::T
end

function random_vec(::Type{VecType}, range) where {VecType}
    dim = length(VecType)
    T = eltype(VecType)
    p = VecType(range[begin] + rand(T) * (range[end] - range[begin]) for _ = 1:dim)
    return p
end

import LinearAlgebra: norm

function wrap(x, side)
    x = rem(x, side)
    if x >= side / 2
        x -= side
    elseif x < -side / 2
        x += side
    end
    return x
end

function fₓ(x::T, y::T, cutoff, side) where {T}
    Δv = wrap.(y - x, side)
    d = norm(Δv)
    if d > cutoff
        fₓ = zero(T)
    else
        fₓ = 2 * (d - cutoff) * (Δv / d)
    end
    return fₓ
end

function forces!(f::Vector{T}, x::Vector{T}, fₓ::F) where {T,F}
    fill!(f, zero(T))
    n = length(x)
    for i = 1:n-1
        for j = i+1:n
            fᵢ = fₓ(i, j, x[i], x[j])
            f[i] += fᵢ
            f[j] -= fᵢ
        end
    end
    return f
end

function md(x0::Vector{T}, v0::Vector{T}, mass, dt, nsteps, isave, forces!) where {T}
    x = copy(x0)
    v = copy(v0)
    a = similar(x0)
    f = similar(x0)
    trajectory = [copy(x0)] # will store the trajectory
    for step = 1:nsteps
        # Compute forces
        forces!(f, x)
        # Accelerations
        @. a = f / mass
        # Update positions
        @. x = x + v * dt + a * dt^2 / 2
        # Update velocities
        @. v = v + a * dt
        # Save if required
        if mod(step, isave) == 0
            println("Saved trajectory at step: ", step)
            push!(trajectory, copy(x))
        end
    end
    return trajectory
end

const side = 300.0
const cutoff = 5.0
trajectory_periodic = md(
    (
        x0 = [random_vec(Vec2D{Float64}, (-50, 50)) for _ = 1:100],
        v0 = [random_vec(Vec2D{Float64}, (-1, 1)) for _ = 1:100],
        mass = [10.0 for _ = 1:100],
        dt = 0.1,
        nsteps = 1000,
        isave = 10,
        forces! = (f, x) -> forces!(f, x, (i, j, p1, p2) -> fₓ(p1, p2, cutoff, side)),
    )...,
)

fig = @gif for (step, x) in pairs(trajectory_periodic)
    scatter([wrap.((p.x, p.y), 100) for p in x], lims = (-60, 60), grid=false)
end
