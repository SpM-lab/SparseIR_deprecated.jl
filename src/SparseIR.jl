module SparseIR

import PyCall: pyimport, PyNULL, PyVector, PyObject

const sparse_ir = PyNULL()

function __init__()
    copy!(sparse_ir, pyimport_conda("sparse_ir", "sparse-ir", "h.shinaoka"))
    check_version_sparse_ir()
end

include("backend.jl")
include("types.jl")
include("kernel.jl")
include("poly.jl")
include("basis.jl")
include("sampling.jl")
include("exports.jl")

end
