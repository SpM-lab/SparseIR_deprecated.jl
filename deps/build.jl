# See discussions at https://gist.github.com/Luthaf/368a23981c8ec095c3eb
using PyCall

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
        [sys.executable, "-m", "pip", "install", "--user", "--upgrade", packages...])
end

include("../src/backend.jl")

function install_irbasis3()
    @info "Checking if required Python libraries are installed..."
    install_packages(["setuptools"])
    
    correct_irbasis3_exists = true
    try
        # Try to import irbasis3
        irbasis3 = pyimport("irbasis3")
        pkg_resources = pyimport("pkg_resources")
        if pkg_resources.parse_version(irbasis3.__version__) <
            pkg_resources.parse_version(min_irbasis3_version)
            @info "Installed irbasis3 is too old!"
            correct_irbasis3_exists = false
        end
    catch e
        @info "Failed to import irbasis3!"
        correct_irbasis3_exists = false
    end
    
    if !correct_irbasis3_exists
        @info "Installing irbasis3 using pip..."
        install_packages(["irbasis3>=$(min_irbasis3_version)"])
    end
end

if "INSTALL_IRBASIS3" ∈ keys(ENV)
   install_irbasis3()
end