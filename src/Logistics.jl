# src/Logistics.jl

module Logistics

export Logistic, logit, logistic, logisticate, complement

struct Logistic{T<:AbstractFloat} <: Real
	t::T
end
Logistic(t::Real) = Logistic(float(t))

function Base.convert(::Type{T}, x::Logistic) where {T<:AbstractFloat}
	return logistic(T(x.t))
end
(::Type{T})(x::Logistic) where {T<:AbstractFloat} = convert(T, x)
function Base.promote_rule(::Type{Logistic{T1}}, ::Type{Logistic{T2}}) where 
		{T1<:AbstractFloat, T2<:AbstractFloat}
	return Logistic{promote_type(T1, T2)}
end
function Base.promote_rule(::Type{T1}, ::Type{Logistic{T2}}) where 
		{T1<:AbstractFloat, T2<:AbstractFloat}
	return promote_type(T1, T2)
end
function Base.promote_rule(::Type{T1}, ::Type{Logistic{T2}}) where 
		{T1<:Real, T2<:AbstractFloat}
	return T2
end
function Base.promote_rule(::Type{BigFloat}, ::Type{Logistic{T}}) where 
		{T<:AbstractFloat}
	return BigFloat
end

function logit(x::Real)
	0 <= x <= 1 && return log(x / (1 - x))
	throw(DomainError(x, "logit only accepts real argument between 0 and 1."))
end
logit(x::Logistic) = x.t

logistic(t::Real) = 1 / (1 + exp(-t))

Base.log(x::Logistic) = -log1p(exp(-x.t))

logisticate(x::Real) = Logistic(logit(x))

complement(x::Logistic) = Logistic(-x.t)

Base.zero(::Type{Logistic}) = Logistic(-Inf)
Base.zero(::Type{Logistic{T}}) where {T<:AbstractFloat} = Logistic(typemin(T))
Base.zero(::Logistic{T}) where {T<:AbstractFloat} = Logistic(typemin(T))

Base.typemin(::Type{Logistic{T}}) where {T<:AbstractFloat} = zero(Logistic{T})

Base.one(::Type{Logistic}) = Logistic(Inf)
Base.one(::Type{Logistic{T}}) where {T<:AbstractFloat} = Logistic(typemax(T))
Base.one(::Logistic{T}) where {T<:AbstractFloat} = Logistic(typemax(T))

Base.typemax(::Type{Logistic{T}}) where {T<:AbstractFloat} = one(Logistic{T})

Base.:<(x::Logistic, y::Logistic) = x.t < y.t
Base.:<=(x::Logistic, y::Logistic) = x.t <= y.t
Base.:>(x::Logistic, y::Logistic) = x.t > y.t
Base.:>=(x::Logistic, y::Logistic) = x.t >= y.t

function Base.:+(x::Logistic{T}, y::Logistic{T}) where {T<:AbstractFloat}
	a, b = minmax(x.t, y.t)
	s = a + b
	s > 0 && throw(
		DomainError(float(x) + float(y), "sum of the logistics exceeds 1."))
	s == 0 && return Logistic(typemax(T))
	return Logistic(b + log((2 * exp(a) + exp(a-b) + 1) / -expm1(s)))
end

function Base.:-(x::Logistic{T}, y::Logistic{T}) where {T<:AbstractFloat}
	a, b = x.t, y.t
	a < b && throw(
		DomainError(float(x) - float(y), "subtrahend exceeds minuend."))
	return Logistic(a + log(-expm1(b-a) / (1 + 2 * exp(b) + exp(a+b))))
end

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
	return Logistic(b + log((1 + exp(-b)) / expm1(b-a)))
end

function logexpm1(u::T) where {T<:AbstractFloat}
	u >= log(prevfloat(T)) && return u
	u >= sqrt(eps(T)) && return log(expm1(u))
	return u/2 + Base.Math.@horner(u^2, log(u), 
		+1 // 24, 
		-1 // 2880, 
		+1 // 181440, 
		-1 // 9676800, 
		+1 // 479001600, 
		-691 // 15692092416000, 
		+1 // 1046139494400, 
		-3617 // 170729965486080000, 
		+43867 // 91963695909076992000, 
		-174611 // 16057153253965824000000)
end

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
Base.:^(x::Logistic{T}, k::Logistic) where {T<:AbstractFloat} = x ^ T(k)

Base.sqrt(x::Logistic) = x ^ (1//2)

Base.cbrt(x::Logistic) = x ^ (1//3)

end # module Logistics
