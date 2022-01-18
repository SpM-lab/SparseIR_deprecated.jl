module SparseIR

import PyCall: pyimport, PyNULL, PyVector, PyObject

const sparse_ir = PyNULL()

function __init__()
    try
        copy!(sparse_ir, pyimport("sparse_ir"))
    catch e
        println()
        println("******************************************************************************")
        println(
            "Failed to import sparse-ir. Please install a proper version of sparse-ir manually!"
        )
        println("******************************************************************************")
        println()
    end
    if !check_version_sparse_ir()
        println("Upgrade sparse-ir!")
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
