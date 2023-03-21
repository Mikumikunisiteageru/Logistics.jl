# src/Logistics.jl

module Logistics
@doc let
    path = joinpath(dirname(@__DIR__), "README.md")
    include_dependency(path)
    read(path, String)
end Logistics

import LogExpFunctions: logit, logistic, log1pexp, logexpm1

export Logistic, logit, logistic, logisticate, complement, half

"""
	Logistic{T<:AbstractFloat} <: Real

	Logistic(t::Real)
	Logistic{T}(t::Real) where {T<:AbstractFloat}

A type representing real numbers in ``[0,1]`` (e.g. probabilities) by their 
logit values.

!!! warning
	Do not use `Logistic` to convert number types! For example, 
	`Logistic(0.39)` equals ``\\operatorname{logistic}(0.39) \\approx 0.60`` 
	rather than ``0.39`` in value. To convert a number to an equivalent 
	`Logistic` instance, use [`logisticate`](@ref) or `convert(Logistic, x)`.
"""
struct Logistic{T<:AbstractFloat} <: Real
	t::T
	Logistic(t::T) where {T<:AbstractFloat} = new{T}(t)
end
Logistic(t::Real) = Logistic(float(t))
Logistic{T}(t::Real) where {T<:AbstractFloat} = Logistic(T(t))
Logistic(x::Logistic) = 
	error("`Syntax prohibited! Use `convert(Logistic, $x)` instead.")
Logistic{T}(x::Logistic) where {T<:AbstractFloat} = 
	error("`Syntax prohibited! Use `convert(Logistic{$T}, $x)` instead.")

Base.show(io::IO, x::Logistic{T}) where 
	{T<:AbstractFloat} = print(io, "Logistic{$T}($(x.t))")
Base.show(io::IO, mime::MIME"text/plain", x::Logistic{T}) where 
	{T<:AbstractFloat} = print(io, "Logistic{$T}($(x.t)) ≈ $(float(x))")

Base.convert(::Type{T}, x::Logistic) where 
	{T<:AbstractFloat} = logistic(T(x.t))
Base.convert(::Type{Logistic}, x::Real) = logisticate(x)
Base.convert(::Type{Logistic{T}}, x::Real) where 
	{T<:AbstractFloat} = logisticate(T, x)
Base.convert(::Type{Logistic}, x::Logistic) = x
Base.convert(::Type{Logistic{T}}, x::Logistic) where 
	{T<:AbstractFloat} = Logistic(T(x.t))

(::Type{T})(x::Logistic) where {T<:AbstractFloat} = convert(T, x)

Base.promote_rule(::Type{Logistic{T1}}, ::Type{Logistic{T2}}) where 
	{T1<:AbstractFloat, T2<:AbstractFloat} = Logistic{promote_type(T1, T2)}
Base.promote_rule(::Type{Logistic}, ::Type{T}) where 
	{T<:AbstractFloat} = T
Base.promote_rule(::Type{Logistic{T}}, ::Type{Logistic}) where 
	{T<:AbstractFloat} = Logistic{T}
Base.promote_rule(::Type{Logistic{T1}}, ::Type{T2}) where 
	{T1<:AbstractFloat, T2<:AbstractFloat} = promote_type(T1, T2)
Base.promote_rule(::Type{Logistic{T1}}, ::Type{T2}) where 
	{T1<:AbstractFloat, T2<:Real} = T1

logit(x::Logistic) = x.t

Base.log(x::Logistic) = -log1pexp(-x.t)

