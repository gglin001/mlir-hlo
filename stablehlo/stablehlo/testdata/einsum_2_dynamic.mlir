// RUN: diff <(stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt) <(stablehlo-opt %s)

module @jit_fun_flat_jax {
  func.func public @main(%arg0: tensor<i64>, %arg1: tensor<?x4x5xf32> {mhlo.sharding = ""}, %arg2: tensor<5x6xf32> {mhlo.sharding = ""}) -> tensor<?x4x6xf32> {
    %0 = call @_einsum(%arg0, %arg1, %arg2) : (tensor<i64>, tensor<?x4x5xf32>, tensor<5x6xf32>) -> tensor<?x4x6xf32>
    return %0 : tensor<?x4x6xf32>
  }
  func.func private @_einsum(%arg0: tensor<i64>, %arg1: tensor<?x4x5xf32>, %arg2: tensor<5x6xf32>) -> tensor<?x4x6xf32> {
    %0 = "stablehlo.dot_general"(%arg1, %arg2) {dot_dimension_numbers = #stablehlo.dot<lhs_contracting_dimensions = [2], rhs_contracting_dimensions = [0]>} : (tensor<?x4x5xf32>, tensor<5x6xf32>) -> tensor<?x4x6xf32>
    return %0 : tensor<?x4x6xf32>
  }
}

