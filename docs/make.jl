using IRBasis3
using Documenter

DocMeta.setdocmeta!(IRBasis3, :DocTestSetup, :(using IRBasis3); recursive=true)

makedocs(;
    modules=[IRBasis3],
    authors="Hiroshi Shinaoka <h.shinaoka@gmail.com> and contributors",
    repo="https://github.com/shinaoka/IRBasis3.jl/blob/{commit}{path}#{line}",
    sitename="IRBasis3.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://shinaoka.github.io/IRBasis3.jl",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/shinaoka/IRBasis3.jl",
    devbranch="main",
)
