# SparseIR

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://shinaoka.github.io/SparseIR.jl/stable)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://shinaoka.github.io/SparseIR.jl/dev)
[![Build Status](https://github.com/shinaoka/SparseIR.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/shinaoka/SparseIR.jl/actions/workflows/CI.yml?query=branch%3Amain)

irbasis (`https://github.com/SpM-lab/irbasis3`) is a Python library for the intermediate representation of propagators.
With the excellent `PyCall` package of `julia`, one can use the
many features of the irbasis3 library from within a `Julia` session.

### Installation

To use this package, both Python and a proper version of `irbasis3` library must be
installed on your system.
Note that the `irbasis3` must be installed via `pip`.
If a proper version of `irbasis3` is already installed,
`SparseIR` can be installed by running

```Julia
julia -e 'using Pkg; Pkg.add(url="https://github.com/shinaoka/SparseIR.jl.git")'
```

Alternatively, run the following command to install both of `irbasis3` and `SparseIR.jl`:

```Julia
julia -e 'ENV["INSTALL_IRBASIS3"]=1; using Pkg; Pkg.add(url="https://github.com/shinaoka/SparseIR.jl.git"); Pkg.build("SparseIR")'
```

### Usage

```Julia
using SparseIR
lambda = 100
beta = 10
eps = 1e-7
k = KernelFFlat(lambda)
basis_f = FiniteTempBasis(k, fermion, beta, eps)
basis_b = FiniteTempBasis(k, boson, beta, eps)
```
