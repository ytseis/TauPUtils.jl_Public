"""
Example 5: Advanced Axis Options

Demonstrate various axis types available in TauP curve plotting.
"""

using TauPUtils
using CairoMakie

phase = "P"
depth = 100.0  # km
model = "iasp91"

fig = Figure(; size=(1400, 1000))

# 1. Time vs Distance (default)
ax1 = Axis(fig[1, 1]; xlabel="Distance / °", ylabel="Time / s", title="Time vs Distance")
curve1 = taup_curve(phase; model=model, depth=depth, x="degree", y="time")
plot_taup_curve!(ax1, curve1; color=:blue, linewidth=2)

# 2. Ray Parameter vs Distance
ax2 = Axis(
    fig[1, 2]; xlabel="Distance / °", ylabel="Ray Parameter / (s/°)", title="Ray Parameter"
)
curve2 = taup_curve(phase; model=model, depth=depth, x="degree", y="rayparamdeg")
plot_taup_curve!(ax2, curve2; color=:red, linewidth=2)

# 3. Takeoff Angle vs Distance
ax3 = Axis(
    fig[2, 1]; xlabel="Distance / °", ylabel="Takeoff Angle / °", title="Takeoff Angle"
)
curve3 = taup_curve(phase; model=model, depth=depth, x="degree", y="takeoffangle")
plot_taup_curve!(ax3, curve3; color=:green, linewidth=2)

# 4. Incident Angle vs Distance
ax4 = Axis(
    fig[2, 2]; xlabel="Distance / °", ylabel="Incident Angle / °", title="Incident Angle"
)
curve4 = taup_curve(phase; model=model, depth=depth, x="degree", y="incidentangle")
plot_taup_curve!(ax4, curve4; color=:purple, linewidth=2)

# 5. Time vs Distance (km)
ax5 = Axis(
    fig[3, 1]; xlabel="Distance / km", ylabel="Time / s", title="Time vs Distance (km)"
)
curve5 = taup_curve(phase; model=model, depth=depth, x="kilometer", y="time")
plot_taup_curve!(ax5, curve5; color=:orange, linewidth=2)

# 6. Path Length vs Distance
ax6 = Axis(fig[3, 2]; xlabel="Distance / °", ylabel="Path Length / km", title="Path Length")
curve6 = taup_curve(phase; model=model, depth=depth, x="degree", y="pathlength")
plot_taup_curve!(ax6, curve6; color=:brown, linewidth=2)

save("advanced_axes.png", fig)
println("Saved: advanced_axes.png")

fig
