using SparseIR
using Test
using Random

@testset "spr.transform" begin
    for stat in [fermion, boson]
        beta = 1e+4
        wmax = 1.0
        eps = 2e-8
        basis = FiniteTempBasis(stat, beta, wmax, eps)
        spr = SparsePoleRepresentation(basis)

        Random.seed!(4711)

        num_poles = 10
        poles = wmax * (2 * rand(num_poles) .- 1)
        coeffs = 2 * rand(num_poles) .- 1
        @assert maximum(abs.(poles)) <= wmax

        Gl = to_IR(SparsePoleRepresentation(basis, poles), coeffs)

        g_spr = from_IR(spr, Gl)

        # Comparison on Matsubara frequencies
        smpl = MatsubaraSampling(basis)
        smpl_for_spr = MatsubaraSampling(spr, smpl.sampling_points)
        giv = evaluate(smpl_for_spr, g_spr)
        giv_ref = evaluate(smpl, Gl; axis=0)
        @test isapprox(giv, giv_ref; atol=300 * eps, rtol=0)

        # Comparison on tau
        smpl_tau = TauSampling(basis)
        gtau = evaluate(smpl_tau, Gl)
        smpl_tau_for_spr = TauSampling(spr)
        gtau2 = evaluate(smpl_tau_for_spr, g_spr)

        @test isapprox(gtau, gtau2; atol=300 * eps, rtol=0)
    end
end
