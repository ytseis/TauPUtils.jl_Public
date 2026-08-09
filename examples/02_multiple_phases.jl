"""
Example 2: Multiple Phases

Compare travel time curves for different seismic phases.
"""

using TauPUtils
using CairoMakie

# Define phases to plot
phases = ["P", "S", "PP", "SS", "PcP", "ScS"]
colors = [:red, :blue, :orange, :green, :purple, :brown]

# Create figure
fig = Figure(; size=(1000, 700))
ax = Axis(
    fig[1, 1];
    xlabel="Distance / °",
    ylabel="Time / s",
    title="Travel Time Curves for Multiple Phases (iasp91, h=0 km)",
)

# Plot each phase
for (phase, color) in zip(phases, colors)
    try
        curve = taup_curve(phase; model="iasp91", depth=0.0)
        plot_taup_curve!(ax, curve; color=color, linewidth=2, label=phase)
    catch e
        @warn "Failed to generate curve for phase: $phase"
    end
end

axislegend(ax; position=:rb)
save("multiple_phases.png", fig)
println("Saved: multiple_phases.png")

fig
