
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


# clf()
xi = [-5.0f0, -5.0f0]

X1 = integrate(xi, 0.0f0; totalTimeStep = 4400.0f0);
X2 = integrate(xi, 1.0f0; totalTimeStep = 4300.0f0);
X12 = stable_switching(xi; totalTimeStep = 10000.0f0);


custom_linewidth = 8
custom_font = 28


fig, (ax1, ax2) = plt.subplots(figsize=(10, 10), ncols=2, nrows=1)

a1_traj = ax1.plot(getindex.(X1, 1), getindex.(X1, 2), color="red", linewidth=custom_linewidth, label=L"A_1")
a1_final = ax1.scatter(X1[end][1], X1[end][2], marker="*" , color="red", s=800, label=L"A_1" * " Final state", zorder=4)
a2_traj = ax1.plot(getindex.(X2, 1), getindex.(X2, 2), color="blue", "--", linewidth=custom_linewidth, label=L"A_2")
a2_final = ax1.scatter(X2[end][1], X2[end][2], marker="*", color="blue", s=800, label=L"A_2" * " Final state", zorder=4)
ax1.set_xlabel(L"x_1", fontsize=28)
ax1.set_ylabel(L"x_2" , fontsize=28)
ax1.tick_params(axis="both", labelsize=custom_font)
# handles, labels = ax1.get_legend_handles_labels()
# fig.legend(handles, labels, loc="upper center", fontsize=22, ncol=4)


for i in 1:2:length(X12)
    ax2.plot(getindex.(X12[i], 1), getindex.(X12[i], 2), color="red", linewidth=custom_linewidth)
end

for i in 2:2:length(X12)
    ax2.plot(getindex.(X12[i], 1), getindex.(X12[i], 2), color="blue",  "--", linewidth=custom_linewidth)
end

a1_a2_final = ax2.scatter(X12[end][end][1], X12[end][end][2], marker="*", color="black", s=600, label="Final state", zorder=4)
ax2.set_xlabel(L"x_1", fontsize=28)
ax2.set_ylabel(L"x_2" , fontsize=28)
ax2.tick_params(axis="both", labelsize=custom_font)


handles, labels = ax1.get_legend_handles_labels()
fig.legend(handles, labels, bbox_to_anchor=(0.7, 0.97), fontsize=22, ncol=4)

handles, labels = ax2.get_legend_handles_labels()
fig.legend(handles, labels, bbox_to_anchor=(0.9, 0.97), fontsize=22, ncol=1)
