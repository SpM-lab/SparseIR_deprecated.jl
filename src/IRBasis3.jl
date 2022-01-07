module IRBasis3

import PyCall: pyimport, PyNULL, PyVector

const irbasis3 = PyNULL()
const packaging_version = PyNULL()

function __init__()
    copy!(irbasis3, pyimport("irbasis3"))
    copy!(packaging_version, pyimport("packaging.version"))

    min_irbasis3_version = "3.0a6"
    if packaging_version.parse(irbasis3.__version__) < packaging_version.parse(min_irbasis3_version)
        error("Installed irbasis3 is too old!")
    end
end

@enum Statistics fermion boson
include("exports.jl")
include("kernel.jl")
include("basis.jl")
include("sampling.jl")

end
