// RUN: stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt > %t.0
// RUN: stablehlo-opt %s > %t.1
// RUN: diff %t.0 %t.1

module @jit_fun_flat_jax {
  func.func public @main(%arg0: tensor<i64>, %arg1: tensor<?x10x10x10xf32> {mhlo.sharding = ""}, %arg2: tensor<?x2xui32> {mhlo.sharding = ""}) -> tensor<?x10x2x10xf32> {
    %0 = call @_take(%arg0, %arg1, %arg2) : (tensor<i64>, tensor<?x10x10x10xf32>, tensor<?x2xui32>) -> tensor<?x10x2x10xf32>
    return %0 : tensor<?x10x2x10xf32>
  }
  func.func private @_take(%arg0: tensor<i64>, %arg1: tensor<?x10x10x10xf32>, %arg2: tensor<?x2xui32>) -> tensor<?x10x2x10xf32> {
    %0 = stablehlo.convert %arg0 : (tensor<i64>) -> tensor<i32>
    %1 = stablehlo.reshape %0 : (tensor<i32>) -> tensor<1xi32>
    %2 = stablehlo.constant dense<2> : tensor<1xi32>
    %3 = stablehlo.constant dense<1> : tensor<1xi32>
    %4 = stablehlo.concatenate %1, %2, %3, dim = 0 : (tensor<1xi32>, tensor<1xi32>, tensor<1xi32>) -> tensor<3xi32>
    %5 = stablehlo.dynamic_broadcast_in_dim %arg2, %4, dims = [0, 1] : (tensor<?x2xui32>, tensor<3xi32>) -> tensor<?x2x1xui32>
    %6 = stablehlo.convert %arg0 : (tensor<i64>) -> tensor<i32>
    %7 = stablehlo.reshape %6 : (tensor<i32>) -> tensor<1xi32>
    %8 = stablehlo.constant dense<2> : tensor<1xi32>
    %9 = stablehlo.constant dense<1> : tensor<1xi32>
    %10 = stablehlo.concatenate %7, %8, %9, dim = 0 : (tensor<1xi32>, tensor<1xi32>, tensor<1xi32>) -> tensor<3xi32>
    %11 = stablehlo.dynamic_iota %10, dim = 0 : (tensor<3xi32>) -> tensor<?x2x1xui32>
    %12 = stablehlo.concatenate %11, %5, dim = 2 : (tensor<?x2x1xui32>, tensor<?x2x1xui32>) -> tensor<?x2x2xui32>
    %13 = "stablehlo.gather"(%arg1, %12) {dimension_numbers = #stablehlo.gather<offset_dims = [1, 3], collapsed_slice_dims = [0, 2], start_index_map = [0, 2], index_vector_dim = 2>, slice_sizes = array<i64: 1, 10, 1, 10>} : (tensor<?x10x10x10xf32>, tensor<?x2x2xui32>) -> tensor<?x10x2x10xf32>
    return %13 : tensor<?x10x2x10xf32>
  }
}

