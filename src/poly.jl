"""
Piecewise Legendre polynomial.
"""

import PyCall: PyObject

struct PiecewiseLegendrePoly
    o::PyObject
end

Base.convert(::Type{PiecewiseLegendrePoly}, o::PyObject) = PiecewiseLegendrePoly(o)
(p::PiecewiseLegendrePoly)(x) = p.o(x)
Base.getindex(p::PiecewiseLegendrePoly, i::Int64) = PiecewiseLegendrePoly(p.o[i - 1])

"""
f: Function-like object
   f should takes a real-valued vector and return a real-valued D-dimensional arrays.
   axis option specifies which axis of this array correponds to the axis of the input.

axis:
   By default, the last axis is used for computing overlap.
"""
function overlap(poly::PiecewiseLegendrePoly, f, axis::Union{Int64,Nothing}=nothing)
    return poly.o.overlap(f, axis)
end

"""
PiecewiseLegendreFT
"""
struct PiecewiseLegendreFT
    o::PyObject
end

Base.convert(::Type{PiecewiseLegendreFT}, o::PyObject) = PiecewiseLegendreFT(o)
(p::PiecewiseLegendreFT)(x) = p.o(x)
Base.getindex(p::PiecewiseLegendreFT, i::Int64) = PiecewiseLegendreFT(p.o[i - 1])
