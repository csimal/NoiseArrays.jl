import Base: getindex

function NoiseArray(rng, d::UnivariateDistribution, sz...)
    T = typeof(Distributions.quantile(d,0.5))
    NoiseArray{T}(rng, d, sz...)
end

Base.@propagate_inbounds @inline function getindex(A::NoiseArray{T,N,R,F}, i::Integer) where {F<:UnivariateDistribution} where {T,N,R}
    @boundscheck checkbounds(A,i)
    Distributions.quantile(A.transform, noise_convert(noise(i, A.noise), Float64))
end

# Override for Bernoulli because quantile(Bernoulli) returns Float64 instead of Bool

NoiseArray(rng, d::Bernoulli, sz...) = NoiseArray{Bool}(rng, d, sz...)

Base.@propagate_inbounds @inline function getindex(A::NoiseArray{Bool,N,R,F}, i::Integer) where {N,R,F<:Bernoulli}
    @boundscheck checkbounds(A,i)
    isless(noise_convert(noise(i, A.noise), Float64), A.transform.p)
end