"""
	logisticate(x::Real) :: Logistic
	logisticate(T::Type{<:AbstractFloat}, x::Real) :: Logistic{T}
	logisticate(::Type{Logistic}, x::Real) :: Logistic
	logisticate(::Type{<:Logistic{T}}, x::Real) 
		where {T<:AbstractFloat} :: Logistic{T}

Convert a `Real` number to its equivalent `Logistic` number.

# Examples
```jldoctest
julia> logisticate(0.39)
Logistic{Float64}(-0.4473122180436648) ≈ 0.39

julia> logisticate(Float32, 0.39)
Logistic{Float32}(-0.4473123) ≈ 0.39

julia> logisticate(Logistic, 0.39)
Logistic{Float64}(-0.4473122180436648) ≈ 0.39

julia> logisticate(Logistic{Float32}, 0.39)
Logistic{Float32}(-0.4473123) ≈ 0.39
```
"""
logisticate(x::Real) = Logistic(logit(x))
logisticate(T::Type{<:AbstractFloat}, x::Real) = logisticate(T(x))
logisticate(::Type{Logistic}, x::Real) = Logistic(logit(x))
logisticate(::Type{<:Logistic{T}}, x::Real) where 
	{T<:AbstractFloat} = logisticate(T(x))

"""
	complement(x::Logistic) :: Logistic

Compute the complement, i.e., the difference between one and the argument.

# Examples
```jldoctest
julia> complement(logisticate(0.2))
Logistic{Float64}(1.3862943611198906) ≈ 0.8

julia> 1 - logisticate(0.2)
0.8
```
"""
complement(x::Logistic) = Logistic(-x.t)

Base.zero(::Type{Logistic}) = Logistic(-Inf)
Base.zero(::Type{Logistic{T}}) where {T<:AbstractFloat} = Logistic(typemin(T))
Base.zero(::Logistic{T}) where {T<:AbstractFloat} = Logistic(typemin(T))

Base.typemin(::Type{Logistic{T}}) where {T<:AbstractFloat} = zero(Logistic{T})

Base.one(::Type{Logistic}) = Logistic(Inf)
Base.one(::Type{Logistic{T}}) where {T<:AbstractFloat} = Logistic(typemax(T))
Base.one(::Logistic{T}) where {T<:AbstractFloat} = Logistic(typemax(T))

Base.typemax(::Type{Logistic{T}}) where {T<:AbstractFloat} = one(Logistic{T})

"""
	half(::Type{Logistic}) :: Logistic
	half(::Type{Logistic{T}}) where {T<:AbstractFloat} :: Logistic{T}
	half(::Logistic{T}) where {T<:AbstractFloat} :: Logistic{T}

Return a `Logistic` number equal to a half.

# Examples
```jldoctest
julia> (logisticate(0) + logisticate(1)) / 2
Logistic{Float64}(0.0) ≈ 0.5

julia> half(Logistic{Float64})
Logistic{Float64}(0.0) ≈ 0.5
```
"""
half(::Type{Logistic}) = Logistic(0)
half(::Type{Logistic{T}}) where {T<:AbstractFloat} = Logistic(zero(T))
half(::Logistic{T}) where {T<:AbstractFloat} = Logistic(zero(T))

Base.:<(x::Logistic, y::Logistic) = x.t < y.t

Base.:<=(x::Logistic, y::Logistic) = x.t <= y.t

Base.:>(x::Logistic, y::Logistic) = x.t > y.t

Base.:>=(x::Logistic, y::Logistic) = x.t >= y.t

Base.:(==)(x::Logistic, y::Logistic) = x.t == y.t

Base.isapprox(x::Logistic, y::Logistic) = isapprox(x.t, y.t)

Base.prevfloat(x::Logistic, d::Integer) = Logistic(prevfloat(x.t, d))
Base.prevfloat(x::Logistic) = Logistic(prevfloat(x.t))

Base.nextfloat(x::Logistic, d::Integer) = Logistic(nextfloat(x.t, d))
Base.nextfloat(x::Logistic) = Logistic(nextfloat(x.t))

function Base.eps(x::Logistic)
	iszero(x) && return nextfloat(x) - x
	isone(x) && return x - prevfloat(x)
	return max(nextfloat(x) - x, x - prevfloat(x))
