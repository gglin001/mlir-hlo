// RUN-DISABLED: stablehlo-opt -inline %s | stablehlo-translate --interpret
// RUN: diff <(stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt) <(stablehlo-opt %s)

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0 = stablehlo.constant dense<1> : tensor<2x1xi32>
    %1:2 = call @inputs() : () -> (tensor<3x5x4xui8>, tensor<3x2x4xui8>)
    %2 = call @expected() : () -> tensor<3x5x4xui8>
    %3 = "stablehlo.scatter"(%1#0, %0, %1#1) ({
    ^bb0(%arg0: tensor<ui8>, %arg1: tensor<ui8>):
      %5 = stablehlo.multiply %arg0, %arg1 : tensor<ui8>
      stablehlo.return %5 : tensor<ui8>
    }) {scatter_dimension_numbers = #stablehlo.scatter<update_window_dims = [0, 2], inserted_window_dims = [1], scatter_dims_to_operand_dims = [1], index_vector_dim = 1>} : (tensor<3x5x4xui8>, tensor<2x1xi32>, tensor<3x2x4xui8>) -> tensor<3x5x4xui8>
    %4 = stablehlo.custom_call @check.eq(%3, %2) : (tensor<3x5x4xui8>, tensor<3x5x4xui8>) -> tensor<i1>
    return %4 : tensor<i1>
  }
  func.func private @inputs() -> (tensor<3x5x4xui8>, tensor<3x2x4xui8>) {
    %0 = stablehlo.constant dense<[[[2, 6, 0, 2], [2, 3, 3, 2], [2, 0, 0, 2], [0, 0, 1, 3], [1, 0, 1, 1]], [[5, 3, 2, 2], [0, 1, 2, 2], [6, 1, 4, 1], [1, 1, 3, 1], [3, 1, 2, 5]], [[3, 3, 1, 6], [0, 2, 3, 2], [0, 3, 1, 3], [7, 1, 1, 0], [1, 4, 6, 2]]]> : tensor<3x5x4xui8>
    %1 = stablehlo.constant dense<[[[1, 2, 0, 2], [2, 3, 0, 0]], [[0, 0, 4, 2], [3, 5, 1, 1]], [[4, 2, 0, 1], [3, 5, 1, 2]]]> : tensor<3x2x4xui8>
    return %0, %1 : tensor<3x5x4xui8>, tensor<3x2x4xui8>
  }
  func.func private @expected() -> tensor<3x5x4xui8> {
    %0 = stablehlo.constant dense<[[[2, 6, 0, 2], [4, 18, 0, 0], [2, 0, 0, 2], [0, 0, 1, 3], [1, 0, 1, 1]], [[5, 3, 2, 2], [0, 0, 8, 4], [6, 1, 4, 1], [1, 1, 3, 1], [3, 1, 2, 5]], [[3, 3, 1, 6], [0, 20, 0, 4], [0, 3, 1, 3], [7, 1, 1, 0], [1, 4, 6, 2]]]> : tensor<3x5x4xui8>
    return %0 : tensor<3x5x4xui8>
  }
}

