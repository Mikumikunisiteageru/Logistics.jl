# test/runtests.jl

using Logistics
using Test
import Aqua

Aqua.test_all(Logistics)

@testset "type" begin
	@test Logistic <: Real
	@test Logistic{Float16} <: Logistic
	@test Logistic{Float32} <: Logistic
	@test Logistic{Float64} <: Logistic
	@test Logistic{BigFloat} <: Logistic
	@test_throws TypeError Logistic{Int64}
	@test_throws TypeError Logistic{Real}
	@test Logistic(0) === Logistic(0.0)
	@test Logistic{Float64}(0) === Logistic(0.0)
	@test Logistic{Float32}(0) === Logistic(0f0)
	half__ = Logistic(0)
	@test half__ isa Logistic{Float64}
	@test_throws ErrorException Logistic(half__)
	@test_throws ErrorException Logistic(half__)
	@test_throws ErrorException Logistic{Float16}(half__)
	@test_throws ErrorException Logistic{Float16}(half__)
	@test_throws ErrorException Logistic{Float16}(half__)
	@test_throws ErrorException Logistic{Float16}(half__)
end

@testset "show" begin
	@test sprint(show, Logistic(Float16(0))) === "Logistic{Float16}(0.0)"
	@test sprint(show, MIME("text/plain"), Logistic(Float16(0))) === 
		"Logistic{Float16}(0.0) ≈ 0.5"
end

@testset "conversion" begin
	half_ = Logistic(0)
	@test convert(Logistic, half_) === half_
	@test convert(Logistic{Float16}, half_) === Logistic(Float16(0))
	@test convert(Logistic, 0.5) === half_
	@test convert(Logistic{Float16}, 0.5) === Logistic(Float16(0))
	@test convert(Float16, half_) === Float16(0.5)
	@test convert(AbstractFloat, half_) === Float64(0.5)
	@test convert(Real, half_) === half_
	@test_throws MethodError convert(Rational{Int}, half_)
	@test Float16(half_) === Float16(0.5)
	@test AbstractFloat(half_) === Float64(0.5)
	@test Real(half_) === half_
	@test_throws MethodError Rational{Int}(half_)
	@test float(half_) === 0.5
	@test float(Logistic(-50)) === 1.928749847963918e-22
	@test float(Logistic(+50)) === 1.0
	@test convert(Logistic, Logistic(-10000)) === Logistic(-10000)
	@test convert(Logistic{Float64}, Logistic(-10000)) === Logistic(-10000)
end

@testset "promotion" begin
	@test promote_type(Logistic, Logistic) == Logistic
	@test promote_type(Logistic, Logistic{Float64}) == Logistic{Float64}
	@test promote_type(Logistic{Float64}, Logistic{Float64}) == 
		Logistic{Float64}
	@test promote_type(Logistic{Float32}, Logistic{Float64}) == 
		Logistic{Float64}
	@test promote_type(Logistic, Real) == Real
	@test promote_type(Logistic, Rational{Int}) == Real
	@test promote_type(Logistic, Float64) == Float64
	@test promote_type(Logistic{Float32}, Float64) == Float64
	@test promote_type(Logistic{Float64}, Float64) == Float64
	@test promote_type(Logistic{BigFloat}, Float64) == BigFloat
	@test promote_type(Logistic{Float32}, Int) == Float32
	@test promote_type(Logistic{Float64}, Int) == Float64
	@test promote_type(Logistic{BigFloat}, Int) == BigFloat
	@test promote_type(Logistic{Float32}, Real) == Float32
	@test promote_type(Logistic{Float64}, Real) == Float64
	@test promote_type(Logistic{BigFloat}, Real) == BigFloat
	@test promote_type(Logistic{Float32}, Bool) == Float32
	@test promote_type(Logistic{Float64}, Bool) == Float64
	@test promote_type(Logistic{BigFloat}, Bool) == BigFloat
	@test promote_type(Logistic{Float32}, BigFloat) == BigFloat
	@test promote_type(Logistic{Float64}, BigFloat) == BigFloat
	@test promote_type(Logistic{BigFloat}, BigFloat) == BigFloat
