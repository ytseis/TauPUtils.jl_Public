"""
Example 4: Velocity Model Comparison

Compare travel time curves for different velocity models.
"""

using TauPUtils
using CairoMakie

# Compare different velocity models
models = ["iasp91", "prem", "ak135"]
phase = "P"
depth = 50.0  # km

fig = Figure(; size=(1200, 800))

# Subplot 1: P-wave
ax1 = Axis(
    fig[1, 1];
    xlabel="Distance / °",
    ylabel="Time / s",
    title="P-wave: Model Comparison (h=50 km)",
)

colors = [:red, :blue, :green]
for (model, color) in zip(models, colors)
    curve = taup_curve("P"; model=model, depth=depth)
    plot_taup_curve!(ax1, curve; color=color, linewidth=2, label=model)
end
axislegend(ax1; position=:rb)

# Subplot 2: S-wave
ax2 = Axis(
    fig[1, 2];
    xlabel="Distance / °",
    ylabel="Time / s",
    title="S-wave: Model Comparison (h=50 km)",
)

for (model, color) in zip(models, colors)
    curve = taup_curve("S"; model=model, depth=depth)
    plot_taup_curve!(ax2, curve; color=color, linewidth=2, label=model)
end
axislegend(ax2; position=:rb)

# Subplot 3: Ray parameter
ax3 = Axis(
    fig[2, 1];
    xlabel="Distance / °",
    ylabel="Ray Parameter / (s/°)",
    title="P-wave Ray Parameter",
)

for (model, color) in zip(models, colors)
    curve = taup_curve("P"; model=model, depth=depth, y="rayparamdeg")
    plot_taup_curve!(ax3, curve; color=color, linewidth=2, label=model)
end
axislegend(ax3; position=:rt)

# Subplot 4: Takeoff angle
ax4 = Axis(
    fig[2, 2];
    xlabel="Distance / °",
    ylabel="Takeoff Angle / °",
    title="P-wave Takeoff Angle",
)

for (model, color) in zip(models, colors)
    curve = taup_curve("P"; model=model, depth=depth, y="takeoffangle")
    plot_taup_curve!(ax4, curve; color=color, linewidth=2, label=model)
end
axislegend(ax4; position=:rb)

save("model_comparison.png", fig)
println("Saved: model_comparison.png")

fig
