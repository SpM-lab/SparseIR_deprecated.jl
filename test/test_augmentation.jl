using SparseIR
using Test

import PyCall: pyimport, PyNULL, PyVector
import SpecialPolynomials: Legendre

sparse_ir = pyimport("sparse_ir")

@testset "augment.LegendreBasis" begin
    for stat in [fermion, boson]
        beta = 10.0
        Nl = 100
        cl = sqrt.(2 .* collect(0:Nl-1) .+ 1)
        basis = SparseIR.LegendreBasis(stat, beta, Nl, cl=cl)

        tau = Float64[0, 0.1*beta, 0.4*beta, beta]
        uval = basis.u(tau)
 
        for l in 0:Nl-1
            p = Legendre(l+1)
            isapprox(
                uval[l+1,:],
                cl[l+1] * (sqrt(2*l+1)/beta) * p(2*tau/beta-1)
            )
        end
    end
end