end

@testset "logit" begin
	@test logit(Logistic(0f0)) === 0f0
	@test logit(Logistic(0f0)) !== 0.0
	@test logit(0.0) === -Inf
	@test logit(0.5) === 0.0
	@test logit(1.0) === +Inf
	@test logit(0.0f0) === -Inf32
	@test logit(0.5f0) === 0.0f0
	@test logit(1.0f0) === +Inf32
	@test logit(0) === -Inf 
	@test logit(1) === +Inf 
	@test logit(0//1) === -Inf 
	@test logit(1//1) === +Inf 
	@test_throws DomainError logit(prevfloat(0.0))
	@test_throws DomainError logit(nextfloat(1.0))
end

@testset "log" begin
	@test log(Logistic(-Inf)) === -Inf
	@test log(Logistic(0.0)) === -log(2)
	@test log(Logistic(+Inf)) === -0.0
	@test log(Logistic(-100)) === -100.0
	@test log(Logistic(+100)) === -3.720075976020836e-44
end

@testset "logisticate" begin
	@test logisticate(0.0) === Logistic(-Inf)
	@test logisticate(0.5) === Logistic(0.0)
	@test logisticate(1.0) === Logistic(+Inf)
	@test logisticate(1e-30) === Logistic(-69.07755278982137)
	@test logisticate(Logistic, 0.0) === Logistic(-Inf)
	@test logisticate(Logistic, 0.5) === Logistic(0.0)
	@test logisticate(Logistic, 1.0) === Logistic(+Inf)
	@test logisticate(Logistic, 1e-30) === Logistic(-69.07755278982137)
	@test logisticate(Float32, 0.0) === Logistic(-Inf32)
	@test logisticate(Float32, 0.5) === Logistic(0.0f0)
	@test logisticate(Float32, 1.0) === Logistic(+Inf32)
	@test logisticate(Float32, 1e-30) === Logistic(-69.07755f0)
	@test logisticate(Logistic{Float32}, 0.0) === Logistic(-Inf32)
	@test logisticate(Logistic{Float32}, 0.5) === Logistic(0.0f0)
	@test logisticate(Logistic{Float32}, 1.0) === Logistic(+Inf32)
	@test logisticate(Logistic{Float32}, 1e-30) === Logistic(-69.07755f0)
end

@testset "complement" begin
	@test complement(Logistic(-Inf)) == Logistic(+Inf)
	@test complement(Logistic(0.0)) == Logistic(0.0)
	@test complement(Logistic(+Inf)) == Logistic(-Inf)
end

@testset "zero" begin
	@test zero(Logistic) == Logistic(-Inf)
	@test zero(Logistic{Float64}) == Logistic(-Inf)
	@test zero(Logistic{Float32}) == Logistic(-Inf32)
	@test zero(Logistic(1.0)) == Logistic(-Inf)
	@test zero(Logistic(1f0)) == Logistic(-Inf32)
end

@testset "typemin" begin
	@test_throws MethodError typemin(Logistic)
	@test typemin(Logistic{Float64}) == Logistic(-Inf) 
	@test typemin(Logistic(1.0)) == Logistic(-Inf) 
end

@testset "one" begin
	@test one(Logistic) == Logistic(+Inf)
	@test one(Logistic{Float64}) == Logistic(+Inf)
	@test one(Logistic{Float32}) == Logistic(+Inf32)
	@test one(Logistic(1.0)) == Logistic(+Inf)
	@test one(Logistic(1f0)) == Logistic(+Inf32)
end

@testset "typemax" begin
	@test_throws MethodError typemax(Logistic)
	@test typemax(Logistic{Float64}) == Logistic(+Inf) 
	@test typemax(Logistic(1.0)) == Logistic(+Inf) 
end

@testset "half" begin
	@test half(Logistic) == Logistic(0)
	@test half(Logistic{Float64}) == Logistic(0.0)
	@test half(Logistic{Float32}) == Logistic(0f0)
	@test half(Logistic(1.0)) == Logistic(0.0)
	@test half(Logistic(1f0)) == Logistic(0f0)
end

@testset "comparisons" begin
	@test Logistic(1.0) < Logistic(2.0)
	@test ! (Logistic(2.0) < Logistic(2.0))
	@test Logistic(1.0) <= Logistic(2.0)
	@test Logistic(2.0) <= Logistic(2.0)
	@test ! (Logistic(1.0) > Logistic(2.0))
	@test ! (Logistic(2.0) > Logistic(2.0))
	@test ! (Logistic(1.0) >= Logistic(2.0))
	@test Logistic(2.0) >= Logistic(2.0)
	@test ! (Logistic(1.0) == Logistic(2.0))
	@test Logistic(2.0) == Logistic(2.0)
	@test Logistic(0.0) == Logistic(-0.0)
	@test ! (Logistic(0.0) != Logistic(-0.0))
	@test Logistic(0.0) !== Logistic(-0.0)
	@test isapprox(Logistic(1.0), Logistic(1.0))
	@test isapprox(Logistic(1.0), prevfloat(Logistic(1.0)))
	@test isapprox(Logistic(1.0), nextfloat(Logistic(1.0)))
end

@testset "prevfloat" begin
	@test prevfloat(Logistic(-Inf)) == Logistic(-Inf)
	@test prevfloat(Logistic(0.0)) == Logistic(-5.0e-324)
	@test prevfloat(Logistic(+Inf)) == Logistic(1.7976931348623157e308)
end

@testset "nextfloat" begin
	@test nextfloat(Logistic(-Inf)) == Logistic(-1.7976931348623157e308)
	@test nextfloat(Logistic(0.0)) == Logistic(5.0e-324)
	@test nextfloat(Logistic(+Inf)) == Logistic(+Inf)
end

@testset "addition" begin
	@test Logistic(0.0) + Logistic(0.0) === Logistic(Inf)
	@test_throws DomainError Logistic(0.0) + Logistic(0.01)
	@test Logistic(0.0) + Logistic(-0.01) === Logistic(5.988969771059924)
	@test Logistic(0.0) + Logistic(-Inf) === Logistic(0.0)
	@test Logistic(+Inf) + Logistic(-Inf) === Logistic(+Inf)
	@test Logistic(0.0) + Logistic(0.0f0) === Logistic(+Inf)
	@test Logistic(0.0) + BigFloat(0.5) == BigFloat(1.0)
	@test Logistic(0.0) + BigFloat(0.5) isa BigFloat
	@test Logistic(0.0) + 1//2 === 1.0
	@test Logistic(0.0) + 0.5 === 1.0
	@test Logistic(-10000) + Logistic(-10000) === Logistic(-9999.30685281944)
	@test Logistic(-10000) + Logistic(0.0) === Logistic(0.0)
end

@testset "subtraction" begin
	@test Logistic(0.0) - Logistic(0.0) === Logistic(-Inf)
	@test_throws DomainError Logistic(0.0) - Logistic(0.01)
	@test Logistic(0.0) - Logistic(-0.01) === Logistic(-5.988969771059924)
	@test Logistic(0.0) - Logistic(-Inf) === Logistic(0.0)
	@test Logistic(+Inf) - Logistic(-Inf) === Logistic(+Inf)
	@test Logistic(0.0) - Logistic(0.0f0) === Logistic(-Inf)
	@test Logistic(0.0) - BigFloat(0.5) == BigFloat(0.0)
	@test Logistic(0.0) - BigFloat(0.5) isa BigFloat
	@test Logistic(0.0) - 1//2 === 0.0
	@test Logistic(0.0) - 0.5 === 0.0
	@test Logistic(-10000) - Logistic(-10000) === Logistic(-Inf)
	@test Logistic(0.0) - Logistic(-10000) === Logistic(0.0)
	@test Logistic(-9999) - Logistic(-10000) === Logistic(-9999.458675145386)
	@test Logistic(10000) - Logistic(10000) === Logistic(-Inf)
	@test Logistic(10000) - Logistic(0) === Logistic(0.0)
	@test Logistic(10000) - Logistic(9999) === Logistic(-9999.458675145386)
end

@testset "multiplication" begin
	@test_throws DomainError Logistic(0) * -1
	@test_throws DomainError Logistic(0) * (-1//10000)
	@test Logistic(0) * -1e-4 === -5e-5
	@test Logistic(-Inf) * -10000 == Logistic(-Inf)
	@test Logistic(0) * 0 === Logistic(-Inf)
	@test Logistic(0) * 1 === Logistic(0)
	@test Logistic(0) * (1//1) === Logistic(0)
	@test Logistic(0) * 1.0 === 0.5
	@test Logistic(0) * 2 === Logistic(+Inf)
	@test_throws DomainError Logistic(0) * 3
	@test Logistic(0) * 3.0 === 1.5
	@test 1 * Logistic(0) === Logistic(0)
	@test (1//1) * Logistic(0) === Logistic(0)
	@test 1.0 * Logistic(0) === 0.5
	@test_skip Logistic(-10000) * (1//10) === Logistic(-Inf)
	@test_skip Logistic(-10000) * (1//1) === Logistic(-10000)
	@test_skip Logistic(-10000) * (10//1) === Logistic(-9997.697414907007)
	@test_skip Logistic(-10000) * 1 === Logistic(-10000)
	@test_skip Logistic(-10000) * 10 === Logistic(-9997.697414907007)
	@test Logistic(10000) * (1//10) === Logistic(-2.197224577336219)
	@test_skip Logistic(10000) * (1//1) === Logistic(10000)
	@test_throws DomainError Logistic(10000) * (10//1)
	@test_skip Logistic(10000) * 1 === Logistic(10000)
	@test_throws DomainError Logistic(10000) * 10
	@test Logistic(10000) * logisticate(0.1) === logisticate(0.1)
	@test Logistic(10000) * Logistic(0) === Logistic(0)
	@test Logistic(10000) * Logistic(-Inf) === Logistic(-Inf)
	@test Logistic(10000) * Logistic(+Inf) === Logistic(10000)
	@test Logistic(-10000) * logisticate(0.1) === Logistic(-10002.302585092993)
	@test Logistic(-10000) * Logistic(0) === Logistic(-10000.69314718056)
	@test Logistic(-10000) * Logistic(-Inf) === Logistic(-Inf)
	@test Logistic(-10000) * Logistic(+Inf) === Logistic(-10000)
	@test Logistic(-10000) * Logistic(-10000) === Logistic(-20000)
	@test Logistic(-10000) * Logistic(+10000) === Logistic(-10000)
	@test Logistic(+10000) * Logistic(+10000) === Logistic(9999.30685281944)
	@test Logistic(-30) * Logistic(-30) === Logistic(-60.000000000000185)
	@test Logistic(0) * Logistic(0) === Logistic(-1.0986122886681098)
	@test Logistic(0) * Logistic(0f0) === Logistic(-1.0986122886681098)
end

@testset "division" begin
	@test_throws DomainError Logistic(0) / -1
	@test_throws DomainError Logistic(0) / (-1//10000)
	@test Logistic(0) / -1e4 === -5e-5
	@test Logistic(-Inf) / -10000 == Logistic(-Inf)
	@test_throws DomainError Logistic(0) / 0
	@test Logistic(0) / 1 === Logistic(0)
	@test Logistic(0) / (1//1) === Logistic(0)
	@test Logistic(0) / 1.0 === 0.5
	@test Logistic(0) / 2 === Logistic(-1.0986122886681098)
	@test Logistic(0) / (1//2) === Logistic(Inf)
	@test_throws DomainError Logistic(0) / (1//3)
	@test Logistic(0) / 3.0 === 0.16666666666666666
	@test 1 \ Logistic(0) === Logistic(0)
	@test (1//1) \ Logistic(0) === Logistic(0)
	@test 1.0 \ Logistic(0) === 0.5
	@test_skip Logistic(-10000) / (10//1) === Logistic(-Inf)
	@test_skip Logistic(-10000) / (1//1) === Logistic(-10000)
	@test_skip Logistic(-10000) / (1//10) === Logistic(-9997.697414907007)
	@test_skip Logistic(-10000) / 1 === Logistic(-10000)
	@test_skip Logistic(-10000) / 10 === Logistic(-Inf)
	@test_skip Logistic(10000) / (10//1) === Logistic(Inf)
	@test_skip Logistic(10000) / (1//1) === Logistic(10000)
	@test_throws DomainError Logistic(10000) / (1//10)
	@test_skip Logistic(10000) / 1 === Logistic(10000)
	@test Logistic(10000) / 10 === Logistic(-2.197224577336219)
	@test Logistic(0) / Logistic(0.1) === Logistic(2.9965651211176616)
	@test_skip Logistic(0) / Logistic(10000) === Logistic(-Inf)
	@test Logistic(-Inf) / Logistic(0) === Logistic(-Inf)
	@test_skip Logistic(0) / Logistic(Inf) === Logistic(0)
	@test_skip Logistic(10000) / Logistic(20000) === Logistic(-Inf)
	@test_skip Logistic(-20000) / Logistic(-10000) === Logistic(-Inf)
	@test Logistic(-10000) / Logistic(-10000) === Logistic(Inf)
	@test_skip Logistic(-10000) / Logistic(+10000) === Logistic(-Inf)
	@test Logistic(+10000) / Logistic(+10000) === Logistic(Inf)
	@test Logistic(-30) / Logistic(-30) === Logistic(Inf)
	@test Logistic(-30) / Logistic(+30) === Logistic(-29.999999999999908)
	@test Logistic(+30) / Logistic(+30) === Logistic(Inf)
	@test Logistic(0) / Logistic(0) === Logistic(Inf)
	@test Logistic(Float16(0)) / Logistic(Float32(0)) === Logistic(Inf32)
end

@testset "logexpm1" begin
	logexpm1 = Logistics.logexpm1
	T = Float64
	u1 = log(prevfloat(typemax(T)))
	@test logexpm1(u1) == u1
	@test logexpm1(nextfloat(u1)) == nextfloat(u1)
	@test logexpm1(prevfloat(u1)) == prevfloat(u1)
	u2 = sqrt(eps(T))
	@test logexpm1(u2) == log(expm1(u2))
	@test logexpm1(nextfloat(u2)) == log(expm1(nextfloat(u2)))
	@test logexpm1(prevfloat(u2)) == log(expm1(prevfloat(u2)))
end

@testset "exponentials" begin
	@test_throws DomainError Logistic(0) ^ -0.0001
	@test Logistic(0) ^ 0 === Logistic(Inf)
	@test Logistic(0) ^ 1 === Logistic(0)
	@test Logistic(0) ^ 1e-4 === Logistic(9.57681863499863)
	@test Logistic(0) ^ 1e+4 === Logistic(-6931.471805599453)
	@test Logistic(9.57681863499863) ^ 1e+4 === Logistic(6.661338147750941e-16)
	@test Logistic(-6931.471805599453) ^ 1e-4 === Logistic(0)
	@test Logistic(60) ^ 1e+30 === Logistic(-8756.51076269652)
	@test Logistic(-10000) ^ 1e-30 === Logistic(59.86721241784519)
	@test Logistic(59.86721241784519) ^ 1e+30 === Logistic(-9999.999999999998)
	@test Logistic(-8756.51076269652) ^ 1e-30 === Logistic(60)
	@test Logistic(0f0) ^ 0 === Logistic(Inf32)
	@test_throws ErrorException Logistic(0) ^ Logistic(0)
end

@testset "sqrt" begin
	@test sqrt(logisticate(0.0)) == logisticate(0.0)
	@test sqrt(logisticate(1.0)) == logisticate(1.0)
	@test isapprox(sqrt(logisticate(0.49)), logisticate(0.7))
end

@testset "cbrt" begin
	@test cbrt(logisticate(0.0)) == logisticate(0.0)
	@test cbrt(logisticate(1.0)) == logisticate(1.0)
	@test isapprox(cbrt(logisticate(0.343)), logisticate(0.7))
end
