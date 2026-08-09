"""
Example 3: Source Depth Comparison

Compare travel time curves for different source depths.
"""

using TauPUtils
using CairoMakie

# Define source depths to compare
depths = [0.0, 50.0, 100.0, 200.0, 400.0, 600.0]  # km
phase = "P"

# Create figure with subplots
fig = Figure(; size=(1200, 800))

# Plot 1: All depths on same plot
ax1 = Axis(
    fig[1, 1];
    xlabel="Distance / °",
    ylabel="Time / s",
    title="P-wave Travel Times at Different Source Depths",
)

colormap = :viridis
colors = cgrad(colormap, length(depths); categorical=true)

for (i, depth) in enumerate(depths)
    curve = taup_curve(phase; model="iasp91", depth=depth)
    plot_taup_curve!(ax1, curve; color=colors[i], linewidth=2, label="$(Int(depth)) km")
end

axislegend(ax1; position=:rb, framevisible=true)

# Plot 2: Depth vs takeoff angle
ax2 = Axis(
    fig[1, 2];
    xlabel="Distance / °",
    ylabel="Takeoff Angle / °",
    title="P-wave Takeoff Angles",
)

for (i, depth) in enumerate(depths)
    curve = taup_curve(phase; model="iasp91", depth=depth, y="takeoffangle")
    plot_taup_curve!(ax2, curve; color=colors[i], linewidth=2, label="$(Int(depth)) km")
end

save("depth_comparison.png", fig)
println("Saved: depth_comparison.png")

fig
