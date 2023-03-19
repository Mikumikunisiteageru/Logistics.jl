var documenterSearchIndex = {"docs":
[{"location":"#Logistics.jl","page":"Logistics.jl","title":"Logistics.jl","text":"","category":"section"},{"location":"","page":"Logistics.jl","title":"Logistics.jl","text":"Logistics","category":"page"},{"location":"#Logistics","page":"Logistics.jl","title":"Logistics","text":"Logistics.jl\n\n(Image: ) (Image: ) (Image: CI) (Image: Codecov) (Image: Aqua.jl Quality Assurance)\n\nLogistics.jl defines the data type Logistic which represents real numbers in 0 1 (e.g. probabilities) with more numerically stable arithmetic operations.\n\nExamples\n\nThe followings are some simple examples illustrating the usage of this package. Please see the documentation for more details of Logistics.jl.\n\njulia> using Logistics\n\njulia> x = Logistic(0)\nLogistic(0.0) ≈ 0.5\n\njulia> y = logisticate(0.2)\nLogistic(-1.3862943611198906) ≈ 0.2\n\njulia> x + y\nLogistic(0.8472978603872037) ≈ 0.7\n\njulia> x - y\nLogistic(-0.8472978603872037) ≈ 0.3\n\njulia> x * y\nLogistic(-2.197224577336219) ≈ 0.10000000000000002\n\njulia> y / x\nLogistic(-0.40546510810816444) ≈ 0.4\n\njulia> x ^ 2\nLogistic(-1.0986122886681098) ≈ 0.25\n\njulia> mx = x ^ 10000\nLogistic(-6931.471805599453) ≈ 0.0\n\njulia> my = y ^ 4307\nLogistic(-6931.84908885367) ≈ 0.0\n\njulia> mx + my\nLogistic(-6930.949611751832) ≈ 0.0\n\njulia> mx - my\nLogistic(-6932.629282338215) ≈ 0.0\n\njulia> sqrt(mx)\nLogistic(-3465.7359027997263) ≈ 0.0\n\njulia> cbrt(mx)\nLogistic(-2310.490601866484) ≈ 0.0\n\njulia> log(y)\n-1.6094379124341003\n\njulia> logit(y)\n-1.3862943611198906\n\n\n\n\n\n","category":"module"},{"location":"#New-type-and-functions","page":"Logistics.jl","title":"New type and functions","text":"","category":"section"},{"location":"","page":"Logistics.jl","title":"Logistics.jl","text":"Logistic\nlogit\nlogistic\nlogisticate\ncomplement\nhalf","category":"page"},{"location":"#Logistics.Logistic","page":"Logistics.jl","title":"Logistics.Logistic","text":"Logistic{T<:AbstractFloat} <: Real\n\nLogistic(t::Real)\nLogistic{T}(t::Real) where {T<:AbstractFloat}\n\nA type representing real numbers in 01 (e.g. probabilities) by their  logit values.\n\n\n\n\n\n","category":"type"},{"location":"#Logistics.logit","page":"Logistics.jl","title":"Logistics.logit","text":"logit(x::Real)\nlogit(x::Logistic)\n\nCompute operatornamelogit(x) = log(x  (1-x)).\n\n\n\n\n\n","category":"function"},{"location":"#Logistics.logistic","page":"Logistics.jl","title":"Logistics.logistic","text":"logistic(t::Real)\n\nCompute operatornamelogistic(x) = 1  (1 + exp(x)).\n\n\n\n\n\n","category":"function"},{"location":"#Logistics.logisticate","page":"Logistics.jl","title":"Logistics.logisticate","text":"logisticate(x::Real) :: Logistic\nlogisticate(T::Type{<:AbstractFloat}, x::Real) :: Logistic{T}\nlogisticate(::Type{Logistic}, x::Real) :: Logistic\nlogisticate(::Type{<:Logistic{T}}, x::Real) \n\twhere {T<:AbstractFloat} :: Logistic{T}\n\nConvert a Real number to its equivalent Logistic number.\n\nExamples\n\njulia> logisticate(0.39)\nLogistic{Float64}(-0.4473122180436648) ≈ 0.39\n\njulia> logisticate(Float32, 0.39)\nLogistic{Float32}(-0.4473123) ≈ 0.39\n\njulia> logisticate(Logistic, 0.39)\nLogistic{Float64}(-0.4473122180436648) ≈ 0.39\n\njulia> logisticate(Logistic{Float32}, 0.39)\nLogistic{Float32}(-0.4473123) ≈ 0.39\n\n\n\n\n\n","category":"function"},{"location":"#Logistics.complement","page":"Logistics.jl","title":"Logistics.complement","text":"complement(x::Logistic) :: Logistic\n\nCompute the complement, i.e., the different between one and the argument.\n\nExamples\n\njulia> complement(logisticate(0.2))\nLogistic{Float64}(1.3862943611198906) ≈ 0.8\n\njulia> 1 - logisticate(0.2)\n0.8\n\n\n\n\n\n","category":"function"},{"location":"#Logistics.half","page":"Logistics.jl","title":"Logistics.half","text":"half(::Type{Logistic}) :: Logistic\nhalf(::Type{Logistic{T}}) where {T<:AbstractFloat} :: Logistic{T}\nhalf(::Logistic{T}) where {T<:AbstractFloat} :: Logistic{T}\n\nReturn a Logistic number equal to a half.\n\nExamples\n\njulia> (logisticate(0) + logisticate(1)) / 2\nLogistic{Float64}(0.0) ≈ 0.5\n\njulia> half(Logistic{Float64})\nLogistic{Float64}(0.0) ≈ 0.5\n\n\n\n\n\n","category":"function"}]
}