export plot_taup_curve!, plot_taup_curve
export plot_traveltime!, plot_traveltime
export plot_phase_diff!, plot_phase_diff

"""
    plot_taup_curve!(ax, curve; kwargs...)

Function to plot a TauPCurve on the given axis.
"""
function plot_taup_curve!(ax, curve; kwargs...)
    xdata = curve.x
    ydata = curve.y
    label = curve.phase

    lines!(ax, xdata, ydata; label=label, kwargs...)
end

"""
    plot_taup_curve!(ax, curves; kwargs...)

Plot multiple TauPCurves on the given axis.
"""
function plot_taup_curve!(ax, curves::Vector{TauPCurve}; kwargs...)
    for curve in curves
        plot_taup_curve!(ax, curve; kwargs...)
    end
end

function _extract_labels(curve::TauPCurve)
    # set labels for axes
    labels = Dict(
        "radian" => "Radian",
        "radian180" => "Radian",
        "degree" => "Distance / °",
        "degree180" => "Distance / °",
        "kilometer" => "Distance / km",
        "kilometer180" => "Distance / km",
        "rayparamrad" => "Ray parameter / (s/rad)",
        "rayparamdeg" => "Ray parameter / (s/°)",
        "rayparamkm" => "Ray parameter / (s/km)",
        "time" => "Time / s",
        "tau" => "Tau",
        "takeoffangle" => "Takeoff angle / °",
        "incidentangle" => "Incident angle / °",
        "turndepth" => "Turn depth / km",
        "amp" => "Amplitude PSv,Sh / m",
        "amppsv" => "Amplitude PSV / m",
        "ampsh" => "Amplitude Sh / m",
        "geospread" => "Geometrical spreading / km⁻¹",
        "refltran" => "Energy flux factor reflection/transmisson coef. Psv,Sh",
        "refltranpsv" => "Energy flux factor reflection/transmisson coef. Psv",
        "refltransh" => "Energy flux factor reflection/transmisson coef. Sh",
        "index" => "Index",
        "tstar" => "tstar",
        "attenuation" => "Attenuation",
        "theta" => "Theta",
        "energygeospread" => "Energy geometric spreading / km⁻²",
        "pathlength" => "Path length / km",
        "radiation" => "PSvSh Radiation pattern",
        "radiationpsv" => "PSv Radiation pattern",
        "radiationsh" => "Sh Radiation pattern",
    )

    xlabel = labels[curve.xlabel]
    ylabel = labels[curve.ylabel]

    return xlabel, ylabel
end

"""
    plot_taup_curve(curve; figure=nothing, axis=nothing, kwargs...)

Function to plot a TauPCurve. figure and axis can be customized via keyword arguments like `figure=(; size=(800,600))` or `axis=(; xlabel="Custom X", ylabel="Custom Y")`.
"""
function plot_taup_curve(curve; figure=nothing, axis=nothing, kwargs...)
    xlabel, ylabel = _extract_labels(curve)

    title = "$(basename(curve.model)) (h=$(curve.source_depth) km)"

    fig = if figure === nothing
        Figure();
    else
        Figure(; figure...);
    end
    ax = if axis === nothing
        Axis(fig[1, 1]; xlabel=xlabel, ylabel=ylabel, title=title)
    else
        Axis(fig[1, 1]; axis...)
    end
    plot_taup_curve!(ax, curve; kwargs...)
    axislegend(unique=true)
    fig
end

function plot_taup_curve(curves::Vector{TauPCurve}; figure=nothing, axis=nothing, kwargs...)
    xlabel, ylabel = _extract_labels(curves[1])
    title = "$(basename(curves[1].model)) (h=$(curves[1].source_depth) km)"

    fig = if figure === nothing
        Figure();
    else
        Figure(; figure...);
    end
    ax = if axis === nothing
        Axis(fig[1, 1]; xlabel=xlabel, ylabel=ylabel, title=title)
    else
        Axis(fig[1, 1]; axis...)
    end
    plot_taup_curve!(ax, curves; kwargs...)
    axislegend(unique=true)
    fig
