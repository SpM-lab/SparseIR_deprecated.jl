"""
Piecewise Legendre polynomial.
"""
struct PiecewiseLegendrePoly
    o::PyObject
end

Base.convert(::Type{PiecewiseLegendrePoly}, o::PyObject) = PiecewiseLegendrePoly(o)
(p::PiecewiseLegendrePoly)(x) = p.o(x)
Base.getindex(p::PiecewiseLegendrePoly, i::Int64) = PiecewiseLegendrePoly(p.o[i-1])

"""
PiecewiseLegendreFT
"""
struct PiecewiseLegendreFT
    o::PyObject
end

Base.convert(::Type{PiecewiseLegendreFT}, o::PyObject) = PiecewiseLegendreFT(o)
(p::PiecewiseLegendreFT)(x) = p.o(x)
Base.getindex(p::PiecewiseLegendreFT, i::Int64) = PiecewiseLegendreFT(p.o[i-1])