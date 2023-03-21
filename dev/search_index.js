var documenterSearchIndex = {"docs":
[{"location":"#Logistics.jl","page":"Logistics.jl","title":"Logistics.jl","text":"","category":"section"},{"location":"","page":"Logistics.jl","title":"Logistics.jl","text":"Logistics","category":"page"},{"location":"#Logistics","page":"Logistics.jl","title":"Logistics","text":"Logistics.jl\n\n(Image: Documentation) (Image: Documentation) (Image: CI) (Image: Codecov) (Image: Aqua.jl Quality Assurance)\n\nLogistics.jl defines the data type Logistic which represents real numbers in 0 1 (e.g. probabilities) with more numerically stable arithmetic operations.\n\nExamples\n\nThe followings are some simple examples illustrating the usage of this package. Please see the documentation for more details of Logistics.jl.\n\njulia> using Logistics\n\njulia> x = Logistic(0)\nLogistic{Float64}(0.0) ≈ 0.5\n\njulia> y = logisticate(0.2)\nLogistic{Float64}(-1.3862943611198906) ≈ 0.2\n\njulia> x + y\nLogistic{Float64}(0.8472978603872037) ≈ 0.7\n\njulia> x - y\nLogistic{Float64}(-0.8472978603872037) ≈ 0.3\n\njulia> x * y\nLogistic{Float64}(-2.197224577336219) ≈ 0.10000000000000002\n\njulia> y / x\nLogistic{Float64}(-0.40546510810816444) ≈ 0.4\n\njulia> x ^ 2\nLogistic{Float64}(-1.0986122886681098) ≈ 0.25\n\njulia> mx = x ^ 10000\nLogistic{Float64}(-6931.471805599453) ≈ 0.0\n\njulia> my = y ^ 4307\nLogistic{Float64}(-6931.84908885367) ≈ 0.0\n\njulia> mx + my\nLogistic{Float64}(-6930.949611751832) ≈ 0.0\n\njulia> mx - my\nLogistic{Float64}(-6932.629282338215) ≈ 0.0\n\njulia> mx * my\nLogistic{Float64}(-13863.320894453122) ≈ 0.0\n\njulia> mx \\ my\nLogistic{Float64}(0.7801934845449816) ≈ 0.6857218127893691\n\njulia> sqrt(mx)\nLogistic{Float64}(-3465.7359027997263) ≈ 0.0\n\njulia> cbrt(mx)\nLogistic{Float64}(-2310.490601866484) ≈ 0.0\n\njulia> log(y)\n-1.6094379124341003\n\njulia> logit(y)\n-1.3862943611198906\n\n\n\n\n\n","category":"module"},{"location":"#The-new-type-Logistic","page":"Logistics.jl","title":"The new type Logistic","text":"","category":"section"},{"location":"","page":"Logistics.jl","title":"Logistics.jl","text":"Logistic","category":"page"},{"location":"#Logistics.Logistic","page":"Logistics.jl","title":"Logistics.Logistic","text":"Logistic{T<:AbstractFloat} <: Real\n\nLogistic(t::Real)\nLogistic{T}(t::Real) where {T<:AbstractFloat}\n\nA type representing real numbers in 01 (e.g. probabilities) by their  logit values.\n\nwarning: Warning\nDo not use Logistic to convert number types! For example,  Logistic(0.39) equals operatornamelogistic(039) approx 060  rather than 039 in value. To convert a number to an equivalent  Logistic instance, use logisticate or convert(Logistic, x).\n\n\n\n\n\n","category":"type"},{"location":"#New-functions","page":"Logistics.jl","title":"New functions","text":"","category":"section"},{"location":"","page":"Logistics.jl","title":"Logistics.jl","text":"logisticate\ncomplement\nhalf\nlogitexp\nloglogistic","category":"page"},{"location":"#Logistics.logisticate","page":"Logistics.jl","title":"Logistics.logisticate","text":"logisticate(x::Real) :: Logistic\nlogisticate(T::Type{<:AbstractFloat}, x::Real) :: Logistic{T}\nlogisticate(::Type{Logistic}, x::Real) :: Logistic\nlogisticate(::Type{<:Logistic{T}}, x::Real) \n\twhere {T<:AbstractFloat} :: Logistic{T}\n\nConvert a Real number to its equivalent Logistic number.\n\nExamples\n\njulia> logisticate(0.39)\nLogistic{Float64}(-0.4473122180436648) ≈ 0.39\n\njulia> logisticate(Float32, 0.39)\nLogistic{Float32}(-0.4473123) ≈ 0.39\n\njulia> logisticate(Logistic, 0.39)\nLogistic{Float64}(-0.4473122180436648) ≈ 0.39\n\njulia> logisticate(Logistic{Float32}, 0.39)\nLogistic{Float32}(-0.4473123) ≈ 0.39\n\n\n\n\n\n","category":"function"},{"location":"#Logistics.complement","page":"Logistics.jl","title":"Logistics.complement","text":"complement(x::Logistic) :: Logistic\n\nCompute the complement, i.e., the difference between one and the argument.\n\nExamples\n\njulia> complement(logisticate(0.2))\nLogistic{Float64}(1.3862943611198906) ≈ 0.8\n\njulia> 1 - logisticate(0.2)\n0.8\n\n\n\n\n\n","category":"function"},{"location":"#Logistics.half","page":"Logistics.jl","title":"Logistics.half","text":"half(::Type{Logistic}) :: Logistic\nhalf(::Type{Logistic{T}}) where {T<:AbstractFloat} :: Logistic{T}\nhalf(::Logistic{T}) where {T<:AbstractFloat} :: Logistic{T}\n\nReturn a Logistic number equal to a half.\n\nExamples\n\njulia> (logisticate(0) + logisticate(1)) / 2\nLogistic{Float64}(0.0) ≈ 0.5\n\njulia> half(Logistic{Float64})\nLogistic{Float64}(0.0) ≈ 0.5\n\n\n\n\n\n","category":"function"},{"location":"#Logistics.logitexp","page":"Logistics.jl","title":"Logistics.logitexp","text":"logitexp(x::Real)\n\nReturn logit(exp(x)) evaluated carefully without intermediate calculation  of exp(x).\n\nIts inverse is the loglogistic function.\n\n\n\n\n\n","category":"function"},{"location":"#Logistics.loglogistic","page":"Logistics.jl","title":"Logistics.loglogistic","text":"loglogistic(x::Real)\n\nReturn log(logistic(x)) evaluated carefully without intermediate calculation  of logistic(x).\n\nIts inverse is the logitexp function.\n\n\n\n\n\n","category":"function"},{"location":"#Functions-from-LogExpFunctions.jl","page":"Logistics.jl","title":"Functions from LogExpFunctions.jl","text":"","category":"section"},{"location":"","page":"Logistics.jl","title":"Logistics.jl","text":"logit\nlogistic","category":"page"},{"location":"#LogExpFunctions.logit","page":"Logistics.jl","title":"LogExpFunctions.logit","text":"logit(x)\n\n\nThe logit or log-odds transformation, defined as\n\noperatornamelogit(x) = logleft(fracx1-xright)\n\nfor 0  x  1.\n\nIts inverse is the logistic function.\n\n\n\n\n\n","category":"function"},{"location":"#LogExpFunctions.logistic","page":"Logistics.jl","title":"LogExpFunctions.logistic","text":"logistic(x)\n\n\nThe logistic sigmoid function mapping a real number to a value in the interval 01,\n\nsigma(x) = frac1e^-x + 1 = frace^x1+e^x\n\nIts inverse is the logit function.\n\n\n\n\n\n","category":"function"}]
}
