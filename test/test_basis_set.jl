using SparseIR
using Test

@testset "basis_set.consistency" begin
    beta = 2
    wmax = 5
    eps = 1e-5

    basis_f_org = FiniteTempBasis(fermion, beta, wmax, eps)
    basis_f, basis_b = finite_temp_bases(beta, wmax, eps, basis_f_org.sve_result)
    smpl_tau_f = TauSampling(basis_f)
    smpl_tau_b = TauSampling(basis_b)
    smpl_wn_f = MatsubaraSampling(basis_f)
    smpl_wn_b = MatsubaraSampling(basis_b)

    bs = FiniteTempBasisSet(beta, wmax, eps; sve_result=basis_f_org.sve_result)
    @test all(smpl_tau_f.sampling_points .== smpl_tau_b.sampling_points)
    @test all(bs.smpl_tau_f.matrix.a .== smpl_tau_f.matrix.a)
    @test all(bs.smpl_tau_b.matrix.a .== smpl_tau_b.matrix.a)
    @test all(bs.smpl_wn_f.matrix.a .== smpl_wn_f.matrix.a)
    @test all(bs.smpl_wn_b.matrix.a .== smpl_wn_b.matrix.a)
end