end

Base.isinf(::Logistic) = false

Base.isfinite(x::Logistic) = !isnan(x.t)

Base.isnan(x::Logistic) = isnan(x.t)

const HASHLOGISTICS = hash("Logistics")

Base.hash(x::Logistic, h::UInt64) = xor(hash(x.t, h), HASHLOGISTICS)

Base.abs(x::Logistic) = x

function Base.:+(x::Logistic{T}, y::Logistic{T}) where {T<:AbstractFloat}
	a, b = minmax(x.t, y.t)
	s = a + b
	s > 0 && throw(
		DomainError(float(x) + float(y), "sum of the logistics exceeds 1."))
	s == 0 && return Logistic(typemax(T))
	a == -Inf && return Logistic(b)
	return Logistic(b + log((2 * exp(a) + exp(a-b) + 1) / -expm1(s)))
end

function Base.:-(x::Logistic{T}, y::Logistic{T}) where {T<:AbstractFloat}
	a, b = x.t, y.t
	a < b && throw(
		DomainError(float(x) - float(y), "subtrahend exceeds minuend."))
	if a <= 0
		return Logistic(a + log(-expm1(b-a) / (1 + 2 * exp(b) + exp(a+b))))
	elseif b <= 0
		return Logistic(log(-expm1(b-a) / (exp(b) + exp(-a) + 2 * exp(b-a))))
	else
		return Logistic(-b + log(-expm1(b-a) / (1 + 2 * exp(-a) + exp(-a-b))))
	end
end

function Base.:*(x::Logistic, y::Union{Integer, Rational})
	(iszero(x) || isone(y)) && return x
	a = x.t
	x > 0 && y < 0 && 
		throw(DomainError(float(x) * y, "multiplicand is negative."))
	if y > 1
		v = a + log(y-1)
		v > 0 && throw(DomainError(float(x) * y, "product exceeds 1."))
		v == 0 && return one(x)
	end
	if a <= 0
		return Logistic(-logexpm1(log1pexp(-a) - log(y)))
	else
		return Logistic(log(y / (1 - y + exp(-a))))
	end
end
Base.:*(x::Union{Integer, Rational}, y::Logistic) = y * x
function Base.:*(x::Logistic{T}, y::Logistic{T}) where {T<:AbstractFloat}
	a, b = minmax(x.t, y.t)
	if b <= 0 
		return Logistic(a + b - log1p(exp(a) + exp(b)))
	else
		Logistic(a - log1p(exp(-b) + exp(a-b)))
	end
end

function Base.:/(x::Logistic{T}, y::Logistic{T}) where {T<:AbstractFloat}
	a, b = x.t, y.t
	a > b && throw(
		DomainError(float(x) / float(y), "dividend exceeds divisor."))
	a == b && return Logistic(typemax(T))
	if b <= 0
		return Logistic(a - b + log((1+exp(b)) / -expm1(a-b)))
	else
		return Logistic(a + log((1+exp(-b)) / -expm1(a-b)))
	end
end
Base.:/(x::Logistic, y::Integer) = x * (1 // y)
Base.:/(x::Logistic, y::Rational) = x * inv(y)

function Base.:^(x::Logistic{T}, k::T) where {T<:AbstractFloat}
	k < 0 && throw(DomainError(float(x) ^ k, "exponent is negative."))
	a = x.t
	if a < 0
		if -a * k < sqrt(eps(T))
			return Logistic(-logexpm1((log1p(exp(a)) - a) * k))
		else
			return Logistic(a*k - log((exp(a)+1)^k - exp(a*k)))
		end
	else
		u = log1p(exp(-a)) * k
		iszero(u) && return Logistic(a - log(k))
		return Logistic(-logexpm1(u))
	end
end

Base.sqrt(x::Logistic) = x ^ (1//2)

Base.cbrt(x::Logistic) = x ^ (1//3)

end # module Logistics
