// RUN: stablehlo-opt -inline %s | stablehlo-translate --interpret
// RUN: stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt > %t.0
// RUN: stablehlo-opt %s > %t.1
// RUN: diff %t.0 %t.1

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0 = call @inputs() : () -> tensor<3x4xi8>
    %1 = call @expected() : () -> tensor<3x4xi8>
    %2 = stablehlo.custom_call @check.eq(%0, %1) : (tensor<3x4xi8>, tensor<3x4xi8>) -> tensor<i1>
    return %2 : tensor<i1>
  }
  func.func private @inputs() -> tensor<3x4xi8> {
    %0 = stablehlo.constant dense<[[2, -2, 0, -3], [0, 1, -1, 2], [-3, 0, 8, -4]]> : tensor<3x4xi8>
    return %0 : tensor<3x4xi8>
  }
  func.func private @expected() -> tensor<3x4xi8> {
    %0 = stablehlo.constant dense<[[2, -2, 0, -3], [0, 1, -1, 2], [-3, 0, 8, -4]]> : tensor<3x4xi8>
    return %0 : tensor<3x4xi8>
  }
}
