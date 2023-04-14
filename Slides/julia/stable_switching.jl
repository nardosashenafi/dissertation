
using PyPlot

const Δt = 0.001f0
const totalTimeStep = 4200.0f0

function oneStep(x, ρ::T) where {T<:Real}
    A1 = [0.0f0 -1.0f0; 2.0f0 0.0f0]
    A2 = [0.0f0 -2.0f0; 1.0f0 0.0f0]

    dx = (1.0f0 - ρ)*A1*x + ρ*A2*x
    return x + dx*Δt
end

function integrate(xi, ρ::T; totalTimeStep = totalTimeStep) where {T<:Real}
    X = Vector{Vector{T}}()

    push!(X, xi)

    for i in 1:totalTimeStep
        x     = oneStep(X[end], ρ)
        push!(X, x)
    end

    return X
end

function stable_switching(xi::Vector{T}, ; totalTimeStep = totalTimeStep) where {T<:Real}
    X = Vector{Vector{Vector{T}}}()

    push!(X, [xi])
    ρ_prev = 0.0

    for i in 1:totalTimeStep
        if prod(X[end][end]) <= 0
            ρ = 0.0f0
        else
            ρ = 1.0f0
        end
        x     = oneStep(X[end][end], ρ)

        if ρ != ρ_prev 
            push!(X, [x])
            ρ_prev = ρ
        else
            push!(X[end], x)
        end
    end
    return X

end


clf()
xi = [-5.0f0, -5.0f0]

X1 = integrate(xi, 0.0f0; totalTimeStep = 4400.0f0);
X2 = integrate(xi, 1.0f0; totalTimeStep = 4400.0f0);
X12 = stable_switching(xi; totalTimeStep = 3500.0f0);


custom_linewidth = 3
custom_font = 28

# subplot(1, 2, 1)
plot(getindex.(X1, 1), getindex.(X1, 2), color="red", linewidth=custom_linewidth, label=L"A_1")
scatter(X1[end][1], X1[end][2], marker="*" , color="red", s=150)
plot(getindex.(X2, 1), getindex.(X2, 2), color="blue", "--", linewidth=custom_linewidth, label=L"A_2")
scatter(X2[end][1], X2[end][2], marker="*", color="blue", s=150)
legend(loc="upper right", fontsize=22)
tick_params(axis="both", labelsize=custom_font)

# subplot(1, 2, 2)
for i in 1:2:length(X12)
    plot(getindex.(X12[i], 1), getindex.(X12[i], 2), color="red", linewidth=custom_linewidth)
end

for i in 2:2:length(X12)
    plot(getindex.(X12[i], 1), getindex.(X12[i], 2), color="blue",  "--", linewidth=custom_linewidth)
end

scatter(X12[end][end][1], X12[end][end][2], marker="*", color="black", s=150)
tick_params(axis="both", labelsize=custom_font)