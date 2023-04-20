using Plots

filename = "./modis_data/MOD11A2.061/MONTH/MOD11A2.061.LST_Day.GLOBAL.30km.2021.degC.mon.bsq.flt"

data = Array{Float32}(undef, 1440, 720, 12)
read!(filename, data)
println(size(data))