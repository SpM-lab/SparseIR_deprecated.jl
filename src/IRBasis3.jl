module IRBasis3

import PyCall: pyimport, PyNULL, PyVector, PyObject

const irbasis3 = PyNULL()

function __init__()
    copy!(irbasis3, pyimport("irbasis3"))
    pkg_resources = pyimport("pkg_resources") # irbasis3 requires pkg_resources

    min_irbasis3_version = "3.0a6"
    if pkg_resources.parse_version(irbasis3.__version__) < pkg_resources.parse_version(min_irbasis3_version)
        error("Installed irbasis3 is too old!")
    end
end

@enum Statistics fermion boson
include("exports.jl")
include("kernel.jl")
include("basis.jl")
include("sampling.jl")

end
