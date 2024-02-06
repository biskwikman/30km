using Printf
using Statistics
using CairoMakie
using Dates

function create_weights(areas_file)
	areas = Array{Float32}(undef, (480, 360))
	read!(areas_file, areas)
	areas = convert(Array{Union{Missing, Float32}}, areas)
	replace!(areas, -9999 => missing)
	total_area = sum(skipmissing(areas))
	areas/total_area
end

function mean_temp(filepath, weights)
	data = Array{Float32}(undef, (1440, 720, 12))
	read!(filepath, data)
	data = convert(Array{Union{Missing, Float32}}, data)
	asia = view(data, 961:1440, 41:400, :)
	typeof(data)
	replace!(asia, -9999 => missing)
	result = weights .* asia
	monthly_temps = Vector{Float32}()

	for i = 1:size(result)[3]
		append!(monthly_temps, sum(skipmissing(result[:,:,i])))
	end
	return monthly_temps
end

function main(create_weights, mean_temp)
	areas_file = "./AsiaMIP_qdeg_area.flt"

	mask_file = "./AsiaMIP_qdeg_gosat2.byt"

	weights = create_weights(areas_file)

	temps61 = Vector{Vector{Float32}}()
	temps06 = Vector{Vector{Float32}}()
	temps05 = Vector{Vector{Float32}}()
	
	for i = 0:15

		if i < 10
			string(i)
			i = @sprintf("%d%d", 0, i)
		else
			string(i)
		end
		filename61 = @sprintf("MOD11A2.061.LST_Day.GLOBAL.30km.20%s.degC.mon.bsq.flt", i)
		filename06 = @sprintf("MOD11A2.006.LST_Day.GLOBAL.30km.20%s.degC.mon.bsq.flt", i)
		filename05 = @sprintf("MOD11A2.005.LST_Day.GLOBAL.30km.20%s.degC.mon.bsq.flt", i)

		filepath61 = "./modis_data/MOD11A2.061/MONTH/$(filename61)"
		filepath06 = "./modis_data/MOD11A2.006/MONTH/$(filename06)"
		filepath05 = "./modis_data/MOD11A2.005/MONTH/$(filename05)"

		push!(temps61, mean_temp(filepath61, weights))
		push!(temps06, mean_temp(filepath06, weights))
		push!(temps05, mean_temp(filepath05, weights))
		
	end

	print(cor(mean(temps06), mean(temps61)))
	x = range(1, 12)
	
	f = Figure()
	ax = Axis(f[1, 1], xlabel="Month", ylabel="°C", xticks=1:12, xautolimitmargin=(0,0))
	
	plot05 = lines!(ax, x, mean(temps05), linewidth=3)
	plot06 = lines!(ax, x, mean(temps06), linewidth=3)
	plot61 = lines!(ax, x, mean(temps61), linewidth=4, linestyle=:dash)

	Legend(f[1, 2],
	    [plot05, plot06, plot61],
	    ["v5", "v6", "v6.1"])
	
	f
	
end

main(create_weights, mean_temp)