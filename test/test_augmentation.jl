using SparseIR
using Test

import PyCall: pyimport, PyNULL, PyVector
import LegendrePolynomials: Pl

sparse_ir = pyimport("sparse_ir")

@testset "augment.LegendreBasis" begin
    for stat in [fermion, boson]
        beta = 10.0
        Nl = 100
        cl = sqrt.(2 .* collect(0:Nl-1) .+ 1)
        basis = SparseIR.LegendreBasis(stat, beta, Nl, cl=cl)

        tau = Float64[0, 0.1*beta, 0.4*beta, beta]
        uval = basis.u(tau)
 
        ref = Matrix{Float64}(undef, Nl, length(tau))
        for l in 0:Nl-1
            x = @. 2 * tau/beta - 1.
            ref[l+1, :] = cl[l+1] .* (sqrt(2*l+1)/beta) * Pl.(x, l)
        end
        @test isapprox(uval, ref)

        sign = statistics_sign(stat)

        # G(iv) = 1/(iv-pole)
        # G(tau) = -e^{-tau*pole}/(1 + e^{-beta*pole}) [F]
        #        = -e^{-tau*pole}/(1 - e^{-beta*pole}) [B]
        pole = 1.0
        tau_smpl = TauSampling(basis)
        gtau = -exp.(-tau_smpl.sampling_points .* pole)./(1 - sign * exp(-beta * pole))
        gl_from_tau = fit(tau_smpl, gtau)

        matsu_smpl = MatsubaraSampling(basis)
        giv = 1 ./ ((im*π/beta) .* matsu_smpl.sampling_points .- pole)
        gl_from_matsu = fit(matsu_smpl, giv)
    
        @test isapprox(gl_from_tau, gl_from_matsu, atol=1e-10*maximum(abs.(gl_from_matsu)), rtol=0)
    end
end