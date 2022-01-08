using IRBasis3
using Test

import PyCall: pyimport, PyNULL, PyVector

irbasis3 = pyimport("irbasis3")


@testset "kernel.KernelFlat" begin
    lambda_ = 10.0
    kernels = [
        (IRBasis3.KernelFFlat, irbasis3.KernelFFlat),
        (IRBasis3.KernelBFlat, irbasis3.KernelBFlat)
    ]
    for (K, K_py) in kernels
        k = K(lambda_)
        k_py = K_py(lambda_)
        @test k_py(0.1, -0.2) ≈ k(0.1, -0.2)
    end
end