# docs/make.jl

using Logistics

using Documenter

makedocs(
	sitename = "Logistics.jl",
	pages = [
		"Logistics.jl" => "index.md",
		],
)

deploydocs(
    repo = "github.com/Mikumikunisiteageru/Logistics.jl.git",
	versions = ["stable" => "v^", "v#.#.#"]
)
