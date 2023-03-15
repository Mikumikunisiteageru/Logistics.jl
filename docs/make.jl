# docs/make.jl

using Logistics

using Documenter

makedocs(
	sitename = "Logistics.jl",
	pages = [
		"Logistics.jl" => "index.md",
		],
	modules = [Logistics],
)

deploydocs(
    repo = "github.com/Mikumikunisiteageru/Logistics.jl.git",
	versions = ["stable" => "v^", "v#.#.#"]
)
