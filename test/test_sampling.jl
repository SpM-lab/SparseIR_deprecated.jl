using SparseIR
using Test

@testset "sampling.moveaxis" begin
    shape = (2, 3, 4)
    x = reshape(collect(1:prod(shape)), shape)
    ref = zeros(Int64, 3, 4, 2)
    for k in 1:4
        for j in 1:3
            for i in 1:2
                ref[j, k, i] = x[i, j, k]
            end
        end
    end
    res = SparseIR._move_axis(x, 1, 3)
    @test all(res .== ref)
end

@testset "sampling._matop_along_axis" begin
    op = reshape(collect(1:6), (3, 2))
    x = reshape(collect(1:4), (2, 2))
    res = SparseIR._matop_along_axis(op, x, 2)
    ref = zeros(Int64, (2, 3))
    for j in 1:2
        for i in 1:3
            for k in 1:2
                ref[j, i] += op[i, k] * x[j, k]
            end
        end
    end
    @test all(res .== ref)
end

@testset "sampling.XSampling" begin
    beta = 1e+4
    wmax = 1.0
    eps = 2e-8

    poles = wmax * Float64[-0.999, -0.01, 0.5]
    coeff = Float64[0.8, -0.2, 0.5]
    for XSampling in [TauSampling, MatsubaraSampling]
        for stat in [fermion, boson]
            basis = FiniteTempBasis(stat, beta, wmax, eps)
            rhol = basis.v(poles) * coeff
            gl = -basis.s .* rhol

            smpl = XSampling(basis)
            gtau = evaluate(smpl, gl)
            gl_reconst = fit(smpl, gtau)

            @test isapprox(gl, gl_reconst; rtol=0, atol=smpl.cond * eps * maximum(abs.(gl)))
        end
    end
end

@testset "sampling.return_types" begin
    @test Base.return_types(fit, (MatsubaraSampling, Array{Float64,3})) ==
          [Array{ComplexF64,3}]
    @test Base.return_types(fit, (MatsubaraSampling, Array{ComplexF64,3})) ==
          [Array{ComplexF64,3}]
    @test Base.return_types(fit, (TauSampling, Array{Float64,3})) == [Array{ComplexF64,3}]
    @test Base.return_types(fit, (TauSampling, Array{ComplexF64,3})) ==
          [Array{ComplexF64,3}]
end
