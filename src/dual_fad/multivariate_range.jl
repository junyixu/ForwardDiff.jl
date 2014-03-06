function dual_fad{T<:Real}(f!::Function, x::Vector{T}, jac_out::Matrix{T}, dual_in, dual_out)
  # assume that f! doesn't overwrite the x vector
  for i in 1:length(x)
    dual_in[i] = Dual(x[i], zero(T))
  end
  for i in 1:length(x)
    dual_in[i] = Dual(x[i], one(T))
    f!(dual_in, dual_out)
    for k in 1:length(dual_out)
      jac_out[k, i] = epsilon(dual_out[k])
    end
    dual_in[i] = Dual(real(dual_in[i]), zero(T))
  end
end

# generates a function that computes the jacobian of f!(x,fx)
# assuming that f takes a Vector{T} of length n
# and writes the result to a Vector{T} of length m
function dual_fad_jacobian{T<:Real}(f!::Function, ::Type{T}; n::Int=1, m::Int=1)
  dual_in = Array(Dual{T}, n)
  dual_out = Array(Dual{T}, m)
  g!(x, jac_out) = dual_fad(f!, x, jac_out, dual_in, dual_out)
  return g!
end
