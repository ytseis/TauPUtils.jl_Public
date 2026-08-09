export plot_discontinuities!, plot_taup_path!, plot_taup_path

"""
    plot_discontinuities!(ax, discontinuity_depths; earth_radius_km=EARTH_R_MAJOR_WGS84_KM, kwargs...)

Plot discontinuity circles on a polar axis.
"""
function plot_discontinuities!(
    ax,
    discontinuity_depths::AbstractVector{<:Real};
    earth_radius_km=EARTH_R_MAJOR_WGS84_KM,
    kwargs...,
)
    for depth in discontinuity_depths
        lines!(ax, range(0, 2pi, length=100), x -> earth_radius_km - depth; kwargs...)
    end
end

"""
    plot_taup_path!(ax, path; arrival_index=:all, kwargs...)

Plot raypaths from a `TauPPath` object on the given polar axis.
"""
function plot_taup_path!(ax, path::TauPPath; arrival_index=:all, kwargs...)
    indices = arrival_index == :all ? eachindex(path.arrivals) : arrival_index
    line_attributes = merge((; color=:black), kwargs)
    plot_object = nothing

    for arrival in path.arrivals[indices]
        for segment in arrival.path
            plot_object = lines!(
                ax,
                deg2rad.(segment.degree),
                segment.depth;
                label=segment.name,
                line_attributes...,
            )
        end
    end

    return plot_object
end

"""
    plot_taup_path(path; figure=(; size=(600, 600)), axis=(; theta_0=pi/2), discontinuity_depths=[0, 410, 660, 2891, 5150], kwargs...)

Plot a `TauPPath` on a new polar figure.
"""
function plot_taup_path(
    path::TauPPath;
    arrival_index=:all,
    figure=(; size=(600, 600)),
    axis=(; theta_0=pi / 2),
    discontinuity_depths=[0, 410, 660, 2891, 5150],
    discontinuity_lines=(; color=:black, linewidth=1),
    kwargs...,
)
    fig = Figure(; figure...)
    ax = PolarAxis(fig[1, 1]; axis...)

    hidedecorations!(ax)
    hidespines!(ax)
    plot_discontinuities!(ax, discontinuity_depths; discontinuity_lines...)
    plot_object = plot_taup_path!(ax, path; arrival_index=arrival_index, kwargs...)
    return Makie.FigureAxisPlot(fig, ax, plot_object)
end
