// RUN-DISABLED: stablehlo-opt -inline %s | stablehlo-translate --interpret
// RUN: diff <(stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt) <(stablehlo-opt %s)

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0 = stablehlo.constant dense<[1, 2]> : tensor<2xi32>
    %1:2 = call @inputs() : () -> (tensor<1x2x3xi32>, tensor<1xi32>)
    %2 = call @expected() : () -> tensor<1x2x3xi32>
    %3 = "stablehlo.scatter"(%1#0, %0, %1#1) ({
    ^bb0(%arg0: tensor<i32>, %arg1: tensor<i32>):
      %5 = stablehlo.multiply %arg0, %arg1 : tensor<i32>
      stablehlo.return %5 : tensor<i32>
    }) {scatter_dimension_numbers = #stablehlo.scatter<update_window_dims = [0], inserted_window_dims = [1, 2], scatter_dims_to_operand_dims = [1, 2]>, unique_indices = true} : (tensor<1x2x3xi32>, tensor<2xi32>, tensor<1xi32>) -> tensor<1x2x3xi32>
    %4 = stablehlo.custom_call @check.eq(%3, %2) : (tensor<1x2x3xi32>, tensor<1x2x3xi32>) -> tensor<i1>
    return %4 : tensor<i1>
  }
  func.func private @inputs() -> (tensor<1x2x3xi32>, tensor<1xi32>) {
    %0 = stablehlo.constant dense<[[[1, 4, 4], [0, 1, -7]]]> : tensor<1x2x3xi32>
    %1 = stablehlo.constant dense<-3> : tensor<1xi32>
    return %0, %1 : tensor<1x2x3xi32>, tensor<1xi32>
  }
  func.func private @expected() -> tensor<1x2x3xi32> {
    %0 = stablehlo.constant dense<[[[1, 4, 4], [0, 1, 21]]]> : tensor<1x2x3xi32>
    return %0 : tensor<1x2x3xi32>
  }
}

