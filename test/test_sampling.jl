using SparseIR
using Test

@testset "sampling.XSampling" begin
    beta = 1e+4
    wmax = 1.
    eps = 2e-8

    poles = wmax * Float64[-.999, -.01, .5]
    coeff = Float64[0.8, -.2, 0.5]
    for XSampling in [TauSampling, MatsubaraSampling]
        for stat in [fermion, boson]
            basis = FiniteTempBasis(stat, beta, wmax, eps)
            rhol = basis.v(poles) * coeff
            gl = - basis.s .* rhol
    
            smpl = XSampling(basis)
            gtau = evaluate(smpl, gl)
            gl_reconst = fit(smpl, gtau)

            @test isapprox(gl, gl_reconst, rtol=0, atol=smpl.cond*eps*maximum(abs.(gl)) )
        end
    end
end

@testset "sampling.return_types" begin
    @test Base.return_types(fit, (MatsubaraSampling, Array{Float64,3})) == [Array{ComplexF64,3}]
    @test Base.return_types(fit, (MatsubaraSampling, Array{ComplexF64,3})) == [Array{ComplexF64,3}]
    @test Base.return_types(fit, (TauSampling, Array{Float64,3})) == [Array{ComplexF64,3}]
    @test Base.return_types(fit, (TauSampling, Array{ComplexF64,3})) == [Array{ComplexF64,3}]
end