module TauPUtils

using JSON
using CairoMakie
using Interpolations

include("taup_curve/struct.jl")
include("taup_curve/taup_curve.jl")
include("taup_curve/plot_taup_curve.jl")
include("taup_path/struct.jl")
include("taup_path/taup_path.jl")
include("taup_path/plot_taup_path.jl")

end # module TauPUtils
