// RUN-DISABLED: stablehlo-opt -inline %s | stablehlo-translate --interpret
// RUN: diff <(stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt) <(stablehlo-opt %s)

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0 = stablehlo.constant dense<0> : tensor<1xi32>
    %1:2 = call @inputs() : () -> (tensor<1x2x3xf32>, tensor<2x3xf32>)
    %2 = call @expected() : () -> tensor<1x2x3xf32>
    %3 = "stablehlo.scatter"(%1#0, %0, %1#1) ({
    ^bb0(%arg0: tensor<f32>, %arg1: tensor<f32>):
      %5 = stablehlo.multiply %arg0, %arg1 : tensor<f32>
      stablehlo.return %5 : tensor<f32>
    }) {scatter_dimension_numbers = #stablehlo.scatter<update_window_dims = [0, 1], inserted_window_dims = [0], scatter_dims_to_operand_dims = [0]>, unique_indices = true} : (tensor<1x2x3xf32>, tensor<1xi32>, tensor<2x3xf32>) -> tensor<1x2x3xf32>
    %4 = stablehlo.custom_call @check.eq(%3, %2) : (tensor<1x2x3xf32>, tensor<1x2x3xf32>) -> tensor<i1>
    return %4 : tensor<i1>
  }
  func.func private @inputs() -> (tensor<1x2x3xf32>, tensor<2x3xf32>) {
    %0 = stablehlo.constant dense<[[[2.527730e+00, 4.00636721, -2.68355799], [-1.1296916, 3.4525857, 1.83168328]]]> : tensor<1x2x3xf32>
    %1 = stablehlo.constant dense<[[2.5121758, 2.9833796, 4.66045713], [-3.02949834, 0.24465926, -1.87548876]]> : tensor<2x3xf32>
    return %0, %1 : tensor<1x2x3xf32>, tensor<2x3xf32>
  }
  func.func private @expected() -> tensor<1x2x3xf32> {
    %0 = stablehlo.constant dense<[[[6.35010195, 11.9525146, -12.5066071], [3.42239881, 0.844707071, -3.4353013]]]> : tensor<1x2x3xf32>
    return %0 : tensor<1x2x3xf32>
  }
}

