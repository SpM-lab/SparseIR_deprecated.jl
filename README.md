# SparseIR

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://shinaoka.github.io/SparseIR.jl/stable)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://shinaoka.github.io/SparseIR.jl/dev)
[![Build Status](https://github.com/shinaoka/SparseIR.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/shinaoka/SparseIR.jl/actions/workflows/CI.yml?query=branch%3Amain)

sparse-ir (`https://github.com/SpM-lab/sparse-ir`) is a Python library for the intermediate representation of propagators.
With the excellent `PyCall` package of `julia`, one can use the
many features of the sparse_ir library from within a `Julia` session.

### Installation

To use this package, both Python and a proper version of `sparse-ir` library must be
installed on your system.
If `PyCall` is installed using `Conda`
(which is the default behavior if no system `python` is found), then the
underlying `sparse-ir` library will be installed automatically via `Conda` when the
package is first loaded.
An optional library `xprec`, which allows to compute the IR basis functions with greater accuracy, is not installed automatically.
If needed, `xprec`  must be installed manually:

```
using Pkg
Pkg.add("Conda") #  if needed
using Conda
Conda.add("xprec", channel="h.shinaoka")
```

As of now (Feb. 15 2022), binary packages of `xprec` are not available on aarch64.
The underlying Python libraries can be updated as
```
using Pkg
Pkg.add("Conda") #  if needed
using Conda
Conda.update()
```

If `PyCall` is not installed using `Conda`, installing both Python and the underlying libraries can be done by other means.



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
