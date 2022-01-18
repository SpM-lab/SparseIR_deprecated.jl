using SparseIR
using Test

import PyCall: pyimport, PyNULL, PyVector

sparse_ir = pyimport("sparse_ir")


@testset "kernel.KernelFlat" begin
    lambda_ = 10.0
    kernels = [
        (SparseIR.KernelFFlat, sparse_ir.KernelFFlat),
        (SparseIR.KernelBFlat, sparse_ir.KernelBFlat)
    ]
    for (K, K_py) in kernels
        k = K(lambda_)
        k_py = K_py(lambda_)
        @test k_py(0.1, -0.2) ≈ k(0.1, -0.2)
    end
end