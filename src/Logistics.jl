# src/Logistics.jl

module Logistics

export Logistic, logit, logistic, logisticate, half, complement

struct Logistic{T<:AbstractFloat} <: Real
	t::T
	Logistic(t::T) where {T<:AbstractFloat} = new{T}(t)
end
Logistic(t::Real) = Logistic(float(t))
Logistic{T}(t::Real) where {T<:AbstractFloat} = Logistic(T(t))
function Logistic(x::Logistic)
	error("`Syntax prohibited! Use `convert(Logistic, $x)` instead.")
	return x
end
function Logistic{T}(x::Logistic) where {T<:AbstractFloat}
	error("`Syntax prohibited! Use `convert(Logistic{$T}, $x)` instead.")
	return Logistic(T(x.t))
end

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
Base.promote_rule(::Type{Logistic{T1}}, ::Type{T2}) where 
	{T1<:AbstractFloat, T2<:AbstractIrrational} = T1
Base.promote_rule(::Type{Logistic{T}}, ::Type{BigFloat}) where 
	{T<:AbstractFloat} = BigFloat
Base.promote_rule(::Type{Logistic{T}}, ::Type{Bool}) where 
	{T<:AbstractFloat} = T

function logit(x::Real)
	0 <= x <= 1 && return log(x / (1 - x))
	throw(DomainError(x, "logit only accepts real argument between 0 and 1."))
end
logit(x::Logistic) = x.t

logistic(t::Real) = 1 / (1 + exp(-t))

function Base.log(x::Logistic)
	u = exp(-x.t)
	if u == u + 1
		return x.t
	else
		return -log1p(u)
	end
end

logisticate(x::Real) = Logistic(logit(x))
logisticate(T::Type{<:AbstractFloat}, x::Real) = logisticate(T(x))
logisticate(::Type{Logistic}, x::Real) = Logistic(logit(x))
logisticate(::Type{<:Logistic{T}}, x::Real) where 
	{T<:AbstractFloat} = logisticate(T(x))

complement(x::Logistic) = Logistic(-x.t)

Base.zero(::Type{Logistic}) = Logistic(-Inf)
Base.zero(::Type{Logistic{T}}) where {T<:AbstractFloat} = Logistic(typemin(T))
Base.zero(::Logistic{T}) where {T<:AbstractFloat} = Logistic(typemin(T))

Base.typemin(::Type{Logistic{T}}) where {T<:AbstractFloat} = zero(Logistic{T})

Base.one(::Type{Logistic}) = Logistic(Inf)
Base.one(::Type{Logistic{T}}) where {T<:AbstractFloat} = Logistic(typemax(T))
Base.one(::Logistic{T}) where {T<:AbstractFloat} = Logistic(typemax(T))

Base.typemax(::Type{Logistic{T}}) where {T<:AbstractFloat} = one(Logistic{T})

half(::Type{Logistic}) = Logistic(0)
half(::Type{Logistic{T}}) where {T<:AbstractFloat} = Logistic(zero(T))
half(::Logistic{T}) where {T<:AbstractFloat} = Logistic(zero(T))

Base.:<(x::Logistic, y::Logistic) = x.t < y.t

Base.:<=(x::Logistic, y::Logistic) = x.t <= y.t

Base.:>(x::Logistic, y::Logistic) = x.t > y.t

Base.:>=(x::Logistic, y::Logistic) = x.t >= y.t

Base.:(==)(x::Logistic, y::Logistic) = x.t == y.t

Base.isapprox(x::Logistic, y::Logistic) = isapprox(x.t, y.t)

Base.prevfloat(x::Logistic) = Logistic(prevfloat(x.t))

Base.nextfloat(x::Logistic) = Logistic(nextfloat(x.t))

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
	if b > 0
		return complement(y) - complement(x)
	elseif a > 0
		return (half(y) - y) + (half(x) - complement(x))
	else
		return Logistic(a + log(-expm1(b-a) / (1 + 2 * exp(b) + exp(a+b))))
	end
end

function Base.:*(x::Logistic, y::Union{Integer, Rational})
	a = x.t
	y < 0 && throw(DomainError(float(x) * y, "multiplicand is negative."))
	if y > 1
		v = a + log(y-1)
		v > 0 && throw(DomainError(float(x) * y, "product exceeds 1."))
		v == 0 && return one(x)
	end
	return Logistic(log(y / (1 - y + exp(-a))))
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
	return Logistic(b + log((1 + exp(-b)) / expm1(b-a)))
end
Base.:/(x::Logistic, y::Integer) = x * (1 // y)
Base.:/(x::Logistic, y::Rational) = x * inv(y)

function logexpm1(u::T) where {T<:AbstractFloat}
	u >= log(prevfloat(typemax(T))) && return u
	return log(expm1(u))
	# u >= sqrt(eps(T)) && return log(expm1(u))
	# return u/2 + Base.Math.@horner(u^2, log(u), 
		# +1 // 24, 
		# -1 // 2880, 
		# +1 // 181440, 
		# -1 // 9676800, 
		# +1 // 479001600, 
		# -691 // 15692092416000, 
		# +1 // 1046139494400, 
		# -3617 // 170729965486080000, 
		# +43867 // 91963695909076992000, 
		# -174611 // 16057153253965824000000)
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
# Base.:^(x::Logistic{T}, k::Logistic) where {T<:AbstractFloat} = x ^ T(k)

Base.sqrt(x::Logistic) = x ^ (1//2)

Base.cbrt(x::Logistic) = x ^ (1//3)

end # module Logistics
