"""
Example 1: Basic Usage

Generate and plot a simple travel time curve for the P phase.
"""

using TauPUtils
using CairoMakie

# Generate travel time curve for P phase
# Default parameters: model="iasp91", depth=0 km
curve = taup_curve("P")

# Display curve information
println(curve)

# Plot the curve
fig = plot_taup_curve(curve, color=:black)
save("p_wave_curve.png", fig)
println("Saved: p_wave_curve.png")

# Generate curve with specific parameters
curve_deep = taup_curve(
    "P";
    model="ak135",
    depth=100.0,  # 100 km source depth
    x="degree",
    y="time",
)

fig2 = plot_taup_curve(curve_deep)
save("p_wave_deep_source.png", fig2)
println("Saved: p_wave_deep_source.png")
