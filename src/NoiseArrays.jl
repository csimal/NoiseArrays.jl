module NoiseArrays

using RandomNoise
using RandomNoise: noise_getindex, noise_convert
using Distributions
using CUDA

include("noise_arrays.jl")
include("distributions.jl")

export NoiseArray

end
