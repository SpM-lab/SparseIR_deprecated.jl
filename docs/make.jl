using SparseIR
using Documenter

DocMeta.setdocmeta!(SparseIR, :DocTestSetup, :(using SparseIR); recursive=true)

makedocs(;
    modules=[SparseIR],
    authors="Hiroshi Shinaoka <h.shinaoka@gmail.com> and contributors",
    repo="https://github.com/shinaoka/SparseIR.jl/blob/{commit}{path}#{line}",
    sitename="SparseIR.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://shinaoka.github.io/SparseIR.jl",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/shinaoka/SparseIR.jl",
    devbranch="main",
)
