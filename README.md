# IRBasis3

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://shinaoka.github.io/IRBasis3.jl/stable)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://shinaoka.github.io/IRBasis3.jl/dev)
[![Build Status](https://github.com/shinaoka/IRBasis3.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/shinaoka/IRBasis3.jl/actions/workflows/CI.yml?query=branch%3Amain)

irbasis (`https://github.com/SpM-lab/irbasis3`) is a Python library for the intermediate representation of propagators.
With the excellent `PyCall` package of `julia`, one can use the
many features of the irbasis3 library from within a `Julia` session.

### Installation

To use this package, both Python and a proper version of `irbasis3` library must be
installed on your system.
Note that the `irbasis3` must be installed via `pip`.
To install a proper version of `irbasis3` into the Python environment with which `PyCall` is configured,
run the following command.

```Julia
julia -e 'ENV["INSTALL_IRBASIS3"]=1; using Pkg; Pkg.build("IRBasis3");'
```

### Usage

```Julia
using IRBasis3
lambda = 100
beta = 10
eps = 1e-7
k = KernelFFlat(lambda)
basis_f = FiniteTempBasis(k, fermion, beta, eps)
basis_b = FiniteTempBasis(k, boson, beta, eps)
```
