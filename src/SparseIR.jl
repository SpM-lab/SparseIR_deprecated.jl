module SparseIR

import PyCall: pyimport, PyNULL, PyVector, PyObject

const sparse_ir = PyNULL()
const pyspr = PyNULL()
const pyaugment = PyNULL()

function __init__()
    copy!(sparse_ir, pyimport_conda("sparse_ir", "sparse-ir", "spm-lab"))
    copy!(pyspr, pyimport("sparse_ir.spr"))
    copy!(pyaugment, pyimport("sparse_ir.augment"))
    check_version_sparse_ir()
end

include("backend.jl")
include("types.jl")
include("kernel.jl")
include("poly.jl")
include("basis.jl")
include("augment.jl")
include("composite.jl")
include("sampling.jl")
include("spr.jl")
include("exports.jl")

end
