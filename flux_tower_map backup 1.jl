### A Pluto.jl notebook ###
# v0.19.42

using Markdown
using InteractiveUtils

# ╔═╡ 43846d4c-1be5-11ef-2210-6df8b2fe995a
begin
	using CairoMakie
	using GeoMakie
	using CSV
	using DataFrames
end

# ╔═╡ 25e38957-09b5-43d2-8d7f-30b033dccbbc
df = Dataframe(CSV.File("tower_locations.csv", df))

# ╔═╡ Cell order:
# ╠═43846d4c-1be5-11ef-2210-6df8b2fe995a
# ╠═25e38957-09b5-43d2-8d7f-30b033dccbbc
