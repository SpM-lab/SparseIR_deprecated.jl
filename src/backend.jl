using PyCall
import VersionParsing: vparse

const min_sparse_ir_version = "0.2"

#=
function install_packages(packages::Vector{String})
    try
        pip = pyimport("pip")
    catch
        get_pip = joinpath(dirname(@__FILE__), "get-pip.py")
        download("https://bootstrap.pypa.io/get-pip.py", get_pip)
        run(`$(PyCall.python) $get_pip --user`)
    end
    
    sys = pyimport("sys")
    subprocess = pyimport("subprocess")
    subprocess.check_call(
        [sys.executable, "-m", "pip", "install", "--user", packages...])
end


function install_sparse_ir()
    need_to_install = false
    try
        # Try to import sparse_ir
        sparse_ir = pyimport("sparse_ir")
        pkg_resources = pyimport("pkg_resources")
        if pkg_resources.parse_version(sparse_ir.__version__) <
            pkg_resources.parse_version(min_sparse_ir_version)
            need_to_install = true
        end
    catch e
        need_to_install = true
    end
    
    if need_to_install
        install_packages(["sparse_ir>=$(min_sparse_ir_version)"])
    end
end
=#

function check_version_sparse_ir()::Bool
    try
        # Try to import sparse_ir
        sparse_ir = pyimport("sparse_ir")
        if vparse(sparse_ir.__version__) < vparse(min_sparse_ir_version)
            return false
        end
    catch e
        return false
    end
    true
end