end

function plot_traveltime(
    phase::String;
    depth=0,
    model="ak135",
    km=false,
    figure=(;),
    axis=(; ylabel=km ? "Distance / km" : "Distance / °", title="$phase (h=$(depth) km)"),
    lines=(; label=phase, linestyle=:solid),
)
    ylabel = km ? "Distance / km" : "Distance / °"
    title = "$phase (h=$(depth) km)"

    fig = Figure(; figure...)
    ax = Axis(fig[1, 1]; xlabel="Time / s", ylabel=ylabel, title=title, axis...)
    pl = plot_traveltime!(ax, phase; depth=depth, model=model, km=km, lines=lines, axis=axis)
    axislegend(ax, unique=true)
    Makie.FigureAxisPlot(fig, ax, pl)
end

function plot_traveltime!(
    ax,
    phase::String;
    depth=0,
    model="ak135",
    km=false,
    lines=(; label=phase, linestyle=:solid),
    axis=(; ylabel=km ? "Distance / km" : "Distance / °", title="$phase (h=$(depth) km)"),
)
    curve = taup_curve(
        phase; depth=depth, model=model, y=km ? "kilometer" : "degree", x="time"
    )
    plot_taup_curve!(ax, curve; lines...)
end

### designate json path directory
function plot_traveltime!(
    ax;
    json=nothing,
    phase=nothing,
    depth=0,
    model="ak135",
    km=false,
    lines=(; linestyle=:solid),
)
    curve = if json !== nothing
        parse_taup_curve_json(json)
    elseif phase !== nothing
        taup_curve(phase; depth=depth, model=model, y=km ? "kilometer" : "degree", x="time")
    else
        error("Either `json` or `phase` must be specified")
    end

    lines_kw = merge((; label=curve.phase), lines)
    plot_taup_curve!(ax, curve; lines_kw...)
end

function plot_traveltime(;
    json=nothing,
    phase=nothing,
    depth=0,
    model="ak135",
    km=false,
    figure=(;),
    axis=(; ylabel=km ? "Distance / km" : "Distance / °"),
    lines=(; linestyle=:solid),
)
    ylabel = km ? "Distance / km" : "Distance / °"
    title = json !== nothing ? basename(json) : "$phase (h=$(depth) km)"

    fig = Figure(; figure...)
    ax = Axis(fig[1, 1]; xlabel="Time / s", ylabel=ylabel, title=title, axis...)
    pl = plot_traveltime!(ax; json=json, phase=phase, depth=depth, model=model, km=km, lines=lines, axis=axis)
    axislegend(ax, unique=true)
    Makie.FigureAxisPlot(fig, ax, pl)
end

"""
    plot_phase_diff!(ax, phase1::String, phase2::String; kwargs...)
    plot_phase_diff(phase1::String, phase2::String; kwargs...)

Plot phase differences for all overlapping branch combinations.
"""
function plot_phase_diff!(
    ax,
    phase1::String,
    phase2::String;
    depth=0,
    model="ak135",
    km=false,
    lines=(; label="$(phase1)-$(phase2)", linestyle=:solid),
)
    results = phase_diff(phase1, phase2; depth=depth, model=model, km=km)

    for result in results
        lines!(ax, result.dtime, result.ddeg; lines...)
    end

    return ax
end

function plot_phase_diff(
    phase1::String,
    phase2::String;
    depth=0,
    model="ak135",
    km=false,
    figure=(;),
    axis=(;
        xlabel="Lag time / s",
        ylabel=km ? "Interstation distance / km" : "Interstation distance / °",
        title="$phase1 - $phase2 (h=$(depth) km)",
    ),
    lines=(; label="$(phase1)-$(phase2)", linestyle=:solid),
)
    fig = Figure(; figure...)
    ax = Axis(fig[1, 1]; axis...)

    plot_phase_diff!(
        ax,
        phase1,
        phase2;
        depth=depth,
        model=model,
        km=km,
        lines=lines,
    )

    Legend(fig[1, 2], ax, unique=true)

    return fig
end
