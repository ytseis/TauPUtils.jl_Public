export RayPathSegment, RayArrival, TauPPath

"""
RayPathSegment

A path segment of a seismic phase returned by `taup path`.
"""
struct RayPathSegment
    name::String
    wavetype::String
    degree::Vector{Float64}
    depth::Vector{Float64}
    time::Vector{Float64}
end

"""
RayArrival

An arrival returned by `taup path`, including path segments.
"""
struct RayArrival
    phase::String
    distdeg::Float64
    time::Float64
    rayparam::Float64
    path::Vector{RayPathSegment}
end

"""
TauPPath

Raypath data returned by `taup path`.
"""
struct TauPPath
    model::String
    source_depths::Vector{Float64}
    receiver_depths::Vector{Float64}
    phases::Vector{String}
    arrivals::Vector{RayArrival}
end

function Base.show(io::IO, path::TauPPath)
    hdr_string_len = maximum(length∘string, propertynames(path))
    indent = 2
    padded_print =
        (name, val) ->
            Base.print(io, "\n", lpad(string(name), hdr_string_len + indent) * ": ", val)

    print(io, "TauPPath:")
    padded_print(:model, path.model)
    padded_print(:source_depths, path.source_depths)
    padded_print(:receiver_depths, path.receiver_depths)
    padded_print(:phases, path.phases)
    padded_print(:arrivals, "$(length(path.arrivals)) arrivals")
end
