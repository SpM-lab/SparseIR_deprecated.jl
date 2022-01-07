using IRBasis3
using Test


@testset "kernel.flat" begin
    irbasis3 = pyimport("irbasis3")
    # Write your tests here.
    lambda = 100.0
    kf = IRBasis3.KernelFFlat(lambda_)
    kf_py = irbasis3.KernelFFlat(lambda_)
end
