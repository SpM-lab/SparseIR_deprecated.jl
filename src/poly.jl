"""
Piecewise Legendre polynomial.
"""

import PyCall: PyObject

struct PiecewiseLegendrePoly
    o::PyObject
end

Base.convert(::Type{PiecewiseLegendrePoly}, o::PyObject) = PiecewiseLegendrePoly(o)
(p::PiecewiseLegendrePoly)(x) = p.o(x)

function Base.getindex(p::PiecewiseLegendrePoly, i::Int64)
    1 <= i <= p.o.size || error("Invalid index!")
    PiecewiseLegendrePoly(p.o.__getitem__(i-1))
end

"""
f: Function-like object
   f should takes a real-valued vector and return a real-valued D-dimensional arrays.
   axis option specifies which axis of this array correponds to the axis of the input.

axis:
   By default, the last axis is used for computing overlap.
"""
function overlap(poly::PiecewiseLegendrePoly, f)::Float64
    return poly.o.overlap(f)[1]
end

"""
PiecewiseLegendreFT
"""
struct PiecewiseLegendreFT
    o::PyObject
end

Base.convert(::Type{PiecewiseLegendreFT}, o::PyObject) = PiecewiseLegendreFT(o)
(p::PiecewiseLegendreFT)(x) = p.o(x)

function Base.getindex(p::PiecewiseLegendreFT, i::Int64)
    1 <= i <= p.o.size || error("Invalid index!")
    PiecewiseLegendreFT(p.o.__getitem__(i - 1))
end
