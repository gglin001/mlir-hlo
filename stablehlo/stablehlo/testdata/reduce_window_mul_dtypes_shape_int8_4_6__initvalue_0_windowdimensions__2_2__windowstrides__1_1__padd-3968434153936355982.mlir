// RUN: stablehlo-opt -inline %s | stablehlo-translate --interpret
// RUN: stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt > %t.0
// RUN: stablehlo-opt %s > %t.1
// RUN: diff %t.0 %t.1

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0 = call @inputs() : () -> tensor<4x6xi8>
    %1 = call @expected() : () -> tensor<3x5xi8>
    %2 = stablehlo.constant dense<0> : tensor<i8>
    %3 = "stablehlo.reduce_window"(%0, %2) ({
    ^bb0(%arg0: tensor<i8>, %arg1: tensor<i8>):
      %5 = stablehlo.multiply %arg0, %arg1 : tensor<i8>
      stablehlo.return %5 : tensor<i8>
    }) {window_dimensions = array<i64: 2, 2>} : (tensor<4x6xi8>, tensor<i8>) -> tensor<3x5xi8>
    %4 = stablehlo.custom_call @check.eq(%3, %1) : (tensor<3x5xi8>, tensor<3x5xi8>) -> tensor<i1>
    return %4 : tensor<i1>
  }
  func.func private @inputs() -> tensor<4x6xi8> {
    %0 = stablehlo.constant dense<[[-1, 0, -5, 0, 0, 0], [-3, 1, -5, -4, 0, 0], [4, 3, 3, 4, 3, 3], [7, -4, -2, -2, -2, 0]]> : tensor<4x6xi8>
    return %0 : tensor<4x6xi8>
  }
  func.func private @expected() -> tensor<3x5xi8> {
    %0 = stablehlo.constant dense<0> : tensor<3x5xi8>
    return %0 : tensor<3x5xi8>
  }
}

