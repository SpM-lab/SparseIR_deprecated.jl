module SparseIR

import PyCall: pyimport, PyNULL, PyVector, PyObject

const irbasis3 = PyNULL()

function __init__()
    try
        copy!(irbasis3, pyimport("irbasis3"))
    catch e
        println()
        println("******************************************************************************")
        println(
            "Failed to import irbasis3. Please install a proper version of irbasis3 manually, or " *
            "run julia -e ****"
        )
        println("******************************************************************************")
        println()
        throw(e)
    end
    pkg_resources = pyimport("pkg_resources") # SparseIR requires pkg_resources

    if pkg_resources.parse_version(irbasis3.__version__) < pkg_resources.parse_version(min_irbasis3_version)
        error("irbasis3 $(irbasis3.__version__) found, but required irbasis3>=$(min_irbasis3_version)!")
    end
end

include("backend.jl")
include("types.jl")
include("kernel.jl")
include("poly.jl")
include("basis.jl")
include("sampling.jl")
include("exports.jl")

end
