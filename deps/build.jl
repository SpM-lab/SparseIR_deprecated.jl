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

println("Checking if required Python libraries are installed...")
install_packages(["setuptools"])

correct_irbasis3_exists = false
try
    # Try to import irbasis3
    irbasis3 = pyimport("irbasis3")
    pkg_resources = pyimport("pkg_resources")
    if pkg_resources.parse_version(irbasis3.__version__) <
        pkg_resources.parse_version(min_irbasis3_version)
        println("Installed irbasis3 is too old!")
    end
catch e
    println("Failed to import irbasis3. May be not installed!")
    println(e)
end

println("Trying to install irbasis3 using pip...")

install_packages(["irbasis3>=$(min_irbasis3_version)"])