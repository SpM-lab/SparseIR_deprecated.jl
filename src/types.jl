
@enum Statistics fermion boson

statistics_sign(stat::Statistics)::Int64 = stat == fermion ? -1 : 1

PyObject(stat::Statistics)::PyObject = (stat == fermion ? "F" : "B")
