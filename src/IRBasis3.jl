module IRBasis3

import PyCall: pyimport, PyNULL, PyVector

const irbasis3 = PyNULL()
const packaging = PyNULL()

function __init__()
    copy!(irbasis3, pyimport("irbasis3"))
    copy!(packaging, pyimport("packaging"))

    min_irbasis3_version = "3.0a6"
    if packaging.parse(irbasis3.__version__) < packaging.parse(min_irbasis3_version)
        error("Installed irbasis3 is too old!")
    end
end


@enum Statistics fermion boson
include("kernel.jl")
include("basis.jl")
include("sampling.jl")

end
