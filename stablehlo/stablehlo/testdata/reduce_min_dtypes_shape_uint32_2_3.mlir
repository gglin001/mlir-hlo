// RUN: stablehlo-opt -inline %s | stablehlo-translate --interpret
// RUN: stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt > %t.0
// RUN: stablehlo-opt %s > %t.1
// RUN: diff %t.0 %t.1

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0 = call @inputs() : () -> tensor<2x3xui32>
    %1 = call @expected() : () -> tensor<3xui32>
    %2 = stablehlo.constant dense<4294967295> : tensor<ui32>
    %3 = stablehlo.reduce(%0 init: %2) across dimensions = [0] : (tensor<2x3xui32>, tensor<ui32>) -> tensor<3xui32>
     reducer(%arg0: tensor<ui32>, %arg1: tensor<ui32>)  {
      %5 = stablehlo.minimum %arg0, %arg1 : tensor<ui32>
      stablehlo.return %5 : tensor<ui32>
    }
    %4 = stablehlo.custom_call @check.eq(%3, %1) : (tensor<3xui32>, tensor<3xui32>) -> tensor<i1>
    return %4 : tensor<i1>
  }
  func.func private @inputs() -> tensor<2x3xui32> {
    %0 = stablehlo.constant dense<[[2, 2, 0], [0, 5, 1]]> : tensor<2x3xui32>
    return %0 : tensor<2x3xui32>
  }
  func.func private @expected() -> tensor<3xui32> {
    %0 = stablehlo.constant dense<[0, 2, 0]> : tensor<3xui32>
    return %0 : tensor<3xui32>
  }
}
