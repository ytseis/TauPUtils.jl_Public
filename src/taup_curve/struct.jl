export TauPCurve

"""
TauPCurve

A curve data of a seismic phase, usually time versus distance computed by `taup curve`.

The properties include: `model`, `phase`, `source_depth`, `receiver_depth`, `description`, `xlabel`, `ylabel`, `x`, `y`.
"""
struct TauPCurve
    model::String
    phase::String
    source_depth::Float64
    receiver_depth::Float64
    description::String
    xlabel::String
    ylabel::String
    x::Vector{Float64}
    y::Vector{Float64}
end

function Base.show(io::IO, curve::TauPCurve)
    hdr_string_len = maximum(length∘string, propertynames(curve))
    # ∘ (\circ) is function composition operator
    indent = 2
    padded_print =
        (name, val) ->
            Base.print(io, "\n", lpad(string(name), hdr_string_len + indent) * ": ", val)
    print(io, "TauPCurve:")
    for field in filter(f -> f ∉ (:x, :y), propertynames(curve))
        padded_print(field, getfield(curve, field))
    end
end

# Get an array of values from an array of TauPCurve structs
function Base.getproperty(curves::AbstractArray{<:TauPCurve}, f::Symbol)
    if f === :phase ||
        f === :source_depth ||
        f === :receiver_depth ||
        f === :description ||
        f === :xlabel ||
        f === :ylabel ||
        f === :x ||
        f === :y
        getfield.(curves, f)
    else
        getfield(curves, f)
    end
end
